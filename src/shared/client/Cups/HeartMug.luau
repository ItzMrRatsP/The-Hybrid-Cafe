local info = {}

info.DisplayName = "Heart Mug"
info.Description = "Love ya!"
info.Image = "rbxassetid://94185970983109"
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
	month = 2;
	day = 8;
})
info.CreatorName = "real_haemster"

return info