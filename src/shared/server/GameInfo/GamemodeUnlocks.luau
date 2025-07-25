local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")
local ServerStorage = game:GetService("ServerStorage")

local smodules = ServerStorage.ServerModules

local datahandler = require(smodules.DataHandler)

local info = {}

info["MainEndurance"] = function(plr)
	local success, hasbadge = pcall(function()
		return BadgeService:UserHasBadgeAsync(plr.UserId, 3893949146190014)
	end)
	if success and hasbadge then
		print("YOU UJNLOCK ENDURANCE!!!")
		return true
	elseif not success then
		warn("[Get EnduranceMain badge fail:", hasbadge)
		return false
	end
end

return info