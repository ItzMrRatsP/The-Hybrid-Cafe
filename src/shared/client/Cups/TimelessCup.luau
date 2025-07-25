local info = {}

info.DisplayName = "Timeless Cup"
info.Description = "Shouldn't it be time-ful?"
info.Image = "rbxassetid://95450996761826"
info.Unlisted = false
info.CanPurchase = false

info.Price = nil

info.Premium = false
info.PremiumTitle = "Loooooong Cup!"
info.ProductID = nil
info.PurchaseDeadline = nil -- In os.time() format

info.Model = script:FindFirstChildWhichIsA("Model")

-- MetaData
info.DateCreated = os.time({
	year = 2025;
	month = 1;
	day = 8;
})
info.CreatorName = "real_haemster"

return info