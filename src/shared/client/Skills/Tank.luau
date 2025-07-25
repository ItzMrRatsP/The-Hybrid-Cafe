local skill = {
	DisplayName = "Tank";
	Image = "rbxassetid://118110526063226";
	
	Description = {
		-- Example
		{"- Extra 100 HP";};
		{"- Deal 25% more damage to enemies";};
		{"- Move slower at -2 Walkspeed";};
	};
	
	-- sale info
	OnSale = true;
	Price = 2500;
	
	PremiumProduct = nil; -- ID of product to purchase if premium skill
	-- this should automatically be unlisted if OnSale is false
	-- also overrides Price property
	
	DateCreated = {2025; 6; 1}; -- Y/M/D
}



return skill