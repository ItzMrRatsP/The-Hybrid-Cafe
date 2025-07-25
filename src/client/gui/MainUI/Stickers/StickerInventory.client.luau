local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local genRNG = Random.new()

local plr = Players.LocalPlayer
local pstickers = plr:WaitForChild("EquippedCosmetics")
local stick_folder = ReplicatedStorage.Stickers
local sfx = SoundService.SFX
local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules

local hoverservice = require(lmodules.HoverService)
local ui_essentials = require(lmodules.UIEssentials)

local holder = script.Parent
local ui = holder.Parent
local mainbuttons = ui.MainButtons
local buttons = mainbuttons.ButtonsLeft
local cbutton = buttons.Stickers
local mainframe = holder.Frame
local close = mainframe.Close

local wheel = mainframe.WheelCover.Wheel
local sframe = mainframe.ScrollingFrame
--local sgrid = sframe.UIGridLayout

local example = sframe.TextButton:Clone()
local stock_row = sframe.Row:Clone()
sframe.TextButton:Destroy()
sframe.Row:Destroy()

local toingTI = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local pushTI = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local current_equipped = {}
local function UpdateEquipped(changedindex)
	for i = 1,5 do
		local eframe = wheel.Buttons:FindFirstChild(tostring(i))
		local butt = eframe.TextButton
		local item = current_equipped[i]
		local scaler = eframe.UIScale
		
		if changedindex == i then
			scaler.Scale = 1.5
			local track = TweenService:Create(scaler, pushTI, {
				Scale = 1;
			})
			track:Play()
		end
		
		if item then
			butt.ItemImage.Image = item.Value
			butt.Title.Text = item:GetAttribute("DisplayName")
			
			butt.EmptyText.Visible = false
			butt.Title.Visible = true
			butt.ItemImage.Visible = true
		else
			butt.EmptyText.Visible = true
			butt.Title.Visible = false
			butt.ItemImage.Visible = false
		end
	end
end

local RNG = Random.new(14122024)
local am_row = 3
local rows = {}
local buttons = {}
local stickerlist = stick_folder:GetChildren()

table.sort(stickerlist, function(a, b)
	return a.Name < b.Name
end)

for i = 1, am_row do
	local new = stock_row:Clone()
	new.LayoutOrder = i
	new.Size = UDim2.fromScale(1/am_row, 0)
	new.Offset.Size = UDim2.new(1, 0, 0, RNG:NextInteger(0, 50))
	new.Parent = sframe
	
	rows[i] = new
end

for i, s in pairs(stickerlist) do
	if s:IsA("StringValue") then
		local place = i % am_row
		place = (place == 0 and am_row) or place
		
		local rSize = RNG:NextNumber(0.75, 0.9)
		
		local new = example:Clone()
		new.Name = s.Name
		new.LayoutOrder = i
		new.Frame.Position = UDim2.fromScale(RNG:NextNumber(0.45, 0.55), 0.5)
		new.Frame.Size = UDim2.fromScale(rSize, rSize)
		new.Frame.ImageLabel.Image = s.Value
		new.Frame.Hover.Image = s.Value
		
		new.Parent = rows[place]
		table.insert(buttons, new)
		
		new.MouseEnter:Connect(function()
			new.Frame.Hover.Visible = true
		end)
		new.MouseLeave:Connect(function()
			new.Frame.Hover.Visible = false
		end)
		new.MouseButton1Up:Connect(function()
			if new:GetAttribute("Locked") then return end
			new.Frame.Hover.Visible = false
			sfx.ButtonPress:Play()
			
			new.Frame.Size = UDim2.fromScale(0.675, 0.675)
			local track = TweenService:Create(new.Frame, toingTI, {
				Size = UDim2.fromScale(rSize, rSize);
			})
			track:Play()

			local targetindex = math.clamp(#current_equipped + 1, 1, 5)
			current_equipped[targetindex] = s
			UpdateEquipped(targetindex)
		end)
	end
end

for i = 1,5 do
	local item = pstickers:FindFirstChild(tostring(i))
	table.insert(current_equipped, item.Value)

	local eframe = wheel.Buttons:FindFirstChild(tostring(i))
	local butt = eframe.TextButton
	local scaler = eframe.UIScale
	
	butt.Activated:Connect(function()
		sfx.ButtonPress:Play()
		table.remove(current_equipped, i)
		UpdateEquipped()
	end)
	
	butt.MouseEnter:Connect(function()
		eframe.GroupColor3 = Color3.fromRGB(100,100,100)
		local track = TweenService:Create(scaler, pushTI, {
			Scale = 1.25;
		})
		track:Play()
	end)
	
	butt.MouseLeave:Connect(function()
		eframe.GroupColor3 = Color3.fromRGB(255,255,255)
		local track = TweenService:Create(scaler, pushTI, {
			Scale = 1;
		})
		track:Play()
	end)
	
	butt.Activated:Connect(function()
		scaler.Scale = 0.75
		local track = TweenService:Create(scaler, pushTI, {
			Scale = 1;
		})
		track:Play()
	end)
end

UpdateEquipped()

cbutton.Button.Activated:Connect(function()
	ui_essentials.ButtonEffect(cbutton.Button)
	
	ui_essentials.DisableAllMains(holder)
	local newstate = not holder.Visible
	holder.Visible = newstate
	
	if newstate then
		ui_essentials.OpenTab(mainframe)
		local mystickers = remotes.GetMyStickers:InvokeServer()
		for _,b in pairs(buttons) do
			local s = stick_folder:FindFirstChild(b.Name)
			local islocked = table.find(mystickers, b.Name) == nil
			b.Visible = not (islocked and s and s:GetAttribute("Unlisted") == true)
			
			if s then
				hoverservice.RemoveButton(b)
				hoverservice.AddButton(b, {
					Title = (islocked and "Locked") or s:GetAttribute("DisplayName");
					Description = (islocked and s:GetAttribute("LockedDescription")) or s:GetAttribute("Description");
				})
			end
			
			if islocked then
				b:SetAttribute("Locked", true)
				b.Frame.ImageLabel.ImageColor3 = Color3.fromRGB(0,0,0)
				b.Frame.ImageLabel.ImageTransparency = 0.2
			end
		end
		
		table.sort(buttons, function(a, b)
			local aL = (a:GetAttribute("Locked") and 1) or 0
			local bL = (b:GetAttribute("Locked") and 1) or 0
			
			if aL ~= bL then
				return aL < bL
			else
				return a.Name < b.Name
			end
		end)
		for i,b in pairs(buttons) do
			local place = i % am_row
			place = (place == 0 and am_row) or place
			
			b.LayoutOrder = i
			b.Parent = rows[place]
		end
	else
		sfx.CloseTab:Play()
	end
end)

close.Activated:Connect(function()
	holder.Visible = false
	sfx.CloseTab:Play()
end)
ui_essentials.ImgCloseButton(close)

holder:GetPropertyChangedSignal("Visible"):Connect(function()
	if holder.Visible == false then
		local sending = {}
		for _,v in pairs(current_equipped) do
			table.insert(sending, v)
		end
		remotes.SetCosmetics:FireServer(sending)
	end
end)

--// Grid Management
local function upd_grid()
	local absx = math.ceil(sframe.AbsoluteSize.X / am_row)
	for _,b in pairs(buttons) do
		b.Size = UDim2.new(1, 0, 0, absx)
	end
end
upd_grid()
sframe:GetPropertyChangedSignal("AbsoluteSize"):Connect(upd_grid)

--[[local minsize = 65
local function upd_grid()
	local abs = sframe.AbsoluteSize.X
	local gridspacing = sgrid.CellPadding.X.Offset
	local maxcells = math.floor(abs / (minsize + gridspacing - 1))
	maxcells = math.clamp(maxcells, 5, 7)
	
	local gridsize = ui_essentials.GetGridSize(sframe, maxcells, gridspacing)
	sgrid.CellSize = gridsize
end
upd_grid()
sframe:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	upd_grid()
end)--]]