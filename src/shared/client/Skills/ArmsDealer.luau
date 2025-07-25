local skill = {
	DisplayName = "Arms Dealer";
	Image = "rbxassetid://110270507468816";
	
	Description = {
		-- Example
		{"- Free revolver on the first day";};
		{"- Firearms are 35% cheaper in the shop";};
		{"- Deal 30% less damage";};
	};
	
	-- sale info
	OnSale = true;
	Price = 5000;
	
	PremiumProduct = nil; -- ID of product to purchase if premium skill
	-- this should automatically be unlisted if OnSale is false
	-- also overrides Price property
	
	DateCreated = {2025; 6; 1}; -- Y/M/D
}



return skill