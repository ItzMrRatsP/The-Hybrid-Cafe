local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lremotes = ReplicatedStorage.LocalRemotes

local service = {}
service.Events = {}

function service.AddButton(button, info)
	local downevent = button.MouseEnter:Connect(function()
		lremotes.SetHover:Fire(info, button)
	end)
	local upevent = button.MouseLeave:Connect(function()
		lremotes.SetHover:Fire(nil, button)
	end)
	
	service.Events[button] = {downevent, upevent}
end
function service.RemoveButton(button)
	local target = service.Events[button]
	if target then
		for _,ev in pairs(target) do
			ev:Disconnect()
		end
	end
	service.Events[button] = nil
	lremotes.SetHover:Fire(nil, button)
end

return service