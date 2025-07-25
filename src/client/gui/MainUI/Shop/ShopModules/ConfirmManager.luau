local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MSS = game:GetService("MarketplaceService")
local RNG = Random.new()

local lmodules = ReplicatedStorage.LocalModules
local sfx = game:GetService("SoundService").SFX
local plr = Players.LocalPlayer
local remotes = ReplicatedStorage.Remotes
local cups = ReplicatedStorage.Cups

local holder = script.Parent.Parent
local buyframe = holder.Frame.Main.Buy
local confirmframe = buyframe.Confirmation
local confirmtitle = confirmframe.Title
local buy = confirmframe.Buy.TextButton
local equip = confirmframe.Equip.TextButton
local equiptitle = confirmframe.EquippedTitle
local price = confirmframe.PriceFrame
local close = confirmframe.Close
local owntitle = confirmframe.OwnedTitle

local ui_essentials = require(lmodules.UIEssentials)
local babemanager = require(script.Parent.BabeManager)

local service = {}
local selected

local jumpTI = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local function JumpFrame()
	confirmframe.Position = UDim2.fromScale(0.5, 0.95)
	local track = TweenService:Create(confirmframe, jumpTI, {
		Position = UDim2.fromScale(0.5, 1)
	})
	track:Play()
end

-- ATM this only accepts Cred items. Robux items are immediately prompted
function service.SelectItem(mod, isinventory, isequipped)
	selected = mod
	local info
	if mod == "Random" then
		info = {
			DisplayName = "Random";
			Price = "???";
		}
	else
		info = require(mod)
	end
	
	confirmframe.Title.Text = info.DisplayName
	price.TextLabel.Text = info.Price or "???"
	
	price.Visible = (not isinventory and not isequipped) or false
	buy.Parent.Visible = (not isinventory and not isequipped) or false
	equip.Parent.Visible = (isinventory and not isequipped) or false
	equiptitle.Visible = (isinventory and isequipped) or false
	owntitle.Visible = isinventory or isequipped or false
	
	confirmframe.Visible = true
	babemanager.GradBabes(true)
	JumpFrame()
end

function service.CloseFrame()
	confirmframe.Visible = false
	babemanager.GradBabes(false)
end

buy.Activated:Connect(function()
	ui_essentials.ButtonEffect(buy)

	if not selected or selected == "Random" then return end
	local success = remotes.Shop_BuyItem:InvokeServer(selected)
	if success then
		service.CloseFrame()
	end
end)
equip.Activated:Connect(function()
	ui_essentials.ButtonEffect(buy)

	sfx.PlasticCup.PlaybackSpeed = RNG:NextNumber(0.9, 1)
	sfx.Dink.PlaybackSpeed = RNG:NextNumber(1.35, 1.5)
	sfx.Dink:Play()
	sfx.PlasticCup:Play()

	if not selected then return end
	if selected == "Random" then
		remotes.Shop_EnableRandom:FireServer()
	else
		remotes.Shop_EquipItem:FireServer(selected)
	end
	
	equip.Parent.Visible = false
	equiptitle.Visible = true
	JumpFrame()
end)

close.Activated:Connect(function()
	service.CloseFrame()
	sfx.CloseTab:Play()
end)
ui_essentials.ImgCloseButton(close)

return service