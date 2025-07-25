local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules

local signal = require(lmodules.Signal)

local service = {}
service.Stats = remotes.UpdateStats.OnClientEvent:Wait()
service.Updated = signal.new()

remotes.UpdateStats.OnClientEvent:Connect(function(newstats)
	service.Stats = newstats
	service.Updated:Fire()
end)

return service

