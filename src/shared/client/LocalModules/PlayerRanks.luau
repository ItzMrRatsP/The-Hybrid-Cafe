local MSS = game:GetService("MarketplaceService")

local Info = {}
local groupId = 5353743

Info.Ranks = {
	[1] = {
		DisplayName = "Lead Developer";
		ChatTag = "Developer📜";
		TagColor = Color3.fromRGB(137, 98, 255);
		ChatColor = Color3.fromRGB(183, 169, 255);
		BubbleColor = Color3.fromRGB(30, 17, 50);
		Verification = function(plr)
			local rank = plr:GetRankInGroup(groupId)
			return rank == 255
		end;
	};
	[2] = {
		DisplayName = "Artist";
		ChatTag = "Artist🎨";
		TagColor = Color3.fromRGB(139, 166, 255);
		ChatColor = Color3.fromRGB(139, 166, 255);
		BubbleColor = Color3.fromRGB(50, 32, 40);
		Verification = function(plr)
			return plr.UserId == 104916767
		end;
	};
	[3] = {
		DisplayName = "Developer";
		ChatTag = "Developer🛠️";
		TagColor = Color3.fromRGB(182, 146, 255);
		ChatColor = Color3.fromRGB(218, 201, 255);
		BubbleColor = Color3.fromRGB(30, 17, 50);
		Verification = function(plr)
			local rank = plr:GetRankInGroup(groupId)
			return rank == 254 or rank == 253
		end;
	};
	[4] = {
		DisplayName = "Community";
		ChatTag = "Respected";
		TagColor = Color3.fromRGB(255, 112, 150);
		Verification = function(plr)
			local rank = plr:GetRankInGroup(groupId)
			return rank == 4 or rank == 2
		end;
	};
	[5] = {
		DisplayName = "Staff";
		ChatTag = "Staff";
		TagColor = Color3.fromRGB(255, 145, 82);
		Verification = function(plr)
			local rank = plr:GetRankInGroup(groupId)
			return rank == 3
		end;
	};
}

function Info.GetPlayerRank(plr)
	if plr:GetAttribute("PlayerRank") then
		return plr:GetAttribute("PlayerRank")
	end
	
	local highest
	for i = 1, #Info.Ranks do
		local ranking = Info.Ranks[i]
		local success, hasrank = pcall(function()
			return ranking.Verification(plr)
		end)
		
		if success and hasrank and (not highest or i < highest) then
			highest = i
			break
		end
	end
	
	plr:SetAttribute("PlayerRank", highest)
	return highest
end

return Info
