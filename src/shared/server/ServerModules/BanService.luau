local Players = game:GetService("Players")
local RNG = Random.new()

local service = {}

function service.Ban(userid, days, reason, privreason)
	local seconds = days * 86400
	if days == -1 then
		seconds = -1
	end
	
	local success, message = pcall(function()
		Players:BanAsync({
			UserIds = {userid};
			Duration = seconds;
			DisplayReason = reason;
			PrivateReason = privreason;
			ExcludeAltAccounts = false;
			ApplyToUniverse = true;
		})
	end)
	if not success then
		warn(message)
	end
	
	return success
end
function service.Unban(userid)
	local success, message = pcall(function()
		Players:UnbanAsync({
			UserIds = {userid};
			ApplyToUniverse = true;
		})
	end)
	
	if not success then
		warn(message)
	end
	
	return success
end

local banning = {}
function service.BanFromRemote(plr, remote, ...)
	if banning[plr] then return end
	banning[plr] = true
	
	local reason = "Exploiting."
	local priv = "Banned by System. | Fired "..remote.Name.." with types: "
	for _,v in pairs({...}) do
		priv = priv..typeof(v)..", "
	end
	
	print("SEEING PRIVREASON:", priv)
	local success = service.Ban(plr.UserId, 365, reason, priv)
	if not success and plr then
		banning[plr] = nil
	end
end

return service
