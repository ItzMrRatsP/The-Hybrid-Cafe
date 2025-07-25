local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local sfx = game:GetService("SoundService").SFX
local remotes = ReplicatedStorage.Remotes
local r_ranks = ReplicatedStorage.Ranks
local lmodules = ReplicatedStorage.LocalModules

local holder = script.Parent
local pframe = holder.Parent
local ranklocked = pframe.RankLocked
local rankpages = pframe.RankPages
local credreward = pframe.CredReward

local maintitle = holder.Title
local subtitle = holder.Title2
local back_rank = holder.LessRank
local front_rank = holder.MoreRank
local modframe = holder.Modifiers
local completed = holder.CompletedBadge

local grad = script.Gradients
local essentials = require(lmodules.EssentialFunctions)
local myrankinfo = require(lmodules.MyRanks)

local currentdisplayed = 1

local pushTI = TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

local pagepoints = {}
local function DisplayRank(num)
	local mod = r_ranks:FindFirstChild(tostring(num))
	if mod then
		currentdisplayed = num
		holder:SetAttribute("SelectedRank", num)
		holder:SetAttribute("IsLocked", myrankinfo.CurrentRank < num)
		
		local nstring = tostring(num)
		local info = require(mod)
		
		for i,f in pairs(pagepoints) do
			f.BackgroundColor3 = (i == num and Color3.fromRGB(255,255,255)) or Color3.fromRGB(19, 9, 33)
		end
		
		local curgrad = maintitle:FindFirstChildWhichIsA("UIGradient")
		if curgrad then
			curgrad:Destroy()
		end
		if myrankinfo.CurrentRank >= num then
			maintitle.Text = info.DisplayName
			credreward.TextLabel.Text = essentials.FormatNum(info.Reward or 0)
			
			subtitle.Visible = num >= 3
			completed.Visible = myrankinfo.CompletedRanks[nstring] ~= nil
			if myrankinfo.CompletedRanks[nstring] then
				if myrankinfo.CompletedRanks[nstring].SpentRobux then
					completed.ImageLabel.ImageColor3 = Color3.fromRGB(94, 255, 121)
				else
					completed.ImageLabel.ImageColor3 = Color3.fromRGB(255, 212, 83)
				end
			end
			
			for i = 1,2 do
				local det = modframe:FindFirstChild("Detail"..i)
				local tex = info.Details[i]
				
				det.Visible = tex ~= nil
				det.Text = tex or ""
			end
			
			local ngrad = grad:FindFirstChild(tostring(num))
			if ngrad then
				ngrad = ngrad:Clone()
				ngrad.Parent = maintitle
				ngrad.Enabled = true
			end
		else
			maintitle.Text = "Locked"
			credreward.TextLabel.Text = "???"
			completed.Visible = false
			
			modframe.Detail1.Visible = true
			modframe.Detail2.Visible = false
			subtitle.Visible = false
			
			modframe.Detail1.Text = "Complete the previous rank to unlock"
		end
	else
		warn("No Rank Mod for "..num)
	end
end


local function HoverEffect(button)
	button.MouseEnter:Connect(function()
		button.Hover.Visible = true
	end)
	button.MouseLeave:Connect(function()
		button.Hover.Visible = false
	end)
end
local function ButtonEffect(button)
	button.UIScale.Scale = 0.75
	holder.UIScale.Scale = 0.95
	
	local track = TweenService:Create(button.UIScale, pushTI, {
		Scale = 1;
	})
	local track2 = TweenService:Create(holder.UIScale, pushTI, {
		Scale = 1;
	})
	track:Play()
	track2:Play()
end

HoverEffect(back_rank)
HoverEffect(front_rank)
local function InitRanks()

	local maxranks = math.clamp(myrankinfo.CurrentRank + 1, 1, #r_ranks:GetChildren() - 1)

	for i = 1, maxranks do
		local new = script.Point:Clone()
		new.BackgroundColor3 = Color3.fromRGB(19, 9, 33)
		new.LayoutOrder = i
		new.Parent = rankpages

		table.insert(pagepoints, new)
	end

	front_rank.Activated:Connect(function()
		if ranklocked.Visible then return end

		ButtonEffect(front_rank)
		sfx.ButtonPress:Play()

		local danext = currentdisplayed + 1
		if danext > maxranks then
			danext = 1
		end
		DisplayRank(danext)
	end)
	back_rank.Activated:Connect(function()
		if ranklocked.Visible then return end

		ButtonEffect(back_rank)
		sfx.ButtonPress:Play()

		local danext = currentdisplayed - 1
		if danext < 1 then
			danext = maxranks
		end
		DisplayRank(danext)
	end)

	DisplayRank(1)
end
InitRanks()

RunService:UnbindFromRenderStep("RenderCompleteBadge")
RunService:BindToRenderStep("RenderCompleteBadge", 100, function(dt)
	local sine = math.sin(tick()) * 5
	completed.ImageLabel.Rotation = (-15) + sine
end)