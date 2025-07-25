local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

local tags = {}
local range = 17.5

local csizes = {
	UDim2.new(1, -10, 0.15, 0);
	UDim2.new(1, -10, 0, 0);
}

local moveTI = TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
RunService.Heartbeat:Connect(function(dt)
	local mypos = Camera.CFrame.Position
	
	for _,t in pairs(tags) do
		if t:GetAttribute("Moving") or not t.Adornee then continue end
		local dist = (t.Adornee.Position - mypos).Magnitude
		local targetsize = (dist <= range and csizes[1]) or csizes[2]
		pcall(function()
			if t.Main.CustomerValue.Size ~= targetsize then
				local track = TweenService:Create(t.Main.CustomerValue, moveTI, {
					Size = targetsize;
				})
				
				t:SetAttribute("Moving", true)
				track:Play()
				task.delay(moveTI.Time, function()
					t:SetAttribute("Moving", false)
				end)
			end
		end)
	end
end)

CollectionService:GetInstanceAddedSignal("PlayerTag"):Connect(function(item)
	table.insert(tags, item)
end)
for _,item in pairs(CollectionService:GetTagged("PlayerTag")) do
	table.insert(tags, item)
end