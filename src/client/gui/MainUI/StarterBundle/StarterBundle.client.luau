local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MSS = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local sfx = game:GetService("SoundService").SFX
local RNG = Random.new()

local plr = Players.LocalPlayer
local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules
local datastats = plr:WaitForChild("DataStats")

local essentials = require(lmodules.EssentialFunctions)
local ui_essentials = require(lmodules.UIEssentials)

local holder = script.Parent
local ui = holder.Parent
local mainbuttons = ui.MainButtons
local buttonframe = mainbuttons.BundleButton
local button_bundle = buttonframe.TextButton
local bundleframe = holder.Frame
local sflash = bundleframe.SideFlash
local close = bundleframe.Close
local buyholder = bundleframe.BuyButton
local buybutton = buyholder.TextButton
local sparkle = buttonframe.Sparkle

local targetproduct = 2675449963

local gradients = {
	bundleframe.UIGradient;
	button_bundle.UIGradient;
}
local timers = {
	bundleframe.Timer;
	buttonframe.Timer;
}

local clockthread

local totaltime = 86400 * 7
local function Update()
	local start = plr:GetAttribute("BundleStart")
	if not start then return end
	
	local myproducts = remotes.GetMyProducts:InvokeServer()

	if clockthread then
		task.cancel(clockthread)
	end
	
	local hasit = table.find(myproducts, targetproduct) ~= nil
	
	if os.time() - start >= totaltime or hasit then
		holder.Visible = false
		buttonframe.Visible = false
	elseif os.time() - start < totaltime then
		-- count it down
		clockthread = task.spawn(function()
			local last = start + totaltime
			repeat
				local left = last - os.time()
				local text = essentials.Convert_To_DHMS(math.floor(left))
				
				for _,t in pairs(timers) do
					t.Text = "Offer ends in "..text
				end
				task.wait(1)
			until os.time() >= last
			
			holder.Visible = false
			buttonframe.Visible = false
		end)
	end
end
Update()
plr:GetAttributeChangedSignal("BundleStart"):Connect(Update)

local success, message = pcall(function()
	local info = MSS:GetProductInfo(targetproduct, Enum.InfoType.Product)
	buybutton.PriceFrame.TextLabel.Text = info.PriceInRobux
end)
if not success then
	warn("[GetBundleInfo]", message)
	buybutton.PriceFrame.TextLabel.Text = "???"
end

buybutton.Activated:Connect(function()
	ui_essentials.ButtonEffect(buybutton, true)
	ui_essentials.RoyalSound()
	ui_essentials.SideFlash(bundleframe.SideFlash)
	
	MSS:PromptProductPurchase(plr, targetproduct)
end)

button_bundle.Activated:Connect(function()
	ui_essentials.ButtonEffect(button_bundle)
	ui_essentials.DisableAllMains(holder)
	
	if not holder.Visible then
		holder.Visible = true
		sfx.Shiny:Play()
		ui_essentials.OpenTab(bundleframe)
	end
end)
close.Activated:Connect(function()
	holder.Visible = false
	sfx.CloseTab:Play()
end)

ui_essentials.ImgCloseButton(close)

task.spawn(function()
	local fadeTI = TweenInfo.new(1, Enum.EasingStyle.Linear)
	while ui do
		local new = sparkle:Clone()
		new.Visible = true

		local s = RNG:NextNumber(0.5, 1)
		new.Name = "ClonedSparkle"
		new.Size = UDim2.fromScale(s, s)
		new.Rotation = RNG:NextNumber(-45, 45)
		new.Position = UDim2.fromScale(RNG:NextNumber(0, 1), RNG:NextNumber(0, 1))
		new.Parent = buttonframe
		
		local ranrot = RNG:NextInteger(-15, 15)
		
		task.spawn(function()
			new.ImageTransparency = 1
			local track = TweenService:Create(new, fadeTI, {
				ImageTransparency = 0;
				Rotation = new.Rotation + ranrot;
			})
			track:Play()
			task.wait(fadeTI.Time)
			local track2 = TweenService:Create(new, fadeTI, {
				ImageTransparency = 1;
				Rotation = new.Rotation + ranrot;
			})
			track2:Play()
			task.wait(fadeTI.Time)
			new:Destroy()
		end)

		task.wait(RNG:NextNumber(1, 3))
	end
end)
task.spawn(function()
	local rotTI = TweenInfo.new(5, Enum.EasingStyle.Linear)
	while ui do
		for _,t in pairs(gradients) do
			t.Rotation = -180
			local track = TweenService:Create(t, rotTI, {
				Rotation = 180;
			})
			track:Play()
		end
		task.wait(rotTI.Time)
	end
end)
