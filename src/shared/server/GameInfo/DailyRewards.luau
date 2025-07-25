local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cups = ReplicatedStorage.Cups
local smodules = ServerStorage.ServerModules
local datahandler = require(smodules.DataHandler)
local analytics = require(smodules.AnalyticsModule)
local specialRewards = require(ReplicatedStorage.LocalModules.SpecialRewards)

local credvalues = {
	50;
	75;
	125;
	150;
	175;
	200;
	250;
}


local service = {}
service.NextClaimTime = (3600 * 12) -- 12 hours

service.ClaimMethods = {
	["Cred"] = function(plr, amount)
		datahandler.Increment(plr, "Cred", amount)
		analytics.LogCredGain(plr, "DailyReward", amount)
	end;
	["Cup"] = function(plr, cname)
		local m = cups:FindFirstChild(cname)
		
		if m then
			datahandler.Update(plr, "CupInventory", function(old)
				if not table.find(old, cname) then
					table.insert(old, cname)
				end
				return old
			end)
		end
	end;
	
	["Sticker"] = function(plr, stickerName)
		local sticker = ReplicatedStorage.Stickers:FindFirstChild(stickerName)
		
		if (sticker) then
			datahandler.Update(plr, "Stickers", function(old)
				if not table.find(old, stickerName) then
					table.insert(old, stickerName)
				end
				
				return old
			end)
		end
	end;
}

local function hasCup(plr, cup)
	local cupInv = datahandler.GetTable(plr, "CupInventory")
	return not not table.find(cupInv, cup)
end

local function hasSticker(plr, sticker)
	local stickerInv = datahandler.GetTable(plr, "Stickers")
	return not (not table.find(stickerInv, sticker))
end

function service.GetRewards(plr, streak: number, level: number)
	--local week = math.ceil(streak / 7)	-- Useless value;
	local sending = {}

	for i = 1, 7 do
		sending[i] = {"Cred"; credvalues[i]}
	end
	
	-- Check if that particular streak has cup attached to it, Then we replace it with cup if it does
	for reward, config in specialRewards.Config do
		-- The reward doesn't exist in the sending list, We can't replace it
		local index = config.index
		if (not sending[index]) then
			warn("The reward is not in the list to replace;")
			continue
		end
		
		-- It has that special cup, So we skip it so we can have the cred rewards
		local hasIt = (config.t == "Cup" and hasCup(plr, reward) or hasSticker(plr, reward))
		print(hasIt, config.t)
		
		if (hasIt) then
			continue
		end
		
		-- update the cup index to the cup value;
		sending[index] = {config.t; reward}
	end

	return sending
end

return service
