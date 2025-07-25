local MSS = game:GetService("MarketplaceService")
local DSS = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules
local smodules = ServerStorage.ServerModules
local purchaseHistoryStore = DSS:GetDataStore("PurchaseHistory")

local ginfo = ServerStorage.GameInfo
local productFunctions = require(ginfo.DeveloperProducts)
local essentials = require(lmodules.EssentialFunctions)
local datahandler = require(smodules.DataHandler)

-- The core 'ProcessReceipt' callback function
local function processReceipt(receiptInfo)
	-- Determine if the product was already granted by checking the data store
	local playerProductKey = receiptInfo.PlayerId .. "_" .. receiptInfo.PurchaseId
	local purchased = false
	local success, result, errorMessage

	success, errorMessage = pcall(function()
		purchased = purchaseHistoryStore:GetAsync(playerProductKey)
	end)
	-- If purchase was recorded, the product was already granted
	if success and purchased then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif not success then
		error("Data store error:" .. errorMessage)
	end

	-- Determine if the product was already granted by checking the data store
	local playerProductKey = receiptInfo.PlayerId .. "_" .. receiptInfo.PurchaseId

	local success, isPurchaseRecorded = pcall(function()
		return purchaseHistoryStore:UpdateAsync(playerProductKey, function(alreadyPurchased)
			if alreadyPurchased then
				return true
			end

			-- Find the player who made the purchase in the server
			local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
			if not player then
				-- The player probably left the game
				-- If they come back, the callback will be called again
				return nil
			end

			pcall(function()
				datahandler.Update(player, "BoughtProducts", function(old)
					if not table.find(old, receiptInfo.ProductId) then
						table.insert(old, receiptInfo.ProductId)
					end
					return old
				end)
			end)

			local handler = productFunctions[receiptInfo.ProductId]

			local success, result = pcall(handler, receiptInfo, player)
			-- If granting the product failed, do NOT record the purchase in datastores.
			if not success or not result then
				error(
					"Failed to process a product purchase for ProductId: "
						.. tostring(receiptInfo.ProductId)
						.. " Player: "
						.. tostring(player)
						.. " Error: "
						.. tostring(result)
				)
				return nil
			end

			-- Record the transaction in purchaseHistoryStore.
			return true
		end)
	end)

	if not success then
		error("Failed to process receipt due to data store error.")
		return Enum.ProductPurchaseDecision.NotProcessedYet
	elseif isPurchaseRecorded == nil then
		-- Didn't update the value in data store.
		return Enum.ProductPurchaseDecision.NotProcessedYet
	else
		-- IMPORTANT: Tell Roblox that the game successfully handled the purchase
		local plr = Players:GetPlayerByUserId(receiptInfo.PlayerId)
		if plr then
			essentials.PurchaseNotify(plr)
			task.spawn(function()
				datahandler.SaveAll(plr)
			end)
		end

		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
end

MSS.ProcessReceipt = processReceipt
