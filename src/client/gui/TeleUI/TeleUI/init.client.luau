local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

local plr = Players.LocalPlayer
local plrgui = plr:WaitForChild("PlayerGui")
local mainUI = plrgui:WaitForChild("MainUI")
local char = plr.Character or plr.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local teleblur = Lighting.TeleBlur
local ranks = ReplicatedStorage.Ranks
local funextras = ReplicatedStorage.FunExtras

local cafecams = ReplicatedStorage.CafeCameras
local lmodules = ReplicatedStorage.LocalModules
local remotes = ReplicatedStorage.Remotes
local UI = script.Parent
local pixelcov = UI.Cover
local pixels = pixelcov.Pixels
local main = UI.Main
local infoframe = main.InfoFrame
local partyframe = infoframe.Party
local pframe = partyframe.PartyFrame
local pcount = partyframe.PlayerCount
local tb = main.Thumbnail
local tiptext = main.Tip
local modename = infoframe.ModeName.ModeName
local difname = infoframe.ModeName.DifName
local rankname = infoframe.ModeName.RankName
local funstuff = tb.Frame

local funtext = script.FunText
local stock_p = pframe.Plr:Clone()
pframe.Plr:Destroy()

local essentials = require(lmodules.EssentialFunctions)
local partingtext = require(script.PartingText)

Camera.CameraType = Enum.CameraType.Custom
Camera.CameraSubject = humanoid
teleblur.Enabled = false
Lighting.ExposureCompensation = 0

local defaultDNames = {
	[1] = {"Normal"; Color3.fromRGB(144, 255, 148)};
	[2] = {"Hard"; Color3.fromRGB(255, 88, 88)};
}
local panTI = TweenInfo.new(15, Enum.EasingStyle.Linear)

remotes.DisplayTeleMessage.OnClientEvent:Connect(function(mode, rank, funs, group, seed)
	local RNG = Random.new(seed)
	local info = require(mode)
	
	local telegroup = table.clone(group)
	local ind = table.find(telegroup, plr)
	if ind then
		table.remove(telegroup, ind)
	end
	
	UI.Enabled = true
	pixelcov.Visible = true
	pixels.Visible = true
	main.Visible = false
	
	modename.Text = info.MainTitle
	tb.Image = info.Image
	
	difname.Text = info.SubTitle[1]
	difname.TextColor3 = info.SubTitle[2]
	
	tiptext.Text = partingtext[RNG:NextInteger(1, #partingtext)]
	
	rankname.Visible = rank ~= nil
	if rank then
		local mod = ranks:FindFirstChild(tostring(rank))
		local info = require(mod)
		
		rankname.Text = info.DisplayName
		rankname.TextColor3 = info.NameColor or Color3.fromRGB(255,255,255)
	end
	
	for _,v in pairs(funstuff:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
	for _,n in pairs(funs) do
		local mod = funextras:FindFirstChild(n)
		local info = require(mod)
		
		local new = funtext:Clone()
		new.Text = "- "..info.DisplayName
		new.Parent = funstuff
	end
	
	local isalone = #telegroup <= 0
	pframe.Visible = not isalone
	pcount.Visible = not isalone
	if #telegroup <= 0 then
		-- this guy is playing solo
		partyframe.Visible = false
	else
		-- not playing alone, regular text
		partyframe.Visible = true
		
		pcount.Text = "With "..#telegroup.." other "..((#telegroup == 1 and "person") or "people")
		for _,p in pairs(telegroup) do
			local n = stock_p:Clone()
			n.Name = p.Name
			n.Image = essentials.GetPlayerPicture(p)
			n.Parent = pframe
		end
	end
	
	pixelcov.Position = UDim2.fromScale(0.5, -0.3)
	for i = 1, 20 + 6 do
		pixelcov.Position += UDim2.fromScale(0, 0.1)
		pixelcov.Pixels.ImageRectOffset = Vector2.new(RNG:NextInteger(-31, 31))
		pixelcov.PixelsTop.ImageRectOffset = Vector2.new(RNG:NextInteger(-31, 31))
		if i == 13 then
			--screen is completely covered so we do the magic
			main.Visible = true
			teleblur.Enabled = true
			Lighting.ExposureCompensation = -2
			
			mainUI.MainButtons.Visible = false
			for _,v in pairs(CollectionService:GetTagged("MainUI")) do
				v.Visible = false
			end
			
			Camera.CameraType = Enum.CameraType.Scriptable
			Camera.CFrame = cafecams.Main.CFrame
			local track = TweenService:Create(Camera, panTI, {CFrame = Camera.CFrame * CFrame.new(50, 0, 0)})
			track:Play()
		end
		task.wait(0.04)
	end
end)
