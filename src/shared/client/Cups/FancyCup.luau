local info = {}

info.DisplayName = "Fancy Cup"
info.Description = "Charged 10x more than normal."
info.Image = "rbxassetid://111948675878188"
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