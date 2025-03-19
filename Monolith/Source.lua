--[[

	                                            $$\ $$\   $$\     $$\       
	                                            $$ |\__|  $$ |    $$ |      
	$$$$$$\$$$$\   $$$$$$\  $$$$$$$\   $$$$$$\  $$ |$$\ $$$$$$\   $$$$$$$\  
	$$  _$$  _$$\ $$  __$$\ $$  __$$\ $$  __$$\ $$ |$$ |\_$$  _|  $$  __$$\ 
	$$ / $$ / $$ |$$ /  $$ |$$ |  $$ |$$ /  $$ |$$ |$$ |  $$ |    $$ |  $$ |
	$$ | $$ | $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |$$ |  $$ |$$\ $$ |  $$ |
	$$ | $$ | $$ |\$$$$$$  |$$ |  $$ |\$$$$$$  |$$ |$$ |  \$$$$  |$$ |  $$ |
	\__| \__| \__| \______/ \__|  \__| \______/ \__|\__|   \____/ \__|  \__|
	                                                                        
	- Made by wis_h (837050650537099346)
	- https://discord.gg/uilibrary

--]]

--[[ LIBRARY DATA ]]-------------------------------------------------
local Library = { 
	Flags = {}, 
	Selected = {},
	Opened = nil,
	Connections = {},
	Theme = {
		Font = nil;
		Accent = Color3.fromRGB(170, 85, 235),
		Background = Color3.fromRGB(15, 15, 15),
		Foreground = Color3.fromRGB(13, 13, 13),

		Text = {
			Selected = Color3.fromRGB(170, 85, 235),
			Unselected = Color3.fromRGB(160, 160, 160)
		},

		Advanced = {
			["Tab Buttons"] = {
				Gradient_S = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(41,41,41)), 
					ColorSequenceKeypoint.new(1, Color3.fromRGB(25,25,25))
				},
				Gradient_US = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(41,41,41)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(16,16,16))
				},
			},
			["Toggles"] = {
				Gradient_S = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 20, 118));
					ColorSequenceKeypoint.new(1, Color3.fromRGB(156, 39, 236));
				}),
				Gradient_US = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(41, 41, 41));
					ColorSequenceKeypoint.new(1, Color3.fromRGB(56, 56, 56));
				}),
			}
		}
	}
}; Library.__index = Library

local Interface = game:GetObjects("rbxassetid://98223893247771")[1]
local Components = game:GetObjects("rbxassetid://93145026007616")[1]

local Typeface = loadstring(game:HttpGet("https://roblo-x.com/scripts/typeface.lua"))()
Library.Theme.Font = Typeface:Register("fonts", {
	name = "font",
	link = "https://roblo-x.com/files/tahoma.ttf",
	weight = "Regular",
	style = "Normal"
})

--[[ DEPENDENCIES ]]-------------------------------------------------
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local InputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PlayerService = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = PlayerService.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--[[ FUNCTIONS ]]----------------------------------------------------
function Library.Create(class : string, properties : {})
	local i
	local madeInstance, errorMessage = pcall(function()
		i = Instance.new(class)    
	end)

	if not madeInstance then
		warn("Failed to create instance of class: " .. class)
		return error(errorMessage, 99)
	end

	for property, value in pairs(properties) do
		local success, err = pcall(function()
			i[property] = value
		end)
		if not success then 
			warn("Problem adding property '" .. property .. "' to instance of class '" .. class .. "': " .. err)
		end
	end

	return i or nil
end

function Library.Overwrite(to_overwrite : {}, overwrite_with : {})
	for i, v in pairs(overwrite_with) do
		if type(v) == 'table' then
			to_overwrite[i] = Library.Overwrite(to_overwrite[i] or {}, v)
		else
			to_overwrite[i] = v
		end
	end

	return to_overwrite or nil
end

function Library.Round(number, float) 
	local multiplier = 1 / (float or 1)
	return math.floor(number * multiplier + 0.5) / multiplier
end 

function Library.Connection(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(Library.Connections, connection)
	return connection 
end

function Library.MakeDraggable(Frame)
	local isDragging = false
	local dragInput = nil
	local dragStart = nil
	local StartPosition = nil

	local function updatePosition(input)
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(
			StartPosition.X.Scale, 
			StartPosition.X.Offset + delta.X,
			StartPosition.Y.Scale, 
			StartPosition.Y.Offset + delta.Y
		)
	end

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			dragStart = input.Position
			StartPosition = Frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					isDragging = false
				end
			end)
		end
	end)

	Frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	InputService.InputChanged:Connect(function(input)
		if input == dragInput and isDragging then
			updatePosition(input)
		end
	end)
end

function Library.LerpColor3(colorA, colorB, alpha)
	return Color3.new(
		colorA.R + (colorB.R - colorA.R) * alpha,
		colorA.G + (colorB.G - colorA.G) * alpha,
		colorA.B + (colorB.B - colorA.B) * alpha
	)
end

function Library.TweenGradient(uiGradient, targetGradient, duration)
	local tweenValue = Instance.new("NumberValue")
	tweenValue.Value = 0

	local startGradient = uiGradient.Color
	local startKeypoints = startGradient.Keypoints
	local targetKeypoints = targetGradient.Keypoints

	local connection = tweenValue.Changed:Connect(function()
		local alpha = tweenValue.Value
		local newKeypoints = table.create(#startKeypoints)

		for i = 1, #startKeypoints do
			local startKeypoint = startKeypoints[i]
			local targetKeypoint = targetKeypoints[i]

			local lerpedColor = Library.LerpColor3(startKeypoint.Value, targetKeypoint.Value, alpha)
			newKeypoints[i] = ColorSequenceKeypoint.new(startKeypoint.Time, lerpedColor)
		end

		uiGradient.Color = ColorSequence.new(newKeypoints)
	end)

	local tween = TweenService:Create( tweenValue, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Value = 1} )
	tween:Play()

	tween.Completed:Connect(function()
		connection:Disconnect()
		tweenValue:Destroy()
	end)

	return tween
end

function Library.GetChildrenOfClass(instance, class)
	local children = {}

	for _,__ in ipairs(instance:GetChildren()) do
		if __:IsA(class) then
			children[#children+1] = __
		end
	end

	return children
end

function Library.MakeResizable(frame, minSize)
	minSize = minSize or Vector2.new(50, 50)

	local resizeHandle = Instance.new("TextButton")
	resizeHandle.Size = UDim2.new(0, 10, 0, 10)
	resizeHandle.Position = UDim2.new(1, -10, 1, -10)
	resizeHandle.BackgroundTransparency = 1
	resizeHandle.Text = ""
	resizeHandle.Name = "handle"
	resizeHandle.ZIndex = 10
	resizeHandle.Parent = frame

	local dragging = false
	local dragStartPos
	local startSize

	local connections = {}

	table.insert(connections, resizeHandle.MouseButton1Down:Connect(function()
		dragging = true
		dragStartPos = InputService:GetMouseLocation()
		startSize = frame.Size
	end))

	table.insert(connections, InputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = InputService:GetMouseLocation()
			local delta = mousePos - dragStartPos

			local newWidth = startSize.X.Offset + delta.X
			local newHeight = startSize.Y.Offset + delta.Y

			newWidth = math.max(minSize.X, newWidth)
			newHeight = math.max(minSize.Y, newHeight)

			frame.Size = UDim2.new(0, newWidth, 0, newHeight)
		end
	end))

	table.insert(connections, InputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end))

	local function cleanup()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end

		if resizeHandle and resizeHandle.Parent then
			resizeHandle:Destroy()
		end
	end

	table.insert(connections, frame.AncestryChanged:Connect(function(_, newParent)
		if not newParent then
			cleanup()
		end
	end))

	return resizeHandle, cleanup
end



--[[ COMPONENT FUNCTIONS ]]----------------------------------------------------
function Library:AddKeypicker(Component)
	local Button
	
	if Component:FindFirstChild("Sub") then
		Button = Library.Create("TextButton", { Parent = Component.Sub, Name = [[Keypicker]], BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BorderColor3 = Color3.fromRGB(0, 0, 0), Text = "[ ... ]", FontFace = Library.Theme.Font, TextColor3 = Color3.fromRGB(205, 205, 205), BackgroundTransparency = 1,})
	else
		local Holder = Library.Create("Frame", { Parent = Component, Name = [[Sub]], AnchorPoint = Vector2.new(1, 0.5), BorderSizePixel = 0, Size = UDim2.new(0, 0, 0, 12), BorderColor3 = Color3.fromRGB(0, 0, 0), AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.new(1, 0, 0.5, 0), BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(255, 255, 255),})
		Library.Create("UIListLayout", { Parent = Holder, VerticalAlignment = Enum.VerticalAlignment.Center, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Right,})
		return Library:AddKeypicker(Component)
	end

	return Button
end

function Library:AddColorpicker(Component)
	local Button
	if Component:FindFirstChild("Sub") then
		Button = Library.Create("TextButton", { Parent = Component.Sub, Name = [[Colorpicker]], Active = false, BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Size = UDim2.new(0, 18, 1, 0), BorderColor3 = Color3.fromRGB(0, 0, 0), Text = [[]], Font = Enum.Font.SciFi, TextColor3 = Color3.fromRGB(170, 170, 170), Selectable = false,})
		Library.Create("UIStroke", { Parent = Button, Name = [[Border]], ApplyStrokeMode = Enum.ApplyStrokeMode.Border,})
		Library.Create("ImageLabel", { Parent = Button, Name = [[Alpha]], Image = [[rbxassetid://12977615774]], BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), BorderColor3 = Color3.fromRGB(0, 0, 0), ImageTransparency = 1, BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(255, 255, 255),})
	else
		local Holder = Library.Create("Frame", { Parent = Component, Name = [[Sub]], AnchorPoint = Vector2.new(1, 0.5), BorderSizePixel = 0, Size = UDim2.new(0, 0, 0, 12), BorderColor3 = Color3.fromRGB(0, 0, 0), AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.new(1, 0, 0.5, 0), BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(255, 255, 255),})
		Library.Create("UIListLayout", { Parent = Holder, VerticalAlignment = Enum.VerticalAlignment.Center, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Right,})
		return Library:AddColorpicker(Component)
	end
	return Button
end

--[[ CREATE UI ]]----------------------------------------------------
local Container = Interface.Container
local TabHolder = Container.Holder
local TabViewer = Container.Viewer

function Library:Window(...)
	local Window, Data = {}, {
		Title = "test",
		Size = UDim2.new(0,480,0,580),
		Position = UDim2.new(0.5,0,0.5,0),
		Anchor = Vector2.new(0,0),
		Resizable = true,
		Draggable = true,
		MinSize = Vector2.new(400,400),
	}; local cfg = Library.Overwrite(Data, ... or {})

	Interface.Parent = CoreGui

	Container.Title.FontFace = Library.Theme.Font
	Container.Title.Text = cfg.Title

	Container.Size = cfg.Size
	Container.Position = cfg.Position
	Container.AnchorPoint = cfg.Anchor

	if cfg.Draggable then Library.MakeDraggable(Container) end
	if cfg.Resizable then Library.MakeResizable(Container, Vector2.new(400, 400)) end

	function Window:Toggle()
		Interface.Container.Visible = not Interface.Container.Visible
	end

	function Window:Tab(...)
		local Tab, Data = {}, {
			Name = ""
		}; local cfg = Library.Overwrite(Data, ... or {})

		local TabButton = Components.TabButton:Clone()
		local TabFrame = Components.Tab:Clone()

		TabFrame.Parent = TabHolder
		TabButton.Parent = TabViewer
		TabButton.Label.Text = cfg.Name
		TabButton.Label.FontFace = Library.Theme.Font

		function Tab.Select()
			if Library.Selected and Library.Selected[1] and Library.Selected[1] ~= TabButton then
				local Button = Library.Selected[1]
				if Library.Selected[2] then Library.Selected[2].Visible = false end

				TweenService:Create(
					Button.Label,
					TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{TextColor3 = Library.Theme.Text.Unselected}
				):Play()

				Library.TweenGradient(Button.Inline.UIGradient, Library.Theme.Advanced["Tab Buttons"].Gradient_US, 0.1)
			end

			Library.Selected = { TabButton, TabFrame }

			TweenService:Create(
				TabButton.Label,
				TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{TextColor3 = Library.Theme.Text.Selected}
			):Play()

			Library.TweenGradient(TabButton.Inline.UIGradient, Library.Theme.Advanced["Tab Buttons"].Gradient_S, 0.1)
			TabFrame.Visible = true
			if Library.Opened then Library.Opened.SetVisible(false); Library.Opened.Open = false end
		end

		TabButton.MouseButton1Click:Connect(Tab.Select)

		function Tab:Section(...)
			local Section, Data = {}, {
				Name = "N/A",
				Side = "Left",
			}; local cfg = Library.Overwrite(Data, ... or {})

			local SectionFrame = Components.Section:Clone()
			SectionFrame.Parent = TabFrame[cfg.Side]

			SectionFrame.Title.Text = cfg.Name
			SectionFrame.Title.FontFace = Library.Theme.Font

			--[[ COMPONENTS ]]----------------------------------------------------
			do
				-- Toggle
				function Section:Toggle(...)
					local Toggle, Data = {}, {
						Name = "N/A",
						Default = true,
						Flag = string.format("%x%x%x%x%x", os.time(), tick() * 1000000, math.random(1, 1000000000), workspace:GetServerTimeNow() * 1000000, math.random(1, 1000000000)),
						Callback = function() end
					}; local cfg = Library.Overwrite(Data, ... or {})

					local Enabled = cfg.Default
					local ToggleFrame = Components.SectionStuff.Toggle:Clone()
					ToggleFrame.Parent = SectionFrame.Container

					ToggleFrame.Title.Text = cfg.Name
					ToggleFrame.Title.FontFace = Library.Theme.Font

					function Toggle.Hide() ToggleFrame.Visible = false end
					function Toggle.Show() ToggleFrame.Visible = true end

					function Toggle:Set(Value)
						if Value then
							Library.TweenGradient(ToggleFrame.Button.UIGradient, Library.Theme.Advanced["Toggles"].Gradient_S, 0.1)
							TweenService:Create(ToggleFrame.Title, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
						else
							Library.TweenGradient(ToggleFrame.Button.UIGradient, Library.Theme.Advanced["Toggles"].Gradient_US, 0.1)
							TweenService:Create(ToggleFrame.Title, TweenInfo.new(0.1), {TextColor3 = Library.Theme.Text.Unselected}):Play()
						end

						Library.Flags[cfg.Flag] = Value
						local Callback = cfg.Callback
						Callback(Value)
					end

					function Toggle:Keybind(...)
						local Keybind, Data = {}, {
							Key = nil,
						}; local cfg = Library.Overwrite(Data, ... or {})

						local Button = Library:AddKeypicker(ToggleFrame)

						local Binding = false
						local CurrentKey = cfg.Key

						function Keybind.Hide() Button.Visible = false end
						function Keybind.Show() Button.Visible = true end

						local function UpdateText()
							if not CurrentKey then Button.Text = "[ ... ]" else
								local Text = (typeof(CurrentKey) == "EnumItem") and CurrentKey.Name or tostring(CurrentKey)
								Text = Text:gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
								Button.Text = ("[ %s ]"):format(Text)
							end
						end

						function Keybind:Set(Input)
							if typeof(Input) == "EnumItem" then
								if Input == Enum.KeyCode.Escape then CurrentKey = nil else CurrentKey = Input end
								UpdateText()
							end
						end

						Library.Connection(Button.MouseButton1Click, function()
							if Binding then return end

							Binding = true
							Button.Text = "..."

							local Connection
							Connection = InputService.InputBegan:Connect(function(Input, Processed)
								if Processed then return end

								Connection:Disconnect()
								Binding = false

								Keybind:Set(Input.KeyCode ~= Enum.KeyCode.Unknown and Input.KeyCode or Input.UserInputType)
							end)
						end)

						Library.Connection(InputService.InputBegan, function(Input, Processed)
							if Processed or not CurrentKey then return end
							
							local InputKey = Input.KeyCode ~= Enum.KeyCode.Unknown and Input.KeyCode or Input.UserInputType
							
							if InputKey == CurrentKey then
								Enabled = not Enabled
								Toggle:Set(Enabled)
							end
						end)

						if cfg.Key then Keybind:Set(cfg.Key) end
						
						for k,v in pairs(cfg) do Keybind[k] = v end	
						return setmetatable(Keybind, {__index = Toggle})
					end

					ToggleFrame.MouseButton1Click:Connect(function()
						Enabled = not Enabled
						Toggle:Set(Enabled)
					end)

					Toggle:Set(cfg.Default)

					for k,v in pairs(cfg) do Toggle[k] = v end	
					return setmetatable(Toggle, {__index = Section})
				end

				-- Slider
				function Section:Slider(...)
					local Slider, Data = {}, {
						Name = "N/A",
						Default = false,
						Callback = function() end,
						Suffix = "",
						Flag = string.format("%x%x%x%x%x", os.time(), tick() * 1000000, math.random(1, 1000000000), workspace:GetServerTimeNow() * 1000000, math.random(1, 1000000000)),

						Min = 0,
						Max = 0,
						Interval = 1
				 	}; local cfg = Library.Overwrite(Data, ... or {})

					local Dragging = false
					local Value = cfg.Default

					local SliderFrame = Components.SectionStuff.Slider:Clone()
					SliderFrame.Parent = SectionFrame.Container

					SliderFrame.Title.Text = cfg.Name

					SliderFrame.Title.FontFace = Library.Theme.Font
					SliderFrame.Holder.Holder.Inline.Amount.FontFace = Library.Theme.Font
					SliderFrame.Holder.Holder.Inline.Amount.ZIndex = 99
					SliderFrame.Holder.add.TextLabel.FontFace = Library.Theme.Font
					SliderFrame.Holder.take.TextLabel.FontFace = Library.Theme.Font

					function Slider.Hide() SliderFrame.Visible = false end
					function Slider.Show() SliderFrame.Visible = true end

					function Slider:Set(value)
						Value = math.clamp(Library.Round(value, cfg.Interval), cfg.Min, cfg.Max)
						
						TweenService:Create(SliderFrame.Holder.Holder.Inline, TweenInfo.new(0.05),{Size = UDim2.new((Value - cfg.Min) / (cfg.Max - cfg.Min), 0, 1, 0)}):Play()
						SliderFrame.Holder.Holder.Inline.Amount.Text = tostring(Value) .. cfg.Suffix
						
						Library.Flags[cfg.Flag] = Value
						local Callback = cfg.Callback
						Callback(Value)
					end

					Library.Connection(InputService.InputChanged, function(Input)
						if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
							local SizeX = (Input.Position.X - SliderFrame.Holder.AbsolutePosition.X) / SliderFrame.Holder.AbsoluteSize.X
							local Value = ((cfg.Max - cfg.Min) * SizeX) + cfg.Min
							Slider:Set(Value)
						end
					end)

					Library.Connection(InputService.InputEnded, function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 then
							Dragging = false
						end 
					end)
		
					SliderFrame.Holder.Holder.MouseButton1Down:Connect(function(X, Y)
						Dragging = true
						
						local SizeX = (X - SliderFrame.Holder.AbsolutePosition.X) / SliderFrame.Holder.AbsoluteSize.X
						local Value = ((cfg.Max - cfg.Min) * SizeX) + cfg.Min

						Slider:Set(Value)
					end)

					SliderFrame.Holder.add.MouseButton1Click:Connect(function() Slider:Set(Value + 1) end)
					SliderFrame.Holder.take.MouseButton1Click:Connect(function() Slider:Set(Value - 1) end)

					Slider:Set(cfg.Default)
	
					for k,v in pairs(cfg) do Slider[k] = v end
					return setmetatable(Slider, {__index = Section})
				end

				-- Label
				function Section:Label(...)
					local Label, Data = {}, {
						Text = "",
						Flag = string.format("%x%x%x%x%x", os.time(), tick() * 1000000, math.random(1, 1000000000), workspace:GetServerTimeNow() * 1000000, math.random(1, 1000000000)),
					}; local cfg = Library.Overwrite(Data, ... or {})

					local LabelFrame = Components.SectionStuff.Label:Clone()
					LabelFrame.Parent = SectionFrame.Container
					LabelFrame.Text = cfg.Text
					LabelFrame.FontFace = Library.Theme.Font

					function Label.Hide() LabelFrame.Visible = false end
					function Label.Show() LabelFrame.Visible = true end

					function Label:Set(text)
						LabelFrame.Text = text
						cfg.Text = text
					end

					function Label:Colorpicker(...)
						local Colorpicker, Data = {}, {
							Name = "",
							Default = Color3.fromRGB(255,255,255),
							Alpha = 0,
							Callback = function() end,
							Flag = string.format("%x%x%x%x%x", os.time(), tick() * 1000000, math.random(1, 1000000000), workspace:GetServerTimeNow() * 1000000, math.random(1, 1000000000)),
						}; local cfg = Library.Overwrite(Data, ... or {})
						
						Colorpicker.Open = false
						local ColorpickerButton = Library.AddColorpicker(self, LabelFrame)
						local ColorpickerFrame = Components.SectionStuff.Colorpicker:Clone()
						ColorpickerFrame.Parent = Interface
						ColorpickerFrame.Visible = false
					
						local AlphaBar = ColorpickerFrame.AlphaBar
						local ColorBar = ColorpickerFrame.HSVBar
						local ColorMap = ColorpickerFrame.ColorMap
					
						local AlphaDragging, HSVDragging, MapDragging = false, false, false
					
						local AlphaBarValue = cfg.Alpha
						local ColorBarValue = 0
						local ColorMapValue = { X = 0, Y = 0 }
					
						local H, S, V = cfg.Default:ToHSV()
					
						ColorMap.Marker.Position = UDim2.fromScale(S, 1-V)
						ColorMap.Marker.AnchorPoint = Vector2.new(S, 1-V)
						ColorMap.Sat.UIGradient.Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromHSV(0,0,1));
							ColorSequenceKeypoint.new(1, Color3.fromHSV(H, 1, 1));
						})
					
						ColorBar.Marker.Position = UDim2.fromScale(0, 1-H)
						ColorBar.Marker.AnchorPoint = Vector2.new(0, 1-H)
					
						AlphaBar.Marker.Position = UDim2.fromScale(cfg.Alpha, 0)
						AlphaBar.Marker.AnchorPoint = Vector2.new(cfg.Alpha, 0)
					
						AlphaBar.Frame.BackgroundColor3 = cfg.Default
						ColorpickerButton.BackgroundColor3 = cfg.Default

						ColorpickerFrame.Position = UDim2.fromOffset(
                            (Container.AbsolutePosition.X + Container.AbsoluteSize.X) + 130, Container.AbsolutePosition.Y + 108)
						
						Container:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
							ColorpickerFrame.Position = UDim2.fromOffset(
								(Container.AbsolutePosition.X + Container.AbsoluteSize.X) + 130, Container.AbsolutePosition.Y + 108)
						end)

						Container:GetPropertyChangedSignal("Size"):Connect(function()
							ColorpickerFrame.Position = UDim2.fromOffset(
								(Container.AbsolutePosition.X + Container.AbsoluteSize.X) + 130, Container.AbsolutePosition.Y + 108)
						end)

						function Colorpicker.SetVisible(bool : boolean)
							ColorpickerFrame.Visible = bool
	
							if bool then
								if Library.Opened and Library.Opened ~= Colorpicker then
									Library.Opened.SetVisible(false)
									Library.Opened.Open = false
								end
								Library.Opened = Colorpicker
							end
						end
	

						local function GetKeypointValue(sequence, time)
							if time == 0 then
								return sequence.Keypoints[1].Value
							elseif time == 1 then
								return sequence.Keypoints[#sequence.Keypoints].Value
							end
						
							for i = 1, #sequence.Keypoints - 1 do
								local thisKeypoint = sequence.Keypoints[i]
								local nextKeypoint = sequence.Keypoints[i + 1]
								if time >= thisKeypoint.Time and time < nextKeypoint.Time then
									local alpha = (time - thisKeypoint.Time) / (nextKeypoint.Time - thisKeypoint.Time)
									return Color3.new(
										(nextKeypoint.Value.R - thisKeypoint.Value.R) * alpha + thisKeypoint.Value.R,
										(nextKeypoint.Value.G - thisKeypoint.Value.G) * alpha + thisKeypoint.Value.G,
										(nextKeypoint.Value.B - thisKeypoint.Value.B) * alpha + thisKeypoint.Value.B
									)
								end
							end
						end
					
						local function UpdateColor(HSV, Alpha)
							AlphaBarValue = AlphaBar.Marker.Position.X.Scale
							ColorBarValue = ColorBar.Marker.Position.Y.Scale
							ColorMapValue = {
								X = ColorMap.Marker.Position.X.Scale,
								Y = ColorMap.Marker.Position.Y.Scale
							}
							
							if HSV then ColorpickerButton.BackgroundColor3 = HSV end
							if Alpha ~= nil then ColorpickerButton.Alpha.ImageTransparency = Alpha end
							AlphaBar.Frame.BackgroundColor3 = HSV or cfg.Default
							
							local color = HSV or cfg.Default
							local alpha = Alpha or cfg.Alpha
							
							Colorpicker.Value = color
							Colorpicker.Alpha = alpha
							
							cfg.Callback(color, alpha)
							Library.Flags[cfg.Flag] = {color, alpha}
						end
						
						InputService.InputBegan:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								if ColorMap.GuiState == Enum.GuiState.Press then 
									MapDragging = true 
								elseif ColorBar.GuiState == Enum.GuiState.Press then 
									HSVDragging = true 
								elseif AlphaBar.GuiState == Enum.GuiState.Press then 
									AlphaDragging = true 
								end
							end
						end)
					
						InputService.InputEnded:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseButton1 then
								MapDragging = false
								HSVDragging = false
								AlphaDragging = false
							end
						end)
					
						InputService.InputChanged:Connect(function(Input)
							if Input.UserInputType == Enum.UserInputType.MouseMovement then
								if MapDragging then
									local AbsPos = ColorMap.AbsolutePosition
									local AbsSize = ColorMap.AbsoluteSize
							
									local RelativeMouseX = math.clamp(((Mouse.X - AbsPos.X) / AbsSize.X), 0, 1)
									local RelativeMouseY = math.clamp(((Mouse.Y - AbsPos.Y) / AbsSize.Y), 0, 1)
							
									ColorMap.Marker.Position = UDim2.fromScale(RelativeMouseX,RelativeMouseY)
									ColorMap.Marker.AnchorPoint = Vector2.new(RelativeMouseX,RelativeMouseY)
							
									local Color = {GetKeypointValue(ColorMap.Sat.UIGradient.Color, RelativeMouseX):ToHSV()}
									local Value = {GetKeypointValue(ColorMap.Val.UIGradient.Color, RelativeMouseY):ToHSV()}
									ColorMapValue.X = RelativeMouseX
									ColorMapValue.Y = RelativeMouseY
							
									UpdateColor(Color3.fromHSV(Color[1], Color[2], Value[3]), nil)
								elseif HSVDragging then
									local AbsPos = ColorBar.AbsolutePosition
									local AbsSize = ColorBar.AbsoluteSize
							
									local RelativeMouseY = math.clamp(((Mouse.Y - AbsPos.Y) / AbsSize.Y), 0, 1)
							
									ColorBar.Marker.Position = UDim2.fromScale(0.5,RelativeMouseY)
									ColorBar.Marker.AnchorPoint = Vector2.new(0.5,RelativeMouseY)
							
									local Color = GetKeypointValue(ColorBar.UIGradient.Color, RelativeMouseY)
							
									ColorMap.Sat.UIGradient.Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, Color3.fromHSV(0,0,1));
										ColorSequenceKeypoint.new(1, Color);
									})
							
									ColorBarValue = RelativeMouseY
							
									local Color = {GetKeypointValue(ColorMap.Sat.UIGradient.Color, ColorMapValue.X):ToHSV()}
									local Value = {GetKeypointValue(ColorMap.Val.UIGradient.Color, ColorMapValue.Y):ToHSV()}
							
									UpdateColor(Color3.fromHSV(Color[1], Color[2], Value[3]), nil)
								elseif AlphaDragging then
									local AbsPos = AlphaBar.AbsolutePosition
									local AbsSize = AlphaBar.AbsoluteSize
							
									local RelativeMouseY = math.clamp(((Mouse.Y - AbsPos.Y) / AbsSize.Y), 0, 1)
							
									AlphaBar.Marker.Position = UDim2.fromScale(0.5,RelativeMouseY)
									AlphaBar.Marker.AnchorPoint = Vector2.new(0.5,RelativeMouseY)
							
									AlphaBarValue = 1 - RelativeMouseY
									local Color = {GetKeypointValue(ColorMap.Sat.UIGradient.Color, ColorMapValue.X):ToHSV()}
									local Value = {GetKeypointValue(ColorMap.Val.UIGradient.Color, ColorMapValue.Y):ToHSV()}
							
									UpdateColor(Color3.fromHSV(Color[1], Color[2], Value[3]), AlphaBarValue)
								end
							end
						end)
					
						function Colorpicker:GetValue()
							return Colorpicker.Value, Colorpicker.Alpha
						end
					
						function Colorpicker:SetValue(Color, Alpha)
							local H, S, V = Color:ToHSV()
							
							ColorMap.Marker.Position = UDim2.fromScale(S, 1-V)
							ColorMap.Marker.AnchorPoint = Vector2.new(S, 1-V)
							
							ColorMap.Sat.UIGradient.Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromHSV(0,0,1));
								ColorSequenceKeypoint.new(1, Color3.fromHSV(H, 1, 1));
							})
							
							ColorBar.Marker.Position = UDim2.fromScale(0, 1-H)
							ColorBar.Marker.AnchorPoint = Vector2.new(0, 1-H)
							
							if Alpha then
								AlphaBar.Marker.Position = UDim2.fromScale(Alpha, 0)
								AlphaBar.Marker.AnchorPoint = Vector2.new(Alpha, 0)
							end
							
							UpdateColor(Color, Alpha)
						end
						
						UpdateColor(cfg.Default, cfg.Alpha)

						ColorpickerButton.MouseButton1Click:Connect(function()
							Colorpicker.Open = not Colorpicker.Open
							Colorpicker.SetVisible(Colorpicker.Open)
						end)
						
						for k,v in pairs(cfg) do 
							Colorpicker[k] = v 
						end
						
						return setmetatable(Colorpicker, {__index = Label})
					end

					function Label:Keybind(...)
						local Keybind, Data = {}, {
							Key = nil,
							Callback = function() end,
							Flag = string.format("%x%x%x%x%x", os.time(), tick() * 1000000, math.random(1, 1000000000), workspace:GetServerTimeNow() * 1000000, math.random(1, 1000000000)),
						}; local cfg = Library.Overwrite(Data, ... or {})

						local Button = Library:AddKeypicker(LabelFrame)

						local Binding = false
						local CurrentKey = cfg.Key

						function Keybind.Hide() Button.Visible = false end
						function Keybind.Show() Button.Visible = true end

						local function UpdateText()
							if not CurrentKey then Button.Text = "[ ... ]" else
								local Text = (typeof(CurrentKey) == "EnumItem") and CurrentKey.Name or tostring(CurrentKey)
								Text = Text:gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
								Button.Text = ("[ %s ]"):format(Text)
							end
						end

						function Keybind:Set(Input)
							if typeof(Input) == "EnumItem" then
								if Input == Enum.KeyCode.Escape then CurrentKey = nil else CurrentKey = Input end
								UpdateText()
								Library.Flags[cfg.Flag] = CurrentKey
							end
						end

						Library.Connection(Button.MouseButton1Click, function()
							if Binding then return end

							Binding = true
							Button.Text = "..."

							local Connection
							Connection = InputService.InputBegan:Connect(function(Input, Processed)
								if Processed then return end

								Connection:Disconnect()
								Binding = false

								Keybind:Set(Input.KeyCode ~= Enum.KeyCode.Unknown and Input.KeyCode or Input.UserInputType)
							end)
						end)

						Library.Connection(InputService.InputBegan, function(Input, Processed)
							if Processed or not CurrentKey then return end
							
							local InputKey = Input.KeyCode ~= Enum.KeyCode.Unknown and Input.KeyCode or Input.UserInputType
							if InputKey == CurrentKey then
								cfg.Callback()
							end
						end)

						if cfg.Key then Keybind:Set(cfg.Key) end
						
						for k,v in pairs(cfg) do Keybind[k] = v end	
						return setmetatable(Keybind, {__index = Label})
					end

					for k,v in pairs(cfg) do Label[k] = v end
					return setmetatable(Label, {__index = Section})
				end

				function Section:Divider()
					local Divider = {}
					local DividerFrame = Components.SectionStuff.Divider:Clone()
					DividerFrame.Parent = SectionFrame.Container

					function Divider.Hide() DividerFrame.Visible = false end
					function Divider.Show() DividerFrame.Visible = true end

					return Divider
				end

				function Section:Dropdown(...)
					local Dropdown, Data = {}, {
						Values = {},
						Flag = string.format("%x%x%x%x%x", os.time(), tick() * 1000000, math.random(1, 1000000000), workspace:GetServerTimeNow() * 1000000, math.random(1, 1000000000)),
						Name = "N/A",
						Default = 1,
						Multi = false,
						Callback = function() end
					}; local cfg = Library.Overwrite(Data, ... or {})
					Dropdown.Open = false
					Dropdown.Selected = nil

					local DropdownFrame = Components.SectionStuff.Dropdown:Clone()
					local DropdownOptions = DropdownFrame.Options

					DropdownOptions.Parent = Interface
					DropdownFrame.Parent = SectionFrame.Container
					
					DropdownOptions.Selection.FontFace = Library.Theme.Font
					DropdownFrame.Title.FontFace = Library.Theme.Font
					DropdownFrame.List:FindFirstChild("Selected").FontFace = Library.Theme.Font

                    DropdownOptions.Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X,0,0)
                    DropdownOptions.Position = UDim2.new(0, DropdownFrame.AbsolutePosition.X, 0, DropdownFrame.AbsolutePosition.Y + DropdownFrame.AbsoluteSize.Y + 4)

					function Dropdown.Hide() DropdownFrame.Visible = false; Dropdown.SetVisible(false) end
					function Dropdown.Show() DropdownFrame.Visible = true end

					function Dropdown.SetVisible(bool : boolean)
						DropdownOptions.Visible = bool

						if bool then
							if Library.Opened and Library.Opened ~= Dropdown then
								Library.Opened.SetVisible(false)
								Library.Opened.Open = false
							end
							Library.Opened = Dropdown
						end
					end

					for _, Option in cfg.Values do
						if type(Option) == 'string' then
							-- local OptionSelected = false
							local OptionButton = DropdownOptions.Selection:Clone()
							OptionButton.Parent = DropdownOptions
							OptionButton.Visible = true
							OptionButton.Text = Option

							OptionButton.MouseButton1Click:Connect(function()
								if not cfg.Multi then
									for _, Button in ipairs(Library.GetChildrenOfClass(DropdownOptions, 'TextButton')) do
										TweenService:Create(Button, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(180,180,180)}):Play()
									end
								end

								TweenService:Create(OptionButton, TweenInfo.new(0.1), {TextColor3 = Library.Theme.Text.Selected}):Play()
								Dropdown.Selected = Option
								DropdownFrame.List:FindFirstChild("Selected").Text = Option

								cfg.Callback(Dropdown.Selected)
								Library.Flags[cfg.Flag] = Dropdown.Selected
							end)
						end
					end

					DropdownFrame.List.MouseButton1Click:Connect(function()
						Dropdown.Open = not Dropdown.Open
						Dropdown.SetVisible(Dropdown.Open)
					end)

					Container:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
						DropdownOptions.Position = UDim2.new(0, DropdownFrame.AbsolutePosition.X, 0, DropdownFrame.AbsolutePosition.Y + DropdownFrame.AbsoluteSize.Y + 4)
					end)

					Container:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						DropdownOptions.Size = UDim2.new(0, DropdownFrame.AbsoluteSize.X, 0, 0)
					end)

					for k,v in pairs(cfg) do Dropdown[k] = v end
					return setmetatable(Dropdown, {__index = Section})
				end

				function Section:Button(...)
					local Button, Data = {}, {
						Text = "",
						Callback = function() end
					}; local cfg = Library.Overwrite(Data, ... or {})

					local ButtonFrame = Components.SectionStuff.Button:Clone()
					ButtonFrame.Parent = SectionFrame.Container
					ButtonFrame.FontFace = Library.Theme.Font
					ButtonFrame.Text = cfg.Text

					function Button.Hide() ButtonFrame.Visible = false end
					function Button.Show() ButtonFrame.Visible = true end

					ButtonFrame.MouseEnter:Connect(function()
						TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {TextColor3 = Library.Theme.Text.Selected}):Play()
					end)

					ButtonFrame.MouseLeave:Connect(function()
						TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {TextColor3 = Library.Theme.Text.Unselected}):Play()
					end)

					ButtonFrame.MouseButton1Click:Connect(function() cfg.Callback() end)

					for k,v in pairs(cfg) do Button[k] = v end
					return setmetatable(Button, {__index = Section})
				end

			end

			for k,v in pairs(cfg) do Section[k] = v end
			return setmetatable(Section, {__index = Tab})
		end

		for k, v in pairs(cfg) do Tab[k] = v end
		return setmetatable(Tab, {__index = Window})
	end

	for k, v in pairs(cfg) do Window[k] = v end
	return setmetatable(Window, {__index = Library})
end

return Library

-- local Window = Library:Window({ Title = "monolith", })
-- local Tabs = {
-- 	Combat = Window:Tab({ Name = "Example Tab" }),
-- 	Combat2 = Window:Tab({ Name = "Example Tab 2" })
-- }; Tabs.Combat.Select()

-- local ExampleSec1 = Tabs.Combat:Section({ Name = "Example Section", Side = "Left" })
-- ExampleSec1:Dropdown({ Name = "Example Dropdown", Values = {"Head", "Torso", "Balls"}, Callback = function(v) print(v) end })
-- local dropdown = ExampleSec1:Dropdown({ Name = "Example Dropdown 2", Values = {"1", "2", "3", "4", "5", "6", "7", "8", "9"}, Callback = function(v) print(v) end })
-- ExampleSec1:Divider()
-- local test = ExampleSec1:Label({ Text = "this is a TEXT LABELL!!!" })
-- test:Colorpicker()
-- test:Colorpicker()
-- ExampleSec1:Toggle({ Text = "this is a toggle", Default = true, Callback = function(v) print(v) end })
-- ExampleSec1:Toggle({ Text = "keybind toggle", Default = true, Callback = function(v) if v then dropdown.Hide() else dropdown.Show() end end }):Keybind()
-- ExampleSec1:Divider()
-- ExampleSec1:Label({ Text = "keybind toggle" }):Keybind({ Callback = function() print("keybind!!!") end})
-- ExampleSec1:Slider({ Name = "uhm some slider lol", Default = 100, Max = 100, Min = 0, Suffix = "%" })
-- ExampleSec1:Button({ Text = "button", Callback = function() print("clicked") end })