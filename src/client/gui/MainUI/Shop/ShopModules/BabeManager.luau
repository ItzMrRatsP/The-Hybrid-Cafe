local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local lmodules = ReplicatedStorage.LocalModules
local sfx = game:GetService("SoundService").SFX
local plr = Players.LocalPlayer
local remotes = ReplicatedStorage.Remotes

local holder = script.Parent.Parent
local buyframe = holder.Frame.Main.Buy
local babes = buyframe.Main.Babes
local scaler = babes.UIScale

local ui_essentials = require(lmodules.UIEssentials)
local sectiontransition = require(holder.ShopModules.SectionTransition)

local service = {}

local fadeTI = TweenInfo.new(0.45, Enum.EasingStyle.Linear)
local backTI = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tracks = {}
function service.DisplayBabe(name)
	for _,b in pairs(babes:GetChildren()) do
		if not b:IsA("ImageLabel") then continue end
		b.ImageTransparency = 0.99
	end
	local img = babes:FindFirstChild(name)
	if img then
		scaler.Scale = 0.75
		img.ImageTransparency = 0.99
		local track = TweenService:Create(img, fadeTI, {
			ImageTransparency = 0;
		})
		local track2 = TweenService:Create(scaler, backTI, {
			Scale = 1.05;
		})
		
		for _,t in pairs(tracks) do
			t:Cancel()
		end
		tracks = {track, track2}
		
		track:Play()
		track2:Play()
		sectiontransition()
	end
end
function service.GradBabes(state)
	for _,b in pairs(babes:GetChildren()) do
		if not b:IsA("ImageLabel") then continue end

		b.UIGradient.Offset = Vector2.new(0, (state and -0.35) or 0)
	end
end

RunService.RenderStepped:Connect(function(dt)
	local current = math.sin(tick()) * 1
	babes.Rotation = current
end)

return service