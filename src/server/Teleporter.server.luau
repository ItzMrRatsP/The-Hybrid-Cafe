local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local RNG = Random.new(tick())

local smodules = ServerStorage.ServerModules
local lmodules = ReplicatedStorage.LocalModules
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local roomfolder = workspace:WaitForChild("Rooms")
local modes = ReplicatedStorage.GamemodeSelections
local funextras = ReplicatedStorage.FunExtras
local ranks = ReplicatedStorage.Ranks

local boatmanager = require(smodules.TeleBoatManager)
local datahandler = require(smodules.DataHnadler)
local testinfo = require(lmodules.TestPlaceInfo)

--// HATCH EVENT
local ptimers = {}

local function GetRoomedPlayers(room)
	local sending = {}
	for _, p in pairs(Players:GetPlayers()) do
		pcall(function()
			if p.CurrentRoom.Value == room then
				table.insert(sending, p)
			end
		end)
	end
	return sending
end
local function SetRoomChallenges(room, chlist)
	local UI = room.BillboardGui
	local frame = UI.ImageFrame
	local chframe = frame.Challenge_List

	for _, t in pairs(chframe:GetChildren()) do
		if t:IsA("TextLabel") then
			t.Visible = false
		end
	end
	for i = 1, #chlist do
		local item = chlist[i]
		local tex = chframe:FindFirstChild(tostring(i))
		if not tex then
			break
		end

		tex.Visible = item ~= nil
		if item then
			local mod = funextras:FindFirstChild(item)
			local info = require(mod)

			tex.Text = "- " .. info.DisplayName
		end
	end
end

for _, room in pairs(roomfolder:GetChildren()) do
	local mainwall = room:FindFirstChild("MainWall") or room.PrimaryPart
	if not mainwall then
		continue
	end

	room:SetAttribute("Timer", -1)
	room:SetAttribute("Closed", false)
	room:SetAttribute("Counting", false)
	room:SetAttribute("MaxPlayers", 1)

	mainwall.Touched:Connect(function(hit)
		local plr = hit.Parent and Players:GetPlayerFromCharacter(hit.Parent)
		if plr then
			local rvalue = plr.CurrentRoom
			--// Cannot enter if player is already in a room, the room is closed or the room is full
			if
				rvalue.Value
				or room:GetAttribute("Closed")
				or (room:GetAttribute("Counting") and #GetRoomedPlayers(room) >= room:GetAttribute("MaxPlayers"))
				or plr:GetAttribute("Teleporting")
			then
				return
			end

			--print("Set room value!!!")
			rvalue.Value = room
			if not room:GetAttribute("Counting") then
				-- empty room, player can host.

				remotes.PromptHostRoom:FireClient(plr)
				room:SetAttribute("Closed", true)

				ptimers[plr] = task.delay(
					20,
					function() -- to prevent softlocking, player loses rights after 10 seconds.
						print("player is too damn slow")

						if plr and rvalue then
							rvalue.Value = nil
						end
						room:SetAttribute("Closed", false)
					end
				)
			end
		end
	end)

	--// UI stuff
	local UI = room.BillboardGui
	local frame = UI.ImageFrame
	local tb = frame.ImageLabel
	local modename = frame.MainTitle
	local difname = frame.Title2
	local pframe = frame.Frame
	local pcount = pframe.PlayerText
	local countdown = UI.Counter
	local chframe = frame.Challenge_List
	local ranktex = frame.Title3

	local function UpdateUI()
		local currenttime, iscounting = room:GetAttribute("Timer"), room:GetAttribute("Counting")

		difname.Visible = iscounting
		modename.Visible = iscounting
		tb.Visible = iscounting
		chframe.Visible = iscounting

		local mode = room:GetAttribute("CurrentMode")
		local matrank = room:GetAttribute("CurrentRank")

		local minfo = mode and modes:FindFirstChild(mode)
		if minfo and iscounting then
			minfo = require(minfo)

			modename.Text = minfo.MainTitle
			tb.Image = minfo.Image

			difname.Text = minfo.SubTitle[1]
			difname.TextColor3 = minfo.SubTitle[2]
		end

		local rankinfo = ranks:FindFirstChild(tostring(matrank))
		ranktex.Visible = rankinfo ~= nil and iscounting
		if rankinfo then
			local r_info = require(rankinfo)
			ranktex.Text = r_info.DisplayName
			ranktex.TextColor3 = r_info.NameColor or Color3.fromRGB(255, 255, 255)
		end
	end
	local function UpdateCount()
		local currenttime, iscounting = room:GetAttribute("Timer"), room:GetAttribute("Counting")
		if iscounting then
			if currenttime <= -1 then
				countdown.Text = "Teleporting now.."
			else
				countdown.Text = "Teleporting in " .. currenttime .. ".."
			end
		else
			countdown.Text = "Waiting for Players.."
		end

		local mplayers = room:GetAttribute("MaxPlayers")
		pcount.Text = #GetRoomedPlayers(room) .. "/" .. mplayers
	end

	UpdateCount()
	UpdateUI()
	room:GetAttributeChangedSignal("Timer"):Connect(UpdateCount)
	room:GetAttributeChangedSignal("MaxPlayers"):Connect(UpdateUI)
	room:GetAttributeChangedSignal("Counting"):Connect(function()
		UpdateUI()
		UpdateCount()
	end)
end

remotes:WaitForChild("HostRoom").OnServerEvent:Connect(function(plr, maxplayers, selmode, rank, sel_fun)
	local mrange = workspace:GetAttribute("MaxPlayerRange")
	if
		typeof(maxplayers) ~= "number"
		or maxplayers < mrange.Min
		or maxplayers > mrange.Max
		or typeof(selmode) ~= "Instance"
		or selmode.Parent ~= modes
		or typeof(sel_fun) ~= "table"
	then
		plr:Kick("Server restart.")
		return
	end

	local modeinfo = require(selmode)
	local matrank = rank

	if matrank then
		if typeof(matrank) ~= "number" then
			plr:Kick("Server restart.")
			return
		end

		matrank = math.clamp(matrank, 1, math.min(datahandler.Get(plr, "CurrentRank"), #ranks:GetChildren() - 1))

		if not modeinfo.AllowRanks then
			matrank = nil
		end
	end

	local filteredfun = {}
	if datahandler.Get(plr, "BestRank") >= 1 then
		for _, ch in pairs(sel_fun) do
			if typeof(ch) ~= "string" then
				plr:Kick("Server restart.")
				return
			end

			local mod = funextras:FindFirstChild(ch)
			if mod then
				table.insert(filteredfun, ch)
			end
		end
	end

	local room = plr.CurrentRoom.Value
	if room and not plr:GetAttribute("Teleporting") and room:GetAttribute("Closed") and modeinfo then
		local max = math.ceil(maxplayers)

		if ptimers[plr] then
			task.cancel(ptimers[plr])
			ptimers[plr] = nil
		end

		room:SetAttribute("CurrentMode", selmode.Name)
		room:SetAttribute("CurrentRank", matrank or 0)
		room:SetAttribute("MaxPlayers", max)
		room:SetAttribute("Closed", false)
		room:SetAttribute("Counting", true)
		SetRoomChallenges(room, filteredfun)

		room:SetAttribute("Timer", 30)
		repeat
			task.wait(1)
			room:SetAttribute("Timer", room:GetAttribute("Timer") - 1)
		until #GetRoomedPlayers(room) <= 0 or #GetRoomedPlayers(room) == maxplayers or room:GetAttribute("Timer") <= -1
		room:SetAttribute("Timer", -1)
		room:SetAttribute("Closed", true)

		if #GetRoomedPlayers(room) > 0 then
			local thr = {}
			local telegroup = GetRoomedPlayers(room)
			local colseed = RNG:NextNumber(0, 10000)
			for _, p in pairs(telegroup) do
				p:SetAttribute("Teleporting", true)
				remotes.DisplayTeleMessage:FireClient(p, selmode, matrank, filteredfun, telegroup, colseed)

				thr[p] = task.delay(15, function()
					if p then
						p:SetAttribute("Teleporting", false)
						p:LoadCharacter()
					end
				end)
			end
			boatmanager.AddBoat(telegroup)

			task.delay(5, function()
				room:SetAttribute("Closed", false)
				room:SetAttribute("Counting", false)
				room:SetAttribute("MaxPlayers", 1)
			end)

			local success, message = pcall(function()
				local id = (testinfo.IsTest and testinfo.TeleportIDs[2]) or testinfo.TeleportIDs[1]
				local code = TeleportService:ReserveServer(id)

				for _, p in pairs(telegroup) do
					local teleoptions = Instance.new("TeleportOptions")
					teleoptions.ReservedServerAccessCode = code

					-- Useful later :cool:
					datahandler.Set(p, "Server", {
						ReservedId = code,
						PlaceId = id,
						Left = true,
					})

					local teledata = {
						forgame = {
							Gamemode = modeinfo.Gamemode,
							Difficulty = modeinfo.Difficulty,
							PartyCount = #telegroup,
							MatchRank = matrank,
							Funs = filteredfun,
						},
						-- any other data exclusive to player here
					}

					teleoptions:SetTeleportData(teledata)

					task.spawn(function()
						TeleportService:TeleportAsync(id, { p }, teleoptions)
					end)
				end

				--[[TeleportService:TeleportToPrivateServer(id, code, telegroup, nil, {
					forgame = {
						Gamemode = modeinfo.Gamemode;
						Difficulty = modeinfo.Difficulty;
						PartyCount = #telegroup;
						MatchRank = matrank;
						Funs = filteredfun;
					};
					-- any other data exclusive to player here
				})--]]
			end)
			--[[if not success then
				for _,p in pairs(telegroup) do
					task.cancel(thr[p])
					p:SetAttribute("Teleporting", false)
					p:LoadCharacter()
				end
			end--]]
		else
			room:SetAttribute("Closed", false)
			room:SetAttribute("Counting", false)
			room:SetAttribute("MaxPlayers", 1)
		end
	end
end)

remotes.ExitRoom.OnServerEvent:Connect(function(plr)
	if plr:GetAttribute("Teleporting") then
		return
	end

	local rvalue = plr.CurrentRoom
	local room = rvalue.Value
	if room then
		rvalue.Value = nil
		if not room:GetAttribute("Counting") then
			-- player was hosting
			room:SetAttribute("Closed", false)
			room:SetAttribute("MaxPlayers", 1)
			room:SetAttribute("Counting", false)

			if ptimers[plr] then
				task.cancel(ptimers[plr])
				ptimers[plr] = nil
			end
		end
	end
end)
