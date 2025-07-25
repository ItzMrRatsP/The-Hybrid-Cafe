local skill = {
	DisplayName = "Investor";
	Image = "rbxassetid://90715858332070";
	
	Description = {
		-- Example
		{"- Cash is either increased or decreased by a percentage every day"; nil; nil; 2};
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