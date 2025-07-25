local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local RNG = Random.new(tick())

local sprops = ServerStorage.ServerProps
local boat_model = sprops.Boat
local boat_spawns = workspace.BoatSpawns
boat_spawns = boat_spawns:GetChildren()

local Service = {}
Service.Boats = {}
-- 65
function Service.AddBoat(group)
	local chosen = boat_spawns[RNG:NextInteger(1, #boat_spawns)]
	
	local new = boat_model:Clone()
	new:PivotTo(chosen.CFrame)
	new.Parent = workspace.Filtered
	
	local paralyzers = {}
	local bodies = {}
	
	local seets = new.PlayerSeats:GetChildren()
	for _,p in pairs(group) do
		local char = p.Character
		local humanoid = char and char:FindFirstChild("Humanoid")
		if char and humanoid and humanoid.Health > 0 then
			bodies[p] = char
			
			if #seets > 0 then
				local ind = RNG:NextInteger(1, #seets)
				local seat = seets[ind]
				table.remove(seets, ind)
				
				seat:Sit(humanoid)
				
				humanoid.JumpHeight = 0
				--[[humanoid.StateChanged:Connect(function(_, newstate)
					print("state changee!", newstate)
					if newstate ~= Enum.HumanoidStateType.Seated then
						humanoid:ChangeState(Enum.HumanoidStateType.Seated)
					end
				end)--]]
				--table.insert(paralyzers, )
			else
				-- teleport him on top of the boat
				char:PivotTo(new.Boat.CFrame * CFrame.new(0,1.5,0))
			end
		end
	end
	
	new:SetAttribute("MainPivot", new:GetPivot())
	table.insert(Service.Boats, new)
	task.delay(15, function()
		local ind = table.find(Service.Boats, new)
		table.remove(Service.Boats, ind)
		
		new:Destroy()
		
		--[[for p, bod in pairs(bodies) do
			if bod and bod.Parent then
				p:LoadCharacter()
			end
		end--]]
	end)
end

RunService.Heartbeat:Connect(function(dt)
	local step = 30 * dt
	local sine = math.sin(tick() * 3)
	local rotsine = sine * 2.5
	for _,model in pairs(Service.Boats) do
		local main = model:GetAttribute("MainPivot")
		local pos = model:GetPivot().Position
		
		local current = CFrame.lookAlong(Vector3.new(pos.X, sine, pos.Z), main.LookVector)
		
		model:PivotTo((current * CFrame.new(0,0,-step)) * CFrame.Angles(math.rad(rotsine),0,0))
	end
end)

return Service