local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RNG = Random.new(tick())

local lmodules = ReplicatedStorage.LocalModules
local jspawns = workspace.JetskiSpawns:GetChildren()
local remotes = ReplicatedStorage.Remotes

local charmodels = ReplicatedStorage.UniqueCustomers:GetChildren()
local charpool = {}
for _, c in pairs(charmodels) do
	if c:IsA("Model") then
		table.insert(charpool, c)
	end
end
local picked = {}

while true do
	task.wait(RNG:NextNumber(5, 15))

	local sending = {}
	for i = 1, RNG:NextInteger(1, 3) do
		local cpath = jspawns[RNG:NextInteger(1, #jspawns)]
		local newpool = {}
		if #picked == #charpool then
			picked = {}
		end
		for _, c in pairs(charpool) do
			if not table.find(picked, c) then
				table.insert(newpool, c)
			end
		end
		local chosen = newpool[RNG:NextInteger(1, #newpool)]

		table.insert(picked, chosen)
		table.insert(sending, {
			char = chosen,
			path = cpath,
		})
	end

	remotes.Env_Jetski:FireAllClients(sending)
end
