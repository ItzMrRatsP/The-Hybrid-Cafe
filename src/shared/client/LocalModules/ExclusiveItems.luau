local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules

local signal = require(lmodules.Signal)

local init = remotes.UpdateExclusive.OnClientEvent:Wait()

local service = {}
service.Passes = init.Passes
service.Weapons = init.Weapons
service.EquippedWeapon = init.EquippedWeapon

service.Updated = signal.new()

remotes.UpdateExclusive.OnClientEvent:Connect(function(newstats)
	service.Passes = newstats.Passes
	service.Weapons = newstats.Weapons
	service.EquippedWeapon = newstats.EquippedWeapon

	service.Updated:Fire()
end)

return service

