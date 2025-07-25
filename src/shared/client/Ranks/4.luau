local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	DisplayName = "Silver Barista";
	NameColor = Color3.fromRGB(219, 241, 255);
	Details = {
		essentials.ColorText("A/C and machines", Color3.fromRGB(255, 93, 93)).." are harder to fix";
		"Customers are "..essentials.ColorText("less patient", Color3.fromRGB(255, 230, 90));
	};
	Reward = 200;
}

return info