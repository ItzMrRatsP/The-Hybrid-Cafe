local TweenService = game:GetService("TweenService")

local holder = script.Parent.Parent
local transframe = holder.Frame.Main.SectionTransition

local swingTI = TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

local last = true
local thread
return function()
	if thread then
		pcall(function()
			task.cancel(thread)
		end)
	end
	thread = task.spawn(function()
		transframe.Size = UDim2.fromScale(0.7,0.8)
		if last then
			transframe.AnchorPoint = Vector2.new(0, 0)
			transframe.Position = UDim2.fromScale(0, 0.2)
		else
			transframe.AnchorPoint = Vector2.new(1, 0)
			transframe.Position = UDim2.fromScale(0.7, 0.2)
		end
		
		local track = TweenService:Create(transframe, swingTI, {
			Size = UDim2.fromScale(0, 0.8)
		})
		track:Play()
		
		last = not last
	end)
end
