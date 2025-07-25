local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	DisplayName = "Master Barista";
	NameColor = Color3.fromRGB(255, 162, 230);
	Details = {
		essentials.ColorText("Toddlers", Color3.fromRGB(255, 93, 93)).." stay longer and can come in pairs.";
		"Have access to only "..essentials.ColorText("one", Color3.fromRGB(255, 230, 90)).." foam machine.";
	};
	Reward = 400;
}

return info