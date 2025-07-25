local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RNG = Random.new()

local lmodules = ReplicatedStorage.LocalModules

local observers = require(lmodules.Utility.Observers)

local leaves = {}
observers.observeTag("PalmTree", function(tree : Model)
	local treetip = tree:WaitForChild("TreePivot", 10)
	local leaf_folder = tree:WaitForChild("Leaves", 10)

	
	if not treetip or not leaf_folder then return end
	
	local tipos = treetip.Position
	local speed = RNG:NextNumber(1, 1.25)
	
	
	local toffset = RNG:NextNumber(-1, 1)
	local leafeye = observers.observeChildren(leaf_folder, function(leaf)

		local d = (leaf.Position - tipos).Unit
		local pivcf = CFrame.lookAlong(tipos, Vector3.new(d.X, 0, d.Y).Unit)
		local offset = leaf.CFrame:ToObjectSpace(pivcf)

		leaf.PivotOffset = offset
		leaves[leaf] = {
			leaf:GetPivot();
			toffset;
			speed + RNG:NextNumber(-0.05, 0.05);
		}
		
		toffset += 0.1
		
		return function()
			leaves[leaf] = nil
		end
	end)
	
	return leafeye
end, {workspace})

RunService.RenderStepped:Connect(function(dt)
	local now = tick()
	
	for leaf, info in pairs(leaves) do
		local ttime = now + info[2]
		local sine = math.sin(ttime * info[3])
		
		--print("pivot tree")
		leaf:PivotTo(info[1] * CFrame.Angles(math.rad(5 * sine),0,0))
	end
end)

return {}