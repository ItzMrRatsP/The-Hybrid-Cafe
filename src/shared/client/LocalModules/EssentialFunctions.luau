local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local lremotes = ReplicatedStorage.LocalRemotes
local remotes = ReplicatedStorage.Remotes

local RNG = Random.new()
local TAU = math.pi * 2

local lib = {}

function lib.EasyRound(num, points)
	local ex = 10 ^ points
	return math.round(num * (ex)) / ex
end

function lib.DiceRoll(T)
	local sum = 0
	for k, v in pairs(T) do
		sum = sum + v
	end
	if sum <= 0 then return nil end
	local r = RNG:NextInteger(1, sum)
	for k, v in pairs(T) do
		r = r - v
		if r <= 0 then
			return k
		end
	end
	return nil
end

function lib.YieldEvent(event, timeout)
	local node = Instance.new("BindableEvent")

	local thr1 = task.spawn(function()
		task.wait(timeout)
		node:Fire()
	end)
	local thr2 = task.spawn(function()
		local s = event:Wait()
		node:Fire(s)
	end)

	node.Event:Once(function()
		task.wait(0.1)
		node:Destroy()
	end)
	local item = node.Event:Wait()

	pcall(task.cancel, thr1)
	pcall(task.cancel, thr2)

	return item
end

function lib.GetPlayerPicture(plr)
	if typeof(plr) == "Instance" and plr:GetAttribute("ProfilePicture") then
		return plr:GetAttribute("ProfilePicture")
	end
	
	local userID = ((typeof(plr) == "number" or typeof(plr) == "string") and plr) or plr.UserId
	local rawID = "rbxthumb://type=AvatarHeadShot&id=REPLACEWITHID&w=352&h=352"
	local newID = string.gsub(rawID, "REPLACEWITHID", userID)

	return newID
end

function lib.Convert_To_HMS(Seconds)
	local Minutes = math.floor(Seconds / 60)
	Seconds = Seconds % 60

	local Hours = math.floor(Minutes / 60)
	Minutes = Minutes % 60

	--// FROMAT //--
	return string.format("%02d:%02d:%02d", Hours, Minutes, Seconds)
end

function lib.Convert_To_DHMS(Num)
	local days = math.floor(Num/86400)
	local remaining = Num % 86400
	local hours = math.floor(remaining/3600)
	remaining = remaining % 3600
	local minutes = math.floor(remaining/60)
	remaining = remaining % 60
	local seconds = remaining
	if (hours < 10) then
		hours = "0" .. tostring(hours)
	end
	if (minutes < 10) then
		minutes = "0" .. tostring(minutes)
	end
	if (seconds < 10) then
		seconds = "0" .. tostring(seconds)
	end

	return tostring(days)..':'..hours..':'..minutes..':'..seconds
end

function lib.ParseToSeconds(T)
	local minutes = math.floor(T / 60)
	local remainingSeconds = T % 60

	if remainingSeconds < 10 then
		remainingSeconds = "0"..remainingSeconds
	end

	return minutes..":"..remainingSeconds
end

function lib.FormatNum(num, noPi, ismoney)
	if not noPi and (num == 314 or num == 3141 or num == 31415 or num == 314159) then
		return "π"
	end

	local formatted = num
	if ismoney then
		formatted = math.floor(num)
	end
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k == 0) then
			break
		end
	end
	if ismoney then
		local cents = math.floor(num * 100) - (math.floor(num) * 100)
		if cents < 10 then
			cents = "0"..cents
		end
		formatted = formatted.."."..cents
	end
	
	return formatted
end

function lib.quadBezier(t, p0, p1, p2)
	local l1 = p0:Lerp(p1, t)--lerp(p0, p1, t)
	local l2 = p1:Lerp(p2, t)--lerp(p1, p2, t)
	local quad = l1:Lerp(l2, t)--lerp(l1, l2, t)

	return quad
end

function lib.SimpleSearch(folder, search)
	if folder:FindFirstChild(search) then return folder[search] end

	local lowersearch = string.lower(search)

	local ns = {}

	for _,v in pairs(folder:GetChildren()) do
		local lowername = string.lower(v.Name)

		ns[lowername] = v
	end

	for name,item in pairs(ns) do
		if string.match(name, lowersearch) then
			return item
		end
	end

	return nil
end

function lib.BendDirection(Direction, MinAngle, MaxAngle, TAUPerc)
	local Angle = RNG:NextNumber(0, TAU)
	if TAUPerc then
		Angle = TAU * TAUPerc
	end

	local directionalCF = CFrame.new(Vector3.new(), Direction)
	local finaldirection = (directionalCF * CFrame.fromOrientation(0, 0, Angle) * CFrame.fromOrientation(math.rad(RNG:NextNumber(MinAngle, MaxAngle)), 0, 0)).LookVector

	return finaldirection
end

function lib.AddUniqueEntry(arr, item)
	if not table.find(arr, item) then
		table.insert(arr, item)
		return true
	end
	return false
end

function lib.Local_ErrorNotify(message, duration)
	lremotes.Notify:Fire(message, duration, {TextColor = Color3.fromRGB(255,75,75)}, {"Buzzer"})
end

function lib.PurchaseNotify(plr)
	remotes.NotifyPlayer:FireClient(plr, "Purchase granted! Thank you so much for your support! ❤", 7, {
		StrokeColor = Color3.fromRGB(18, 95, 27);
		TextColor = Color3.fromRGB(125, 255, 116);
	}, {"Purchase"})
	remotes.RoyalParticles:FireClient(plr)
end

function lib.ColorText(input : string, color : Color3)
	local hexcol = color:ToHex()
	
	local start = '<font color="#'..string.upper(hexcol)..'">'
	local edge = '</font>'
	
	return start..input..edge
end

return lib