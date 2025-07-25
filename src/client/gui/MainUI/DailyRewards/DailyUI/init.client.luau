local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local RNG = Random.new()

local plr = Players.LocalPlayer
local sfx = game:GetService("SoundService").SFX
local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules
local lremotes = ReplicatedStorage.LocalRemotes

local holder = script.Parent
local main = holder.Frame
local UI = holder.Parent
local itemholder1 = main.Items
local itemholder2 = main.ItemsLow
local close = main.Close
local streaktitle = main.Title2
local claim = main.Claim
local logintimer = UI.LoginTimer

local stock_frame = script.Frame

local datastats = plr:WaitForChild("DataStats")
local d_taken = datastats:WaitForChild("DailyTaken")

local ui_essentials = require(lmodules.UIEssentials)
local essentials = require(lmodules.EssentialFunctions)
local methods = require(script.RewardMethods)
local quotes = require(script.StreakQuotes)

local streakColor = Color3.fromRGB(0, 255, 217)

local targetframe
local jumpTI = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

remotes.QueueDailyReward.OnClientEvent:Connect(function(rewards, streak, level)
	if streak <= 1 then
		streaktitle.Text = "Come back tomorrow to claim the next reward!"
	else
		local using
		for _,v in pairs(quotes) do
			if streak >= v[2] then
				using = v[1]
			end
		end
		streaktitle.Text = "x"..streak.." login streak! "..using[RNG:NextInteger(1, #using)]
		
		local intensity = math.min(streak / 30)
		streaktitle.TextColor3 = Color3.fromRGB(255,255,255):Lerp(Color3.fromRGB(255, 42, 0), intensity)
		
		local pix = math.floor(intensity * 3)
		if pix > 0 then
			local tpos = streaktitle.Position
			RunService:BindToRenderStep("ShakeDaily", 100, function(dt)
				streaktitle.Position = tpos + UDim2.fromOffset(RNG:NextInteger(-pix, pix), RNG:NextInteger(-pix, pix))
			end)
		end
	end

	local add = math.floor((streak - 1) / 7) * 7
	
	for i,v in pairs(rewards) do
		local p = (i <= 5 and itemholder1) or itemholder2
		local new = stock_frame:Clone()
		-- We're on that streak, Or already completed, So we can just color it 
		local isTodayStreak = (i == streak + 1)
		
		
		new.Frame.DayTitle.Text = "Day "..add + i
		
		if methods[v[1]] then
			local args = table.clone(v)
			table.remove(args, 1)
			
			methods[v[1]](new, unpack(args), isTodayStreak)
		end
		
		new.LayoutOrder = i
		new.Parent = p
		
		if i == level then
			targetframe = new
		elseif i < level then
			new.Frame.Claimed.Visible = true
		end
	end
	
	if plr:GetAttribute("Loading") then
		plr:GetAttributeChangedSignal("Loading"):Wait()
		task.wait()
	end
	local bframe = UI.Blog
	if plr:GetAttribute("NewBlog") and bframe.Visible then
		bframe:GetPropertyChangedSignal("Visible"):Wait()
	end
	
	holder.Visible = true
	ui_essentials.OpenTab(main)
end)

local pressed = false
claim.TextButton.Activated:Connect(function()
	if pressed then return end
	pressed = true
	
	remotes.ClaimDailyReward:FireServer()
	ui_essentials.ButtonEffect(targetframe.Frame)
	sfx.MailClaim:Play()
	sfx.ClickedSound:Play()
	sfx.MoneyCollect:Play()
	
	if targetframe then
		targetframe.Frame.Claimed.Visible = true
		ui_essentials.ButtonEffect(targetframe.Frame, true)
		lremotes.RoyalParticles:Fire(Color3.fromRGB(143, 246, 255))
	end
	
	local hpos = holder.Position
	holder.Position += UDim2.fromOffset(0,-25)
	local track = TweenService:Create(holder, jumpTI, {
		Position = hpos;
	})
	track:Play()
	
	task.delay(2, function()
		RunService:UnbindFromRenderStep("ShakeDaily")
		if holder.Visible then
			sfx.CloseTab:Play()
			holder.Visible = false
		end
	end)
end)

local cdthread
local claimtime = (3600 * 12)
local function UpdateTimer()
	local current = d_taken.Value
	local since = os.time() - current

	if cdthread then
		pcall(task.cancel, cdthread)
	end
	if since >= claimtime then
		-- already up, make it disappear
		logintimer.Visible = false
	else
		-- still counting down
		logintimer.Visible = true
		
		local timeleft = (current + claimtime) - math.floor(os.time())
		cdthread = task.spawn(function()
			repeat
				logintimer.TextLabel.Text = "Daily reward in "..essentials.Convert_To_HMS(timeleft)
				task.wait(1)
				timeleft -= 1
			until timeleft <= 0
			logintimer.Visible = false
		end)
	end
end
UpdateTimer()
d_taken:GetPropertyChangedSignal("Value"):Connect(UpdateTimer)

close.Activated:Connect(function()
	holder.Visible = false
	sfx.CloseTab:Play()
end)
ui_essentials.ImgCloseButton(close)
ui_essentials.GlareGradient(main.UIGradient)