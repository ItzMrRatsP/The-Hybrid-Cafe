local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules
local essentials = require(lmodules.EssentialFunctions)

local info = {
	Title = "Revamped Upgrades!";
	DateCreated = {2025; 2; 22}; -- Y/M/D
	Color = Color3.fromRGB(168, 78, 78);
	ImageBanner = "rbxassetid://122196117377176";
	Active = false;
}

info.Content = {
	{"Image"; 0.3; 1; "rbxassetid://122196117377176"};
	{"Header"; nil; "Summary:"};
	{"NormalText"; nil; "- ⬆️ Revamped Upgrades"};
	{"NormalText"; nil; "- ☕ New Cups"};
	{"NormalText"; nil; "- 💎 Me! (New Unique Customer)"};
	{"NormalText"; nil; "- 🔫 Water Gun Item"};
	{"NormalText"; nil; "- ❓ New Badges"};
	{"NormalText"; nil; "- 🔧 Adjustments, Fixes, and more!"};
	{"Spacing"; 5;};

	{"NormalText"; nil; "Hellooooo internet! After 2 weeks, we have a content update for the Hybrid Cafe! I'm personally excited for this one, so let's get right into it!"};
	{"Spacing"; 5;};

	{"NormalText"; nil; "First thing to look at is the "..essentials.ColorText("revamped Upgrades", Color3.fromRGB(255, 222, 102)).." in the game shop! Instead of individual upgrades, you can now level up your cafe machines! This includes all the existing upgrades, and "..essentials.ColorText("introduces new ones!", Color3.fromRGB(255, 222, 102))};
	{"Spacing"; 5;};

	{"NormalText"; nil; "There's even a "..essentials.ColorText("Bonus Oven", Color3.fromRGB(162, 134, 255)).." upgrade that gives money whenever you create a perfect snack!"};
	{"Image"; 1; 2200/1028; "rbxassetid://75834113373610"};
	{"Spacing"; 20;};
	
	{"NormalText"; nil; "Next up, a new utility item has been introduced in the shop! The "..essentials.ColorText("Water Gun", Color3.fromRGB(255, 222, 102)).." does everything a Water Spray does, but better! Tired of that cat thief! Don't just spray her away, snipe her!"};
	{"Image"; 1; 1557/549; "rbxassetid://123463223200120"};
	{"Spacing"; 20;};

	{"NormalText"; nil; "You may have also noticed a new Unique Customer... "..essentials.ColorText("It's me", Color3.fromRGB(255, 185, 248)).."! This feels so weird typing about myself! Anyway... "..essentials.ColorText("Kiki", Color3.fromRGB(255, 222, 102))..", is a new Unique Customer that will visit at the end of the day. Upon serving her, you'll get an exclusive Spray just like all the other Unique Customers!"};
	{"Image"; 1; 1758/822; "rbxassetid://86741486859233"};
	{"Spacing"; 20;};

	{"NormalText"; nil; "Well enough about me! I heard that the ArenaDev group reached "..essentials.ColorText("100,000 members", Color3.fromRGB(162, 134, 255)).."! That's more than... 50! I'm sure the engineers have something cooking to celebrate it. For now, they added "..essentials.ColorText("rewards for being a Group member", Color3.fromRGB(255, 222, 102)).."! Just hop in the Group Rewards and you can earn a free Classic Coffee Cup, just like that!"};
	{"Image"; 1; 2071/758; "rbxassetid://77848218352349"};
	{"Spacing"; 20;};

	{"NormalText"; nil; "Oh! Speaking of cups, there's 2 new cups that can be purchased in the Shop!"};
	{"Image"; 1; 2071/758; "rbxassetid://115730954846208"};
	{"NormalText"; 15; "(I wouldn't drink from the Toilet Cup if I were you)"};
	{"Spacing"; 20;};
	
	{"NormalText"; nil; "That's all for content! Some of the notable adjustments are the Extras Menu being unlocked after completing Trainee Barista, instead of Iron. So that's great!"};
	{"Spacing"; 5;};

	{"NormalText"; nil; essentials.ColorText("Valentines season", Color3.fromRGB(255, 185, 248)).." is also over, so great job if you were able to get a visit from Cupid! If not, there's always next year! ❤️"};
	{"Spacing"; 5;};

	{"NormalText"; nil; "And that will be all for this week! Be sure to stay tuned for more updates! Signing out!"};
	{"Spacing"; 5;};
	
	{"Image"; 0.175; 45/40; "rbxassetid://80996085126719"};
	{"Spacing"; 20;};
}

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