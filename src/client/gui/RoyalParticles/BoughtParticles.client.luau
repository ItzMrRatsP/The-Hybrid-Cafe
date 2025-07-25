local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RNG = Random.new()

local lremotes = ReplicatedStorage.LocalRemotes
local remotes = ReplicatedStorage.Remotes
local targetremote = remotes.RoyalParticles

local ui = script.Parent
local star = ui.Star

local function Royals()
	-- 25 on the left, 25 on the right

	local items = {}
	for i = 1, 50 do
		local ranang = RNG:NextNumber(5, 85)
		local sin, cos = math.sin(math.rad(ranang)), math.cos(math.rad(ranang))
		local hlen = RNG:NextNumber(0, 0.6)
		local x = cos * hlen
		local y = sin * hlen

		local right = i > 25
		local start = (right and UDim2.fromScale(1, 1)) or UDim2.fromScale(0, 1)
		local target = (right and UDim2.fromScale(1 - x, 1 - y)) or UDim2.fromScale(x, 1 - y)

		local TI = TweenInfo.new(RNG:NextNumber(0.3, 0.8), Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
		local new = star:Clone()
		local s = RNG:NextNumber(0.05, 0.1)
		new.Size = UDim2.fromScale(s, s)
		new.Position = start
		new.Rotation = RNG:NextInteger(-360, 360)
		new.ImageTransparency = 0
		new.ImageColor3 = color or new.ImageColor3
		new.Visible = true
		new.Parent = ui
		table.insert(items, new)

		local track = TweenService:Create(new, TI, {
			Position = target;
			Rotation = RNG:NextInteger(-360, 360);
		})
		track:Play()
		task.delay(0.1, function()
			local track2 = TweenService:Create(new, TI, {
				ImageTransparency = 1;
			})
			track2:Play()
		end)
	end

	task.wait(1)
	for _,v in pairs(items) do
		v:Destroy()
	end
end

targetremote.OnClientEvent:Connect(Royals)
lremotes.RoyalParticles.Event:Connect(Royals)