local RunService = game:GetService("RunService")

local ReGui = require(game.ReplicatedStorage.ReGui)
ReGui:Init()

local Window = ReGui:Window({
	Position = UDim2.fromOffset(10,10),
	Size = UDim2.fromOffset(500, 300),
	NoMove = true,
	NoResize = true,
	NoSelect = true,
	NoTitleBar = true, 
})

local Viewport = Window:Viewport({
	Model = ReGui:InsertPrefab("R15 Rig"),
	Size = UDim2.fromScale(1, 1),
	Clone = true,
	Border = false
})

--// Spin rig
local Model = Viewport.Model
RunService.RenderStepped:Connect(function(DeltaTime)
	local Y = 30 * DeltaTime
	local Pivot = Model:GetPivot() * CFrame.Angles(0, math.rad(Y) ,0)
	Model:PivotTo(Pivot)
end)
