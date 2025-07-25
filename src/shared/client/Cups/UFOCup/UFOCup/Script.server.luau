local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage.Remotes

local model = script.Parent
local ufo = model.UFO
local lightweld = ufo.UFOBase.Lights

task.wait(0.15)
remotes.Emit_VFX:FireAllClients("SpinWeld", lightweld, 180)

script:Destroy()