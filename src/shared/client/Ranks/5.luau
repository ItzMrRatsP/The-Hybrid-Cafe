local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	DisplayName = "Gold Barista";
	NameColor = Color3.fromRGB(255, 220, 78);
	Details = {
		"Next customer enters "..essentials.ColorText("25%", Color3.fromRGB(255, 230, 90)).." quicker";
		essentials.ColorText("Akari", Color3.fromRGB(255, 93, 93)).." lurks in an area only once";
	};
	Reward = 235;
}

return info