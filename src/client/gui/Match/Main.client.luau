-- The main essentials of Match making
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local essentials = require(ReplicatedStorage.LocalModules.UIEssentials)
local sfx = game.SoundService.SFX

local mmRemote = ReplicatedStorage.Remotes.Matchmaking

local match = script.Parent
local globalbtn = match.GlobalButton
local btn = globalbtn.TextButton

local Notify = ReplicatedStorage.LocalRemotes.Notify
local MatchFound = ReplicatedStorage.Remotes.MatchFound

local clash = sfx.Clash

local clientCooldown = 5
local clientDebounce = false
local state = false
local found = false

local startOfFinding = os.time()

local Colors = {
	Aspect = {
		Disabled = ColorSequence.new {
			ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 255, 120));
			ColorSequenceKeypoint.new(0.575, Color3.fromRGB(255, 255, 255));
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255));
		},

		Enabled = ColorSequence.new {
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 131, 131));
			ColorSequenceKeypoint.new(0.575, Color3.fromRGB(255, 255, 255));
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255));
		}
	},

	Stroke = {
		Disabled = Color3.fromRGB(120, 255, 136);
		Enabled = Color3.fromRGB(255, 130, 130)
	},

	MainButton = {
		Disabled = ColorSequence.new {
			ColorSequenceKeypoint.new(0, Color3.fromRGB(41, 102, 53));
			ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 157, 26));
		},

		Enabled = ColorSequence.new {
			ColorSequenceKeypoint.new(0, Color3.fromRGB(102, 40, 40));
			ColorSequenceKeypoint.new(1, Color3.fromRGB(157, 23, 23));
		}
	},
}

local function getClockDiff(s: number, piece: string)
	local matchStr = `%02d:%02d {piece}`
	local diff = os.time() - s
	local seconds = diff % 60
	local minutes = (diff / 60) % 60

	return string.format(matchStr, minutes, seconds)
end

local function updateButton()
	for _, gradient in btn:GetDescendants() do
		if not gradient:IsA("UIGradient") then
			continue
		end
		
		local Ancestor = gradient.Parent
		
		if (Ancestor:IsA("TextButton")) then
			gradient.Color = (state and Colors.MainButton.Enabled) or Colors.MainButton.Disabled
		else
			gradient.Color = (state and Colors.Aspect.Enabled) or Colors.Aspect.Disabled
		end
	end
	
	btn.UIStroke.Color = (state and Colors.Stroke.Enabled) or Colors.Stroke.Disabled
	btn.TextLabel.Text = (state and "CANCEL") or "PLAY GLOBAL"
	globalbtn.Timer.Visible = state
	
	if not state then
		return
	end
	
	task.spawn(function()
		while (state and not found) do
			-- set
			globalbtn.Timer.Text = getClockDiff(startOfFinding, "SEARCHING FOR MATCH")
			task.wait()
		end
	end)
end

btn.Activated:Connect(function()
	sfx.Shiny:Play()
	essentials.ButtonEffect(btn)
	
	if (found) then
		return
	end
	
	if (clientDebounce) then
		return
	end
	
	clientDebounce = true
	task.delay(clientCooldown, function()
		clientDebounce = false
	end)

	-- Update the button;
	state = not state
	updateButton()
	
	if (state) then
		startOfFinding = os.time()
	end

	-- Send events to server for queue;
	mmRemote:FireServer()
end)

MatchFound.OnClientEvent:Connect(function(start: number)
	-- Match
	local clockDiffString = getClockDiff(start, "MATCH FOUND")
	globalbtn.Timer.Visible = false
	
	found = true
	
	clash:Play()
	Notify:Fire(clockDiffString)
end)