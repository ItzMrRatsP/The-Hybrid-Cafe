local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	Title = "Ghost and Ranks Update!";
	DateCreated = {2025; 1; 25}; -- Y/M/D
	Color = Color3.fromRGB(78, 22, 221);
	ImageBanner = "rbxassetid://89689269403003";
	Active = false;
}

info.Content = {
	{"Image"; 0.3; 1/1; "rbxassetid://89689269403003"};
	{"Header"; nil; "Summary:"};
	{"NormalText"; nil; "- 👻 New Main Events!"};
	{"NormalText"; nil; "- 🛡️ Hard Mode and Challenges Revamped"};
	{"NormalText"; nil; "- 🥳 Extras Menu"};
	{"NormalText"; nil; "- 🎨 Stickers converted to Sprays"};
	{"NormalText"; nil; "- ☕ New Cups"};
	{"NormalText"; nil; "- 💸 New Decorations"};
	{"NormalText"; nil; "- 📜 New Badges"};
	{"NormalText"; nil; "- 🔧 Adjustments, fixes, and more!"};
	{"Spacing"; 5;};
	{"NormalText"; nil; "Hellooooo internet! Today we've just received a brand new update for The Hybrid Cafe! There's a TON to cover, so let's get right into it!"};
	{"Spacing"; 5;};
	{"NormalText"; nil; "The first thing you may notice is that a brand new difficulty scale has been introduced to Story Mode! There's over "..essentials.ColorText("8", Color3.fromRGB(255, 222, 102)).." different difficulties now! But how do they work? ¯\(°_o)/¯"};
	{"Spacing"; 5;};
	{"NormalText"; nil; "After "..essentials.ColorText("Trainee Barista", Color3.fromRGB(175, 220, 255))..", each difficulty adds a modifier that makes the run slightly harder. Accumulate these modifiers, and you get quite the challenge! Additionally, completing these difficulties now gives you an instant burst of "..essentials.ColorText("Cred!", Color3.fromRGB(102, 247, 255))};
	{"Spacing"; 5;};
	{"NormalText"; nil; essentials.ColorText("The Eye", Color3.fromRGB(162, 134, 255)).." is an entity that lives in the Cafe walls. When the lights flicker, "..essentials.ColorText("make sure not to move!", Color3.fromRGB(255, 222, 102)).." It will kill any barista that moves."};
	{"Image"; 1; 1920/756; "rbxassetid://88410380979772"};
	{"Spacing"; 20;};
	{"NormalText"; nil; "Sometimes, you'll also get a visit from "..essentials.ColorText("the Ghost", Color3.fromRGB(162, 134, 255)).."! They can go through walls, and are absolutely invincible! Your best course of action is just avoid them until they go away. Good thing you baristas have a sixth sense to detect their direction!"};
	{"Image"; 1; 1171/482; "rbxassetid://115973163988599"};
	{"Spacing"; 20;};
	{"NormalText"; nil; "Very scary! Oh well, not like the customers care! If you're just tired of all the chaos, don't worry! After beating the "..essentials.ColorText("Iron Barista", Color3.fromRGB(175, 220, 255)).." difficulty, you'll have access to the new "..essentials.ColorText("Extras", Color3.fromRGB(255, 222, 102)).." menu! These are just fun modifiers that you can enable in your runs. Don't want those pesky enemies? Peaceful Mode is there! "..essentials.ColorText("Although, enabling these modifiers will prevent you from earning any Cred or unlocking any badges.", Color3.fromRGB(175,175,175)) };
	{"Spacing"; 5;};
	{"NormalText"; nil; "Another new feature in this update is "..essentials.ColorText("Sprays", Color3.fromRGB(162, 134, 255)).."! Your earned Stickers can now be used to be sprayed onto "..essentials.ColorText("most surfaces", Color3.fromRGB(255, 222, 102)).." in the Cafe! Just open up the Spray Wheel just like how you do with any emote wheel and select the spray you equipped! These look much more pretty on the walls instead of your machines."};
	{"Image"; 1; 1589/601; "rbxassetid://131385095877008"};
	{"Spacing"; 20;};
	{"NormalText"; nil; "And that's all the new features! We also have new Cups in the Shop, including the LOOOOONG LOOOOOOOONG cup, and some new decorations in the game shop!"};
	{"Image"; 1; 1004/467; "rbxassetid://132200298435145"};
	{"Spacing"; 5;};
	{"Image"; 1; 14/7; "rbxassetid://120614024617719"};
	{"Spacing"; 20;};
	{"NormalText"; nil; "There's also some adjustments, and fixes. Most of them are fine, but they FINALLY fixed the bug where customers would just fall down when getting out of their chairs... I swear that was so annoying!"};
	{"Spacing"; 5;};
	{"NormalText"; nil; "Anyway! That's all for this update! That's quite the content! Now, I'll have to call my friends to get through the new Story Mode difficulties! See you next update! Signing out!"};
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