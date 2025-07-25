local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local UIEssentials = require(ReplicatedStorage.LocalModules.UIEssentials)
local sfx = SoundService.SFX

local remotes = ReplicatedStorage.Remotes
local holder = script.Parent
local main = holder.Main
local rejoin = main.Rejoin
local cancel = main.Cancel

local rejoinButton = rejoin.TextButton
local cancelButton = cancel.TextButton

local sideFlash = main.SideFlash


--// ui_essentials.SideFlash(bundleframe.SideFlash)
local cancel = false

-- main part of the script
remotes.EnableRejoinUI.OnClientEvent:Connect(function()
	holder.Visible = true
end)

rejoinButton.Activated:Connect(function()
	-- active
	if (cancel) then
		return
	end
	
	-- rejoin the last server
	remotes.RejoinToLastInstance:FireServer()
	cancel = true
	
	UIEssentials.SideFlash(sideFlash)
	UIEssentials.ButtonEffect(rejoinButton)
	
	holder.Visible = false
	sfx.CloseTab:Play()
end)


cancelButton.Activated:Connect(function()
	-- active
	if (cancel) then
		return
	end
	
	cancel = true

	UIEssentials.SideFlash(sideFlash)
	UIEssentials.ButtonEffect(cancelButton)
	
	holder.Visible = false
	sfx.CloseTab:Play()
end)

UIEssentials.ImgCloseButton(rejoinButton)
UIEssentials.ImgCloseButton(cancelButton)