local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage.Remotes
local meshes = script.Parent.Meshes

task.wait(1)
remotes.Emit_VFX:FireAllClients("RinaRGB", meshes.RGBPart)
script:Destroy()