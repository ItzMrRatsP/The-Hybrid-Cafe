local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MSS = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")

local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules
local wepfolder = ReplicatedStorage.Weapons
local sfx = game:GetService("SoundService").SFX

local ui_essentials = require(lmodules.UIEssentials)
local myperks = require(lmodules.ExclusiveItems)
local giftables = require(lmodules.GamepassInfo)
local weaponpasses = require(lmodules.WeaponPasses)

local holder = script.Parent
local frame = holder.Frame
local ui = holder.Parent
local mainbuttons = ui.MainButtons
local cbutton = mainbuttons.ButtonsLeft.Exclusive
local close = frame.Close
local mainstuff = frame.Main
local perks = mainstuff.PerkFrame
local weapons = mainstuff.WeaponFrame

local sc1, sc2 = weapons.ScrollingFrame, perks.ScrollingFrame
local stock_perk = script.Perk
local stock_wep = script.Weapon

local strokecolor = Color3.fromRGB(199, 131, 255)
local TI = TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

local wepbuttons = {}
local perkbuttons = {}

local function UpdateEquipped()
	for n, f in pairs(wepbuttons) do
		if n == myperks.EquippedWeapon then
			f.TextButton.UIStroke.Color = Color3.fromRGB(0,255,0)
		else
			f.TextButton.UIStroke.Color = strokecolor
		end
	end
end

local function CreateButton(name, info, order, iswep)
	local new = stock_wep:Clone()
	local butt = new.TextButton

	if iswep then
		new.UIAspectRatioConstraint.AspectRatio = 1.5
	end

	butt.Title.Text = info.DisplayName or ""
	butt.ImageLabel.Image = info.Image or ""

	new.LayoutOrder = order or 0
	new.Name = name
	new.Parent = sc1
	wepbuttons[name] = new

	butt.Activated:Connect(function()
		ui_essentials.ButtonEffect(butt)
		
		myperks.EquippedWeapon = name
		UpdateEquipped()
		
		remotes.EquipWeapon:FireServer(name)
	end)
end

for i, item in pairs(myperks.Weapons) do
	local mod = wepfolder:FindFirstChild(item)
	if not mod then continue end
	
	local info = require(mod)
	CreateButton(item, info, i, true)
end
CreateButton("None", {
	DisplayName = "None";
	Image = "rbxassetid://14815623257";
}, 0)
UpdateEquipped()

local function GetfromID(id)
	local info
	for n, poing in pairs(giftables) do
		if poing.ID == tonumber(id) then
			info = poing
			break
		end
	end
	
	return info
end

local function CreatePerk(id, enabled)
	local info = GetfromID(id)
	if not info or weaponpasses[tonumber(id)] then return end

	local new = stock_perk:Clone()
	local n_frame = new.Frame
	local butt = new.TextButton
	local scaler = butt.UIScale

	n_frame.PassName.Text = info.DisplayName

	n_frame.BackgroundColor3 = info.Color
	n_frame.UIStroke.Color = info.Color
	n_frame.BG.ImageColor3 = info.Color
	butt.BackgroundColor3 = info.Color
	butt.UIStroke.Color = info.Color

	task.spawn(function()
		local product = MSS:GetProductInfo(tonumber(id), Enum.InfoType.GamePass)
		n_frame.ImageLabel.Image = "rbxassetid://"..product.IconImageAssetId
	end)

	local currentstate = enabled
	butt.CurrentState.Text = (currentstate and "Enabled") or "Disabled"

	new.Parent = sc2
	perkbuttons[id] = new

	butt.Activated:Connect(function()
		sfx.ButtonPress:Play()

		scaler.Scale = 0.8
		local track = TweenService:Create(scaler, TI, {Scale = 1})
		track:Play()

		currentstate = not currentstate
		butt.CurrentState.Text = (currentstate and "Enabled") or "Disabled"

		remotes.ToggleGamepass:FireServer(tonumber(id), currentstate)
	end)
end

for id, enabled in pairs(myperks.Passes) do
	CreatePerk(id, enabled)
end

local function Validity()
	local valid = #myperks.Weapons > 0
	if not valid then
		local has = 0
		for n, en in pairs(myperks.Passes) do
			has += 1
		end
		valid = has > 0
	end
	
	cbutton.Visible = valid
end

Validity()
myperks.Updated:Connect(function()
	print("redisplaying exclusive")
	
	local destroying = {}
	for n, f in pairs(wepbuttons) do
		if not table.find(myperks.Weapons, n) and n ~= "None" then
			table.insert(destroying, n)
		end
	end
	for _,n in pairs(destroying) do
		wepbuttons[n]:Destroy()
		wepbuttons[n] = nil
	end
	
	for _,n in pairs(myperks.Weapons) do
		if not wepbuttons[n] then
			local mod = wepfolder:FindFirstChild(n)
			if not mod then continue end

			local info = require(mod)
			CreateButton(n, info, 1, true)
		end
	end
	UpdateEquipped()
	
	destroying = {}
	for id, butt in pairs(perkbuttons) do
		if myperks.Passes[id] == nil then
			table.insert(destroying, id)
		end
	end
	for _,id in pairs(destroying) do
		perkbuttons[id]:Destroy()
		perkbuttons[id] = nil
	end
	for id, enabled in pairs(myperks.Passes) do
		if not perkbuttons[id] then
			CreatePerk(id, enabled)
		end
	end
	
	Validity()
end)

cbutton.Button.Activated:Connect(function()
	ui_essentials.ButtonEffect(cbutton.Button)

	ui_essentials.DisableAllMains(holder)
	local newstate = not holder.Visible
	holder.Visible = newstate

	if newstate then
		ui_essentials.OpenTab(frame)
	else
		sfx.CloseTab:Play()
	end
end)

close.Activated:Connect(function()
	holder.Visible = false
	sfx.CloseTab:Play()
end)
ui_essentials.ImgCloseButton(close)

local function UpdateList1()
	local abs = sc1.UIListLayout.AbsoluteContentSize.X
	sc1.CanvasSize = UDim2.fromOffset(abs, 0)
end
local function UpdateList2()
	local abs = sc2.UIListLayout.AbsoluteContentSize.Y
	sc2.CanvasSize = UDim2.fromOffset(0, abs)
end

UpdateList1()
UpdateList2()
sc1.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateList1)
sc2.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateList2)

ui_essentials.GlareGradient(frame.UIGradient)
ui_essentials.GlareGradient(cbutton.Button.UIGradient)