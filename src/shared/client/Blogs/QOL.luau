local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	Title = "QOL Update!";
	DateCreated = {2025; 7; 20}; -- Y/M/D
	Color = Color3.fromRGB(78, 22, 221);
	ImageBanner = "rbxassetid://123170622046327";
	Active = true;
}

info.Content = {
	{"Image"; 0.3; 1/1; "rbxassetid://123170622046327"};
	{"Header"; nil; "Summary:"};
	{"NormalText"; nil; "- ⭐ Matchmaking"};
	{"NormalText"; nil; "- ⚔️ Solo Improvement"};
	{"NormalText"; nil; "- 🎨 Free Spray"};
	{"NormalText"; nil; "- 🧾 Task Tracking"};
	{"Spacing"; 5};
	{"Header"; nil; "⭐ Matchmaking"};
	{"NormalText"; nil; `To try {essentials.ColorText("Matchmaking", Color3.fromRGB(255, 212, 125))}, all you have to do is press the button below and queue into the match with people that may not even be in your server! Please let us know if you encounter any bugs.`};
	{"Spacing"; 5};
	{"Header"; nil; "⚔️ Solo Improvement"};
	{"NormalText"; nil; `Hostile entities will now have a {essentials.ColorText("20%", Color3.fromRGB(255, 60, 60))} health reduction in solo play!`};
	{"Spacing"; 5};
	{"Header"; nil; "🎨 Free Spray"};
	{"NormalText"; nil; `On day {essentials.ColorText("2", Color3.fromRGB(142, 150, 255))} of the daily rewards, grab yourself {essentials.ColorText("Alice Thumbs Up", Color3.fromRGB(142, 150, 255))} spray!`};
	{"Spacing"; 5};
	{"Header"; nil; "🧾 Task Tracking"};
	{"NormalText"; nil; `If you complete a task for your {essentials.ColorText("active ticket", Color3.fromRGB(142, 150, 255))}, it will now mark it with a {essentials.ColorText("checkmark", Color3.fromRGB(142, 150, 255))}, no more guessing what's done!`};
	{"Spacing"; 5};
}

-- essentials.ColorText("8", Color3.fromRGB(255, 222, 102))

--[[
255, 222, 102 - yellow
175, 220, 255 - blue silver
162, 134, 255 - purple
255, 78, 78 - red
99, 255, 96 - green
102, 247, 255 - light blue
176, 176, 176 - grey

{"NormalText"; nil; ""};
]]

return info