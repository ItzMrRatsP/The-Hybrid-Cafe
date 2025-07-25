local RunService = game:GetService("RunService")
local Terrain = workspace.Terrain
local Camera = workspace.CurrentCamera

local amsounds = game:GetService("SoundService").Ambience

local folders = {
	[workspace:WaitForChild("Env_Sea")] = {
		Sound = amsounds.Shores;
		VolRange = NumberRange.new(0, 0.5);
		DistRange = NumberRange.new(25, 85);
	};
}
for fder, info in pairs(folders) do
	local new = Instance.new("Attachment")
	new.Name = "Amb/"..fder.Name
	
	info.Sound.RollOffMaxDistance = info.DistRange.Max
	info.Sound.RollOffMinDistance = info.DistRange.Min
	info.Sound.Looped = true
	info.Sound.Playing = true
	info.Sound.Parent = new
	
	new.Parent = Terrain
	info.Attachment = new
end

RunService.RenderStepped:Connect(function()
	local cpos = Camera.CFrame.Position
	for fder, info in pairs(folders) do
		local parts = fder:GetChildren()
		
		local closest
		for _,p in pairs(parts) do
			local point = p:GetClosestPointOnSurface(cpos)
			local dist = (cpos - point).Magnitude
			if not closest or dist < (closest - cpos).Magnitude then
				closest = point
			end
		end
		if closest then
			info.Attachment.WorldPosition = closest
		end
	end
end)