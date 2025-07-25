local ChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lmodules = ReplicatedStorage.LocalModules

local p_ranks = require(lmodules.PlayerRanks)

ChatService.OnIncomingMessage = function(message: TextChatMessage)
	local properties = Instance.new("TextChatMessageProperties")

	if message.TextSource then
		local plr = Players:GetPlayerByUserId(message.TextSource.UserId)
		local rank = plr:GetAttribute("PlayerRank")
		if rank then
			local info = p_ranks.Ranks[rank]
			local tagcolor = info.TagColor or Color3.fromRGB(255,255,255)
			local texcolor = info.ChatColor or Color3.fromRGB(255,255,255)
			
			properties.PrefixText = string.format("<font color='#%s'>[%s]</font> ", tagcolor:ToHex(), info.ChatTag) .. message.PrefixText
			if texcolor ~= Color3.fromRGB(255,255,255) then
				properties.Text = string.format("<font color='#%s'>%s</font> ", texcolor:ToHex(), message.Text)
			end
		end
	end

	return properties
end

ChatService.OnBubbleAdded = function(message: TextChatMessage, adornee: Instance)
	-- Check if the chat message has a TextSource (sender) associated with it
	
	print(message, adornee)
	
	if message.TextSource then
		-- Create a new BubbleChatMessageProperties instance to customize the chat bubble
		local bubbleProperties = Instance.new("BubbleChatMessageProperties")

		-- Get the user who sent the chat message based on their UserId
		local plr = Players:GetPlayerByUserId(message.TextSource.UserId)
		local rank = plr:GetAttribute("PlayerRank")
		
		if rank then
			local info = p_ranks.Ranks[rank]
			
			bubbleProperties.TextColor3 = info.BubbleTextColor or bubbleProperties.TextColor3
			bubbleProperties.BackgroundColor3 = info.BubbleColor or bubbleProperties.BackgroundColor3
			bubbleProperties.FontFace = info.Font or bubbleProperties.FontFace
		end
		return bubbleProperties
	end
	
	return nil
end