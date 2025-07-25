local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	DisplayName = "Ruby Barista";
	NameColor = Color3.fromRGB(255, 103, 103);
	Details = {
		essentials.ColorText("The Eye", Color3.fromRGB(255, 93, 93)).." triggers quicker";
		essentials.ColorText("Ghosts", Color3.fromRGB(255, 93, 93)).." move slightly faster";
	};
	Reward = 300;
}

return info