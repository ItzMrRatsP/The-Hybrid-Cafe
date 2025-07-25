local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local remotes = ReplicatedStorage.Remotes
local lremotes = ReplicatedStorage.LocalRemotes
local music = SoundService.Music
local sfx = SoundService.SFX
local lobbymusic = music.MainLobby
local bandfolder = workspace:WaitForChild("Lobby"):WaitForChild("MusicBand")

local lead = bandfolder:WaitForChild("PianoGirl")
local members = {
	bandfolder:WaitForChild("BassGuy");
	bandfolder:WaitForChild("DrumGuy");
	bandfolder:WaitForChild("VibraphoneGuy");
	lead;
}

ContentProvider:PreloadAsync({lobbymusic})
local musicmanager = require(lmodules.MusicManager)

local tracks = {}
for _,m in pairs(members) do
	local obj_anim = m:WaitForChild("MainAnimation")
	local animator = m:WaitForChild("Humanoid"):WaitForChild("Animator")
	
	task.spawn(function()
		ContentProvider:PreloadAsync({obj_anim})
		
		local track = animator:LoadAnimation(obj_anim)
		track:SetAttribute("Offset", obj_anim:GetAttribute("Offset") or 0) 
		track:Play(0)
		track:AdjustSpeed(1)
		table.insert(tracks, track)
		
		local current = lobbymusic.TimePosition
		local len = track.Length
		
		--print(m, len)
		local tp = (obj_anim:GetAttribute("Offset") or 0) + (current % len)
		track.TimePosition = tp
		--print(m, tp, current)
	end)
end

task.spawn(function()
	while true do
		task.wait(2)
		
		--print("updating trackpos")
		for _, track in pairs(tracks) do
			local current = lobbymusic.TimePosition
			local len = track.Length
			
			local tp = track:GetAttribute("Offset") + (current % len)
			track.TimePosition = tp
		end
	end
end)

local plr = Players.LocalPlayer
local setfolder = plr:WaitForChild("Settings")
local lobmusic = setfolder.LobbyMusic
--local muteprompt = lead:WaitForChild("Piano"):WaitForChild("Base"):WaitForChild("Attachment"):WaitForChild("MusicPrompt")

local current_musicstate = lobmusic.Value
local function update_music(nosound)
	if not nosound then
		sfx.ButtonPress:Play()
	end
	music.Volume = (current_musicstate and 1) or 0
end

update_music(true)
lremotes.ToggleLobbyMusic.Event:Connect(function(state)
	current_musicstate = state
	update_music(true)
end)
--[[muteprompt.Triggered:Connect(function()
	current_musicstate = not current_musicstate
	update_music()

	remotes.SetSetting:FireServer("LobbyMusic", current_musicstate)
end)--]]