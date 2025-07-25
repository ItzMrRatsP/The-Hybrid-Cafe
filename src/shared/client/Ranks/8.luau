local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	DisplayName = "Diamond Barista";
	NameColor = Color3.fromRGB(120, 244, 255);
	Details = {
		"Normal customers may be "..essentials.ColorText("strict", Color3.fromRGB(255, 230, 90));
		"Shop items may be "..essentials.ColorText("unavailable to purchase", Color3.fromRGB(255, 93, 93));
	};
	Reward = 350;
}

return info