local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local music = SoundService.Music

local current = music.MainLobby
local fadeTI = TweenInfo.new(0.4, Enum.EasingStyle.Linear)

for _,c in pairs(music:GetChildren()) do
	if c:IsA("Sound") and c.SoundGroup == music then
		c.Volume = 0
		c.Playing = true
	end
end
current.Volume = current:GetAttribute("DefaultVolume") or 0.5

local service = {}

function service.ChangeTrack(name)
	local target = music:FindFirstChild(name)
	if not target or target == current then return end
	
	current = target
	for _,c in pairs(music:GetChildren()) do
		if c:IsA("Sound") and c.SoundGroup == music then
			local tv = (c == target and (c:GetAttribute("DefaultVolume") or 0.5)) or 0
			--print(c, tv)
			local track = TweenService:Create(c, fadeTI, {
				Volume = tv;
			})
			track:Play()
		end
	end
end

return service