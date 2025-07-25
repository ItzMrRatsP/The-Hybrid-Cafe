local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local SFX = game:GetService("SoundService").SFX
local lmodules = ReplicatedStorage.LocalModules
local remotes = ReplicatedStorage.Remotes
local lremotes = ReplicatedStorage.LocalRemotes

local ui_essentials = require(lmodules.UIEssentials)

local main = script.Parent
local close = main.Close
local title = main.Title
local desc = main.Description

local TI = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

local decaythread
local function ClosePopup()
	SFX.CloseTab:Play()
	main.Visible = false
end

local function CreatePopup(t_title, t_desc, t_close, noclose, duration)
	if not t_title and not t_desc then
		ClosePopup()
		return
	end
	
	if decaythread then
		pcall(function()
			task.cancel(decaythread)
		end)
	end
	ClosePopup()
	
	title.Text = t_title or ""
	desc.Text = t_desc or "Nothing!"
	close.TextButton.TextLabel.Text = t_close or "Okay"
	
	close.Visible = not (noclose or false)
	main.Visible = true
	
	SFX.OpenTab:Play()
	
	main.Position = UDim2.fromScale(0.5, 0.55)
	local track = TweenService:Create(main, TI, {
		Position = UDim2.fromScale(0.5, 0.5);
	})
	track:Play()
	
	if duration or noclose then
		-- Close after specified time
		local dur = duration or 2
		decaythread = task.delay(dur, function()
			
		end)
	end
end

remotes.PopupPlayer.OnClientEvent:Connect(CreatePopup)
lremotes.Popup.Event:Connect(CreatePopup)

close.TextButton.Activated:Connect(function()
	ui_essentials.ButtonEffect(close.TextButton)
	ClosePopup()
end)

local function upd_dtx()
	local abs = main.AbsoluteSize.Y
	desc.UITextSizeConstraint.MaxTextSize = math.clamp(abs / 8, 5, 1000)
end

upd_dtx()
main:GetPropertyChangedSignal("AbsoluteSize"):Connect(upd_dtx)

