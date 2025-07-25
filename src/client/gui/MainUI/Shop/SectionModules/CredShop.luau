local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MSS = game:GetService("MarketplaceService")
local UIS = game:GetService("UserInputService")

local lmodules = ReplicatedStorage.LocalModules
local sfx = game:GetService("SoundService").SFX
local plr = Players.LocalPlayer
local remotes = ReplicatedStorage.Remotes
local cups = ReplicatedStorage.Cups

local stock = script.Frame

local holder = script.Parent.Parent
local credframe = holder.Frame.Main.Sections.Cred

local essentials = require(lmodules.EssentialFunctions)
local ui_essentials = require(lmodules.UIEssentials)
local confirm_manager = require(holder.ShopModules.ConfirmManager)
local my_inventory = require(holder.ShopModules.Inventory)
local babemanager = require(holder.ShopModules.BabeManager)

local products = {
	[1] = {2686839532; "250 Cred";};
	[2] = {2686839644; "750 Cred";};
	[3] = {2686839769; "1,500 Cred";};
	[4] = {2686839920; "3,000 Cred";};
	[5] = {2686840078; "7,500 Cred!";};
}

for i,info in pairs(products) do
	local frame = credframe:FindFirstChild(tostring(i))
	local butt = frame.TextButton
	
	butt.Title.Text = info[2]
	butt.PriceFrame.TextLabel.Text = "???"
	ui_essentials.GlareGradient(butt.UIGradient)
	
	task.spawn(function()
		local success, prod = pcall(function()
			return MSS:GetProductInfo(info[1], Enum.InfoType.Product)
		end)
		if success and prod then
			butt.PriceFrame.TextLabel.Text = essentials.FormatNum(prod.PriceInRobux)
		elseif not success then
			warn("Cannot get CredProduct Info:", prod)
		end
	end)
	
	butt.MouseEnter:Connect(function()
		butt.Hover.Visible = true
	end)
	butt.MouseLeave:Connect(function()
		butt.Hover.Visible = false
	end)
	butt.Activated:Connect(function()
		ui_essentials.ButtonEffect(butt)
		ui_essentials.RoyalSound()
		
		MSS:PromptProductPurchase(plr, info[1])
	end)
end

local service = {}

function service.Enable()
	sfx.Shiny:Play()
	credframe.Visible = true
	babemanager.DisplayBabe("BabeGirl")
end

function service.Disable()
	credframe.Visible = false
end

return service