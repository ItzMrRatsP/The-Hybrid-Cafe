local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local DataHandler = require(ServerStorage.ServerModules.DataHandler)

Players.PlayerAdded:Connect(function(Player)
	DataHandler.Set(Player, "DailyStreak", 2)
	DataHandler.Set(Player, "DailyLevel", 2)
	DataHandler.Set(Player, "DailyTaken", DataHandler.Get(Player, "DailyTaken") - (60*60*12))
end)