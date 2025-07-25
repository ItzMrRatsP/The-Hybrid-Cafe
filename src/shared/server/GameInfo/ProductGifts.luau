local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local smodules = ServerStorage.ServerModules
local remotes = ReplicatedStorage.Remotes

local skills = ReplicatedStorage.Skills
local datahandler = require(smodules.DataHandler)

local items = {}

for _,m in pairs(skills:GetChildren()) do
	local info = require(m)
	
	local id = info.GiftProduct
	if not info.OnSale or not id then continue end
	
	local tab = {}
	tab.CanGift = function(plr)
		local myskills = datahandler.GetTable(plr, "Skills")
		return table.find(myskills, m.Name) == nil
	end
	tab.Gifting = function(plr, gifter)
		datahandler.Update(plr, "Skills", function(tab)
			if not table.find(tab, m.Name) then
				table.insert(tab, m.Name)
			end
			
			return tab
		end)
		
		remotes.NotifyPlayer:FireClient(plr, "🎁"..gifter.Name.." gifted you the "..info.DisplayName.." class!", 10, {
			TextColor = Color3.fromRGB(255, 169, 232);
			StrokeColor = Color3.fromRGB(106, 41, 94);
		}, {"BellRing"})
	end
	
	items[id] = tab
end

return items