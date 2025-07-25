local frame = script.Parent
local mainblog = frame.MainBlog

local elems = {}
elems.Elements = {
	["Title"] = function(size, text)
		local pixelspersize = 330 / (size or 40)
		local abs = mainblog.AbsoluteSize
		
		local new = script.Title:Clone()
		new.Text = text
		new.TextSize = math.max(abs.Y / pixelspersize, 5)
		
		return new
	end;
	["NormalText"] = function(size, text)
		local pixelspersize = 330 / (size or 20)
		local abs = mainblog.AbsoluteSize

		local new = script.NormalText:Clone()
		new.Text = text
		new.TextSize = math.max(abs.Y / pixelspersize, 5)

		return new
	end;
	["Header"] = function(size, text)
		local pixelspersize = 330 / (size or 35)
		local abs = mainblog.AbsoluteSize

		local new = script.Header:Clone()
		new.Text = text
		new.TextSize = math.max(abs.Y / pixelspersize, 5)

		return new
	end;
	["Image"] = function(size, ratio, id)
		local new = script.ImageLabel:Clone()
		new.Image = id
		new.Size = UDim2.fromScale(size or 0.5, 1)
		new.UIAspectRatioConstraint.AspectRatio = ratio or 1

		return new
	end;
	["Spacing"] = function(size)
		local new = script.Spacing:Clone()
		new.Size = UDim2.new(1, 0, 0, size or 10)

		return new
	end;
	
}

function elems.ProcessInput(input)
	local getting = input[1] and elems.Elements[input[1]]
	if getting then
		local args = table.clone(input)
		table.remove(args, 1)
		
		local element = getting(unpack(args))
		return element
	end
	
	warn("Input not received: "..input[1])
	return nil
end

return elems