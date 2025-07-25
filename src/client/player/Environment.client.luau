local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local RNG = Random.new(tick())

local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules
local props = ReplicatedStorage.Props
local jetskis = props.Jetskis
local jspawns = workspace.JetskiSpawns:GetChildren()
local cruiseanim = props.CruiseAnim
local spats = props.SplashAts

local essentials = require(lmodules.EssentialFunctions)

local sealevel = workspace:GetAttribute("SeaLevel")
local basespeed = 40
local showTI = TweenInfo.new(1, Enum.EasingStyle.Linear)
local fadeTI = TweenInfo.new(2, Enum.EasingStyle.Linear)
remotes.Env_Jetski.OnClientEvent:Connect(function(info)
	for _,v in pairs(info) do
		local chosen, path = v.char, v.path
		local jet = jetskis:FindFirstChild(chosen:GetAttribute("JetskiClass") or "Hybrid") or jetskis.Hybrid
		
		-- NOTE: paths may not be rendered properly, so a check must be made
		if not path then continue end
		
		local new, ride = chosen:Clone(), jet:Clone()
		local root = new.HumanoidRootPart
		local torso = new.Torso
		local animator = new.Humanoid.Animator
		
		local ismodded = ride.Name == "Modded"
		
		ride.Name = "Jetski"
		ride.Parent = new
		local m6d = Instance.new("Motor6D")
		m6d.Parent = torso
		m6d.Part0 = torso
		m6d.Part1 = ride
		
		new.Parent = workspace.Filtered
		for _,s in pairs(ride:GetDescendants()) do
			if s:IsA("Sound") then
				s:Play()
			end
		end
		
		for _,d in pairs(new:GetDescendants()) do
			if d:IsA("BasePart") or d:IsA("Decal") then
				local ori = d.Transparency
				d.Transparency = 1
				
				local track2 = TweenService:Create(d, showTI, {
					Transparency = ori;
				})
				track2:Play()
			end
		end
		for _,at in pairs(spats:GetChildren()) do
			at:Clone().Parent = ride
		end
		
		local track = animator:LoadAnimation(cruiseanim)
		track.Looped = true
		track:Play(0)
		
		local at0, at1, at2 = path:WaitForChild("Start"), path:WaitForChild("Mid"), path:WaitForChild("End")
		local p0, p1, p2 = at0.WorldPosition, at1.WorldPosition, at2.WorldPosition
		local dir = (essentials.quadBezier(0.05, p0, p1, p2) - essentials.quadBezier(0, p0, p1, p2)).Unit
		local len = 0
		for i = 0, 0.95, 0.05 do
			local dist = (essentials.quadBezier(i, p0, p1, p2) - essentials.quadBezier(i + 0.05, p0, p1, p2)).Magnitude
			len += dist
		end
		
		local speed = (ismodded and 70 or basespeed) + RNG:NextNumber(-10, 20)
		task.spawn(function()
			local sineset = RNG:NextNumber(-50000, 50000)
			local offset = CFrame.new(RNG:NextNumber(-10, 10), 3, 0)
			local timespending = len / speed
			local step = 0
			
			root.CFrame = CFrame.lookAlong(p0, dir) * offset
			local lastpos = essentials.quadBezier(0, p0, p1, p2)
			local fading = false
			while step < timespending do
				step += RunService.RenderStepped:Wait()
				local perc = math.clamp(step / timespending, 0, 1)
				local sine = math.sin((tick() + sineset) * 3) * 0.75
				
				local pos = essentials.quadBezier(perc, p0, p1, p2)
				local d = (pos - lastpos).Unit
				root.CFrame = CFrame.lookAlong(pos, d) * offset * CFrame.new(0, offset, 0)
				
				lastpos = pos
				if not fading and timespending - step <= 2 then
					fading = true
					for _,d in pairs(new:GetDescendants()) do
						if d:IsA("BasePart") or d:IsA("Decal") then
							local track2 = TweenService:Create(d, showTI, {
								Transparency = 1;
							})
							track2:Play()
						end
					end
				end
			end
			new:Destroy()
		end)
	end
end)

for _,m in pairs(lmodules.ClientRun:GetChildren()) do
	if m:IsA("ModuleScript") then
		task.spawn(require, m)
	end
end