local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ArrayToDictonary = require(ReplicatedStorage.LocalModules.Util.Table.ArrayToDictonary)

local cups = {}

cups.Enums = ArrayToDictonary {"TimelessCup", "AliceThumbsUp"}
cups.Config = {
	[cups.Enums.AliceThumbsUp] = {index = 2, t = "Sticker"};
	[cups.Enums.TimelessCup] = {index = 7, t = "Cup"};
}

return cups :: {
	Enums: {[string]: string};
	Config: {
		[string]: {index: number, t: "Sticker" | "Cup"};
	}
}
