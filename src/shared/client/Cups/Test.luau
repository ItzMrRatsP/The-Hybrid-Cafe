local info = {}

info.DisplayName = "Test"
info.Description = "test"
info.Image = "rbxassetid://95791367519103"
info.Unlisted = true

info.Model = script:FindFirstChildWhichIsA("Model")

-- MetaData
info.DateCreated = os.time({
	year = 2025;
	month = 1;
	day = 3;
})
info.CreatorName = "real_haemster"

return info