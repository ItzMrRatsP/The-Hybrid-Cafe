local RNG = Random.new()
local images = {
	"rbxassetid://74908754273777";
	"rbxassetid://112122202987018";
	"rbxassetid://108200621132208";
	"rbxassetid://71171335601211";
	"rbxassetid://74603795996088";
	"rbxassetid://81460291924152";
}

script.Parent.SurfaceGui.ImageLabel.Image = images[RNG:NextInteger(1, #images)]
script:Destroy()