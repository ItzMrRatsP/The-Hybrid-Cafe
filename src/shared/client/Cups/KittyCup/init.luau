local info = {}

info.DisplayName = "Kitty Cup"
info.Description = "Meow meow meow."
info.Image = "rbxassetid://95005397645436"
info.Unlisted = false

info.CanPurchase = true

info.Price = 5000

info.Model = script:FindFirstChildWhichIsA("Model")

-- MetaData
info.DateCreated = os.time({
	year = 2025;
	month = 1;
	day = 3;
})
info.CreatorName = "real_haemster"

return info