local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local uniques = ReplicatedStorage.UniqueCustomers
local sprays = ReplicatedStorage.Stickers
local cups = ReplicatedStorage.Cups

local selcustomer = uniques.EasterRabbit
local selspray = sprays.GetFrom_EasterRabbit
local selcup = cups.EggshellCup

local ui_essentials = require(lmodules.UIEssentials)

local holder = script.Parent
local frame = holder.Frame
local rewardholder = frame.RewardHolder

return function()
	
	local ecust = ui_essentials.GetCustomerFrame(selcustomer, true)
	ecust.Size = UDim2.fromScale(1, 1)
	ecust.BackgroundTransparency = 1
	
	ecust.CustName:Destroy()
	ecust.Parent = frame.CustHolder
	
	frame.CustHolder.UICorner:Clone().Parent = ecust.ViewportFrame
	frame.BottomTitle.Text = selcustomer:GetAttribute("DisplayName")
	
	local sprayimage = selspray.Value
	local cupinfo = require(selcup)
	local cupimage = cupinfo.Image
	
	rewardholder.Item.Frame.ImageLabel.Image = sprayimage
	rewardholder.Item2.Frame.ImageLabel.Image = cupimage
	
	ui_essentials.GlareGradient(frame.UIGradient)
end