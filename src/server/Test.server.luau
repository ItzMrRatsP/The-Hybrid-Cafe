local insert = game:GetService("InsertService")

local new = insert:LoadAsset(125886373)
for _,v in pairs(new:GetChildren()) do
	v.Parent = workspace
end

local stickers = game.ReplicatedStorage.Stickers
for _,s in pairs(stickers:GetChildren()) do
	if s:IsA("StringValue") then
		local desc1, desc2 = s:GetAttribute("Description"), s:GetAttribute("LockedDescription")
		desc1 = string.gsub(desc1, "sticker", "spray")
		desc2 = string.gsub(desc2, "sticker", "spray")
		
		s:SetAttribute("Description", desc1)
		s:SetAttribute("LockedDescription", desc2)
	end
end

print(game:GetService("MarketplaceService"):GetProductInfo(1056292728, Enum.InfoType.GamePass).IconImageAssetId)

local RNG = Random.new()
local score = 0
while true do
	local increase = RNG:NextInteger(1, 2000) > 1
	
	if not increase then
		break
	else
		score += 1
		if score % 5000 == 0 then
			task.wait()
		end
	end
end
print(score)

local TeleportService = game:GetService("TeleportService")
local telegroup = game:GetService("Players"):GetPlayers()

local id = 100519426937560
local code = TeleportService:ReserveServer(id)

TeleportService:TeleportToPrivateServer(id, code, telegroup, nil, {
	forgame = {
		Gamemode = "MainNormal";
		Difficulty = 1;
		PartyCount = #telegroup;
		MatchRank = 7;
		Funs = {};
	};
})