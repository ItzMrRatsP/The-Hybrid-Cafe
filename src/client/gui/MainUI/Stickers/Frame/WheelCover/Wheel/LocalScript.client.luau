

local function arrangeButtons(frame, buttons)
	local increment = 360 / #buttons
	local dist = 0.325
	
	for i, b in pairs(buttons) do
		local rot = increment * (i - 1)
		local sine = math.sin(math.rad(rot))
		local cos = math.cos(math.rad(rot))
		local X = sine * dist
		local Y = cos * dist
		
		
		b.Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromScale(X, -Y)
	end
end

local frame = game.StarterGui.MainUI.Wheel
local example = frame.Buttons.ExampleItem

local buttons = {}
for i = 1, 5 do
	local new= example:Clone()
	new.Parent = frame.Buttons
	table.insert(buttons, new)
end

arrangeButtons(frame, buttons)