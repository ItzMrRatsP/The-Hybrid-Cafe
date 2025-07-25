local SocialService = game:GetService("SocialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RNG = Random.new()

local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules
local plr = Players.LocalPlayer
local SFX = SoundService.SFX
local setfolder = plr:WaitForChild("Settings")
local lobmusic = setfolder.LobbyMusic

local UI = script.Parent
local mainbuttons = UI.MainButtons
local bleft = mainbuttons.ButtonsLeft
local bright = mainbuttons.ButtonsRight
local invitebutton = bright.InviteFriends

local ui_essentials = require(lmodules.UIEssentials)

local dotTI = TweenInfo.new(0.4, Enum.EasingStyle.Linear)
local benTI = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In)

local caninvite = SocialService:CanSendGameInviteAsync(plr)
invitebutton.Visible = caninvite
if caninvite then
	invitebutton.Button.Activated:Connect(function()
		ui_essentials.ButtonEffect(invitebutton.Button)
		SocialService:PromptGameInvite(plr)
	end)
	
	task.spawn(function()
		task.wait(RNG:NextNumber(10, 15))
		while true do
			if UI.Enabled then
				for i = 3, 1, -1 do
					local dot = invitebutton.Button.Dots[tostring(i)]
					local sound = SFX.Bubble:Clone()
					sound.Name = "_CLONEDSOUND"
					sound.PlaybackSpeed = 0.3 + ((3 - i) * 0.1)
					sound.Parent = SFX
					sound:Play()
					sound.Ended:Once(function()
						sound:Destroy()
					end)

					dot.Visible = true
					local track = TweenService:Create(dot, dotTI, {
						BackgroundTransparency = 1;
					})
					track:Play()
					task.wait(0.1)
				end

				local oric = invitebutton.Button.UIStroke.Color
				invitebutton.Button.UIStroke.Color = Color3.fromRGB(255,255,255)
				invitebutton.Button.Size = UDim2.fromScale(0.9,0.9)

				local track3 = TweenService:Create(invitebutton.Button, benTI, {
					Size = UDim2.fromScale(1,1)
				})
				local track2 = TweenService:Create(invitebutton.Button.UIStroke, dotTI, {
					Color = oric;
				})
				track2:Play()
				track3:Play()
				SFX.Bubble2:Play()
			end
			
			task.wait(RNG:NextNumber(15, 40))
		end
	end)
	
	ui_essentials.GlareGradient(invitebutton.Button.UIGradient)
end

--[[local current_musicstate = lobmusic.Value
local function update_music()
	mgroup.Volume = (current_musicstate and 1) or 0
	musicbutton.Image = (current_musicstate and "rbxassetid://7203392850") or "rbxassetid://11488028230"
end

update_music()
musicbutton.Activated:Connect(function()
	current_musicstate = not current_musicstate
	update_music()
	
	remotes.SetSetting:FireServer("LobbyMusic", current_musicstate)
end)

plr:GetAttributeChangedSignal("Teleporting"):Connect(function()
	local state = plr:GetAttribute("Teleporting")
	UI.Enabled = not state
end)--]]