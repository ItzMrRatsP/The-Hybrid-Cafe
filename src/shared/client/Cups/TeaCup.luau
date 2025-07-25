local info = {}

info.DisplayName = "Tea Cup"
info.Description = "Wait, that's illegal."
info.Image = "rbxassetid://123449018129048"
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