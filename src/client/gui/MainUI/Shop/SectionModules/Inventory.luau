local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MSS = game:GetService("MarketplaceService")

local lmodules = ReplicatedStorage.LocalModules
local sfx = game:GetService("SoundService").SFX
local plr = Players.LocalPlayer
local remotes = ReplicatedStorage.Remotes
local cups = ReplicatedStorage.Cups

local stock = script.Frame

local holder = script.Parent.Parent
local scrollingframe = holder.Frame.Main.Sections.Inventory

local essentials = require(lmodules.EssentialFunctions)
local ui_essentials = require(lmodules.UIEssentials)
local confirm_manager = require(holder.ShopModules.ConfirmManager)
local my_inventory = require(holder.ShopModules.Inventory)
local babemanager = require(holder.ShopModules.BabeManager)

local service = {}

function service.Enable()
	scrollingframe.Visible = true
	babemanager.DisplayBabe("BabeBoy")
end

function service.Disable()
	scrollingframe.Visible = false
	confirm_manager.CloseFrame()
end

local function CreateButton(name, image, order, equipped)
	local new = stock:Clone()
	local butt = new.TextButton
	
	butt.Title.Text = name
	butt.Display.ImageLabel.Image = image
	new.LayoutOrder = order
	
	if equipped then
		butt.UIStroke.Color = Color3.fromRGB(0, 255, 0)
	end
	
	return new
end
local function inventoryupdate()
	local inventory = my_inventory.inventory
	local current = my_inventory.current
	local israndom = my_inventory.israndom

	for _,b in pairs(scrollingframe:GetChildren()) do
		if b:IsA("Frame") then
			b:Destroy()
		end
	end

	for i, it in pairs(inventory) do
		local mod = cups:FindFirstChild(it)
		if not mod then continue end

		local equipped = (current == it and not israndom)

		local info = require(mod)
		local new = CreateButton(info.DisplayName, info.Image, (#inventory - i) + 1, equipped)

		new.Parent = scrollingframe

		local butt = new.TextButton
		butt.Activated:Connect(function()
			ui_essentials.ButtonEffect(butt)
			confirm_manager.SelectItem(mod, true, equipped)
		end)
	end

	local random = CreateButton("Random", "rbxassetid://112321115208290", 0, israndom)
	random.Parent = scrollingframe
	random.TextButton.Activated:Connect(function()
		ui_essentials.ButtonEffect(random.TextButton)
		confirm_manager.SelectItem("Random", true, israndom)
	end)
end

inventoryupdate()
my_inventory.OnUpdate:Connect(inventoryupdate)

local gridlayout = scrollingframe.UIGridLayout
local function UpdateSize()
	local abs = gridlayout.AbsoluteContentSize.Y
	local x = scrollingframe.AbsoluteWindowSize.X
	x = x * 0.025

	gridlayout.CellPadding = UDim2.new(0.025, 0, 0, x)
	scrollingframe.CanvasSize = UDim2.fromOffset(0, abs + 50)
end

UpdateSize()
scrollingframe:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateSize)
gridlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)

return service