local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RNG = Random.new()

local plr = Players.LocalPlayer
local lobby = workspace:WaitForChild("Lobby")
local folder = lobby:WaitForChild("Shopkeepers")

local daniel = folder:WaitForChild("Daniel")
local summer = folder:WaitForChild("Summer")
local amber = folder:WaitForChild("Amber")

local dan_animator = daniel:WaitForChild("Humanoid"):WaitForChild("Animator")
local sum_animator = summer:WaitForChild("Humanoid"):WaitForChild("Animator")
local amb_animator = amber:WaitForChild("Humanoid"):WaitForChild("Animator")

local chatbb = script.ChatBillboard

local anims = {
	[daniel] = {
		dan_animator:LoadAnimation(daniel:WaitForChild("Idle"));
		dan_animator:LoadAnimation(daniel:WaitForChild("Wave"));
	};
	[summer] = {
		sum_animator:LoadAnimation(summer:WaitForChild("Idle"));
		sum_animator:LoadAnimation(summer:WaitForChild("Wave"));
	};
	[amber] = {
		amb_animator:LoadAnimation(amber:WaitForChild("Idle"));
	};
}

anims[daniel][1].Looped = true
anims[summer][1].Looped = true
anims[amber][1].Looped = true

anims[daniel][1]:Play(0)
anims[amber][1]:Play(0)
task.delay(2, function()
	anims[summer][1]:Play(0)
end)


local necks = {
	daniel:WaitForChild("Torso"):WaitForChild("Neck");
	summer:WaitForChild("Torso"):WaitForChild("Neck");
	amber:WaitForChild("Torso"):WaitForChild("Neck");
}
for _,n in pairs(necks) do
	n:SetAttribute("MainC0", n.C0)
end
local test = 0
RunService:BindToRenderStep("ShopkeeperLook", 100, function(dt)
	local char = plr.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	
	local rootcf = root.CFrame
	for _,n in pairs(necks) do
		local nroot = n.Parent.Parent:FindFirstChild("HumanoidRootPart")
		if not nroot then continue end
		
		local target = n:GetAttribute("MainC0")
		if (nroot.Position - rootcf.Position).Magnitude <= 30 then
			local tr = CFrame.lookAt(nroot.Position, rootcf.Position)
			local rot = (nroot.CFrame:ToObjectSpace(tr)).Rotation
			local x, y, z = rot:ToOrientation()
			if math.abs(math.deg(y)) >= 75 then
				y = 0
			end
			target = n:GetAttribute("MainC0") * CFrame.Angles(0, 0, y)
			
		end
		
		n.C0 = n.C0:Lerp(target, 0.15)
	end
	test += 1
end)


local popTI = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
while true do
	task.wait(RNG:NextNumber(5, 10))
	
	local ranpool = {daniel; summer}
	local dude = ranpool[RNG:NextInteger(1, #ranpool)]
	local dmod = dude:WaitForChild("Dialogue")
	dmod = require(dmod)
	
	anims[dude][2]:Play(0.1)
	anims[dude][2]:AdjustSpeed(0.5)
	local new = chatbb:Clone()
	local scaler = new.Frame.UIScale
	new.Frame.TextLabel.Text = dmod[RNG:NextInteger(1, #dmod)]
	scaler.Scale = 0.1
	new.Adornee = dude:WaitForChild("Head")
	new.Parent = dude
	
	local track = TweenService:Create(scaler, popTI, {
		Scale = 1
	})
	track:Play()
	
	task.wait(4)
	task.spawn(function()
		local track2 = TweenService:Create(scaler, popTI, {
			Scale = 0.1;
		})
		track2:Play()
		
		task.wait(popTI.Time)
		new:Destroy()
	end)
end