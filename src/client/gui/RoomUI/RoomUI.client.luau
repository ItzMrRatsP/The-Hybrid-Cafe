local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GamepadService = game:GetService("GamepadService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RNG = Random.new()

local plr = Players.LocalPlayer
local lmodules = ReplicatedStorage.LocalModules
local funmods = ReplicatedStorage.FunExtras:GetChildren()
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local datastats = plr:WaitForChild("DataStats")
local unlockedmodes = plr:WaitForChild("UnlockedModes")
local ch_level = datastats:WaitForChild("ChallengeLevel")
local bestrank = datastats:WaitForChild("BestRank")
local rvalue = plr:WaitForChild("CurrentRoom")
local sfx = game:GetService("SoundService").SFX
local modefolder = ReplicatedStorage.GamemodeSelections

local UI = script.Parent
local exit = UI:WaitForChild("ExitButton")
local mainframe = UI.Holder.Main
local pframe = mainframe.PFrame
local difdesc = pframe:WaitForChild("DifDescription")
local bframe = pframe:WaitForChild("DifHolder")
local diflayout = bframe.UIListLayout
local close = pframe:WaitForChild("Close")
local partytitle = pframe:WaitForChild("Title")
local startbutton = pframe:WaitForChild("StartButton")
local ranklocked = pframe.RankLocked
local rankframe = pframe.RankFrame

local modevalue = mainframe.SelectedMode
local stock_frame = script.NormalMode

local chframe = mainframe.ChallFrame
local plrframe = chframe.PlrFrame
local pcounter = plrframe:WaitForChild("PHolder"):WaitForChild("Counter")
local minus, plus = plrframe:WaitForChild("LessPlayer"), plrframe:WaitForChild("MorePlayer")

local funframe = chframe.FunFrame
local funlocked = funframe.Locked
local fundisclaimer = funframe.Disclaimer
local list_ch = funframe.ChallengeList
local example_ch = list_ch.Frame:Clone()
list_ch.Frame:Destroy()

local ui_essentials = require(lmodules.UIEssentials)
local hoverservice = require(lmodules.HoverService)

local selected_dif = 1
local mcounter = 4
local ev

local pulseTI = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local fadeTI = TweenInfo.new(0.4, Enum.EasingStyle.Linear)
local backTI = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

--// Mode Buttons
local _mlist = modefolder:GetChildren()
table.sort(_mlist, function(a, b)
	local ia, ib = require(a), require(b)
	return (ia.Weight or 1) > (ib.Weight or 1)
end)

local buttons = {}
for i, m in pairs(_mlist) do
	local info = require(m)
	if info.Unlisted or info.Disabled then continue end
	
	local new = stock_frame:Clone()
	new.Name = m.Name
	new.LayoutOrder = i
	
	local butt = new.TextButton
	butt.ImageLabel.Image = info.Image
	butt.TextLabel.Text = info.DisplayName
	
	if info.Locked then
		butt.Locked.Visible = true
		butt.Locked.TextLabel.Text = info.LockedMessage or "This mode is locked"
	end
	
	butt.MouseEnter:Connect(function()
		butt.Hover.Visible = true
	end)
	butt.MouseLeave:Connect(function()
		butt.Hover.Visible = false
	end)
	butt.Activated:Connect(function()
		if butt.Locked.Visible then return end
		
		ui_essentials.ButtonEffect(butt)
		modevalue.Value = m
		difdesc.Text = info.Description
		ranklocked.Visible = not (info.AllowRanks or false)
	end)
	
	table.insert(buttons, new)
	new.Parent = bframe
end

local function SelectItem()
	local current_m = modevalue.Value
	
	for _,b in pairs(buttons) do
		b.TextButton.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		b.TextButton.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	
	local selb = current_m and bframe:FindFirstChild(current_m.Name)
	if selb then
		selb.TextButton.UIStroke.Color = Color3.fromRGB(213, 162, 255)
		selb.TextButton.TextLabel.TextColor3 = Color3.fromRGB(213, 162, 255)
	end
end

modevalue.Value = modefolder.MainNormal
SelectItem()
modevalue:GetPropertyChangedSignal("Value"):Connect(SelectItem)

local function UnlockItem(val)
	for _,b in pairs(buttons) do
		if b.Name == val.Name then
			b.TextButton.Locked.Visible = false
		end
	end
end
for _,c in pairs(unlockedmodes:GetChildren()) do
	UnlockItem(c)
end
unlockedmodes.ChildAdded:Connect(UnlockItem)

local function UpdateContent()
	local abs = diflayout.AbsoluteContentSize
	bframe.CanvasSize = UDim2.fromOffset(abs.X + 50, 0)
end
UpdateContent()
diflayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateContent)

--// Minus and Plus player buttons
local function mp_hoverset(button)
	button.MouseEnter:Connect(function()
		button.Hover.Visible = true
	end)
	button.MouseLeave:Connect(function()
		button.Hover.Visible = false
	end)
end
local function upd_mpcounter()
	pcounter.Text = mcounter
	pcounter.Size = UDim2.fromScale(1, 0.6)
	
	local track = TweenService:Create(pcounter, pulseTI, {
		Size = UDim2.fromScale(1, 0.8)
	})
	track:Play()
end

mp_hoverset(minus)
minus.Activated:Connect(function()
	sfx.ButtonPress:Play()
	local currentrange = workspace:GetAttribute("MaxPlayerRange")
	mcounter = math.clamp(mcounter - 1, currentrange.Min, currentrange.Max)
	upd_mpcounter()
end)

mp_hoverset(plus)
plus.Activated:Connect(function()
	sfx.ButtonPress:Play()
	local currentrange = workspace:GetAttribute("MaxPlayerRange")
	mcounter = math.clamp(mcounter + 1, currentrange.Min, currentrange.Max)
	upd_mpcounter()
end)

--// Exit button
exit.Activated:Connect(function()
	sfx.ButtonPress:Play()
	mainframe.Visible = false
	if rvalue.Value then
		remotes.ExitRoom:FireServer()
	end
end)
exit.MouseEnter:Connect(function()
	local track = TweenService:Create(exit, pulseTI, {
		BackgroundTransparency = 0.2;
		Size = UDim2.fromScale(0.3, 0.1);
	})
	track:Play()
end)
exit.MouseLeave:Connect(function()
	local track = TweenService:Create(exit, pulseTI, {
		BackgroundTransparency = 0.4;
		Size = UDim2.fromScale(0.2, 0.1);
	})
	track:Play()
end)

--// Close Button
close.Activated:Connect(function()
	sfx.ButtonPress:Play()
	sfx.CloseTab:Play()
	mainframe.Visible = false
	GamepadService:DisableGamepadCursor()
	if rvalue.Value then
		remotes.ExitRoom:FireServer()
	end
end)
ui_essentials.ImgCloseButton(close)

--// Challenge Frame
local butts_ch = {}
for _,m in pairs(funmods) do
	if m:IsA("ModuleScript") then
		local info = require(m)
		
		local new = example_ch:Clone()
		new.Name = m.Name
		new.Title.Text = info.DisplayName
		new.LayoutOrder = info.Order or 1
		new:SetAttribute("Checked", false)
		
		hoverservice.AddButton(new, {
			Title = info.DisplayName;
			Description = info.Description;
		})
		
		new.Checkmarked.Activated:Connect(function()
			if funlocked.Visible then return end
			sfx.ButtonPress:Play()
			
			local newstate = not new:GetAttribute("Checked")
			new:SetAttribute("Checked", newstate)
			new.Checkmarked.Tick.Visible = newstate
			
			local hasenabled = false
			for _,b in pairs(butts_ch) do
				if b:GetAttribute("Checked") then
					hasenabled = true
					break
				end
			end
			fundisclaimer.Visible = hasenabled
		end)
		
		new.Parent = list_ch
		table.insert(butts_ch, new)
	end
end

local function UpdateFun()
	funlocked.Visible = bestrank.Value < 1
end
UpdateFun()
bestrank:GetPropertyChangedSignal("Value"):Connect(UpdateFun)

--// Start party
startbutton.Activated:Connect(function()
	sfx.ButtonPress:Play()
	if rvalue.Value and modevalue.Value then
		mainframe.Visible = false
		GamepadService:DisableGamepadCursor()
		
		local sel_fun = {}
		for _,b in pairs(butts_ch) do
			if b:GetAttribute("Checked") then
				table.insert(sel_fun, b.Name)
			end
		end
		
		local myrank = rankframe:GetAttribute("SelectedRank") or 1
		if rankframe:GetAttribute("IsLocked") or ranklocked.Visible then
			myrank = nil
		end
		
		remotes.HostRoom:FireServer(mcounter, modevalue.Value, myrank, sel_fun)
	end
end)
startbutton.MouseEnter:Connect(function()
	local track = TweenService:Create(startbutton, pulseTI, {
		BackgroundTransparency = 0.5;
		Size = UDim2.fromScale(0.5, 0.1);
	})
	track:Play()
end)
startbutton.MouseLeave:Connect(function()
	local track = TweenService:Create(startbutton, pulseTI, {
		BackgroundTransparency = 0.75;
		Size = UDim2.fromScale(0.35, 0.1);
	})
	track:Play()
end)

rvalue:GetPropertyChangedSignal("Value"):Connect(function()
	local room = rvalue.Value
	if not room then
		if ev then
			ev:Disconnect()
			ev = nil
		end
		
		mainframe.Visible = false
		exit.Visible = false
		GamepadService:DisableGamepadCursor()
	else
		if not room:GetAttribute("Counting") then
			ev = room:GetAttributeChangedSignal("Counting"):Connect(function()
				if room:GetAttribute("Counting") then
					exit.Visible = true
					mainframe.Visible = false
					GamepadService:DisableGamepadCursor()
				end
			end)
		else
			exit.Visible = true
		end
	end
end)
plr:GetAttributeChangedSignal("Teleporting"):Connect(function()
	local state = plr:GetAttribute("Teleporting")
	exit.Visible = not state
end)

remotes:WaitForChild("PromptHostRoom").OnClientEvent:Connect(function()
	print("room hosted")
	mainframe.Visible = true
	partytitle.Text = plr.DisplayName.."'s Party"
	GamepadService:EnableGamepadCursor(mainframe)
	
	ui_essentials.DisableAllMains()
	ui_essentials.OpenTab(mainframe)
end)