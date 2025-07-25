local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules
local smodules = ServerStorage.ServerModules

local essentials = require(lmodules.EssentialFunctions)
local datahandler = require(smodules.DataHandler)
local weaponpasses = require(lmodules.WeaponPasses)

return function(plr)
	local ownedpasses = datahandler.GetTable(plr, "VirtualGamepasses")
	local disabledpasses = datahandler.GetTable(plr, "DisabledGamepasses")
	local currentweapons = datahandler.GetTable(plr, "Weapons")

	local passes = {}
	local new_weapon

	for id, name in pairs(weaponpasses) do
		if ownedpasses[tostring(id)] and ownedpasses[tostring(id)] > 0 then
			-- owns this pass
			local added = essentials.AddUniqueEntry(currentweapons, name)
			if added then
				new_weapon = name
			end
		end
	end
	for id, am in pairs(ownedpasses) do
		if am <= 0 then continue end
		
		local isdisabled = disabledpasses[id] == true
		--print(id, isdisabled)
		
		passes[tonumber(id)] = not isdisabled
	end

	datahandler.Set(plr, "Weapons", currentweapons)
	if new_weapon then
		datahandler.Set(plr, "EquippedWeapon", new_weapon)
	end

	remotes.UpdateExclusive:FireClient(plr, {
		Passes = passes;
		Weapons = currentweapons;
		EquippedWeapon = datahandler.Get(plr, "EquippedWeapon");
	})
end