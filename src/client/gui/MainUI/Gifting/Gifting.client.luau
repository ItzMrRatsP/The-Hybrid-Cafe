local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local MSS = game:GetService("MarketplaceService")

local plr = Players.LocalPlayer
local sfx = SoundService.SFX
local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules
local lremotes = ReplicatedStorage.LocalRemotes

local ui_essentials = require(lmodules.UIEssentials)
local essentials = require(lmodules.EssentialFunctions)
local giftables = require(lmodules.GamepassInfo)

local holder = script.Parent
local ui = holder.Parent
local mainbuttons = ui.MainButtons
local cbutton = mainbuttons.ButtonsRight.Gift
local mainframe = holder.Frame
local close = mainframe.Close
local work = mainframe.Workframe
local details = work.Details
local gsc = work.Giftables
local plrbox = details.TextBox
local submit = details.SubmitFrame.SubmitGift
local warning = details.Warning
local pfp = details.PlrImage
local listbutton = details.GetFromList
local plist = listbutton.PlayerList

local stock_p = plist.PButton:Clone()
local stockgp = gsc.Pass:Clone()
gsc.Pass:Destroy()
plist.PButton:Destroy()

local passbuttons = {}
local selectedplr
local function RefreshPasses()
	local passes = remotes.GetMyGamepasses:InvokeServer()
	if passes == nil then return end
	holder:SetAttribute("SelectedPass", "")
	
	passbuttons = {}
	for _,f in pairs(gsc:GetChildren()) do
		if f:IsA("Frame") then
			f:Destroy()
		end
	end
	
	for name, am in pairs(passes) do
		local info = giftables[name]
		
		local new = stockgp:Clone()
		
		new:SetAttribute("ButtonColor", info.Color)
		new.TextButton.BG.ImageColor3 = info.Color
		new.TextButton.UIStroke.Color = info.Color
		new.TextButton.BackgroundColor3 = info.Color
		
		new.TextButton.PassName.Text = info.DisplayName
		local success, message = pcall(function()
			local devinfo = MSS:GetProductInfo(info.ID, Enum.InfoType.GamePass)
			new.TextButton.ImageLabel.Image = "rbxassetid://"..devinfo.IconImageAssetId
			new.TextButton.PriceFrame.TextLabel.Text = devinfo.PriceInRobux
		end)
		if not success then
			warn("Gamepass failed to load,", message)
			new.TextButton.PriceFrame.TextLabel.Text = "???"
		end
		
		if am >= 1 then
			new.TextButton.IsOwned.Text = "(Owned)"
			if am > 1 then
				new.TextButton.PriceFrame.TextLabel.Text = "FREE!"
			end
		else
			new.TextButton.IsOwned.Text = "(Not Owned)"
		end
		
		new.TextButton.Activated:Connect(function()
			ui_essentials.ButtonEffect(new.TextButton)
			
			holder:SetAttribute("SelectedPass", name)
			for _,b in pairs(passbuttons) do
				b.TextButton.UIStroke.Color = b:GetAttribute("ButtonColor")
			end
			new.TextButton.UIStroke.Color = Color3.fromRGB(0, 255, 0)
		end)
		
		new.Parent = gsc
		table.insert(passbuttons, new)
	end
end

plrbox.FocusLost:Connect(function(_enterpressed)
	local success, ID = pcall(function()
		return Players:GetUserIdFromNameAsync(plrbox.Text)
	end)
	
	if success then
		selectedplr = ID
		pfp.Image = essentials.GetPlayerPicture(ID)
		warning.Visible = false
	else
		pfp.Image = "rbxassetid://0"
		selectedplr = nil
		warning.Visible = true
	end
end)

listbutton.Activated:Connect(function()
	sfx.ButtonPress:Play()
	
	plist.Visible = not plist.Visible
	if plist.Visible then
		for _,p in pairs(plist:GetChildren()) do
			if p:IsA("TextButton") then
				p:Destroy()
			end
		end
		
		local using = Players:GetPlayers()
		table.sort(using, function(a,b)
			return a.Name < b.Name
		end)
		for i, p in pairs(using) do
			local new = stock_p:Clone()
			new.Text = p.Name
			
			new.LayoutOrder = i
			new.Parent = plist
			
			new.Activated:Connect(function()
				sfx.ButtonPress:Play()
				plist.Visible = false
				
				warning.Visible = false
				selectedplr = p.UserId
				plrbox.Text = p.Name
				pfp.Image = essentials.GetPlayerPicture(p)
			end)
		end
	end
end)

submit.Activated:Connect(function()
	ui_essentials.ButtonEffect(submit, true)
	ui_essentials.RoyalSound()
	
	if not selectedplr or holder:GetAttribute("SelectedPass") == "" then
		essentials.Local_ErrorNotify("Specify a player and gamepass first!", 5)
		return
	end
	
	local success, message = remotes.GiftGamepass:InvokeServer(selectedplr, holder:GetAttribute("SelectedPass"))
	if success then
		lremotes.Notify:Fire(message, 4, {
			TextColor = Color3.fromRGB(255, 169, 232);
			StrokeColor = Color3.fromRGB(106, 41, 94);
		}, {"BellRing"})
		RefreshPasses()
	else
		essentials.Local_ErrorNotify(message, 5)
	end
end)

cbutton.Button.Activated:Connect(function()
	ui_essentials.ButtonEffect(cbutton.Button)

	ui_essentials.DisableAllMains(holder)
	local newstate = not holder.Visible
	holder.Visible = newstate

	if newstate then
		ui_essentials.OpenTab(mainframe)
		RefreshPasses()
	else
		sfx.CloseTab:Play()
	end
end)

close.Activated:Connect(function()
	holder.Visible = false
	sfx.CloseTab:Play()
end)
ui_essentials.ImgCloseButton(close)

local function update()
	local abs = gsc.UIListLayout.AbsoluteContentSize.Y
	gsc.CanvasSize = UDim2.fromOffset(0, abs)
end
gsc.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)

warning.Visible = false

ui_essentials.GlareGradient(cbutton.Button.UIGradient)

