local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	Title = "Mini Content Update!";
	DateCreated = {2025; 2; 1}; -- Y/M/D
	Color = Color3.fromRGB(54, 190, 104);
	ImageBanner = "rbxassetid://74193345579071";
	Active = false;
}

info.Content = {
	{"Image"; 0.5; 16/9; "rbxassetid://74193345579071"};
	{"Header"; nil; "Summary:"};
	{"NormalText"; nil; "- 💸 New Shop Items!"};
	{"NormalText"; nil; "- 👽 New Quest Badge!"};
	{"NormalText"; nil; "- 📷 Camera QoL features!"};
	{"NormalText"; nil; "- 🔧 Adjustments, fixes, and more!"};
	{"Spacing"; 5;};
	{"NormalText"; nil; "Hellooooo internet! We got a small content update for this week! Let's get right into it!"};
	{"Spacing"; 5;};
	{"NormalText"; nil; "One of the most notable addtions are the new "..essentials.ColorText("decorations", Color3.fromRGB(162, 134, 255)).."! A fan, UFO, camera, and a mosquito bat! Is this even a cafe anymore?"};
	{"Image"; 1; 1747/730; "rbxassetid://119474194300461"};
	{"Spacing"; 20;};
	{"NormalText"; nil; "After doing some testing, it seems like the fan is able to blow away objects! I wonder how it'd work if you attach it to something? Cameras can also flash your teammates, the UFO can fly, and the mosquito bat can be used as a weapon! Stuns enemies every time!"};
	{"Spacing"; 5;};
	{"NormalText"; nil; "Speaking of UFOs, there's a new "..essentials.ColorText("quest badge", Color3.fromRGB(255, 222, 102)).." available! "..essentials.ColorText("Xndra the Alien", Color3.fromRGB(106, 255, 161)).." needs your help to get to her home planet! Maybe it's something to do with the new UFO decoration? I'm just kidding! I already know the steps, but I won't tell you! It's more fun to figure it out yourself! I will tell you this... "..essentials.ColorText("A good fuel source for a ship requires a lot of heat!", Color3.fromRGB(255, 78, 78))};
	{"Spacing"; 5;};
	{"NormalText"; nil; "Anyway! Other than those, there's a bunch of quality of life features, such as camera bobbing, and players having animations for holding objects! On top of that, we have some balance changes. Respawn time has been reduced by half! That and some needed bug fixes."};
	{"Spacing"; 5;};
	{"NormalText"; nil; "That's all for this update! Like I said, it's a small one for this week! Maybe something huge will happen next week? Anyway, see you next update! Signing out!"};
	{"Spacing"; 20;};
}

--[[
255, 222, 102 - yellow
175, 220, 255 - blue silver
162, 134, 255 - purple
255, 78, 78 - red
99, 255, 96 - green
102, 247, 255 - light blue
176, 176, 176 - grey
106, 255, 161 - alien green

{"NormalText"; nil; ""};
]]

return info