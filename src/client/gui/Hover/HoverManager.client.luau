local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local lremotes = ReplicatedStorage.LocalRemotes
local UI = script.Parent
local example = UI.Hover:Clone()

UI.Hover:Destroy()

local c_button
local current

local function AdjustFrame(item)
	local abs1 = UI.AbsoluteSize
	local abs2 = item.AbsoluteSize
	local mouse = UIS:GetMouseLocation()

	local anc = Vector2.new(1,1)
	if mouse.X - abs2.X < 0 then
		anc = Vector2.new(0, anc.Y)
	end
	if mouse.Y - abs2.Y < 0 then
		anc = Vector2.new(anc.X, 0)
	end
	item.AnchorPoint = anc
	item.Position = UDim2.fromOffset(mouse.X, mouse.Y)
end
lremotes.SetHover.Event:Connect(function(info, button)
	if current and (info or not button or button == c_button) then
		current:Destroy()
		current = nil
		c_button = nil
	end
	
	if info then
		c_button = button
		current = example:Clone()
		current.Visible = true
		current.Title.Text = info.Title or ""
		current.Desc.Text = info.Description or "No description."
		current.Title.TextColor3 = info.TitleColor or Color3.fromRGB(255,255,255)
		
		local mouse = UIS:GetMouseLocation()
		current.Position = UDim2.fromOffset(mouse.X, mouse.Y)
		
		AdjustFrame(current)
		current.Parent = UI
	end
end)

RunService.RenderStepped:Connect(function(dt)
	if current then
		AdjustFrame(current)
	end
end)

