local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local function yellow(text)
	return essentials.ColorText(text, Color3.fromRGB(255, 222, 102))
end
local function red(text)
	return essentials.ColorText(text, Color3.fromRGB(255, 78, 78))
end
local function purple(text)
	return essentials.ColorText(text, Color3.fromRGB(162, 134, 255))
end

local info = {
	Title = "Classes and more! Content Update";
	DateCreated = {2025; 6; 27}; -- Y/M/D
	Color = Color3.fromRGB(255, 138, 159);
	ImageBanner = "rbxassetid://74656933366060";
	Active = false;
}

info.Content = {
	{"Image"; 0.3; 1/1; "rbxassetid://95268195507281"};
	{"Header"; nil; "Summary:"};
	{"NormalText"; nil; "- ⚔️ Classes! Equip perks for yourself!"};
	{"NormalText"; nil; "- 🍭 Toddlers in the cafe!"};
	{"NormalText"; nil; "- 🛡️ New Difficulty"};
	{"NormalText"; nil; "- 🐈‍⬛ New Unique Customers"};
	{"NormalText"; nil; "- 💸 New Shop Items"};
	{"NormalText"; nil; "- 🔧 Adjustments, fixes, and more!"};
	{"Spacing"; 5;};
	
	{"NormalText"; nil; "Hellooooo internet! It's been a hot minute since the last update! I even took up gardening while waiting! I wonder if I can still write update blogs... Well, let's see what this new update offers!"};
	{"Spacing"; 5;};
	
	{"NormalText"; nil; yellow("Classes").." have arrived! These are perks that can be equipped to run your cafe better! Whether it's defense, offense, or "..purple("rainbow-mutated").." coffee, each class gives a set of strengths and weaknesses!"};
	{"Image"; 1; 1980/990; "rbxassetid://74656933366060"};
	{"Spacing"; 20;};
	
	{"NormalText"; nil; "These classes can be bought from "..yellow("Ambers").." skill shop! With some resources from ArenaTech, she's able to build technology for Cafe management! How convenient!"};
	{"Image"; 1; 1479/997; "rbxassetid://112355412945650"};
	{"NormalText"; 15; "*She'll come by for a cup of coffee, too!*"};
	{"Spacing"; 20;};
	
	{"NormalText"; nil; "Just be extra cautious when making that coffee! "..red("Toddlers").." have been walking in the cafe causing chaos for the Baristas! "..red("They just go up to you and... throw stuff.").." Sometimes I wonder... How are they fitting an entire anvil in their pockets?"};
	{"Image"; 1; 1178/518; "rbxassetid://95590403740124"};
	{"Spacing"; 20;};
	
	{"NormalText"; nil; "Well I'm sure you can deal with them! Besides that, "..purple("Nekoro").." is coming to visit the Cafe! With a brand new outfit (and a pair of legs to walk) she'll come visit for a cup of coffee!"};
	{"Image"; 1; 1920/909; "rbxassetid://110296637690461"};
	{"Spacing"; 20;};
	
	{"NormalText"; nil; "Also, try out the new shop items! With new traps for the enemies, decorations, and a... Well, I don't know what a "..purple('"Gubby"').." is but I'm sure they're a fun addition to the cafe!"};
	{"Image"; 1; 1908/1123; "rbxassetid://76007955204830"};
	{"Spacing"; 20;};
	
	{"NormalText"; nil; "And that's it! Try out all the new features with the new difficulty, "..essentials.ColorText("Master Barista", Color3.fromRGB(255, 167, 201)).."! This one will be very difficult! Good luck!"};
	{"Spacing"; 5;};
	{"NormalText"; nil; "Signing out!"};
	{"Spacing"; 5;};

	{"Image"; 0.175; 45/40; "rbxassetid://80996085126719"};
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

{"NormalText"; nil; ""};
]]

return info