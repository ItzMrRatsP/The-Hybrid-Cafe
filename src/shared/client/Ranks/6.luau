local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	DisplayName = "Amethyst Barista";
	NameColor = Color3.fromRGB(208, 160, 255);
	Details = {
		essentials.ColorText("+1", Color3.fromRGB(255, 230, 90)).." Event per day";
		essentials.ColorText("Double events", Color3.fromRGB(255, 93, 93)).." may happen at a time";
	};
	Reward = 265;
}

return info