local info = {}

info.DisplayName = "Gem Chalice"
info.Description = "Royalty only."
info.Image = "rbxassetid://124342159002749"
info.Unlisted = false
info.CanPurchase = true

info.Price = nil

info.Premium = true
info.PremiumTitle = "Limited Time!"
info.ProductID = 2686838142
info.PurchaseDeadline = 1737208800 -- In os.time() format

info.Model = script:FindFirstChildWhichIsA("Model")

-- MetaData
info.DateCreated = os.time({
	year = 2025;
	month = 1;
	day = 3;
})
info.CreatorName = "real_haemster"

return info