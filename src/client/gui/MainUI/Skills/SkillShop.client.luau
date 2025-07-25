local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local MSS = game:GetService("MarketplaceService")
local Camera = workspace.CurrentCamera
local RNG = Random.new()

local plr = Players.LocalPlayer
local lmodules = ReplicatedStorage.LocalModules
local lremotes = ReplicatedStorage.LocalRemotes
local SFX = game:GetService("SoundService").SFX
local datastats = plr:WaitForChild("DataStats")
local credval = datastats:WaitForChild("Cred")
local skillmods = ReplicatedStorage.Skills
local remotes = ReplicatedStorage.Remotes

local plr = Players.LocalPlayer
local holder = script.Parent
local UI = holder.Parent
local frame = holder.Frame
local close = frame.Close
local credtext = frame.CredDisplay.TextLabel
local content = frame.Content
local actions = content.Actions
local mainactions = actions.MainAction
local buttonsframe = content.Buttons.ScrollingFrame
local sinfoframe = content.SkillInfo.Content
local desc_frame = sinfoframe.Description

local act_gift = actions.Gift
local act_buy, act_equip, act_robux = mainactions.Buy, mainactions.Equip, mainactions.RobuxBuy

local essentials = require(lmodules.EssentialFunctions)
local ui_essentials = require(lmodules.UIEssentials)
local promise = require(lmodules.Utility.Promise)
local myskills = require(lmodules.MySkills)

local prompt = workspace:WaitForChild("Lobby"):WaitForChild("Required"):WaitForChild("SkillShopHolder"):WaitForChild("ProximityPrompt")
local current

local sm_button = buttonsframe.Frame
local desctext = desc_frame.TextLabel
sm_button.Visible = false
desctext.Visible = false

local equipped_color = Color3.fromRGB(0,255,0)
local product_cache = {}

local function IsUnlisted(m, info)
	return ((not info.Price and not info.PremiumProduct) 
		or info.OnSale == false)
		and table.find(myskills.Skills, m.Name) == nil
end

local skilltab = {}
for _,m in pairs(skillmods:GetChildren()) do
	local info = require(m)
	
	local new = sm_button:Clone()
	local butt = new.TextButton
	
	local listed = not IsUnlisted(m, info)
	--print(m, listed)
	
	new.Visible = listed
	butt.TextLabel.Text = info.DisplayName
	butt.GraphicBG.Image = info.Image
	new.Parent = buttonsframe
	
	if info.PremiumProduct then
		butt.UIStroke.Color = Color3.fromRGB(255, 237, 135)
		butt.BackgroundColor3 = Color3.fromRGB(72, 45, 21)
		butt.TextLabel.GoldGradient.Enabled = true
		
		ui_essentials.GlareGradient(butt.TextLabel.GoldGradient)
	end
	
	new:SetAttribute("StrokeColor", butt.UIStroke.Color)
	
	local item = {
		module = m;
		button = new;
		date = info.DateCreated;
		default = info.IsDefault;
	}
	table.insert(skilltab, item)
end

table.sort(skilltab, function(a, b)
	if a.default then
		return true
	elseif b.default then
		return false
	end
	
	for i = 1, 3 do
		local na, nb = a.date[i], b.date[i]
		if na ~= nb then
			return na > nb
		end
	end
	
	return a.module.Name < b.module.Name
end)

local function getitem_fromname(name)
	for _,item in pairs(skilltab) do
		if item.module.Name == name then
			return item
		end
	end
	return nil
end

local function updated_equipped()
	for _,item in pairs(skilltab) do
		local equipping = myskills.Equipped == item.module.Name
		item.button.TextButton.UIStroke.Color = (equipping and equipped_color) or item.button:GetAttribute("StrokeColor")
	end
end

local robget
local function selectitem(item)
	for _,t in pairs(desc_frame:GetChildren()) do
		if t:IsA("TextLabel") and t.Visible then
			t:Destroy()
		end
	end
	
	current = item
	
	local info = require(item.module)
	
	sinfoframe.ImageLabel.Image = info.Image
	sinfoframe.Title.Text = info.DisplayName
	sinfoframe.ImageLabel.UIStroke.Color = Color3.fromRGB(214, 164, 255)
	sinfoframe.ImageLabel.UIStroke.GoldGradient.Enabled = false
	sinfoframe.OuterGlow.Visible = false
	
	if info.PremiumProduct then
		sinfoframe.ImageLabel.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		sinfoframe.ImageLabel.UIStroke.GoldGradient.Enabled = true
		sinfoframe.OuterGlow.Visible = true
	end
	
	for i,des in pairs(info.Description) do
		local nd = desctext:Clone()
		nd.Visible = true
		nd.LayoutOrder = i
		
		nd.Text = des[1]
		nd.TextXAlignment = des[2] or Enum.TextXAlignment.Left
		nd.TextColor3 = des[3] or Color3.fromRGB(255,255,255)
		
		local current = nd.Size
		nd.Size = UDim2.new(current.X.Scale, current.X.Offset, current.Y.Scale * (des[4] or 1), current.Y.Offset)
		
		nd.Parent = desc_frame
	end
	
	act_gift.Visible = info.GiftProduct ~= nil
	act_buy.Visible = false
	act_equip.Visible = false
	act_robux.Visible = false
	if robget then
		robget:cancel()
		robget = nil
	end
	if table.find(myskills.Skills, item.module.Name) then
		act_equip.Visible = true
		
		local equipped = myskills.Equipped == item.module.Name
		act_equip.TextButton.BuyFor.Text = (equipped and "Equipped!") or "Equip Skill"
	elseif info.PremiumProduct then
		act_robux.Visible = true
		
		act_robux.TextButton.BuyFor.Text = "..."
		robget = promise.new(function(resolve, reject, oncancel)
			if product_cache[info.PremiumProduct] then
				resolve(product_cache[info.PremiumProduct])
				return
			end
			
			local prod = MSS:GetProductInfo(info.PremiumProduct, Enum.InfoType.Product)
			product_cache[info.PremiumProduct] = prod.PriceInRobux
			
			resolve(prod.PriceInRobux)
		end):andThen(function(price)
			act_robux.TextButton.BuyFor.Text = ""..essentials.FormatNum(price, true)
		end, function()
			act_robux.TextButton.BuyFor.Text = "".."???"
		end):catch(function(err)
			warn(tostring(err))
		end)
		
	elseif info.Price then
		act_buy.Visible = true
		act_buy.TextButton.TextHolder.Price.Text = essentials.FormatNum(info.Price, true)
	end
end

local function updated_myskills()
	if current then
		selectitem(current)
	end
end

for i, item in pairs(skilltab) do
	item.button.LayoutOrder = i
	
	item.button.TextButton.Activated:Connect(function()
		ui_essentials.ButtonEffect(item.button.TextButton)
		
		selectitem(item)
	end)
end

updated_equipped()
updated_myskills()
myskills.Updated:Connect(function()
	updated_equipped()
	updated_myskills()
end)

-- Button functions
local function InitButton(frame, foo)
	local butt = frame.TextButton
	
	butt.Activated:Connect(function()
		foo(butt)
	end)
end

InitButton(act_buy, function(butt)
	ui_essentials.ButtonEffect(butt)
	if not current or not current.module then return end
	
	local info = require(current.module)
	if not info.OnSale or info.PremiumProduct then return end
	
	local accepted, message = remotes.BuySkill:InvokeServer(current.module)
	if accepted then
		ui_essentials.Notify("Purchased "..info.DisplayName.." Skill!", "Purchased", 5)
	elseif message then
		ui_essentials.Notify(message, "Error", 5)
	end
end)
InitButton(act_robux, function(butt)
	ui_essentials.RoyalSound()
	ui_essentials.ButtonEffect(butt)
	if not current or not current.module then return end

	local info = require(current.module)
	if not info.OnSale or not info.PremiumProduct then return end
	
	MSS:PromptProductPurchase(plr, info.PremiumProduct)
end)
InitButton(act_equip, function(butt)
	ui_essentials.ButtonEffect(butt)
	if not current or not current.module then return end

	butt.BuyFor.Text = "Equipped!"
	remotes.EquipSkill:FireServer(current.module)
end)
InitButton(act_gift, function(butt)
	ui_essentials.ButtonEffect(butt)
	if not current or not current.module then return end
	
	local info = require(current.module)
	if not info.OnSale or not info.GiftProduct then return end
	
	lremotes.InitGiftScene:Fire(info.GiftProduct)
end)

-- Cred Display
ui_essentials.AddCredText(credtext)

-- Robux Glare
ui_essentials.GlareGradient(act_robux.TextButton.UIGradient)
ui_essentials.GlareGradient(sinfoframe.ImageLabel.UIStroke.GoldGradient)
ui_essentials.GlareGradient(sinfoframe.OuterGlow.GoldGradient)

--// Opening anim
holder:GetPropertyChangedSignal("Visible"):Connect(function()
	local state = holder.Visible

	prompt.Enabled = not state
	if state then
		ui_essentials.DisableAllMains(holder)
		ui_essentials.OpenTab(frame)
		
		local equipped = myskills.Equipped
		local item = getitem_fromname(equipped)
		if item then
			selectitem(item)
		end
	end
end)

--// Close
close.Activated:Connect(function()
	holder.Visible = false
	SFX.CloseTab:Play()
end)
ui_essentials.ImgCloseButton(close)

prompt.Triggered:Connect(function()
	holder.Visible = true
end)