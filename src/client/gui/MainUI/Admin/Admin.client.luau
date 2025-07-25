local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local sfx = SoundService.SFX
local remotes = ReplicatedStorage.Remotes
local lremotes = ReplicatedStorage.LocalRemotes
local lmodules = ReplicatedStorage.LocalModules
local datastats = plr:WaitForChild("DataStats")

local ui_essentials = require(lmodules.UIEssentials)

local holder = script.Parent
local ui = holder.Parent
local mainbuttons = ui.MainButtons
local mainframe = holder.Frame
local close = mainframe.Close
local cmd_box = mainframe.CommandBox
local message_box = mainframe.GlobalBox
local target_box = mainframe.TargetPlayerBox
local duration_box = mainframe.DurationBox
local private_box = mainframe.PrivateBox
local cbutton = mainbuttons.ButtonsRight.Admin
local submit = mainframe.Submit
local ban = mainframe.Ban
local kick = mainframe.Kick
local unban = mainframe.Unban

local isadmin = plr:GetAttribute("IsAdmin") or false
cbutton.Visible = isadmin



if not isadmin then
	holder:Destroy()
end

submit.Activated:Connect(function()
	sfx.ButtonPress:Play()
	
	local cmd, targetname, message = cmd_box.Text, target_box.Text, message_box.Text
	
	local is_cmd = cmd ~= ""
	local userid
	pcall(function()
		userid = Players:GetUserIdFromNameAsync(targetname)
	end)
	
	print("pressed")
	if is_cmd and not userid then return end
	if not is_cmd and message == "" then return end
	
	if is_cmd then
		remotes.Admin_RemoteCommand:FireServer(userid, cmd, message)
	else
		remotes.Admin_AnnounceServer:FireServer(message, userid)
	end
end)

kick.Activated:Connect(function()
	sfx.ButtonPress:Play()
	
	local targetname = target_box.Text
	local reason = message_box.Text
	local success, userid = pcall(function()
		return Players:GetUserIdFromNameAsync(targetname)
	end)
	
	if not success then return end
	
	remotes.Admin_Kick:FireServer(userid, reason)
end)
ban.Activated:Connect(function()
	sfx.ButtonPress:Play()

	local targetname = target_box.Text
	local reason = message_box.Text
	local privatereason = private_box.Text
	local banduration = duration_box.Text
	local success, userid = pcall(function()
		banduration = tonumber(banduration) or -1
		return Players:GetUserIdFromNameAsync(targetname)
	end)

	if not success then return end

	local result, message = remotes.Admin_Ban:InvokeServer(true, userid, banduration, reason, privatereason)
	if result then
		lremotes.Notify:Fire("Successfully banned "..targetname, 5)
	else
		lremotes.Notify:Fire(message, 5, {TextColor = Color3.fromRGB(255,75,75)}, {"Buzzer"})
	end
end)
unban.Activated:Connect(function()
	sfx.ButtonPress:Play()

	local targetname = target_box.Text
	local privatereason = private_box.Text
	local success, userid = pcall(function()
		return Players:GetUserIdFromNameAsync(targetname)
	end)

	if not success then return end

	local result, message = remotes.Admin_Ban:InvokeServer(false, userid)
	if result then
		lremotes.Notify:Fire("Successfully unbanned "..targetname, 5)
	else
		lremotes.Notify:Fire(message, 5, {TextColor = Color3.fromRGB(255,75,75)}, {"Buzzer"})
	end
end)

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

local plist = mainframe.PlayerList
local plrbutton = plist.TextButton
plrbutton.Visible = false

local order = 1
local function PlayerAdded(plr)
	local new = plrbutton:Clone()
	new.Name = plr.Name
	new.LayoutOrder = order
	new.Text = plr.Name
	new.Visible = true
	
	new.Parent = plist
	
	new.Activated:Connect(function()
		sfx.ButtonPress:Play()
		target_box.Text = plr.Name
	end)
	
	order += 1
end
local function PlayerRemoved(plr)
	local item = plist:FindFirstChild(plr.Name)
	if item then
		item:Destroy()
	end
end
for _,p in pairs(Players:GetPlayers()) do
	task.spawn(PlayerAdded, p)
end
Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoved)