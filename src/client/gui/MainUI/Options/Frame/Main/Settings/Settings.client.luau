local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local lremotes = ReplicatedStorage.LocalRemotes
local remotes = ReplicatedStorage.Remotes
local lmodules = ReplicatedStorage.LocalModules
local mysettings = plr:WaitForChild("Settings")

local essentials = require(lmodules.EssentialFunctions)
local ui_essentials = require(lmodules.UIEssentials)

local holder = script.Parent

local items = {
	--[[
	{
	StatValue; (Used to get the initial value of the setting)
	SettingFrame;
	Function; (Passed arguments depend on the Class attribute of the SettingFrame)
	}
	]]
	
	["LobbyMusic"] = {
		mysettings:WaitForChild("LobbyMusic");
		holder.LobbyMusic;
		function(state)
			remotes.SetSetting:FireServer("LobbyMusic", state)
			lremotes.ToggleLobbyMusic:Fire(state)
		end;
	};
	["GameMusic"] = {
		mysettings:WaitForChild("GameMusic");
		holder.GameMusic;
		function(state)
			remotes.SetSetting:FireServer("GameMusic", state)
		end;
	};
	["CameraBobbing"] = {
		mysettings:WaitForChild("CameraBobbing");
		holder.CameraBobbing;
		function(state)
			remotes.SetSetting:FireServer("CameraBobbing", state)
		end;
	};
};
local classes = {
	["Toggle"] = function(iteminfo)
		local frame = iteminfo[2]
		local checkbutt = frame.Frame.TextButton
		
		local currentstate = iteminfo[1].Value
		
		checkbutt.Tick.Visible = currentstate
		checkbutt.Activated:Connect(function()
			ui_essentials.ButtonEffect(checkbutt)
			
			currentstate = not currentstate
			checkbutt.Tick.Visible = currentstate
			
			iteminfo[3](currentstate)
		end)
	end;
};

for name, iteminfo in pairs(items) do
	local manager = classes[iteminfo[2]:GetAttribute("Class") or ""]
	if manager then
		manager(iteminfo)
	end
end