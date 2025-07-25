local info = {}

info.DisplayName = "Stacked Cups"
info.Description = "Glued together"
info.Image = "rbxassetid://81426358355909"
info.Unlisted = false
info.CanPurchase = false

info.Price = nil

info.Premium = true
info.PremiumTitle = "Limited Time!"
info.ProductID = 2836843598
info.PurchaseDeadline = 1740232800 -- In os.time() format

info.Model = script:FindFirstChildWhichIsA("Model")

-- MetaData
info.DateCreated = os.time({
	year = 2025;
	month = 2;
	day = 6;
})
info.CreatorName = "real_haemster"

return info