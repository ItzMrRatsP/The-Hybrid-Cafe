local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local lremotes = ReplicatedStorage.LocalRemotes
local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules

local essentials = require(lmodules.EssentialFunctions)
local ui_essentials = require(lmodules.UIEssentials)

print("getting stats")
local mystats = require(lmodules.MyStats)
print("got stats")

local holder = script.Parent
local stock = script.StatItem
local listlayout = holder.UIListLayout

local items = {
	-- {StatName, DisplayName, FormatType (default is Number)}
	
	{"TotalPlaytime"; "Total Playtime", "Time"};
	{"HighestDay"; "Highest Day"};
	{"CustomersServed"; "Customers Served"};
	{"PerfectOrders"; "Perfect Orders"};
	{"DaysCompleted"; "Days Completed"};
	{"CoffeeCups"; "Coffee Cups Created"};
	{"MilkCups"; "Milk Cups Created"};
	{"Snacks"; "Snacks Created"};
	{"Drinks"; "Drinks Created"};
	{"EnemiesKilled"; "Enemies Killed"};
	{"Deaths"; "Deaths"};
	{"AkarisSprayed"; "Thieves Sprayed"};
	{"ACFixes"; "A/C Fixes"};
	{"MachineFixes"; "Machine Fixes"};
	{"ProfitEarned"; "Profit Earned", "Money"};
	{"ProfitSpent"; "Profit Spent", "Money"};
};

local formats = {
	["Number"] = function(num) -- type is number
		return essentials.FormatNum(num, true)
	end;
	["Time"] = function(num) -- type is number in seconds
		if num >= 3600 then
			-- Display in hours
			local hour = math.floor(num / 3600)
			return essentials.FormatNum(hour, true).." Hour"..((hour > 1 and "s") or "")
		elseif num >= 60 then
			--Display in minutes
			local minute = math.floor(num / 60)
			return essentials.FormatNum(minute, true).." Minute"..((minute > 1 and "s") or "")
		else
			--Display in seconds
			return essentials.FormatNum(num, true).." Second"..((num > 1 and "s") or "")
		end
	end;
	["Money"] = function(num) -- type is number
		local rounded = math.round(num * 100) / 100
		return "$"..essentials.FormatNum(rounded, true, true)
	end;
	["Plain"] = function(input) -- returns the stat as is
		return input
	end;
}

local frames = {}
for i, info in pairs(items) do
	local new = stock:Clone()
	new.Name = info[1]
	new.Title.Text = info[2]
	new.LayoutOrder = i
	new:SetAttribute("FormatType", info[3] or "Number")
	
	frames[info[1]] = new
	
	new.Parent = holder
end

local function Update()
	for n, frame in pairs(frames) do
		local currentvalue = mystats.Stats[n]
		local formattype = frame:GetAttribute("FormatType")
		
		local formattedvalue = formats[formattype](currentvalue)
		frame.VHolder.StatValue.Text = formattedvalue
	end
end
Update()
mystats.Updated:Connect(Update)

local function AdjustList()
	local abs = listlayout.AbsoluteContentSize.Y
	holder.CanvasSize = UDim2.fromOffset(0, abs + 50)
end
AdjustList()
listlayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(AdjustList)