local BadgeService = game:GetService("BadgeService")

local info = {
	[4488119458388820] = {
		DisplayName = "First Drink!";
		Description = "Serve your first order!";
		Category = "Milestones";
		TitleColor = Color3.fromRGB(197, 170, 255);
		
		Enabled = true;
		Order = 10;
	};
	[1687108421693483] = {
		DisplayName = "Day 5 Completed";
		Description = "Seized the day in a slippery environment.";
		Category = "Milestones";
		TitleColor = Color3.fromRGB(166, 197, 255);

		Enabled = true;
		Order = 20;
	};
	[3351529494851426] = {
		DisplayName = "Day 6 Completed";
		Description = "Completed a very, very messy day at the cafe.";
		Category = "Milestones";
		TitleColor = Color3.fromRGB(255, 139, 139);

		Enabled = true;
		Order = 30;
	};
	[3893949146190014] = {
		DisplayName = "Day 7 Completed";
		Description = "Successfully concluded the experiment. They liked our coffee.";
		Category = "Milestones";
		TitleColor = Color3.fromRGB(137, 116, 255);
		UnlockedSticker = "BronzeStar";

		Enabled = true;
		Order = 40;
	};
	
	[904571290106188] = {
		DisplayName = "A Little Spice";
		Description = "Win Story Mode on at least Iron Barista difficulty.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(203, 239, 255);
		UnlockedSticker = "SilverStar";

		Enabled = true;
		Order = 50;
	};
	[577917973826204] = {
		DisplayName = "Higher Tolerance";
		Description = "Win Story Mode on at least Gold Barista difficulty.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(255, 200, 33);
		UnlockedSticker = "GoldStar";

		Enabled = true;
		Order = 60;
	};
	[507708802155182] = {
		DisplayName = "Coffee Lieutenant";
		Description = "Win Story Mode on Diamond Barista difficulty.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(51, 255, 214);
		UnlockedSticker = "GalacticStar";

		Enabled = true;
		Order = 70;
	};
	[1219808603935961] = {
		DisplayName = "Coffee Domination";
		Description = "Win Story Mode on Master Barista difficulty.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(255, 149, 209);

		Enabled = true;
		Order = 71;
	};
	
	[1154200726149284] = {
		DisplayName = "Completed Hard Mode";
		Description = "Finished the week as an unlucky employee.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(255, 149, 149);
		--UnlockedSticker = "SilverStar";
		
		Enabled = false;
		Order = 50;
	};
	
	[4284986133221485] = {
		DisplayName = "Challenger";
		Description = "Complete a week with at least 1 challenge enabled.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(178, 140, 255);

		Enabled = false;
		Order = 60;
	};
	[542866333505647] = {
		DisplayName = "Absolute Insanity";
		Description = "Complete a week with atleast 6 challenges enabled!";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(168, 255, 87);
		--UnlockedSticker = "GoldStar";

		Enabled = false;
		Order = 70;
	};
	[2468144691064325] = {
		DisplayName = "On Another Level";
		Description = "Complete Hard Mode with all challenges enabled with 3 other players.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(255, 61, 61);
		--UnlockedSticker = "GalacticStar";

		Enabled = false;
		Order = 70;
	};
	[3145779983621040] = {
		DisplayName = "Perfect!";
		Description = "Achieve a perfect order.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(255, 210, 155);

		Enabled = true;
		Order = 80;
	};
	[2686654672522660] = {
		DisplayName = "Perfect Day!";
		Description = "Serve all perfect orders in a single day!";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(255, 178, 70);

		Enabled = true;
		Order = 90;
	};
	[90441015477309] = {
		DisplayName = "Obsessive and Compulsive";
		Description = "Win a run with only perfect orders.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(214, 255, 65);

		Enabled = true;
		Order = 90;
	};
	[1482434172431149] = {
		DisplayName = "First-Class Cafe";
		Description = "Max out all upgrades in the Shop during a run.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(175, 240, 255);

		Enabled = true;
		Order = 91;
	};
	[1760058275303929] = {
		DisplayName = "The Gang's All Here";
		Description = "Serve all of the Unique Customers!";
		Category = "Milestones";
		TitleColor = Color3.fromRGB(255, 144, 222);

		Enabled = true;
		Order = 100;
	};
	[2628694672167901] = {
		DisplayName = "The Celestial One";
		Description = "Roll a 1 in 1,000,000 on the RNGBoy";
		Category = "Special";
		TitleColor = Color3.fromRGB(205, 172, 255);

		Enabled = true;
		Order = 110;
	};
	[231587057160390] = {
		DisplayName = "A Special Guest";
		Description = "Make sure to take a picture with them!";
		Category = "Special";
		TitleColor = Color3.fromRGB(208, 126, 255);
		
		Enabled = true;
		Order = 111;
	};
	[799314909320759] = {
		DisplayName = "Swiftly Prepared";
		Description = "Serve a Unique Customer immediately after they enter the cafe!";
		Category = "Special";
		TitleColor = Color3.fromRGB(255, 117, 48);

		Enabled = true;
		Order = 110;
	};
	[2843097897619668] = {
		DisplayName = "Rest In Peace";
		Description = "Respect the dead.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(156, 255, 187);
		UnlockedCup = "SpiritedCup";

		Enabled = true;
		Order = 120;
	};
	[2023042789361667] = {
		DisplayName = "Our Little Secret";
		Description = "Serve an artificial Void Mocha.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(145, 108, 255);
		UnlockedCup = "InfectedCup";

		Enabled = true;
		Order = 120;
	};
	[271048406152908] = {
		DisplayName = "E.T Go Home";
		Description = "Help Xndra get to her home planet.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(119, 255, 135);
		UnlockedCup = "UFOCup";

		Enabled = true;
		Order = 120;
	};
	[1005151821529544] = {
		DisplayName = "Chronicles of King Egg";
		Description = "Bring King Egg back to its home.";
		Category = "Challenge";
		TitleColor = Color3.fromRGB(192, 250, 255);
		--UnlockedCup = "UFOCup";

		Enabled = true;
		Order = 120;
	};
	
	[906655745189981] = {
		DisplayName = "100 Served Drinks";
		Description = "Serve 100 drinks to customers.";
		Category = "Milestones";
		TitleColor = Color3.fromRGB(164, 203, 255);

		Enabled = true;
		Order = 130;
	};
	[4236111412843415] = {
		DisplayName = "1000 Served Drinks!";
		Description = "Serve 1000 drinks to customers.";
		Category = "Milestones";
		TitleColor = Color3.fromRGB(108, 155, 255);

		Enabled = true;
		Order = 140;
	};
	[1141003412621922] = {
		DisplayName = "5000 Served Drinks!!";
		Description = "Serve 5000 drinks to customers!";
		Category = "Milestones";
		TitleColor = Color3.fromRGB(58, 78, 255);

		Enabled = true;
		Order = 150;
	};

	[1172801891497363] = {
		DisplayName = "Meet the Developers!";
		Description = "Be in the same server as Bili_Billie or real_haemster.";
		Category = "Special";
		TitleColor = Color3.fromRGB(177, 108, 255);
		UnlockedSticker = "MetDevelopers";

		Enabled = true;
		Order = 9990;
	};
}

for id, thing in pairs(info) do
	pcall(function()
		local badgeinfo = BadgeService:GetBadgeInfoAsync(id)
		info[id].DisplayName = info[id].DisplayName or badgeinfo.Name
		info[id].Description = info[id].Description or badgeinfo.Description
		info[id].Icon = info[id].Icon or ("rbxassetid://"..badgeinfo.IconImageId)
		
		local enab = info[id].Enabled
		if enab == nil then
			enab = badgeinfo.IsEnabled
		end
		info[id].Enabled = enab
	end)
end

return info
