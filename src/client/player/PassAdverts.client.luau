local MSS = game:GetService("MarketplaceService")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SFX = game:GetService("SoundService").SFX
local RNG = Random.new()

local lremotes = ReplicatedStorage.LocalRemotes
local lmodules = ReplicatedStorage.LocalModules
local plr = Players.LocalPlayer

local essentials = require(lmodules.EssentialFunctions)
local ui_essentials = require(lmodules.UIEssentials)

local FlashTI = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

-- Updates price on the sign and prompts product purchase
local function SignAdded(sign)
	local pass_id = sign:GetAttribute("GamepassID")
	local part = sign:WaitForChild("Sign")
	local UI = part:WaitForChild("SurfaceGui")
	local flash = UI:WaitForChild("Flash")
	local pricelabel = UI:WaitForChild("PriceFrame"):WaitForChild("TextLabel")
	
	local passinfo = MSS:GetProductInfo(pass_id, Enum.InfoType.GamePass)
	
	pricelabel.Text = (passinfo.PriceInRobux and essentials.FormatNum(passinfo.PriceInRobux, true)) or "???"
	
	local CD = Instance.new("ClickDetector")
	CD.CursorIcon = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png"
	CD.MaxActivationDistance = 100
	CD.Parent = part
	
	CD.MouseClick:Connect(function()
		local new = flash:Clone()
		new.Visible = true
		new.Name = "ClonedFlash"
		new.BackgroundTransparency = 0.5
		new.Size = UDim2.fromScale(0, 1)
		new.Parent = UI
		
		local track = TweenService:Create(new, FlashTI, {
			BackgroundTransparency = 1;
			Size = UDim2.fromScale(1, 1);
		})
		track:Play()
		
		task.delay(0.5, function()
			new:Destroy()
		end)
		
		ui_essentials.RoyalSound()
		MSS:PromptGamePassPurchase(plr, pass_id)
	end)
end

for _,c in pairs(CollectionService:GetTagged("GamepassSigns")) do
	task.spawn(SignAdded, c)
end
CollectionService:GetInstanceAddedSignal("GamepassSigns"):Connect(SignAdded)

while true do
	task.wait(RNG:NextInteger(60, 120))
	
	lremotes.Notify:Fire("Don't forget to leave a like and invite your friends! ❤", 5, {
		TextColor = Color3.fromRGB(255, 216, 119);
		StrokeColor = Color3.fromRGB(83, 55, 43);
	}, {"Favourite"})
end