local info = {}

info.DisplayName = "Berry Cup"
info.Description = "Makes your drink twice as sweet."
info.Image = "rbxassetid://78851179408350"
info.Unlisted = false

info.CanPurchase = true

info.Price = 5000

info.Model = script:FindFirstChildWhichIsA("Model")

-- MetaData
info.DateCreated = os.time({
	year = 2025;
	month = 6;
	day = 30;
})
info.CreatorName = "real_haemster"

return info