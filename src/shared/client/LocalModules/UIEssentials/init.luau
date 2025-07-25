local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local RNG = Random.new()

local lmodules = ReplicatedStorage.LocalModules
local lremotes = ReplicatedStorage.LocalRemotes
local plr = Players.LocalPlayer
local pgui = plr:WaitForChild("PlayerGui")
local sfx = SoundService.SFX
local datastats = plr:WaitForChild("DataStats")
local credval = datastats:WaitForChild("Cred")

local essentials = require(lmodules.EssentialFunctions)

local service = {}

local backTI = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local pulseTI = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local fadeTI = TweenInfo.new(0.25, Enum.EasingStyle.Linear)
local flashTI = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
function service.ButtonEffect(butt, nosound)
	if not nosound then
		sfx.ButtonPress:Play()
	end
	butt.Size = UDim2.fromScale(0.8, 0.8)

	local track = TweenService:Create(butt, pulseTI, {Size = UDim2.fromScale(1,1)})
	track:Play()

	local fl = butt:FindFirstChild("Flash")
	if fl then
		local new = fl:Clone()
		new.Name = "ClonedFlash"
		new.Visible = true
		new.Parent = butt

		local track2 = TweenService:Create(new, pulseTI, {BackgroundTransparency = 1;})
		track2:Play()

		track2.Completed:Once(function()
			new:Destroy()
		end)
	end
end

function service.RoyalSound()
	sfx.Shine.PlaybackSpeed = RNG:NextNumber(0.9, 1.1)
	sfx.ClickedSound:Play()
	sfx.Shine:Play()
end

function service.SideFlash(flash)
	local new = flash:Clone()
	new.Name = "_ClonedFlash"
	new.Visible = true
	new.Parent = flash.Parent
	
	local track = TweenService:Create(new, flashTI, {
		BackgroundTransparency = 1;
		Size = UDim2.fromScale(1, 1);
	})
	track:Play()
	
	task.delay(0.5, function()
		new:Destroy()
	end)
end

function service.OpenTab(frame)
	sfx.OpenTab:Play()
	frame.Size = UDim2.fromScale(0.8,0.8)
	local track = TweenService:Create(frame, backTI, {
		Size = UDim2.fromScale(1, 1);
	})
	track:Play()
end

function service.ImgCloseButton(butt)
	butt.MouseEnter:Connect(function()
		local track = TweenService:Create(butt, fadeTI, {
			TextColor3 = Color3.fromRGB(255, 83, 83);
		})
		track:Play()
	end)
	butt.MouseLeave:Connect(function()
		local track = TweenService:Create(butt, fadeTI, {
			TextColor3 = Color3.fromRGB(255, 255, 255);
		})
		track:Play()
	end)
end

function service.GetGridSize(frame, cells, spacing)
	local x = math.floor(frame.AbsoluteSize.X)
	if frame:IsA("ScrollingFrame") then
		x = math.floor(frame.AbsoluteCanvasSize.X)
	end
	
	local availablespace = math.floor(x - (spacing * (cells - 1)))
	
	local cellspace = math.floor(availablespace / cells)
	
	return UDim2.fromOffset(cellspace, cellspace)
end

-- Turns all main frames visibility to false
function service.DisableAllMains(except)
	for _,c in pairs(CollectionService:GetTagged("MainUI")) do
		if c:IsDescendantOf(pgui) and c ~= except then
			if c:IsA("ScreenGui") then
				c.Enabled = false
			else
				c.Visible = false
			end
		end
	end
end

function service.GetCustomerFrame(model, revealed)
	local dname = model:GetAttribute("DisplayName")
	local custimage = model:GetAttribute("CustomImage")
	
	local new = script.CustItem:Clone()
	new.ViewportFrame.Rig:Destroy()
	
	local lcolor = (revealed and Color3.fromRGB(255,255,255)) or Color3.fromRGB(0,0,0)
	if custimage then
		new.CustomImage.Visible = true
		new.ViewportFrame.Visible = false
		
		new.CustomImage.Image = custimage
		new.CustomImage.ImageColor3 = lcolor
	else
		local model = model:Clone()
		model:PivotTo(CFrame.new(0,0,0))
		model.Parent = new.ViewportFrame

		new.ViewportFrame.ImageColor3 = lcolor
	end
	
	new.Mystery.Visible = not revealed
	new.CustName.Visible = revealed

	new.CustName.Text = dname or model.Name
	
	return new
end

local ntypes = {
	["Purchased"] = {
		TextColor = Color3.fromRGB(133, 255, 153);
		Sounds = {"Purchase"};
	};
	["Error"] = {
		TextColor = Color3.fromRGB(255, 108, 108);
		Sounds = {"Buzzer"};
	};
	["RoyalPurchase"] = {
		StrokeColor = Color3.fromRGB(18, 95, 27);
		TextColor = Color3.fromRGB(125, 255, 116);
		Sounds = {"Purchase"};
	};
	
	
}
function service.Notify(text, ntype, duration, custom_details, scale)
	if not text then
		warn("Text not provided for notification, sunk")
		return
	end
	local set = ntypes[ntype] or custom_details or {}
	
	lremotes.Notify:Fire(text, duration, set, set.Sounds, scale)
end

local cred_texts = {}
local function UpdateCred()
	local current = credval.Value
	local text = essentials.FormatNum(current)
	for _,t in pairs(cred_texts) do
		t.Text = text
	end
end
function service.AddCredText(text)
	table.insert(cred_texts, text)
	text.AncestryChanged:Connect(function()
		table.remove(cred_texts, table.find(cred_texts, text))
	end)
	
	UpdateCred()
end
credval:GetPropertyChangedSignal("Value"):Connect(UpdateCred)

local glaring = {}
RunService:BindToRenderStep("GradientGlare", 100, function(dt)
	
	local offset = 0
	for _,g in pairs(glaring) do
		local current = math.sin((tick() + offset) * 1)
		g.Rotation = current * 180
		
		offset += 0.75
	end
end)
function service.GlareGradient(grad)
	table.insert(glaring, grad)
end

return service