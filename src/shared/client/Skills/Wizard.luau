local skill = {
	DisplayName = "Wizard";
	Image = "rbxassetid://121198544674652";
	
	Description = {
		-- Example
		{"- Walk faster at +2 Walkspeed"; nil; Color3.fromRGB(210, 171, 255)};
		{"- Coffee can be Golden or Rainbow when created, giving extra cash"; nil; Color3.fromRGB(210, 171, 255); 2};
		{"- HP reduced by 25"; nil; Color3.fromRGB(210, 171, 255)};
	};
	
	-- sale info
	OnSale = true;
	Price = nil;
	
	PremiumProduct = 3306486826; -- ID of product to purchase if premium skill
	GiftProduct = 3313897854;
	-- this should automatically be unlisted if OnSale is false
	-- also overrides Price property
	
	DateCreated = {2025; 6; 1}; -- Y/M/D
}



return skill