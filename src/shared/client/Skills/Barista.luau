local skill = {
	DisplayName = "Barista";
	Image = "rbxassetid://140211036360959";
	
	Description = {
		-- Example, Arguments 2 and 3 can be nil
		-- (text, alignment, color, scale)
		{"- Default class."; Enum.TextXAlignment.Left; Color3.fromRGB(255,255,255); 1};
	};
	
	-- sale info
	OnSale = false;
	Price = nil;
	
	PremiumProduct = nil; -- ID of product to purchase if premium skill
	-- this should automatically be unlisted if OnSale is false
	-- also overrides Price property
	
	IsDefault = true; -- specifically used to put it at the top of the list
	DateCreated = {2025; 6; 1}; -- Y/M/D
}



return skill