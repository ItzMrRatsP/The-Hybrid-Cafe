local RNG = Random.new()
local color = BrickColor.random().Color

local model = script.Parent
local mug = model.Mug

local shoe1, shoe2 = model.Meshes["ShoeBlox-Left"], model.Meshes["ShoeBlox-Right"]

shoe1.SurfaceAppearance.Color = color
shoe2.SurfaceAppearance.Color = color

mug.Special.PlaybackSpeed = RNG:NextNumber(0.95, 1.1)
mug.Special:Play()