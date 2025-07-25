local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local cups = ReplicatedStorage.Cups

local essentials = require(lmodules.EssentialFunctions)

local info = {}

local amountimages = {
	{"rbxassetid://6916319427", 0};
	{"rbxassetid://6916319287", 150};
	{"rbxassetid://6916319109", 200};
	{"rbxassetid://6916318824", 250};
}

local gradients = {
	Cup = {
		-- Normal
		normal = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(79, 49, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(79, 60, 31))
		};
		-- Brighter
		streak = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(166, 102, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(243, 184, 95))
		}
	};
	
	Sticker = {
		-- Normal
		normal = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(79, 0, 55)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(97, 0, 92))
		};
		-- Brighter
		streak = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(166, 0, 136)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(243, 0, 198))
		}
	};

	Cred = {
		normal = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 43, 79)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 67, 79))
		};
		-- Brighter
		streak = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(76, 117, 214)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 194, 227))
		}
	}
}

info["Cred"] = function(frame, amount, streak: boolean)
	local img = "rbxassetid://6916319427"
	for _,v in pairs(amountimages) do
		if amount >= v[2] then
			img = v[1]
		end
	end

	frame.Frame.Display.ImageLabel.Image = img
	frame.Frame.Title.Text = "x"..essentials.FormatNum(amount)

	frame.Frame.UIGradient.Color = (streak and gradients.Cred.streak or gradients.Cred.normal)
end

info["Cup"] = function(frame, cname, streak: boolean)
	local mod = cups:FindFirstChild(cname)
	local info = (mod and require(mod)) or {}

	frame.Frame.Display.ImageLabel.Image = info.Image or "rbxassetid://15668939723"
	frame.Frame.Title.Text = info.DisplayName or "N/A"

	frame.Frame.UIStroke.Color = Color3.fromRGB(255, 203, 114)
	frame.Frame.DayTitle.UIStroke.Color = Color3.fromRGB(154, 123, 87)
	frame.Frame.Title.UIStroke.Color = Color3.fromRGB(154, 123, 87)

	frame.Frame.UIGradient.Color = (streak and gradients.Cup.streak or gradients.Cup.normal)
end

info["Sticker"] = function(frame, stickerName, streak: boolean)
	local sticker = ReplicatedStorage.Stickers:FindFirstChild(stickerName, true)
	
	frame.Frame.Display.ImageLabel.Image = sticker.Value or "rbxassetid://15668939723"
	frame.Frame.Title.Text = sticker:GetAttribute("DisplayName") or "N/A"

	frame.Frame.UIStroke.Color = Color3.fromRGB(255, 116, 253)
	frame.Frame.DayTitle.UIStroke.Color = Color3.fromRGB(154, 94, 151)
	frame.Frame.Title.UIStroke.Color = Color3.fromRGB(154, 89, 143)
	
	frame.Frame.UIGradient.Color = (streak and gradients.Sticker.streak or gradients.Sticker.normal)
end

return info
