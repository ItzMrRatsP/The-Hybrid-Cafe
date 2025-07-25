local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage.Remotes
local model = script.Parent

remotes.Emit_VFX:FireAllClients("ShakeBody", model)
script:Destroy()