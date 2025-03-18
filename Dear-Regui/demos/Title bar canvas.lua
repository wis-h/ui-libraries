local ReGui = require(game.ReplicatedStorage.ReGui)
ReGui:Init()

local Window = ReGui:Window({
	Title = "Window",
	Size = UDim2.fromOffset(350, 300)
}):Center()

--// Fetch canvases
local TitleCanvas = Window.TitleBarCanvas

--// Collapse toggle button
TitleCanvas:Button({
	Text = "Skibidi toilet",
	LayoutOrder = 2,
	Callback = function()
		Window:ToggleCollapsed()
	end,
})

--// Help button
local Help = TitleCanvas:RadioButton({
	LayoutOrder = 1,
	Icon = 12905962634
})
ReGui:SetItemTooltip(Help, function(Canvas)
	Canvas:Label({
		Text = "Check github.com/depthso/Dear-ReGui/"
	})
end)
