local skill = {
	DisplayName = "Void";
	Image = "rbxassetid://100335952669654";
	
	Description = {
		-- Example
		{"- Moves faster during the disasters"; nil; Color3.fromRGB(245, 108, 255)};
		{"- Takes less damage during disasters"; nil; Color3.fromRGB(245, 108, 255); 2};
		-- rest of the stuff
	};
	
	-- sale info
	OnSale = false;
	Price = nil;
	
	PremiumProduct = 1336938053; -- ID of product to purchase if premium skill
	GiftProduct = 3343201259;
	
	-- this should automatically be unlisted if OnSale is false
	-- also overrides Price property
	
	DateCreated = {2025; 7; 21}; -- Y/M/D
}



return skill