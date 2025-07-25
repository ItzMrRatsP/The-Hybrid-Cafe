local info = {}

info.DisplayName = "Spirited Cup"
info.Description = "The Cup laughs."
info.Image = "rbxassetid://115398321833547"
info.Unlisted = false
info.CanPurchase = false

info.Price = nil

info.Premium = false
info.ProductID = nil
info.PurchaseDeadline = nil -- In os.time() format

info.Model = script:FindFirstChildWhichIsA("Model")

-- MetaData
info.DateCreated = os.time({
	year = 2025;
	month = 1;
	day = 7;
})
info.CreatorName = "real_haemster"

return info