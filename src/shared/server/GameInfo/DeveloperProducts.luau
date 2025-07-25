local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local remotes = ReplicatedStorage.Remotes
local smodules = ServerStorage.ServerModules
local lremotes = ReplicatedStorage.LocalRemotes
local lmodules = ReplicatedStorage.LocalModules
local cups = ReplicatedStorage.Cups
local skills = ReplicatedStorage.Skills
local ginfo = ServerStorage.GameInfo

local gift_service = require(smodules.GiftService)
local datahandler = require(smodules.DataHandler)
local analytics = require(smodules.AnalyticsModule)
local giftables = require(lmodules.GamepassInfo)
local prod_gifts = require(ginfo.ProductGifts)

local products = {}

local function giftnotify(plr, message, duration)
	remotes.NotifyPlayer:FireClient(plr, message, duration, {
		TextColor = Color3.fromRGB(255, 169, 232);
		StrokeColor = Color3.fromRGB(106, 41, 94);
	})
end

local function errnotify(plr)
	remotes.NotifyPlayer:FireClient(plr, "Something went wrong with your purchase! Your gift has been returned to you.", 5, {
		TextColor = Color3.fromRGB(255, 123, 125);
		StrokeColor = Color3.fromRGB(0, 0, 0);
	})
end

local function ProcessGift(plr, code)
	local info = giftables[code]

	local targetid = plr:GetAttribute("GiftTarget") or plr.UserId

	task.spawn(function()
		local success = gift_service.GrantGift(plr, targetid, code)

		if success then
			local yes, name = pcall(function()
				return Players:GetNameFromUserIdAsync(targetid)
			end)
			if yes then
				giftnotify(plr, "Successfully gifted "..info.DisplayName.." to "..name.."!", 5)
			end
		else
			gift_service.GrantGift(plr, plr.UserId, code)
		end
	end)

	return true
end

products[2675449963] = function(receipt, plr) -- Triple Bundle
	print("hi i bought this bundle")
	
	local pack = {
		915029382;
		915039285;
		914909471;
	}
	
	datahandler.Update(plr, "VirtualGamepasses", function(old)
		local new = old or {}
		for _,id in pairs(pack) do
			local prv = new[tostring(id)] or 0
			new[tostring(id)] = prv + 1
		end
		
		return new
	end)
	plr:SetAttribute("BundleStart", 0)
	
	return true
end;
products[2675450541] = function(receipt, plr) -- Extra Cash Gift
	return ProcessGift(plr, "ExtraCash")
end;
products[2675450301] = function(receipt, plr) -- Extra Health Gift
	return ProcessGift(plr, "ExtraHealth")
end;
products[2675450416] = function(receipt, plr) -- Extra Stamina Gift
	return ProcessGift(plr, "ExtraStamina")
end;
products[2676604402] = function(receipt, plr) -- Extra Stamina Gift
	return ProcessGift(plr, "Minigun")
end;
products[2687924326] = function(receipt, plr) -- Extra Stamina Gift
	return ProcessGift(plr, "DoubleCred")
end;
products[2836126645] = function(receipt, plr) -- Extra Stamina Gift
	return ProcessGift(plr, "Railgun")
end;


--// Cred products
local cred_products = {
	[2686839532] = 250;
	[2686839644] = 750;
	[2686839769] = 1500;
	[2686839920] = 3000;
	[2686840078] = 7500;
}
local credperrobux = 7500 / 1099

for id, am in pairs(cred_products) do
	products[id] = function(receipt, plr)
		local success, nope = pcall(function()
			datahandler.Increment(plr, "Cred", am)
		end)
		
		if not success then
			warn("CREDPRODUCT FAIL:", nope)
		else
			task.spawn(function()
				analytics.LogCredGain(plr, "RobuxPurchase", am)
			end)
		end
		return success
	end
end

for _,c in pairs(cups:GetChildren()) do
	if not c:IsA("ModuleScript") then continue end
	
	local info = require(c)
	if info.Premium and info.ProductID and info.CanPurchase then
		local deadline = info.PurchaseDeadline
		products[info.ProductID] = function(receipt, plr)
			local current = datahandler.GetTable(plr, "CupInventory")

			if table.find(current, c.Name) ~= nil or (deadline and os.time() - deadline > 60) then
				-- Convert price to Cred
				local spent = receipt.CurrencySpent or 1
				local credgiving = math.round(credperrobux * spent)
				
				datahandler.Increment(plr, "Cred", credgiving)
			else
				datahandler.Update(plr, "CupInventory", function(old)
					table.insert(old, c.Name)
					return old
				end)
			end
			
			return true
		end
	end
end

for _,sk in pairs(skills:GetChildren()) do
	local info = require(sk)
	local id = info.PremiumProduct
	local gift_id = info.GiftProduct
	
	if id then
		products[id] = function(receipt, plr)
			if info.OnSale then
				datahandler.Update(plr, "Skills", function(old)
					if not table.find(old, sk.Name) then
						table.insert(old, sk.Name)
					end

					return old
				end)
			else
				local spent = receipt.CurrencySpent or 1
				local credgiving = math.round(credperrobux * spent)

				datahandler.Increment(plr, "Cred", credgiving)
			end

			return true
		end
	end
	if gift_id and prod_gifts[gift_id] then
		products[gift_id] = function(receipt, plr)
			local motherid = plr:GetAttribute("GiftTarget")
			local mother = Players:GetPlayerByUserId(motherid)
			
			local success = false
			if mother and prod_gifts[gift_id].CanGift(mother) then
				success = true
			end
			
			if success then
				prod_gifts[gift_id].Gifting(mother)
			else
				datahandler.Update(plr, "GiftBank", function(tab)
					tab[tostring(gift_id)] = tab[tostring(gift_id)] or 0
					tab[tostring(gift_id)] += 1
					
					return tab
				end)
			end

			return true
		end
	end
end

return products