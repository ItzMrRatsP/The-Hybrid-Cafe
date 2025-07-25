local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.Parent = Players.LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
frame.Parent = screenGui

GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function()
	local inset = GuiService.TopbarInset
	frame.Size = UDim2.new(0, inset.Width, 0, inset.Height)
	frame.Position = UDim2.new(0, inset.Min.X, 0, inset.Min.Y)
end)