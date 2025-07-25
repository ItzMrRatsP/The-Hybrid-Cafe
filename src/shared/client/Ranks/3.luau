local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	DisplayName = "Bronze Barista";
	NameColor = Color3.fromRGB(255, 128, 0);
	Details = {
		"Shop items are "..essentials.ColorText("20%", Color3.fromRGB(255, 230, 90)).." more expensive";
		essentials.ColorText("+1", Color3.fromRGB(255, 230, 90)).." Event per day";
	};
	Reward = 165;
}

return info