local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	Title = "Valentines and Railguns!";
	DateCreated = {2025; 2; 8}; -- Y/M/D
	Color = Color3.fromRGB(255, 143, 192);
	ImageBanner = "rbxassetid://89786056193116";
	Active = false;
}

info.Content = {
	{"Image"; 0.3; 1; "rbxassetid://89786056193116"};
	{"Header"; nil; "Summary:"};
	{"NormalText"; nil; "- ❤️ Valentines Day Mini-Event"};
	{"NormalText"; nil; "- 🍫 Valentines Ingredient Set"};
	{"NormalText"; nil; "- ⚡ Railgun Weapon"};
	{"NormalText"; nil; "- ⚙️ Options Menu"};
	{"NormalText"; nil; "- 💎 Exclusive Menu"};
	{"NormalText"; nil; "- 🔧 Adjustments, Fixes, and more!"};
	{"Spacing"; 5;};
	
	{"NormalText"; nil; "Hellooooo internet! This week, we have a sweet update to cover, so BUCKLE UP!"};
	{"Spacing"; 5;};
	
	{"NormalText"; nil; "First up we have a new seasonal event for "..essentials.ColorText("Valentines Day!", Color3.fromRGB(255, 185, 248)).." Just like New Years, you're given a fresh set of ingredients for the Valentines season! Hope you got something special for your loved ones!"};
	{"Image"; 1; 1451/689; "rbxassetid://90111256640165"};
	{"Spacing"; 20;};
	
	{"NormalText"; nil; "On top of new ingredients, a "..essentials.ColorText("special customer", Color3.fromRGB(255, 222, 102)).." is visiting the cafe! "..essentials.ColorText("The Cupid", Color3.fromRGB(255, 185, 248)).." is an Event Customer, and will only visit during the Valentines period! Once the season ends, she won't visit the cafe! Serve her to "..essentials.ColorText("earn a limited-time Spray and Cup!", Color3.fromRGB(255, 222, 102)).." Make sure not to miss her!"};
	{"Image"; 1; 1920/877; "rbxassetid://133382953601769"}; -- isdone
	{"Image"; 1; 2200/1080; "rbxassetid://90275601108201"};
	{"Spacing"; 20;};
	
	{"NormalText"; nil; "With the addition of such a special customer, you're gonna need some EXTRA firepower to protect her... "..essentials.ColorText("The Railgun", Color3.fromRGB(102, 247, 255)).." is a new Exclusive weapon that deals "..essentials.ColorText("great explosive damage", Color3.fromRGB(255, 78, 78)).." to anything it touches! Perfect for dealing with massive groups, and blasting away objects to annoy your fellow baristas!"};
	{"Image"; 1; 1631/808; "rbxassetid://138264015982201"};
	{"Spacing"; 20;};
	
	{"NormalText"; nil; "This update also feature a new "..essentials.ColorText("Options", Color3.fromRGB(162, 134, 255)).." menu! This menu is accessible in both the lobby and game! Adjust the music and camera effects to your liking in the Settings menu. On top of that, there is also a "..essentials.ColorText("Stats", Color3.fromRGB(162, 134, 255)).." menu that shows all your statistics from all your runs!"};
	{"Spacing"; 5;};
	
	{"NormalText"; nil; "Take a look at this engineers stats! That's a LOT of playtesting! (￣y▽￣)╭"};
	{"Image"; 1; 1612/615; "rbxassetid://120942223532257"};
	{"Spacing"; 20;};
	
	{"NormalText"; nil; "Coming back to Exclusive weapons, the Minigun is currently "..essentials.ColorText("ON SALE!", Color3.fromRGB(99, 255, 96)).." You can get the new Minigun at literally HALF THE PRICE! DANG! Exclusive weapons have also been adjusted so they can stack with multiple players! Imagine a whole team of baristas with a minigun..."};
	{"Image"; 1; 1468/655; "rbxassetid://92487962312033"};
	{"Spacing"; 20;};
	
	{"NormalText"; nil; "Well then! That's most of the content for this update! Some of the difficulties for Story Mode have also been balanced and adjusted! How fun!"};
	{"Spacing"; 5;};
	
	{"NormalText"; nil; "That's all for this week! "..essentials.ColorText("Let your affection be known from your loved ones this Valentines season!", Color3.fromRGB(255, 185, 248)).." I will see you next update. Signing out!"};
	
	{"Spacing"; 5;};
	{"Image"; 0.175; 45/40; "rbxassetid://80996085126719"};
	{"NormalText"; 10; "Yup! That's me!"};
	
	{"Spacing"; 20;};
}

--Color3.fromRGB(255, 255, 255)
--[[
rbxassetid://80996085126719
255, 222, 102 - yellow
175, 220, 255 - blue silver
162, 134, 255 - purple
255, 78, 78 - red
99, 255, 96 - green
102, 247, 255 - light blue
176, 176, 176 - grey
106, 255, 161 - alien green
255, 185, 248 - pastel pink
255, 203, 211 - very light red

{"NormalText"; nil; ""};
]]

return info