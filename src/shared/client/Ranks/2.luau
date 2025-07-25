local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	DisplayName = "Iron Barista";
	NameColor = Color3.fromRGB(175, 175, 175);
	Details = {
		"Profit quota is "..essentials.ColorText("25%", Color3.fromRGB(255, 230, 90)).." higher";
		essentials.ColorText("+1", Color3.fromRGB(255, 230, 90)).." Customer per day";
	};
	Reward = 135;
}

return info

-- 255, 93, 93 event
-- 255, 230, 90 value