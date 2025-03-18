-- The key is 'bozo'

local ReGui = require(game.ReplicatedStorage.ReGui)
ReGui:Init()

local Window = ReGui:Window({
	Title = "Key system",
	Size = UDim2.fromOffset(300, 100),
	NoCollapse = true,
	NoResize = true,
	NoClose = true
})

local Key = Window:InputText({
	Label = "Key",
	PlaceHolder = "Key here",
	Value = "",
})

Window:Button({
	Text = "Enter",
	Callback = function()
		-- Successful
		if Key:GetValue() == "bozo" then
			Window:Close()
			-- Unsuccessful
		else
			Key:SetLabel("Wrong key!")
		end
	end,
})
