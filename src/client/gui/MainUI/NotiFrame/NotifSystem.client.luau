local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local LocalRemotes = ReplicatedStorage:WaitForChild("LocalRemotes")

local SFX = game:GetService("SoundService"):WaitForChild("SFX")

local frame = script.Parent
local nt_text = frame:WaitForChild("NotiText"):Clone()
frame.NotiText:Destroy()

local queued = {}

local pop_ti = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local fade_ti = TweenInfo.new(1.2, Enum.EasingStyle.Linear)
local function Notify(text, duration, details, sounds, scale)
	if plr:GetAttribute("Loading") then
		table.insert(queued, {text, duration, details, sounds, scale})
	end
	
	local new = nt_text:Clone()
	
	new.Visible = true
	new.Text = text
	new.Size = UDim2.new(1, 0, 0, math.round(40 * (scale or 1)))
	if details then
		new.Name = details.NotifClass or new.Name
		new.TextColor3 = details.TextColor or new.TextColor3
		new.UIStroke.Color = details.StrokeColor or new.UIStroke.Color
		-- TODO: play a specified sound effect
	end
	if sounds then
		for _,n in pairs(sounds) do
			local s = SFX:FindFirstChild(n)
			if s then
				s:Play()
			end
		end
	end
	
	local lowest = 1000
	for _,p in pairs(frame:GetChildren()) do
		if p:IsA("TextLabel") then
			if p.LayoutOrder < lowest then
				lowest = p.LayoutOrder
			end
		end
	end
	new.LayoutOrder = lowest - 1
	
	new.Size = UDim2.fromScale(1, 0)
	new.Parent = frame
	
	local track = TweenService:Create(new, pop_ti, {Size = UDim2.new(1,0,0,40)})
	track:Play()
	
	if duration and duration > 0 then
		pcall(function()
			task.wait(duration)
			local fadetrack = TweenService:Create(new, fade_ti, {TextTransparency = 1})
			local fadetrack2 = TweenService:Create(new.UIStroke, fade_ti, {Transparency = 1})

			fadetrack:Play()
			fadetrack2:Play()

			task.wait(fade_ti.Time)
			new:Destroy()
		end)
	else
		warn("[NotiSystem] Notification not provided duration; may be display infinitely. |", details)
	end
end

local function ClearNotifs(class)
	-- If class is not provided, will clear all notifications
	for _,p in pairs(frame:GetChildren()) do
		if p:IsA("TextLabel") and (not class or p.Name == class) then
			p:Destroy()
		end
	end
end

Remotes:WaitForChild("NotifyPlayer").OnClientEvent:Connect(Notify)
Remotes:WaitForChild("ClearPlayerNotifications").OnClientEvent:Connect(ClearNotifs)
LocalRemotes:WaitForChild("Notify").Event:Connect(Notify)
LocalRemotes:WaitForChild("ClearNotifications").Event:Connect(ClearNotifs)

plr:GetAttributeChangedSignal("Loading"):Connect(function()
	if not plr:GetAttribute("Loading") then
		for _,v in pairs(queued) do
			task.spawn(Notify, table.unpack(v))
			task.wait(0.25)
		end
		
		queued = {}
	end
end)