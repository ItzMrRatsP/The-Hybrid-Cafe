--!nocheck

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")
local HTTP = game:GetService("HttpService")
local MSS = game:GetService("MarketplaceService")
local BadgeService = game:GetService("BadgeService")

local remotes = ReplicatedStorage.Remotes
local smodules = ServerStorage.ServerModules
local lmodules = ReplicatedStorage.LocalModules
local ginfo = ServerStorage.GameInfo
local stick_folder = ReplicatedStorage.Stickers
local cups = ReplicatedStorage.Cups
local skills = ReplicatedStorage.Skills

local datahandler = require(smodules.DataHandler)
local banservice = require(smodules.BanService)
local gift_service = require(smodules.GiftService)
local daily_rewards = require(ginfo.DailyRewards)
local prod_gifts = require(ginfo.ProductGifts)
local analytics = require(smodules.AnalyticsModule)
local giftables = require(lmodules.GamepassInfo)
local essentials = require(lmodules.EssentialFunctions)
local t = require(lmodules.Utility.TypeChecker)

local update_exclusive = require(smodules.Common.UpdateExclusive)

task.spawn(function()
	require(ginfo.DisplayedBadges)
end)

local giftdb = {}
remotes.GiftGamepass.OnServerInvoke = function(plr, targetID, gpcode)
	if giftdb[plr] then
		return false, "Something went wrong. Try again."
	end
	if typeof(targetID) ~= "number" or typeof(gpcode) ~= "string" then
		plr:Kick("Server Restart.")
		return false, "Something went wrong. Try again."
	end
	
	local info = giftables[gpcode]
	if not info then
		return false, "Select a gift."
	end
	
	giftdb[plr] = true
	task.delay(3, function()
		giftdb[plr] = nil
	end)
	
	-- Check if given userID is valid
	local success, hisName = pcall(function()
		return Players:GetNameFromUserIdAsync(targetID)
	end)
	if not success then
		return false, "Cannot gift to specified player."
	end
	-- TODO: IT'S STILL CHARGING EVEN THOUGH YOU HAVE THE FREES
	local mycoins = datahandler.GetTable(plr, "VirtualGamepasses")
	
	local idintext = tostring(info.ID)
	if mycoins[idintext] and mycoins[idintext] > 1 then
		-- Can gift it instantly
		local success2 = gift_service.GrantGift(plr, targetID, gpcode)
		if success2 then
			-- successfully gifted, deduct the coin
			datahandler.Update(plr, "VirtualGamepasses", function(old)
				print("spending from "..old[idintext])
				old[idintext] -= 1
				return old
			end)
			task.spawn(datahandler.SaveAll, plr)
			
			return true, "Successfully gifted "..info.DisplayName.." to "..hisName.."!"
		else
			return false, "Failed to send gift."
		end
	else
		-- Player must buy the product
		plr:SetAttribute("GiftTarget", targetID)
		
		MSS:PromptProductPurchase(plr, info.GiftID)
		return true, "Gifting "..info.DisplayName.." to "..hisName.."..."
	end
end

-- return response (number), message
-- 0: no response, 1: success, 2: error
-- uses plr:GetAttribute("GiftTarget") which is a userID
remotes.GiftProduct.OnServerInvoke = function(plr, ID, mother)
	if not t.number(ID) or not t.Instance(mother) or not mother:IsA("Player") or mother == plr or not prod_gifts[ID] then
		return 2, "Product not selected"
	end
	
	local giftbox = prod_gifts[ID]
	local cangift = giftbox.CanGift(mother)
	
	if not cangift then
		return 2, "Player already has this!"
	end
	
	local bank = datahandler.GetTable(plr, "GiftBank")
	local tokens = bank[tostring(ID)] or 0
	if tokens > 0 then
		datahandler.Update(plr, "GiftBank", function(tab)
			tab[tostring(ID)] = tab[tostring(ID)] or 0
			tab[tostring(ID)] -= 1

			return tab
		end)
		
		giftbox.Gifting(mother)
		return 1, "Successfully Gifted "..mother.Name
	else
		plr:SetAttribute("GiftTarget", mother.UserId)
		
		pcall(function()
			MSS:PromptProductPurchase(plr, ID)
		end)
		
		return 0
	end
end

remotes.GetMyProducts.OnServerInvoke = function(plr)
	local products = table.clone(datahandler.GetTable(plr, "BoughtProducts"))
	return products or {}
end

local gp_db = {}
remotes.GetMyGamepasses.OnServerInvoke = function(plr)
	if gp_db[plr] then return nil end
	gp_db[plr] = true
	task.delay(1, function()
		gp_db[plr] = nil
	end)
	
	local myvirtuals = datahandler.GetTable(plr, "VirtualGamepasses")
	local sending = {}
	for code, info in pairs(giftables) do
		local am = myvirtuals[tostring(info.ID)] or 0
		sending[code] = am
	end
	
	return sending
end

remotes.GetMyStickers.OnServerInvoke = function(plr)
	local mystickers = datahandler.GetTable(plr, "Stickers")
	--[[for i,v in pairs(mystickers) do
		print(i,v)
	end--]]
	return mystickers
end

--[[
	DailyTaken = 0;
	DailyLevel = 0;
	DailyStreak = 0;
	]]

local dailydb = {}
remotes.ClaimDailyReward.OnServerEvent:Connect(function(plr)
	-- Can he even take his rewards?
	local sincedaily = datahandler.Get(plr, "DailyTaken")
	local daily_takentime = os.time() - sincedaily
	
	if daily_takentime < daily_rewards.NextClaimTime or dailydb[plr] then
		return
	end
	dailydb[plr] = true
	task.delay(1, function()
		if plr then
			dailydb[plr] = nil
		end
	end)
	
	local level, streak = datahandler.Get(plr, "DailyLevel"), datahandler.Get(plr, "DailyStreak")
	local hisrewards = daily_rewards.GetRewards(plr, streak, level)
	
	local claiming = hisrewards[level]
	if not claiming or not daily_rewards.ClaimMethods[claiming[1]] then return end
	
	local args = table.clone(claiming)
	table.remove(args, 1)
	
	local success, message = pcall(function()
		daily_rewards.ClaimMethods[claiming[1]](plr, unpack(args))
	end)
	if not success then
		warn("[DailyClaim Fail]", message)
	else
		datahandler.Increment(plr, "DailyLevel", 1)
		datahandler.Increment(plr, "DailyStreak", 1)
		datahandler.Set(plr, "DailyTaken", os.time())
	end
end)

local cosm_accepted = {
	[ReplicatedStorage.Stickers] = "Spray";
}
remotes.SetCosmetics.OnServerEvent:Connect(function(plr, coslist)
	if typeof(coslist) ~= "table" or #coslist > 5 then 
		banservice.BanFromRemote(plr, remotes.SetCosmetics, coslist)
		return
	end
	
	local pstickers = datahandler.GetTable(plr, "Stickers")
	
	local filtered = {}
	for i = 1, 5 do
		local item = coslist[i]
		if not item then continue end
		
		if typeof(item) ~= "Instance" or not cosm_accepted[item.Parent] or item.ClassName == "PackageLink" then
			plr:Kick("Server Restart.")
			return
		end
		
		if table.find(pstickers, item.Name) then
			local entryname = cosm_accepted[item.Parent].."/"..item.Name
			table.insert(filtered, entryname)
		end
	end
	
	print("set cosmetics")
	datahandler.Set(plr, "EquippedCosmetics", filtered)
end)

remotes.GetBadgeList.OnServerInvoke = function(plr)
	local badgelist = require(ginfo.DisplayedBadges)
	return badgelist
end

local spb_db = {}
remotes.SetPlayerBadge.OnServerEvent:Connect(function(plr, id)
	if typeof(id) ~= "number" then
		banservice.BanFromRemote(plr, remotes.SetPlayerBadge, id)
		return
	end
	
	spb_db[plr] = spb_db[plr] or 0
	if spb_db[plr] > 35 then return end
	spb_db[plr] += 1
	
	local badgelist = require(ginfo.DisplayedBadges)
	if badgelist[id] then
		local success, hasbadge = pcall(function()
			return BadgeService:UserHasBadgeAsync(plr.UserId, id)
		end)
		if success and hasbadge then
			datahandler.Set(plr, "DisplayedAchievement", id)
		end
	end
	
	task.wait(60/35)
	spb_db[plr] -= 1
end)

local db = {}
local function SetDB(plr)
	db[plr] = true
	task.delay(2, function()
		if plr then
			db[plr] = nil
		end
	end)
end

--// Requests to buy a cup
remotes.Shop_BuyItem.OnServerInvoke = function(plr, mod)
	if typeof(mod) ~= "Instance" or not mod:IsA("ModuleScript") or mod.Parent ~= cups then
		banservice.BanFromRemote(plr, remotes.Shop_BuyItem, mod)
		return false
	end
	
	local cupname = mod.Name
	local info = require(mod)
	local myinv = datahandler.GetTable(plr, "CupInventory")
	if not info.CanPurchase or not info.Price or table.find(myinv, cupname) ~= nil then return false end
	
	local balance = datahandler.Get(plr, "Cred")
	if balance >= info.Price then
		-- Grant purchase
		
		datahandler.Increment(plr, "Cred", -info.Price)
		analytics.LogShopItem(plr, cupname, info.Price)
		datahandler.Update(plr, "CupInventory", function(old)
			table.insert(old, cupname)
			return old
		end)
		
		remotes.NotifyPlayer:FireClient(plr, "Successfully purchased "..info.DisplayName.."!", 5, {
			TextColor = Color3.fromRGB(133, 255, 153);
		}, {"NormalPurchase"})
		
		return true
	else
		-- Player is too poor
		remotes.NotifyPlayer:FireClient(plr, "You don't have enough Cred!", 5, {
			TextColor = Color3.fromRGB(255, 108, 108);
		}, {"Buzzer"})
		
		return false
	end
end

remotes.Shop_EquipItem.OnServerEvent:Connect(function(plr, mod)
	if typeof(mod) ~= "Instance" or not mod:IsA("ModuleScript") or mod.Parent ~= cups then
		banservice.BanFromRemote(plr, remotes.Shop_BuyItem, mod)
		return
	end
	
	local cupname = mod.Name
	local info = require(mod)
	local myinv = datahandler.GetTable(plr, "CupInventory")
	local current = datahandler.Get(plr, "CurrentCup")
	if table.find(myinv, cupname) == nil or current == cupname then return end
	
	datahandler.Set(plr, "RandomCups", false)
	datahandler.Set(plr, "CurrentCup", cupname)
end)

remotes.Shop_EnableRandom.OnServerEvent:Connect(function(plr)
	datahandler.Set(plr, "RandomCups", true)
end)

remotes.BuySkill.OnServerInvoke = function(plr, module)
	if typeof(module) ~= "Instance" or module.Parent ~= skills then
		banservice.BanFromRemote(plr, remotes.BuySkill, module)
		return
	end
	
	local info = require(module)
	local myskills = datahandler.GetTable(plr, "Skills")
	
	if not info.OnSale or not info.Price or info.PremiumProduct then
		return false, "Something's wrong."
	end
	if table.find(myskills, module.Name) then
		return false, "You already own this skill."
	end
	
	local balance = datahandler.Get(plr, "Cred")
	if balance >= info.Price then
		datahandler.Increment(plr, "Cred", -info.Price)
		analytics.LogShopItem(plr, "Skill/"..module.Name, info.Price)
		datahandler.Update(plr, "Skills", function(old)
			table.insert(old, module.Name)
			return old
		end)
		
		return true
	else
		return false, "You don't have enough Cred!"
	end
end
remotes.EquipSkill.OnServerEvent:Connect(function(plr, module)
	if typeof(module) ~= "Instance" or module.Parent ~= skills then
		banservice.BanFromRemote(plr, remotes.EquipSkill, module)
		return
	end

	local info = require(module)
	local myskills = datahandler.GetTable(plr, "Skills")
	
	if not table.find(myskills, module.Name) then
		return
	end
	
	datahandler.Set(plr, "EquippedSkill", module.Name)
end)

remotes.ToggleGamepass.OnServerEvent:Connect(function(plr, id, state)
	if typeof(id) ~= "number" or typeof(state) ~= "boolean" then
		banservice.BanFromRemote(plr, remotes.ToggleGamepass, id, state)
		return
	end
	
	local strung = tostring(id)
	
	-- Checking if they own the gamepass
	local mypasses = datahandler.GetTable(plr, "VirtualGamepasses")
	if not mypasses[strung] or mypasses[strung] <= 0 then return end
	
	datahandler.Update(plr, "DisabledGamepasses", function(old)
		old[strung] = not state
		return old
	end)
end)
remotes.EquipWeapon.OnServerEvent:Connect(function(plr, weapon)
	if typeof(weapon) ~= "string" then
		banservice.BanFromRemote(plr, remotes.EquipWeapon, weapon)
		return
	end
	
	-- Checking if they own the weapon
	local wepname = weapon
	local myweps = datahandler.GetTable(plr, "Weapons")
	if not table.find(myweps, wepname) then
		-- If doesn't own, change to none
		wepname = "None"
	end
	
	datahandler.Set(plr, "EquippedWeapon", wepname)
	update_exclusive(plr)
end)

remotes.RequestGroupRewards.OnServerInvoke = function(plr)
	local success, ingroup = pcall(function()
		return plr:IsInGroup(5353743)
	end)
	
	local yes = (success and ingroup) or false
	if yes then
		datahandler.Update(plr, "CupInventory", function(old)
			essentials.AddUniqueEntry(old, "ClassicCup")
			return old
		end)
		
		return true, "Thank you for joining! You received a free Classic Cup. You can equip it in the Shop."
	else
		return false, "You are not in the ArenaDev Group. If you recently joined, please rejoin the game."
	end
end

remotes.Admin_AnnounceServer.OnServerEvent:Connect(function(plr, message, targetid)
	if typeof(message) ~= "string" or db[plr] then return end
	SetDB(plr)
	
	if not plr:GetAttribute("IsAdmin") then
		banservice.BanFromRemote(plr, remotes.Admin_RemoteCommand, message, targetid)
		return
	end
	
	if not targetid then
		MessagingService:PublishAsync("globalmessage", message)
	else
		MessagingService:PublishAsync("player_"..targetid, HTTP:JSONEncode({
			action = "serverannounce";
			message = message;
		}))
	end
end)
remotes.Admin_RemoteCommand.OnServerEvent:Connect(function(plr, targetid, command, arguments)
	if typeof(targetid) ~= "number" or typeof(command) ~= "string" or typeof(arguments) ~= "string" or db[plr] then return end
	SetDB(plr)
	
	if not plr:GetAttribute("IsAdmin") then
		banservice.BanFromRemote(plr, remotes.Admin_RemoteCommand)
		return
	end
	
	MessagingService:PublishAsync("player_"..targetid, HTTP:JSONEncode({
		action = "command";
		message = arguments;
		command = command;
	}))
end)
remotes.Admin_Kick.OnServerEvent:Connect(function(plr, userid, reason)
	if db[plr] then return end
	SetDB(plr)
	
	if typeof(userid) ~= "number" or typeof(reason) ~= "string" or not plr:GetAttribute("IsAdmin") then
		banservice.BanFromRemote(plr, remotes.Admin_Kick, userid, reason)
		return
	end
	
	local target = Players:GetPlayerByUserId(userid)
	if target then
		target:Kick(reason)
	end
end)
remotes.Admin_Ban.OnServerInvoke = function(plr, Ban, userid, duration, reason, privatereason)
	if db[plr] then return end
	SetDB(plr)
	
	if not plr:GetAttribute("IsAdmin") or typeof(Ban) ~= "boolean" or typeof(userid) ~= "number" or (reason ~= nil and typeof(reason) ~= "string")
		or (duration ~= nil and typeof(duration) ~= "number") or (privatereason ~= nil and typeof(privatereason) ~= "string") then
		
		banservice.BanFromRemote(plr, remotes.Admin_Ban, Ban, userid, duration, reason, privatereason)
		return false, "Error occured."
	end
	if (privatereason and #privatereason > 900) or (reason and #reason > 400) or duration == 0 then
		return false, "Problem with arguments."
	end
	
	if Ban then
		local privreason = "Banned by "..plr.Name.." ("..plr.UserId..") | "..privatereason
		
		local success = banservice.Ban(userid, duration, reason, privreason)
		
		return success, (not success and "Failed to ban player.")
	else
		local success = banservice.Unban(userid)
		
		return success, (not success and "Failed to unban player.")
	end
end