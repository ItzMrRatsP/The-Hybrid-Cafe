local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local sfx = SoundService.SFX
local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules
local puniques = plr:WaitForChild("UniqueIndex")
local uniquefolder = ReplicatedStorage.UniqueCustomers

local ui_essentials = require(lmodules.UIEssentials)

local holder = script.Parent
local ui = holder.Parent
local mainbuttons = ui.MainButtons
local mainframe = holder.Frame
local cbutton = mainbuttons.ButtonsLeft.Customers
local close = mainframe.Close
local sc = mainframe.ScrollingFrame

--local cust_stock = script.CustItem

local pool = uniquefolder:GetChildren()
local event_custs = {}
local active_events = {}
local has_secrets = {}

local eventpage

table.sort(pool, function(a, b)
	return a.Name < b.Name
end)
for _,m in pairs(pool) do
	if not m:IsA("Model") then continue end
	
	local rar = m:GetAttribute("Rarity")
	local dname = m:GetAttribute("DisplayName")
	local discovered = puniques:FindFirstChild(m.Name) ~= nil
	
	if rar == "Event" then
		if m:GetAttribute("Active") then
			table.insert(active_events, m)
			eventpage = m:GetAttribute("EventPage") or eventpage
		elseif discovered then
			table.insert(event_custs, m)
		else
			continue
		end
	elseif discovered and rar == "Secret" then
		table.insert(has_secrets, m)
	end
	
	if not rar then
		warn(m, "has no rarity!")
		continue
	end
	
	local tframe = sc:FindFirstChild(rar)
	if not tframe then continue end
	
	local new = ui_essentials.GetCustomerFrame(m, discovered)
	
	--[[local new = cust_stock:Clone()
	new.ViewportFrame.Rig:Destroy()
	local model = m:Clone()
	model:PivotTo(CFrame.new(0,0,0))
	model.Parent = new.ViewportFrame

	new.ViewportFrame.ImageColor3 = (discovered and Color3.fromRGB(255,255,255)) or Color3.fromRGB(0,0,0)
	new.Mystery.Visible = not discovered
	new.CustName.Visible = discovered

	new.CustName.Text = dname or m.Name--]]
	
	new.Parent = tframe.Frame
end

if eventpage then
	local evframe = script.EventPages:FindFirstChild(eventpage)
	if evframe then
		local new = evframe:Clone()
		new.Name = "EventPage"
		
		new.LayoutOrder = 0
		new.Parent = sc
		
		local init = new:FindFirstChild("Initialize")
		if init then
			init = require(init)
			task.spawn(init)
		end
	end
end

RunService:UnbindFromRenderStep("EventIndicatorSpin")
cbutton.EventIcon.Visible = #active_events > 0
sc.Event.Visible = #event_custs > 0 or #active_events > 0
sc.Secret.Visible = #has_secrets > 0

if cbutton.EventIcon.Visible then
	local ori = cbutton.EventIcon.Rotation
	RunService:BindToRenderStep("EventIndicatorSpin", 100, function(dt)
		local sine = math.sin(tick())
		cbutton.EventIcon.Rotation = ori + (sine * 10)
	end)
end

cbutton.Button.Activated:Connect(function()
	ui_essentials.ButtonEffect(cbutton.Button)
	
	ui_essentials.DisableAllMains(holder)
	local newstate = not holder.Visible
	holder.Visible = newstate
	
	if newstate then
		ui_essentials.OpenTab(mainframe)
	else
		sfx.CloseTab:Play()
	end
end)

close.Activated:Connect(function()
	holder.Visible = false
	sfx.CloseTab:Play()
end)
ui_essentials.ImgCloseButton(close)