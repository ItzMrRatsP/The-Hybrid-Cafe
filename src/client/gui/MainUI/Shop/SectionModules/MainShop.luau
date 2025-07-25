local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MSS = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")

local lmodules = ReplicatedStorage.LocalModules
local sfx = game:GetService("SoundService").SFX
local plr = Players.LocalPlayer
local remotes = ReplicatedStorage.Remotes
local cups = ReplicatedStorage.Cups

local holder = script.Parent.Parent
local scrollingframe = holder.Frame.Main.Sections.Cups

local stock_row = script.Row
local stock_normal = script.Frame
local stock_premium = script.Premium

local essentials = require(lmodules.EssentialFunctions)
local ui_essentials = require(lmodules.UIEssentials)
local confirm_manager = require(holder.ShopModules.ConfirmManager)
local inventory = require(holder.ShopModules.Inventory)
local babemanager = require(holder.ShopModules.BabeManager)

local service = {}

local items = {}
for _,v in pairs(cups:GetChildren()) do
	if not v:IsA("ModuleScript") then continue end
	
	local info = require(v)
	if info.Unlisted or not info.CanPurchase then continue end
	
	if info.Premium and info.ProductID then
		local now = os.time()
		local deadline = info.PurchaseDeadline
		if not deadline or now > deadline then continue end
		
		local new = stock_premium:Clone()
		new.Name = v.Name
		local butt = new.TextButton
		butt.DisplayL.ImageLabel.Image = info.Image
		butt.DisplayR.ImageLabel.Image = info.Image
		butt.Title2.Text = info.DisplayName
		butt.Title.Text = info.PremiumTitle or "Limited Time!"
		new:SetAttribute("CreationDate", info.DateCreated or os.time())
		new:SetAttribute("Premium", true)
		
		ui_essentials.GlareGradient(butt.UIStroke.UIGradient)
		
		task.spawn(function()
			local bg = butt.BG2
			local scaler = bg.UIScale
			
			local scaler_L = butt.DisplayL.UIScale
			local scaler_R = butt.DisplayR.UIScale
			
			while bg.Parent and scaler.Parent do
				local dt = RunService.RenderStepped:Wait()
				local sine = math.sin(tick() * 2)
				
				scaler.Scale = 1.125 + (0.125 * sine)
				scaler_L.Scale = 1.05 + (sine * 0.05)
				scaler_R.Scale = 1.05 + (sine * 0.05)
			end
		end)
		
		task.spawn(function()
			butt.PriceFrame.TextLabel.Text = "???"
			local success, product_info = pcall(function()
				return MSS:GetProductInfo(info.ProductID, Enum.InfoType.Product)
			end)
			if success and product_info then
				butt.PriceFrame.TextLabel.Text = product_info.PriceInRobux
			else
				warn("Failed to get Product Info:", product_info)
			end
		end)
		
		butt.Activated:Connect(function()
			ui_essentials.ButtonEffect(butt)
			ui_essentials.RoyalSound()

			if butt.Owned.Visible then return end
			MSS:PromptProductPurchase(plr, info.ProductID)
		end)
		
		if deadline then
			task.spawn(function()
				local timer = butt.Timer
				repeat
					local remaining = deadline - os.time()
					timer.Text = "Goes offsale in "..essentials.Convert_To_DHMS(math.floor(remaining))
					task.wait(1)
				until os.time() >= deadline or not timer
				
				if butt.Parent.Parent then
					butt.Parent.Parent:Destroy()
				end
			end)
		end
		
		table.insert(items, new)
	elseif info.Price then
		local new = stock_normal:Clone()
		new.Name = v.Name
		local butt = new.TextButton
		butt.Display.ImageLabel.Image = info.Image
		butt.Title.Text = info.DisplayName
		butt.PriceFrame.TextLabel.Text = info.Price
		new:SetAttribute("CreationDate", info.DateCreated or os.time())
		
		butt.Activated:Connect(function()
			ui_essentials.ButtonEffect(butt)
			
			if butt.Owned.Visible then return end
			confirm_manager.SelectItem(v, table.find(inventory.inventory, v.name) ~= nil, inventory.current == v.Name)
		end)
		
		table.insert(items, new)
	end
end
table.sort(items, function(a, b)
	if a:GetAttribute("Premium") and not b:GetAttribute("Premium") then
		return true
	elseif b:GetAttribute("Premium") and not a:GetAttribute("Premium") then
		return false
	end
	
	return a:GetAttribute("CreationDate") > b:GetAttribute("CreationDate")
end)

local rowid = 1
local currentrow
local hp

for i, b in pairs(items) do
	if not currentrow then
		hp = 3
		currentrow = stock_row:Clone()
		currentrow.LayoutOrder = rowid
		
		currentrow.Parent = scrollingframe
		rowid += 1
	end
	
	b.LayoutOrder = i
	b.Parent = currentrow
	hp -= (b:GetAttribute("Premium") and 3) or 1
	if hp <= 0 then
		currentrow = nil
	end
end

local function UpdateGot()
	for _,f in pairs(items) do
		f.TextButton.Owned.Visible = table.find(inventory.inventory, f.Name) ~= nil
	end
end

UpdateGot()
inventory.OnUpdate:Connect(UpdateGot)

local listlayout = scrollingframe.UIListLayout
local function UpdateSize()
	local abs = listlayout.AbsoluteContentSize.Y
	local x = scrollingframe.AbsoluteWindowSize.X
	x = x * 0.05
	
	listlayout.Padding = UDim.new(0, x)
	scrollingframe.CanvasSize = UDim2.fromOffset(0, abs + 50)
end
UpdateSize()
scrollingframe:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateSize)
listlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)

function service.Enable()
	scrollingframe.Visible = true
	babemanager.DisplayBabe("BabeBoy")
end

function service.Disable()
	scrollingframe.Visible = false
	confirm_manager.CloseFrame()
end

return service