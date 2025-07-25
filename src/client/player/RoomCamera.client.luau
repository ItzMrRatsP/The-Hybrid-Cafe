local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local plr = Players.LocalPlayer
local rvalue = plr:WaitForChild("CurrentRoom")

local ev

local function Cleanup()
	if ev then
		ev:Disconnect()
		ev = nil
	end
	Camera.CameraType = Enum.CameraType.Custom
	local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
	if hum then
		Camera.CameraSubject = hum
	end
end
rvalue:GetPropertyChangedSignal("Value"):Connect(function()
	if ev then
		ev:Disconnect()
		ev = nil
	end
	local room = rvalue.Value
	if room then
		Camera.CameraType = Enum.CameraType.Scriptable
		
		local tpos = (room.Floor.CFrame * CFrame.new(20, 10, 0)).Position
		ev = RunService.Heartbeat:Connect(function()
			local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local target = CFrame.lookAt(tpos, root.Position)
				Camera.CFrame = Camera.CFrame:Lerp(target, 0.15)
			end
		end)
	else
		Cleanup()
	end
end)
plr:GetAttributeChangedSignal("Teleporting"):Connect(function()
	if plr:GetAttribute("Teleporting") then
		Cleanup()
	end
end)

