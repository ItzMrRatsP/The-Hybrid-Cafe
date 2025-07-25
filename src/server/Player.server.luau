local Players = game:GetService("Players")
local DSS = game:GetService("DataStoreService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BadgeService = game:GetService("BadgeService")
local MessagingService = game:GetService("MessagingService")
local MSS = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")

local RNG = Random.new()

local remotes = ReplicatedStorage.Remotes
local servermodules = ServerStorage.ServerModules
local lmodules = ReplicatedStorage.LocalModules
local lremotes = ReplicatedStorage.LocalRemotes
local ginfo = ServerStorage.GameInfo
local stick_folder = ReplicatedStorage.Stickers
local ucustomers = ReplicatedStorage.UniqueCustomers
local blogs = ReplicatedStorage.Blogs
local cupfolder = ReplicatedStorage.Cups

local overheadUI = script.OverheadUI

local datahandler = require(servermodules.DataHandler)
local gift_store = DSS:GetDataStore("Gifts_"..datahandler.masterKey)
local cust_store = DSS:GetOrderedDataStore("CustomerIds")
local lbmodule = require(servermodules.LeaderboardManager)
local p_ranks = require(lmodules.PlayerRanks) -- hah pranked
local essentials = require(lmodules.EssentialFunctions)
local giftservice = require(servermodules.GiftService)
local testinfo = require(lmodules.TestPlaceInfo)
local DailyRewardLib = require(ginfo.DailyRewards)
local gmodeunlocks = require(ginfo.GamemodeUnlocks)
local reconciler = require(servermodules.DataReconciler)
local GetCosmetic = require(lmodules.GetCosmetic)
local weaponpasses = require(lmodules.WeaponPasses)
local giftables = require(lmodules.GamepassInfo)
local starter_popinfo = require(ginfo.StarterPopup)

local update_exclusive = require(servermodules.Common.UpdateExclusive)

local function AnnounceServer(message)
	remotes.NotifyPlayer:FireAllClients(message, 10, {
		NotifClass = "ServerAnnouncement";
		TextColor = Color3.fromRGB(119, 137, 255);
		StrokeColor = Color3.fromRGB(54, 62, 116);
	}, {"DoorbellChime"})
end

local function CheckGifts(plr)
	local success2, message2 = pcall(function()
		local myprocessed = datahandler.GetTable(plr, "ProcessedGamepasses")
		
		local adding = {}
		for _,g in pairs(giftables) do
			if myprocessed[tostring(g.ID)] ~= nil then continue end
			local haspass = MSS:UserOwnsGamePassAsync(plr.UserId, g.ID)
			if haspass then
				table.insert(adding, g.ID)
			end
		end
		
		datahandler.Update(plr, "ProcessedGamepasses", function(old)
			local new = old or {}
			for _,id in pairs(adding) do
				new[tostring(id)] = true
			end

			return new
		end)
		datahandler.Update(plr, "VirtualGamepasses", function(old)
			local new = old or {}
			for _,id in pairs(adding) do
				print("adding 1 to "..id)
				local prv = new[tostring(id)] or 0
				new[tostring(id)] = prv + 1

				print("now at "..prv + 1)
			end
			
			return new
		end)
	end)
	if not success2 then
		warn(message2)
	end
	
	local collecting = {}
	local names = {}
	local success, message = pcall(function()
		gift_store:UpdateAsync(plr.UserId, function(current)
			if current then
				for _,c in pairs(current) do
					local info = giftables[c.Code]
					if info then
						table.insert(collecting, info.ID)
						
						if #names < 5 then
							table.insert(names, "You received "..info.DisplayName.." from "..c.SenderName.."!")
						elseif #names == 5 then
							table.insert(names, "...and more!")
						end
					end
				end
			end
			return {}
		end)
	end)
	
	if not success then
		warn(message)
		return
	end
	
	datahandler.Update(plr, "VirtualGamepasses", function(old)
		local new = old or {}
		for _,id in pairs(collecting) do
			print("adding 1 to "..id)
			local prv = new[tostring(id)] or 0
			new[tostring(id)] = prv + 1
		end
		
		return new
	end)
	pcall(function()
		for i = #names, 1, -1 do
			remotes.NotifyPlayer:FireClient(plr, names[i], 5, {
				TextColor = Color3.fromRGB(255, 169, 232);
				StrokeColor = Color3.fromRGB(106, 41, 94);
			}, i == 1 and {"BellRing"})
		end
	end)
end

local admins = {
	35037689;
}
local devs = {
	35037689;
	3731562822;
}

local giftlisteners = {}
local function PlayerAdded(plr)
	if table.find(admins, plr.UserId) then
		plr:SetAttribute("IsAdmin", true)
	end
	
	local currentroom = Instance.new("ObjectValue")
	currentroom.Name = "CurrentRoom"
	currentroom.Parent = plr
	
	--// Data Loading
	local datasucc, datmes = pcall(function()
		datahandler.InitializePlayer(plr)
	end)
	if not datasucc then
		warn("[FAILED PLAYER LOADING]", datmes)
		plr:Kick("Failed to load your data. Please rejoin!")
	end
	
	for name, foo in pairs(reconciler) do
		local success, message = pcall(foo, plr)
		if not success then
			warn("Reconcile "..name.." FAIL:", message)
		end
	end
	
	local datastats = plr.DataStats
	local displayedach = datastats.DisplayedAchievement
	
	if testinfo.IsTest then
		--// Whatever debug needed here
		--datahandler.Set(plr, "Cred", 1000000)
		--datahandler.Set(plr, "CurrentRank", 9)
		--datahandler.Set(plr, "BestRank", 9)
	end
	
	local function placeSelf(oldroom)
		local current = currentroom.Value
		local char = plr.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")

		if not root then return end

		if current then
			local floor = current.Floor
			root.CFrame = floor.CFrame * CFrame.new(0, 5, 0)
		elseif oldroom then
			local floor = oldroom.Floor
			root.CFrame = floor.CFrame * CFrame.new(15, 5, 0)
		end
	end
	
	-- Set StarterBundleTimer
	local startbundle = datahandler.Get(plr, "StarterBundleTimer") or os.time()
	datahandler.Set(plr, "StarterBundleTimer", startbundle)
	
	plr:SetAttribute("BundleStart", startbundle)
	
	--// Manage Daily
	--[[
	DailyTaken = 0;
	DailyLevel = 0;
	DailyStreak = 0;
	]]
	
	local sincedaily = datahandler.Get(plr, "DailyTaken")
	local daily_takentime = os.time() - sincedaily
	if daily_takentime >= DailyRewardLib.NextClaimTime + (86400) then
		-- Reset if the timer is more than 24 hours since claim time
		datahandler.Set(plr, "DailyLevel", 1)
		datahandler.Set(plr, "DailyStreak", 1)
	end
	if daily_takentime >= DailyRewardLib.NextClaimTime then
		-- He can claim his daily!!
		-- Other Daily stats update during claim function
		local _streak = datahandler.Get(plr, "DailyStreak")
		local _level = datahandler.Get(plr, "DailyLevel")
		local his_dailies = DailyRewardLib.GetRewards(plr, _streak, _level)
		
		-- Reset Daily Level if it's not in the list
		if his_dailies[_level] == nil then
			datahandler.Set(plr, "DailyLevel", 1)
			_level = 1
		end
		
		remotes.QueueDailyReward:FireClient(plr, his_dailies, _streak, _level)
	end
	
	-- Establish Player Rank
	p_ranks.GetPlayerRank(plr)
	
	local function CharAdded(char)
		currentroom.Value = nil
		for _,bod in pairs(char:GetChildren()) do
			if bod:IsA("BasePart") then
				bod.CollisionGroup = "Players"
			end
		end
		
		task.wait(0.1)
		char.Parent = workspace.Characters
		
		local root = char:WaitForChild("HumanoidRootPart")
		local hum = char:WaitForChild("Humanoid")
		
		hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		
		local new = overheadUI:Clone()
		new.Adornee = root
		local main = new.Main
		
		main.CustomerValue.Text = datahandler.GetTable(plr, "PlayerStats")["CustomersServed"].." Customers Served"
		main.PName.Text = plr.DisplayName
		local rank = plr:GetAttribute("PlayerRank")
		if rank then
			local info = p_ranks.Ranks[rank]
			main.Title.TextColor3 = info.TagColor
			main.Title.Text = info.ChatTag
			main.Title.Visible = true
		else
			main.Title.Visible = false
		end
		
		local badgelist = require(ginfo.DisplayedBadges)
		local function UpdateTag()
			local assigned = badgelist[displayedach.Value]
			main.BTitle.Visible = assigned ~= nil
			if assigned then
				main.BTitle.AchName.Text = assigned.DisplayName
				main.BTitle.AchName.TextColor3 = assigned.TitleColor or Color3.fromRGB(197, 170, 255)
				main.BTitle.BIcon.Image = assigned.Icon
			end
		end
		UpdateTag()
		local updev = displayedach:GetPropertyChangedSignal("Value"):Connect(UpdateTag)
		
		new.Parent = root
		new.AncestryChanged:Once(function()
			updev:Disconnect()
		end)
	end
	if plr.Character then
		task.spawn(CharAdded, plr.Character)
	end
	plr.CharacterAdded:Connect(CharAdded)
	
	local oldroom
	currentroom:GetPropertyChangedSignal("Value"):Connect(function()
		placeSelf(oldroom)
		oldroom = currentroom.Value
	end)
	
	-- Update leaderboard stats (global)
	lbmodule.UpdatePlayer(plr)
	
	-- Unique Customers Indexing
	local uniqueindex = datahandler.GetTable(plr, "UniqueCustomers")
	local uniquefolder = Instance.new("Folder")
	uniquefolder.Name = "UniqueIndex"
	
	for cust, val in pairs(uniqueindex) do
		local new = Instance.new("IntValue")
		new.Name = cust
		new.Value = val
		
		new.Parent = uniquefolder
	end
	
	uniquefolder.Parent = plr
	
	-- Settings
	local setfolder = Instance.new("Folder")
	setfolder.Name = "Settings"
	for set,val in pairs(datahandler.GetTable(plr, "Settings")) do
		local new
		if typeof(val) == "string" then
			new = Instance.new("StringValue")
		elseif typeof(val) == "number" then
			new = Instance.new("IntValue")
		elseif typeof(val) == "boolean" then
			new = Instance.new("BoolValue")
		end
		
		new.Name = set
		new.Value = val
		new.Parent = setfolder
	end
	
	setfolder.Parent = plr
	
	local function update_settings(newset)
		for _,v in pairs(setfolder:GetChildren()) do
			local newval = newset[v.Name]
			v.Value = newval
		end
	end
	datahandler.OnUpdate(plr, "Settings", update_settings)
	
	local function update_auras()
		local aura_inv, current = datahandler.GetTable(plr, "AuraInventory", datahandler.Get(plr, "CurrentAura"))
		
		local data = {
			inventory = aura_inv;
			equipped = current
		}
		
		remotes.UpdateAuras:FireClient(plr, data)
	end
	
	update_auras()
	datahandler.OnUpdate("AuraInventory", update_auras)
	datahandler.OnUpdate("CurrentAura", update_auras)
	
	local function update_inv()
		local inv, current = datahandler.GetTable(plr, "CupInventory"), datahandler.Get(plr, "CurrentCup")
		local randomcups = datahandler.Get(plr, "RandomCups")
		local sending = {
			inventory = inv;
			equipped = current;
			israndom = randomcups;
		}
		
		remotes.UpdateInventory:FireClient(plr, sending)
	end
	
	-- This is for updating inventory, Cups exclusiuve
	update_inv()
	datahandler.OnUpdate(plr, "CupInventory", update_inv)
	datahandler.OnUpdate(plr, "CurrentCup", update_inv)
	datahandler.OnUpdate(plr, "RandomCups", update_inv)
	
	--// Blog Read
	local readblogs = datahandler.GetTable(plr, "ReadBlogs")
	for _,b in pairs(blogs:GetChildren()) do
		local blinfo = require(b)
		if blinfo.Active and not table.find(readblogs, b.Name) then
			table.insert(readblogs, b.Name)
			plr:SetAttribute("NewBlog", true)
		end
	end
	datahandler.Set(plr, "ReadBlogs", readblogs)
	
	--// Unlocked gamemodes
	local unlockedmodes = Instance.new("Folder")
	unlockedmodes.Name = "UnlockedModes"
	unlockedmodes.Parent = plr
	
	task.spawn(function()
		for n, reg in pairs(gmodeunlocks) do
			local success, yes = pcall(reg, plr)
			if success and yes then
				local gkey = Instance.new("BoolValue")
				gkey.Name = n
				gkey.Value = true
				gkey.Parent = unlockedmodes
			end
		end
	end)
	
	task.spawn(function()
		if not datahandler.Get(plr, "RankMigrated") then
			datahandler.Set(plr, "RankMigrated", true)
			local success, hasbadge = pcall(function()
				return BadgeService:UserHasBadgeAsync(plr.UserId, 3893949146190014)
			end)
			if success and hasbadge then
				local c = datahandler.Get(plr, "CurrentRank")
				datahandler.Set(plr, "CurrentRank", math.max(2, c))
				datahandler.Update(plr, "CompletedRanks", function(old)
					old["1"] = {
						SpentRobux = false;
					}

					return old
				end)

				print("Upgraded rank from migration")
			end
		end
		
		--// Establish Ranks to client
		local _sendingrank = {
			CurrentRank = datahandler.Get(plr, "CurrentRank");
			CompletedRanks = datahandler.GetTable(plr, "CompletedRanks")
		}
		remotes.UpdateRanks:FireClient(plr, _sendingrank)
	end)
	
	task.spawn(function()
		local serverInfo = datahandler.Get(plr, "Server")
		task.spawn(function()
			for k, v in serverInfo do
				print(k, v)	
			end
		end)
		
		if (serverInfo.Left) then
			-- send remotes for join backs
			remotes.EnableRejoinUI:FireClient(plr)
			
			-- set it back to default
			datahandler.Update(plr, "Server", function(old)
				local new = serverInfo or {}
				new.Left = false
				
				return new
			end)
		end
	end)
	
	--// Player Stats
	remotes.UpdateStats:FireClient(plr, datahandler.GetTable(plr, "PlayerStats"))
	datahandler.OnUpdate(plr, "PlayerStats", function(newstats)
		remotes.UpdateStats:FireClient(plr, newstats)
	end)
	
	--// Exclusives
	update_exclusive(plr)
	datahandler.OnUpdate(plr, "VirtualGamepasses", function()
		update_exclusive(plr)
	end)
	datahandler.OnUpdate(plr, "DisabledGamepasses", function()
		update_exclusive(plr)
	end)
	
	--// Skills
	local function update_skills()
		local sending = {
			Skills = datahandler.GetTable(plr, "Skills");
			Equipped = datahandler.Get(plr, "EquippedSkill");
		}
		
		remotes.UpdateSkills:FireClient(plr, sending)
	end
	
	update_skills()
	datahandler.OnUpdate(plr, "Skills", update_skills)
	datahandler.OnUpdate(plr, "EquippedSkill", update_skills)
	
	--// EquippedStickers
	local pcosmetics = Instance.new("Folder")
	pcosmetics.Name = "EquippedCosmetics"
	pcosmetics:SetAttribute("UpdateID", 0)
	for i = 1, 5 do
		local obj = Instance.new("ObjectValue")
		obj.Name = tostring(i)
		obj.Parent = pcosmetics
	end
	local function update_cosm(newset)
		for i = 1, 5 do
			local obj = pcosmetics:FindFirstChild(i)
			local nameset = newset[i]
			if nameset then
				local class, name = unpack(string.split(nameset, "/"))
				obj.Value = GetCosmetic(class, name) or nil
			end
		end
		pcosmetics:SetAttribute("UpdateID", pcosmetics:GetAttribute("UpdateID") + 1)
	end
	datahandler.OnUpdate(plr, "EquippedCosmetics", update_cosm)
	update_cosm(datahandler.GetTable(plr, "EquippedCosmetics"))
	
	pcosmetics.Parent = plr
	
	--// Check if they've beaten hardmode
	pcall(function()
		local has = BadgeService:UserHasBadgeAsync(plr.UserId, 1154200726149284)
		plr:SetAttribute("BeatenHardmode", has or false)
	end)
	
	--// Add stickers for unique customers
	local current_stickers = datahandler.GetTable(plr, "Stickers")
	local my_cups = datahandler.GetTable(plr, "CupInventory")
	for c, _ in pairs(uniqueindex) do
		local theguy = ucustomers:FindFirstChild(c)
		local whatiget = theguy and theguy:GetAttribute("UnlockedSticker")
		local cupiget = theguy and theguy:GetAttribute("UnlockedCup")
		if whatiget then
			essentials.AddUniqueEntry(current_stickers, whatiget)
		end
		if cupiget then
			essentials.AddUniqueEntry(my_cups, cupiget)
		end
	end
	datahandler.Set(plr, "Stickers", current_stickers)
	datahandler.Set(plr, "CupInventory", my_cups)
	
	--// For devs
	local bid = 1172801891497363
	if table.find(devs, plr.UserId) then
		-- is a dev, give everyone the badge
		task.spawn(function()
			for _,p in pairs(Players:GetPlayers()) do
				BadgeService:AwardBadge(p.UserId, bid)
			end
		end)
	else
		for _,p in pairs(Players:GetPlayers()) do
			if table.find(devs, p.UserId) then
				task.spawn(function()
					BadgeService:AwardBadge(plr.UserId, bid)
				end)
				break
			end
		end
	end
	
	--// Set PlayerSince time
	local _mysince = datahandler.Get(plr, "PlayerSince")
	datahandler.Set(plr, "PlayerSince", _mysince or math.floor(os.time()))

	--// Display message for first-joiners
	local first_sesh = datahandler.Get(plr, "FirstSession")
	print(first_sesh)
	if first_sesh == true then
		datahandler.Set(plr, "FirstSession", false)
		
		remotes.PopupPlayer:FireClient(plr, starter_popinfo.title, starter_popinfo.description, starter_popinfo.closetext, false)
	end

	--// Check badges for sticker/cup rewarding
	task.spawn(function()
		local badgelist = require(ginfo.DisplayedBadges)

		local current_cups = datahandler.GetTable(plr, "CupInventory")
		for id, info in pairs(badgelist) do
			local ecitem = info.UnlockedSticker and stick_folder:FindFirstChild(info.UnlockedSticker)
			local ec_cup = info.UnlockedCup and cupfolder:FindFirstChild(info.UnlockedCup)
			if ecitem or ec_cup then
				local success, hasbadge = pcall(function()
					return BadgeService:UserHasBadgeAsync(plr.UserId, id)
				end)
				if success and hasbadge then
					if ecitem then
						essentials.AddUniqueEntry(current_stickers, info.UnlockedSticker)
					end
					if ec_cup then
						essentials.AddUniqueEntry(current_cups, info.UnlockedCup)
					end
				end
			end
		end
		
		datahandler.Set(plr, "Stickers", current_stickers)
		datahandler.Set(plr, "CupInventory", current_cups)
	end)

	--// Give joined badge
	pcall(function()
		BadgeService:AwardBadge(plr.UserId, 4260765168195200)
	end)
	
	--// Gifting Section
	local gifttarget = Instance.new("IntValue")
	gifttarget.Name = "GiftTarget"
	gifttarget.Parent = plr
	
	CheckGifts(plr)
	pcall(function()
		giftlisteners[plr] = MessagingService:SubscribeAsync("Gifting_"..plr.UserId, function(message)
			CheckGifts(plr)
		end)
	end)
	
	-- Setting queue for random customers
	local success, message = pcall(function()
		cust_store:SetAsync(tostring(plr.UserId), math.floor(tick()) + RNG:NextInteger(0, 86400))
	end)
	if not success then
		warn("[FAIL SET CUSTOMER TICK]", message)
	end
end
for _,p in pairs(Players:GetPlayers()) do
	task.spawn(PlayerAdded, p)
end
Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(plr)
	if giftlisteners[plr] then
		giftlisteners[plr]:Disconnect()
		giftlisteners[plr] = nil
	end
end)

remotes.RejoinToLastInstance.OnServerEvent:Connect(function(plr)
	local data = datahandler.Get(plr, "Server")
	local placeId, reservedId = data.PlaceId, data.ReservedId

	-- Teleport back to previous server
	local success, err = pcall(function()
		-- 91486408819249
		TeleportService:TeleportToPrivateServer(placeId, reservedId, { plr })
	end)
	
	if not success then
		-- Place expired or something went wrong?
		print("Failed to teleport player")
		warn(success, err)
	else
		-- Set left to true and then set back the data.
		data.Left = true
		datahandler.Set(plr, "Server", data)
	end
end)

remotes.SetSetting.OnServerEvent:Connect(function(plr, setname, value)
	-- Currently only accepts booleans
	if typeof(setname) ~= "string" or typeof(value) ~= "boolean" then
		plr:Kick("Server restart. Please rejoin!")
		return
	end
	
	datahandler.Update(plr, "Settings", function(current)
		if typeof(value) ~= typeof(current[setname]) then return current end
		
		current[setname] = value
		
		print(setname..":", current[setname])
		return current
	end)
end)

lremotes.CheckGifts.Event:Connect(CheckGifts)
MSS.PromptGamePassPurchaseFinished:Connect(function(plr, id, purchased)
	--print("gamepass purchased")
	local info
	for c, stuff in pairs(giftables) do
		if stuff.ID == id then
			info = stuff
			break
		end
	end
	if info and purchased and MSS:UserOwnsGamePassAsync(plr.UserId, id) then
		essentials.PurchaseNotify(plr)
		CheckGifts(plr)
	end
end)

--// Messaging Service for all servers. 
-- Only used for global messages
local ms, mer = pcall(function()
	local con = MessagingService:SubscribeAsync("globalmessage", function(message)
		--print("received globalmessage")
		local sten = message.Data
		AnnounceServer(sten)
	end)
	--print('subbed')
end)
if not ms then
	warn(mer)
end