local Analytics = game:GetService("AnalyticsService")
local Players = game:GetService("Players")
local Http = game:GetService("HttpService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local servermodules = ServerStorage.ServerModules

local datahandler = require(servermodules.DataHandler)

local service = {}

local function safeRun(foo)
	task.spawn(function()
		local success, message = pcall(foo)
		if not success then
			warn(message)
		end
	end)
end

function service.LogShopItem(plr, itemname, price)
	safeRun(function()
		local newbalance = datahandler.Get(plr, "Cred")

		Analytics:LogEconomyEvent(plr, Enum.AnalyticsEconomyFlowType.Sink,
			"Cred", price, newbalance,
			Enum.AnalyticsEconomyTransactionType.Shop.Name,
			itemname,
			{}
		)
	end)
end
function service.LogCredGain(plr, Type, gain)
	safeRun(function()
		local newbalance = datahandler.Get(plr, "Cred")
		Analytics:LogEconomyEvent(plr, Enum.AnalyticsEconomyFlowType.Source,
			"Cred", math.abs(gain), math.clamp(newbalance, 0, 9e9),
			Enum.AnalyticsEconomyTransactionType.Gameplay.Name,
			Type,
			{}
		)
	end)
end

return service