local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local sfx = SoundService.SFX
local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules
local lremotes = ReplicatedStorage.LocalRemotes

local ui_essentials = require(lmodules.UIEssentials)
local essentials = require(lmodules.EssentialFunctions)

local holder = script.Parent
local ui = holder.Parent
local mainbuttons = ui.MainButtons
local cbutton = mainbuttons.MiniButtons.Settings
local mainframe = holder.Frame
local sections = mainframe.Main
local buttons = mainframe.Sections
local close = mainframe.Close

local sectionframes = {
	["Settings"] = sections.Settings;
	["Stats"] = sections.Stats;
}
local sectionbuttons = {
	["Settings"] = buttons.Settings;
	["Stats"] = buttons.Stats;
}

local TI = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local function DisplaySection(name)
	for _,f in pairs(sectionframes) do
		f.Visible = false
	end
	
	local target = sectionframes[name]
	local scaler = target.UIScale
	target.Visible = true
	
	scaler.Scale = 0.8
	local track = TweenService:Create(scaler, TI, {Scale = 1})
	track:Play()
end
DisplaySection("Settings")

for n, b in pairs(sectionbuttons) do
	local butt = b.TextButton
	
	butt.Activated:Connect(function()
		ui_essentials.ButtonEffect(butt)
		DisplaySection(n)
	end)
end

cbutton.Button.Activated:Connect(function()
	ui_essentials.ButtonEffect(cbutton.Button)

	ui_essentials.DisableAllMains(holder)
	local newstate = not holder.Visible
	holder.Visible = newstate

	if newstate then
		ui_essentials.OpenTab(mainframe)
	else
		sfx.CloseTab:Play()
	end
end)

close.Activated:Connect(function()
	holder.Visible = false
	sfx.CloseTab:Play()
end)
ui_essentials.ImgCloseButton(close)

