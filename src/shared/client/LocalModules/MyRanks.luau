local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage.Remotes

local service = {}
local info = remotes.UpdateRanks.OnClientEvent:Wait()

service.CurrentRank = math.max(1, info.CurrentRank)
service.CompletedRanks = info.CompletedRanks

return service

