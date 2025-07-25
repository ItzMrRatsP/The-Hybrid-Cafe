local DSS = game:GetService("DataStoreService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RNG = Random.new()

local lmodules = ReplicatedStorage.LocalModules
local servermodules = ServerStorage.ServerModules
local bfolders = workspace:WaitForChild("Leaderboards")

local essentials = require(lmodules.EssentialFunctions)
local datahandler = require(servermodules.DataHandler)

local masterkey = "_001LIVE"
local Boards = {
	["CustomersServed"] = {
		bfolders.CustomersServed;
		DSS:GetOrderedDataStore("AlltimeCustomers"..masterkey);
		function(plr)
			local val = datahandler.GetTable(plr, "PlayerStats")["CustomersServed"]
			return val or 0
		end;
	};
}
local stockname = script.Stock

task.spawn(function()
	while true do
		local week, year = os.date("%U"), os.date("%Y")
		
		local b = table.clone(Boards)
		b["WeeklyCustomersServed"] = {
			bfolders.CustomersServed_Weekly;
			DSS:GetOrderedDataStore(masterkey.."Customers_"..week.."/"..year);
		}
		
		for stat, info in pairs(b) do
			local UI = info[1].SurfaceGui
			local store = info[2]
			
			local plrinfo = {}
			local success, err = pcall(function()
				local pages = store:GetSortedAsync(false, 50, 1, 9e9)
				local current = pages:GetCurrentPage()
				
				for rank, data in pairs(current) do
					local id = data.key
					plrinfo[rank] = {
						id;
						Players:GetNameFromUserIdAsync(id);
						data.value;
					}
				end
			end)
			if not success then
				warn("[FAILED GET LEADERBOARD DATA]", err)
				continue
			end
			
			for _,f in pairs(UI.ScrollingFrame:GetChildren()) do
				if not f:IsA("UIListLayout") then
					f:Destroy()
				end
			end
			for i, p in pairs(plrinfo) do
				local f = stockname:Clone()
				f.Name = i
				f.LayoutOrder = i
				
				f.Left.PlacePosition.Text = i.."."
				f.Left.PlrName.Text = p[2]
				f.Left.ProfilePic.Image = essentials.GetPlayerPicture(p[1])
				f.Right.Leaderstat.Text = essentials.FormatNum(p[3], true)
				
				f.Parent = UI.ScrollingFrame
			end
		end
		
		task.wait(RNG:NextNumber(60, 120))
	end
end)


local Service = {}

function Service.UpdatePlayer(plr)
	for stat, info in pairs(Boards) do
		local succ, nope = pcall(function()
			local val = info[3](plr)
			if typeof (val) ~= "number" then return end

			info[2]:SetAsync(plr.UserId, val)
		end)
		if not succ then
			warn("[FAILED SET LEADERBOARD STAT]", nope)
		end
	end
end

return Service