local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RNG = Random.new(tick())

local ServerModules = script.Parent

local Service = {}
Service.Throttle = 0
Service.DataStore2 = require(script.DataStore2)

Service.DefaultData = {
	Cred = 0;
	
	--HighestDay = 0;
	GamesPlayed = 0;
	--TotalDays = 0;
	BestRank = 0;
	CurrentRank = 1;
	
	--TimePlayed = 0;
	--CustomersServed = 0;
	--CashEarned = 0;
	--CashSpent = 0;
	BestEndurance = 0;
	LearntTutorials = {};
	
	Server = {
		ReservedId = 0;
		PlaceId = 0;
		Left = false;
	};
	
	ReadBlogs = {};
	RandomCups = false;
	
	AuraInventory = {"Galaxy"};
	CurrentAura = "Galaxy";
	
	CupInventory = {"Default"};
	CurrentCup = "Default";
	
	DailyTaken = 0;
	DailyLevel = 0;
	DailyStreak = 0;
	
	RankMigrated = false;
	CompletedRanks = {};
	BestTimes = {};
	UniqueCustomers = {};
	ServiceQuality = {
		Waiting = {0; 0};
		Build = {0; 0};
		Top = {0; 0};
		Snacks = {0; 0};
	};
	
	BoughtProducts = {};
	ProcessedGamepasses = {};
	GiftHistory = {};
	GiftBank = {};

	DisabledGamepasses = {};
	VirtualGamepasses = {};
	EquippedWeapon = "None";
	Weapons = {};
	
	Skills = {"Barista"};
	EquippedSkill = "Barista";
	
	PlayerSince = nil;
	FirstSession = true;
	
	EquippedCosmetics = {};
	Stickers = {};
	DisplayedAchievement = 0;
	
	FreeRevives = 1;
	ChallengeLevel = 1;
	Completions = {
		["Main"] = 0;
		["Main_Hard"] = 0;
	};
	
	Settings = {
		LobbyMusic = true;
		GameMusic = true;
		CameraBobbing = true;
	};
	
	PlayerStats = {
		TotalPlaytime = 0;
		HighestDay = 0;
		CustomersServed = 0;
		PerfectOrders = 0;
		DaysCompleted = 0;
		CoffeeCups = 0;
		MilkCups = 0;
		Snacks = 0;
		Drinks = 0;
		EnemiesKilled = 0;
		Deaths = 0;
		AkarisSprayed = 0;
		ACFixes = 0;
		MachineFixes = 0;
		ProfitEarned = 0;
		ProfitSpent = 0;
	};
	
	TriedToLeave = false;
}

Service.masterKey = "THC_001_Live"

local CombinedKeys = {}
local function CombineItem(key)
	if not table.find(CombinedKeys, key) then
		table.insert(CombinedKeys, key)
		Service.DataStore2.Combine(Service.masterKey, key)
	end
end

for data, default in pairs(Service.DefaultData) do
	CombineItem(data)
end

local load = 0
function Service.InitializePlayer(plr)
	
	if load > 0 then
		print("Loaded with someone, joined queue")
		repeat
			task.wait(RNG:NextNumber(0.4, 0.7))
		until load <= 0
	end
	
	load += 1
	local folder = Instance.new("Folder")
	folder.Name = "DataStats"
	
	local now = tick()
	local success, mes = pcall(function()
		for key, default in pairs(Service.DefaultData) do
			local value
			if typeof(default) == "string" then
				value = Instance.new("StringValue")
			elseif typeof(default) == "number" then
				value = Instance.new("IntValue")
			elseif typeof(default) == "boolean" then
				value = Instance.new("BoolValue")
			end
			
			if value then
				value.Name = key
				local store = Service.DataStore2(key, plr)
				value.Value = store:Get(default)
				value.Parent = folder

				store:OnUpdate(function(newvalue)
					value.Value = newvalue
				end)
			end
		end
	end)
	
	print(plr, "Data loaded", tick() - now)
	folder.Parent = plr
	load -= 1
	if not success then
		error(mes)
	end
end

function Service.Get(plr, key, dontget)
	CombineItem(key)
	
	local store = Service.DataStore2(key, plr)
	local success, item = pcall(function()
		return store:Get(Service.DefaultData[key], dontget)
	end)
	
	if success and item ~= nil then
		return item
	else
		return Service.DefaultData[key]
	end
end

function Service.GetTable(plr, key)
	CombineItem(key)
	
	local store = Service.DataStore2(key, plr)
	local success, item = pcall(function()
		return store:GetTable(Service.DefaultData[key])
	end)
	return (success and item) or Service.DefaultData[key]
end

function Service.Set(plr, key, value)
	CombineItem(key)
	
	local store = Service.DataStore2(key, plr)
	store:Set(value)
end

-- NOTE: This function only works on tables
function Service.Update(plr, key, call)
	CombineItem(key)
	
	--update is a function that passes current value and returns new value, like UpdateAsync
	local current = Service.GetTable(plr, key)
	local modded = call(current)
	--print(modded)
	Service.Set(plr, key, modded)
end

function Service.Increment(plr, key, value)
	if Service.DefaultData[key] == nil then return end
	CombineItem(key)

	local store = Service.DataStore2(key, plr)
	pcall(function()
		store:Increment(value, Service.DefaultData[key])
	end)
end

function Service.OnUpdate(plr, key, foo)
	if Service.DefaultData[key] == nil then return end
	CombineItem(key)
	
	local store = Service.DataStore2(key, plr)
	store:OnUpdate(foo)
end

function Service.GetThrotLimit()
	local am = #Players:GetPlayers()
	return (60 + (am * 10)) - (am * 2)
end

function Service.GetSortedThrot()
	local am = #Players:GetPlayers()
	return ((am * 2))
end

function Service.SaveAll(plr)
	if Service.Throttle >= Service.GetThrotLimit() then
		repeat
			task.wait(1)
		until Service.Throttle < Service.GetThrotLimit()
	end
	Service.Throttle += 1

	Service.DataStore2.SaveAll(plr)

	Service.Throttle -= 1

	print("data savedAll")
end

return Service
