local info = {}

info.DisplayName = "Drip Cup"
info.Description = "Drippy!"
info.Image = "rbxassetid://129213381800939"
info.Unlisted = false
info.CanPurchase = true

info.Price = nil

info.Premium = true
info.PremiumTitle = "No spillage... Just drip."
info.ProductID = 3306486975
info.PurchaseDeadline = 1752588000 -- In os.time() format

info.Model = script:FindFirstChildWhichIsA("Model")

-- MetaData
info.DateCreated = os.time({
	year = 2025;
	month = 6;
	day = 13;
})
info.CreatorName = "real_haemster"

return info