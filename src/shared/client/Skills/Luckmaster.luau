local skill = {
	DisplayName = "Luckmaster";
	Image = "rbxassetid://128072646777253";
	
	Description = {
		-- Example
		{"- Receive a Lucky Block every end of shift"; nil; Color3.fromRGB(255, 217, 120)};
		{"- Better luck with Lucky Blocks and RNGBoy"; nil; Color3.fromRGB(255, 217, 120)};
		{"- Always get an Epic decoration in the shop"; nil; Color3.fromRGB(255, 217, 120)};
		{"- Better chance of rarer Unique Customers visiting"; nil; Color3.fromRGB(255, 217, 120)};
	};
	
	-- sale info
	OnSale = true;
	Price = nil;
	
	PremiumProduct = 3300070896; -- ID of product to purchase if premium skill
	GiftProduct = 3313898137;
	-- this should automatically be unlisted if OnSale is false
	-- also overrides Price property
	
	DateCreated = {2025; 6; 1}; -- Y/M/D
}



return skill