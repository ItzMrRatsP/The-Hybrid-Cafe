local skill = {
	DisplayName = "Chef";
	Image = "rbxassetid://72718149530306";
	
	Description = {
		-- Example
		{"- Increased passive healing";};
		{"- Receive a free Hamburger every end of shift";};
	};
	
	-- sale info
	OnSale = true;
	Price = 1000;
	
	PremiumProduct = nil; -- ID of product to purchase if premium skill
	-- this should automatically be unlisted if OnSale is false
	-- also overrides Price property
	
	DateCreated = {2025; 6; 1}; -- Y/M/D
}



return skill