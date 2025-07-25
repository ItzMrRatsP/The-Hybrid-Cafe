local info = {}

info.DisplayName = "Squared Cup"
info.Description = "A bit awkward to sip..."
info.Image = "rbxassetid://118265632988162"
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