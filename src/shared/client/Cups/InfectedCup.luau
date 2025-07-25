local info = {}

info.DisplayName = "Infected Cup"
info.Description = "Infected, but not contagious!"
info.Image = "rbxassetid://77490664594451"
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