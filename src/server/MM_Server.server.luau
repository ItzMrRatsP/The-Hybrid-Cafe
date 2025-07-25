local MemoryStoreService = game:GetService("MemoryStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local AnalyticsService = game:GetService("AnalyticsService")

local MM_Hashmap = MemoryStoreService:GetSortedMap("Matchmaking")

-- Change, It will queue everyone when it reaches that amount of players
local MAX_PLAYER_QUEUE = 5
local MINIMUM_PLAYER_QUEUE = 1
local EXPIRE = (60 * 60 * 24 * 45) -- max expire time, do not change
local COOLDOWN_PER_REQUEST = 5
local GAME_ID = 91486408819249

local matchFound = ReplicatedStorage.Remotes.MatchFound
local hostMatch = ReplicatedStorage.Remotes.Matchmaking

local mainNormal = require(ReplicatedStorage.GamemodeSelections.MainNormal)

local serverCooldown = {}
local localQueuedPlayers = {}
local preservedToTeleport = {}

-- we don't want to make player stuck on the diff they selected
local function createListOfQueue()
	-- set time
	local read = MM_Hashmap:GetRangeAsync(Enum.SortDirection.Descending, MAX_PLAYER_QUEUE)
	local exportTable = {}

	if #read < MINIMUM_PLAYER_QUEUE or #read < MAX_PLAYER_QUEUE then
		return
	end

	for index, data in read do
		MM_Hashmap:RemoveAsync(data.key)
		preservedToTeleport[data.key] = true
		
		exportTable[data.key] = data
	end

	return exportTable
end

local function joinGlobal(player: Player)
	local success, err = pcall(function()
		MM_Hashmap:SetAsync(`{player.UserId}`, {
			queueStarted = os.time(),
		}, EXPIRE)
	end)
	
	if (not success) then
		warn(err)
		return
	end
	
	localQueuedPlayers[player.UserId] = true
end

local function leaveGlobal(player: Player)
	-- Player didn't even enter queue
	if (not localQueuedPlayers[player.UserId]) then
		return
	end
	
	local success, err = pcall(function()
		MM_Hashmap:RemoveAsync(`{player.UserId}`)
	end)
	
	if (not success) then
		return
	end
	
	localQueuedPlayers[player.UserId] = nil
end

hostMatch.OnServerEvent:Connect(function(player)
	if preservedToTeleport[player] then
		warn('teleporting player; reserved already')
		return
	end
	
	if (serverCooldown[player] and os.time() < serverCooldown[player] + COOLDOWN_PER_REQUEST) then
		warn('request blocked; wait.')
		return
	end

	if localQueuedPlayers[player.UserId] then
		leaveGlobal(player)
	else
		joinGlobal(player)
	end
end)

Players.PlayerRemoving:Connect(leaveGlobal)

-- Loop
while (true) do
	local playersQueue = createListOfQueue()
	if (not playersQueue) then
		task.wait(COOLDOWN_PER_REQUEST)
		continue
	end

	-- List is full, tp them after
	local playersToTeleport = {}
	
	for index, data in playersQueue do
		local player = Players:GetPlayerByUserId(data.key)
		if (not player) then
			continue
		end
		
		preservedToTeleport[player] = true
		matchFound:FireClient(player, data.value.queueStarted)
		
		-- Add to funnel
		AnalyticsService:LogFunnelStepEvent(player, "joined game")
		
		table.insert(playersToTeleport, player)
	end
	
	--[[
						local teledata = {
						forgame = {
							Gamemode = modeinfo.Gamemode;
							Difficulty = modeinfo.Difficulty;
							PartyCount = #telegroup;
							MatchRank = matrank;
							Funs = filteredfun;
						};
						-- any other data exclusive to player here
					}
	]]
	
	-- Delay 1s before teleporting
	task.delay(1, function()
		local teleOption = Instance.new("TeleportOptions")
		local teleData = {
			forgame = {
				Gamemode = mainNormal.Gamemode,
				Difficulty = mainNormal.Difficulty,
				PartyCount = MAX_PLAYER_QUEUE;
				MatchRank = 1;
				Funs = {};
			}
		}

		-- Set the data
		teleOption:SetTeleportData(teleData)

		-- Teleport:
		-- Teleport everyone in party.
		TeleportService:TeleportAsync(GAME_ID, playersToTeleport, teleOption)
		
	end)
	
	task.wait(COOLDOWN_PER_REQUEST)
end