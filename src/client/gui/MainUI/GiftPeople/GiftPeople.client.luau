--[[
HOW:

USE A REMOTEFUNCTION TO RETURN IF PLAYER CAN BE GIFTED OR NOT
IF YES THEN PROMPT THE PRODUCT VIA SERVER

IF GIFTING FAILS THEN ADD A VALUE IN A "GIFTBANK" DATASTORE

IF THERE IS A PRODUCT IN THE GIFTBANK THEN THE PROCESS IS INSTANTANEOS AND DOESNT PROMPT A PRODUCT

]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SFX = game:GetService("SoundService").SFX

local lmodules = ReplicatedStorage.LocalModules
local lremotes = ReplicatedStorage.LocalRemotes
local remotes = ReplicatedStorage.Remotes

local frame = script.Parent
local main = frame.Frame
local scrollingframe = main.Content.Frame.ScrollingFrame
local close = main.Close

local ex = scrollingframe.Frame
ex.Visible = false

local observer = require(lmodules.Utility.Observers)
local promise = require(lmodules.Utility.Promise)
local essentials = require(lmodules.EssentialFunctions)
local ui_essentials = require(lmodules.UIEssentials)

local prodID = nil

observer.observePlayer(function(plr)
	local new = ex:Clone()
	local butt = new.TextButton
	
	new.Visible = plr ~= Players.LocalPlayer
	butt.TextLabel.Text = "@"..plr.Name
	if plr.DisplayName ~= plr.Name then
		butt.TextLabel.Text = butt.TextLabel.Text.." ("..plr.DisplayName..")"
	end
	butt.GraphicBG.Image = essentials.GetPlayerPicture(plr)
	
	local prom = promise.new(function(resolve, reject, oncancel)
		-- is friends
		local isfriends = Players.LocalPlayer:IsFriendsWith(plr.UserId)
		
		local action = (isfriends and resolve) or reject
		action()
	end):andThen(function()
		new.LayoutOrder = 1
	end, function()
		new.LayoutOrder = 50
	end):finally(function()
		new.Parent = scrollingframe
	end):catch(function(err)
		warn(tostring(err))
	end)
	
	butt.Activated:Connect(function()
		ui_essentials.ButtonEffect(butt)
		if not prodID then return end
		
		local response, message = remotes.GiftProduct:InvokeServer(prodID, plr)
		-- 0: silence, 1: success, 2: error
		
		if response == 1 then
			ui_essentials.Notify(message or "Success!", "Purchased", 5)
		elseif response == 2 then
			ui_essentials.Notify(message or "Error occured", "Error", 5)
		end
		if response ~= 2 then
			SFX.CloseTab:Play()
			frame.Visible = false
		end
	end)
	
	return function()
		new:Destroy()
		prom:cancel()
	end
end)

lremotes.InitGiftScene.Event:Connect(function(ID)
	prodID = ID

	frame.Visible = true
	ui_essentials.OpenTab(main)
end)

ui_essentials.ImgCloseButton(close)
close.Activated:Connect(function()
	SFX.CloseTab:Play()
	frame.Visible = false
end)