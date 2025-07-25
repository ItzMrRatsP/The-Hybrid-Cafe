local info = {}

info.DisplayName = "Eggshell Cup"
info.Description = "Served the Easter Rabbit!"
info.Image = "rbxassetid://119921741525618"
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
	month = 6;
	day = 30;
})
info.CreatorName = "real_haemster"

return info