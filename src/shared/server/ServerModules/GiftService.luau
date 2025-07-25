local DSS = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessagingService = game:GetService("MessagingService")

local smodules = ServerStorage.ServerModules
local lmodules = ReplicatedStorage.LocalModules
local datahandler = require(smodules.DataHandler)
local gift_store = DSS:GetDataStore("Gifts_"..datahandler.masterKey)

local giftables = require(lmodules.GamepassInfo)

local service = {}

function service.GrantGift(plr, ID, GPCode)
	if not giftables[GPCode] then
		return false
	end
	
	local success, no = pcall(function()
		gift_store:UpdateAsync(ID, function(pending)
			local sending = pending or {}
			table.insert(sending, {
				Code = GPCode;
				SenderName = plr.Name;
				SenderID = plr.UserId;
			})

			return sending
		end)
	end)
	if not success then
		warn(no)
		return false
	end
	local s2, message = pcall(function()
		MessagingService:PublishAsync("Gifting_"..ID, {
			Gifter = plr.UserId;
			Item = GPCode;
		})
	end)
	if not s2 then
		warn(message)
	end
	
	return true
end

return service