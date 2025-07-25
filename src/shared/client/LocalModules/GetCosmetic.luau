local ReplicatedStorage = game:GetService("ReplicatedStorage")

local stickers = ReplicatedStorage.Stickers

return function(class, name)
	-- Will be useful for expanded flairs like emotes
	
	return stickers:FindFirstChild(name)
end