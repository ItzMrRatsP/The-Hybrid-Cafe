local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local remotes = ReplicatedStorage.Remotes

local signal = require(lmodules.Signal)

local init = remotes.UpdateInventory.OnClientEvent:Wait()

local module = {
	inventory = init.inventory;
	current = init.equipped;
	israndom = init.israndom;
}

module.OnUpdate = signal.new()

remotes.UpdateInventory.OnClientEvent:Connect(function(items)
	module.inventory = items.inventory
	module.current = items.equipped
	module.israndom = items.israndom
	
	module.OnUpdate:Fire()
end)

return module
