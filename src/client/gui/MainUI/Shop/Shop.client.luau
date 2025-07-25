local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local RNG = Random.new()

local plr = Players.LocalPlayer
local lmodules = ReplicatedStorage.LocalModules
local SFX = game:GetService("SoundService").SFX
local datastats = plr:WaitForChild("DataStats")
local credval = datastats:WaitForChild("Cred")
local rvalue = plr:WaitForChild("CurrentRoom")

local plr = Players.LocalPlayer
local holder = script.Parent
local UI = holder.Parent
local frame = holder.Frame
local mods = holder.SectionModules
local main = frame.Main
local buttons = main.Buttons
local credframe = UI.MainButtons.ButtonsLeft.CredDisplay
local credframe2 = frame.CredDisplay

local essentials = require(lmodules.EssentialFunctions)
local ui_essentials = require(lmodules.UIEssentials)
local musicmanager = require(lmodules.MusicManager)

local sensor = workspace:WaitForChild("Lobby"):WaitForChild("Required"):WaitForChild("ShopSensor")
local default_section = "MainShop"
local current

local sections = {
	["MainShop"] = require(mods:FindFirstChild("MainShop"));
	["Inventory"] = require(mods:FindFirstChild("Inventory"));
	["CredShop"] = require(mods:FindFirstChild("CredShop"));
}
local bsecs = {
	Cred = "CredShop";
	Cups = "MainShop";
	Inventory = "Inventory";
}

local function DisableAll()
	for s, info in pairs(sections) do
		info.Disable()
	end
end

for name, sec in pairs(bsecs) do
	local f = buttons:FindFirstChild(name)
	if not f then continue end
	local butt = f.TextButton
	
	butt.Activated:Connect(function()
		ui_essentials.ButtonEffect(butt)
		
		DisableAll()
		sections[sec].Enable()
		current = sec
	end)
end
ui_essentials.GlareGradient(buttons.Cred.TextButton.UIGradient)

local fadeTI = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local cleanupthread
holder:GetPropertyChangedSignal("Visible"):Connect(function()
	local state = holder.Visible
	if state then
		ui_essentials.DisableAllMains(holder)
		ui_essentials.OpenTab(frame)
		SFX.ShopBell.PlaybackSpeed = RNG:NextNumber(0.75, 0.85)
		SFX.DoorOpen.PlaybackSpeed = RNG:NextNumber(0.95, 1.05)
		SFX.ShopBell:Play()
		SFX.DoorOpen:Play()
		
		if cleanupthread then
			pcall(function()
				task.cancel(cleanupthread)
			end)
		end
		musicmanager.ChangeTrack("ShopMusic")
		Lighting.ShopBlur.Size = 0
		Lighting.ShopBlur.Enabled = true
		local track = TweenService:Create(Lighting.ShopBlur, fadeTI, {
			Size = 28;
		})
		local track2 = TweenService:Create(Camera, fadeTI, {
			FieldOfView = 60;
		})
		
		track:Play()
		track2:Play()
		
		UI.MainButtons.Visible = false
		if default_section then
			DisableAll()
			sections[default_section].Enable()
			current = default_section
			default_section = nil
		end
	else
		musicmanager.ChangeTrack("MainLobby")
		SFX.CloseTab:Play()
		UI.MainButtons.Visible = true

		local track = TweenService:Create(Lighting.ShopBlur, fadeTI, {
			Size = 0;
		})
		local track2 = TweenService:Create(Camera, fadeTI, {
			FieldOfView = 70;
		})

		track:Play()
		track2:Play()
		cleanupthread = task.delay(fadeTI.Time, function()
			Lighting.ShopBlur.Enabled = false
		end)
	end
end)

--// Cred Display
local function UpdateAmount()
	local am = credval.Value
	credframe.TextLabel.Text = essentials.FormatNum(am)
	credframe2.TextLabel.Text = essentials.FormatNum(am)
end
UpdateAmount()
credval:GetPropertyChangedSignal("Value"):Connect(UpdateAmount)

--// Buy Cred button
local butt = credframe.BuyCred.TextButton
butt.Activated:Connect(function()
	ui_essentials.ButtonEffect(butt)

	local char = plr.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not rvalue.Value and sensor and root then
		DisableAll()
		sections["CredShop"].Enable()
		current = "CredShop"
		default_section = nil
		
		root.CFrame = sensor.CFrame * CFrame.new(RNG:NextNumber(-3, 3), 0, RNG:NextNumber(-3, 3))
	end
end)
butt.MouseEnter:Connect(function()
	butt.Hover.Visible = true
end)
butt.MouseLeave:Connect(function()
	butt.Hover.Visible = false
end)

local params = OverlapParams.new()
params.FilterDescendantsInstances = {workspace:WaitForChild("Characters")}
params.FilterType = Enum.RaycastFilterType.Include
RunService.Heartbeat:Connect(function(dt)
	local mychar = plr.Character
	if not sensor or not mychar then return end
	local parts = workspace:GetPartBoundsInBox(sensor.CFrame, sensor.Size)
	
	local yes = false
	for _,p in pairs(parts) do
		if p.Parent == mychar then
			yes = true
			break
		end
	end
	
	holder.Visible = yes
end)