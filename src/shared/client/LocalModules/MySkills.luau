local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules

local signal = require(lmodules.Signal)

local init = remotes.UpdateSkills.OnClientEvent:Wait()

local service = {}
service.Equipped = init.Equipped
service.Skills = init.Skills

service.Updated = signal.new()

remotes.UpdateSkills.OnClientEvent:Connect(function(newstats)
	service.Equipped = newstats.Equipped
	service.Skills = newstats.Skills

	service.Updated:Fire()
end)

return service

