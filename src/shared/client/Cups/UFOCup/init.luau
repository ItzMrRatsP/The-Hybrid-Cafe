local info = {}

info.DisplayName = "UFO Cup"
info.Description = "A special gift from Xndra!"
info.Image = "rbxassetid://75354337788812"
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
	day = 31;
})
info.CreatorName = "real_haemster"

return info