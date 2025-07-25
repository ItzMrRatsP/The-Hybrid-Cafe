local ServerStorage = game:GetService("ServerStorage")
local smodules = ServerStorage.ServerModules

local datahandler = require(smodules.DataHandler)

local conciler = {}

conciler["MigrateEquippedStickers"] = function(plr)
	local value = datahandler.Get(plr, "EquippedStickers", true)
	--print("reconcile", value)
	if value then
		local newset = {}
		for i,v in pairs(value) do
			newset[i] = "Spray/"..v
		end
		datahandler.Set(plr, "EquippedStickers", nil)
		datahandler.Set(plr, "EquippedCosmetics", newset)
		
		--print("Reconcilled cosmetics")
	end
end

local newstats = {
	HighestDay = "HighestDay";
	TotalDays = "DaysCompleted";
	TimePlayed = "TotalPlaytime";
	CustomersServed = "CustomersServed";
	CashEarned = "ProfitEarned";
	CashSpent = "ProfitSpent";
}
conciler["MigrateStatsToNew"] = function(plr)
	datahandler.Update(plr, "PlayerStats", function(old)
		for stat, newname in pairs(newstats) do
			local oldval = datahandler.Get(plr, stat, true)
			if oldval then
				old[newname] = oldval
			end
		end
		
		return old
	end)
	for stat, newname in pairs(newstats) do
		datahandler.Set(plr, stat, nil)
	end
end

return conciler