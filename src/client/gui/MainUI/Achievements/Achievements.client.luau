local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")

local plr = Players.LocalPlayer
local sfx = SoundService.SFX
local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules

local ui_essentials = require(lmodules.UIEssentials)

local holder = script.Parent
local ui = holder.Parent
local mainbuttons = ui.MainButtons
local buttons = mainbuttons.ButtonsLeft
local cbutton = buttons.Achievements
local mainframe = holder.Frame
local SC = mainframe.ScrollingFrame
local disclaimer = mainframe.Disclaimer
local close = mainframe.Close

local example = SC.Frame:Clone()
SC.Frame:Destroy()
disclaimer.Visible = true

local buttons = {}
local displayed = false
local db = false
local function InitBadges()
	local list = remotes.GetBadgeList:InvokeServer()
	disclaimer:Destroy()
	
	for id, info in pairs(list) do
		local success, hasbadge = pcall(function()
			return BadgeService:UserHasBadgeAsync(plr.UserId, id)
		end)
		hasbadge = (success and hasbadge) or false
		
		--print(info.DisplayName, info.Enabled, hasbadge)
		if not info.Enabled and not hasbadge then continue end
		
		local new = example:Clone()
		new.LayoutOrder = (info.Order or 1) + ((not hasbadge and 1000) or 0)
		new.TextButton.Locked.Visible = not hasbadge
		new.TextButton.BadgeImg.Image = info.Icon
		new.TextButton.BInfo.Title.Text = info.DisplayName
		new.TextButton.BInfo.Description.Text = info.Description
		
		new.Parent = SC
		table.insert(buttons, new)
		
		if hasbadge then
			new.TextButton.Activated:Connect(function()
				if db then return end
				db = true
				
				ui_essentials.ButtonEffect(new.TextButton)
				remotes.SetPlayerBadge:FireServer(tonumber(id))
				
				db = false
			end)
		end
	end
end

cbutton.Button.Activated:Connect(function()
	ui_essentials.ButtonEffect(cbutton.Button)
	
	ui_essentials.DisableAllMains(holder)
	local newstate = not holder.Visible
	holder.Visible = newstate
	
	if newstate then
		ui_essentials.OpenTab(mainframe)
		
		if not displayed then
			displayed = true
			InitBadges()
		end
	else
		sfx.CloseTab:Play()
	end
end)

close.Activated:Connect(function()
	holder.Visible = false
	sfx.CloseTab:Play()
end)
ui_essentials.ImgCloseButton(close)