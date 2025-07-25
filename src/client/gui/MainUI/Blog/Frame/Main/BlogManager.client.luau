local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local sfx = game:GetService("SoundService").SFX
local lmodules = ReplicatedStorage.LocalModules
local blogs = ReplicatedStorage.Blogs:GetChildren()

local frame = script.Parent
local mainframe = frame.Parent
local holder = mainframe.Parent
local ui = holder.Parent
local selectblog = frame.SelectBlog
local blogholder = frame.MainBlog
local stock_button = script.BlogButton
local close = frame.Parent.Close
local blogbutton = ui.MainButtons.MiniButtons.BlogButton

local ui_essentials = require(lmodules.UIEssentials)
local elementmanager = require(frame.Elements)

table.sort(blogs, function(a,b)
	local seta, setb = require(a), require(b)
	
	for i = 1, 3 do
		if seta.DateCreated[i] ~= setb.DateCreated[i] then
			return seta.DateCreated[i] > setb.DateCreated[i]
		end
	end
	return seta.DateCreated[3] > setb.DateCreated[3]
end)

local padding = blogholder.UIPadding
local listlayout = blogholder.UIListLayout
local function DisplayBlog(mod)
	for _,v in pairs(blogholder:GetChildren()) do
		if v == listlayout or v == padding then continue end
		v:Destroy()
	end
	
	local info = require(mod)
	local title = elementmanager.ProcessInput({"Title"; nil; info.Title})
	local title2 = elementmanager.ProcessInput({"NormalText"; 25; info.DateCreated[2].."/"..info.DateCreated[3].."/"..info.DateCreated[1]})
	title.Parent = blogholder
	title2.Parent = blogholder
	for i,v in pairs(info.Content) do
		local elm = elementmanager.ProcessInput(v)
		if elm then
			elm.LayoutOrder = i
			elm.Parent = blogholder
		end
	end
end

for i,b in pairs(blogs) do
	local info = require(b)
	local new = stock_button:Clone()
	local butt = new.TextButton
	
	local col = info.Color or Color3.fromRGB(50, 50, 50)
	butt.BackgroundColor3 = col
	butt.UIStroke.Color = col:Lerp(Color3.fromRGB(0,0,0), 0.3)
	butt.Title.Text = info.Title or "No Title"
	butt.Date.Text = info.DateCreated[2].."/"..info.DateCreated[3].."/"..info.DateCreated[1]
	butt.Banner.Image = info.ImageBanner or ""
	
	new.LayoutOrder = i
	new.Parent = selectblog
	
	butt.Activated:Connect(function()
		ui_essentials.ButtonEffect(butt)
		
		DisplayBlog(b)
	end)
	butt.MouseEnter:Connect(function()
		butt.Hover.Visible = true
	end)
	butt.MouseLeave:Connect(function()
		butt.Hover.Visible = false
	end)
end

blogbutton.Button.Activated:Connect(function()
	ui_essentials.ButtonEffect(blogbutton.Button)
	
	ui_essentials.DisableAllMains(holder)
	local newstate = not holder.Visible
	holder.Visible = newstate

	if newstate then
		DisplayBlog(blogs[1])
		ui_essentials.OpenTab(mainframe)
	else
		sfx.CloseTab:Play()
	end
end)

close.Activated:Connect(function()
	holder.Visible = false
	sfx.CloseTab:Play()
end)
ui_essentials.ImgCloseButton(close)

plr:GetAttributeChangedSignal("Loading"):Connect(function()
	if not plr:GetAttribute("Loading") and plr:GetAttribute("NewBlog") then
		holder.Visible = true
		DisplayBlog(blogs[1])
		ui_essentials.OpenTab(mainframe)
	end
end)

local function selupdate()
	local abs = selectblog.UIListLayout.AbsoluteContentSize.Y
	selectblog.CanvasSize = UDim2.fromOffset(0, abs + 50)
end
selupdate()
selectblog.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(selupdate)