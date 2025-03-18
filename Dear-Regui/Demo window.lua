--// Import ReGui
local ReGui = require(game.ReplicatedStorage.ReGui)
ReGui:Init({
	--Debug = true,
	--Prefabs = game.StarterGui["ReGui-Prefabs"]
})

do --// Tabs window demo
	local Window = ReGui:TabsWindow({
		Title = "Tabs window demo!",
		Size = UDim2.fromOffset(300, 200)
	})

	local Names = {"Avocado", "Broccoli", "Cucumber"}
	for _, Name in next, Names do
		local Tab = Window:CreateTab({Name=Name})
		Tab:Label({
			Text = `This is the {Name} tab!`
		})
	end
end

do --// Watermark demo
	local Watermark = ReGui.Elements:Canvas({
		Parent = ReGui.Container.Windows,
		Position = UDim2.fromOffset(10,10),
		Size = UDim2.fromOffset(250, 50),

		CornerRadius = UDim.new(0, 2),
		Border = true,
		BorderThickness = 1,
		BorderColor = Color3.fromRGB(91, 91, 91),
		BackgroundTransparency = 0.4,
		BackgroundColor3 = Color3.fromRGB(39, 39, 39),
	})

	local StatsRow = Watermark:Row({
		Spacing = 10
	})

	local FPSLabel = StatsRow:Label()
	local TimeLabel = Watermark:Label()

	game:GetService("RunService").RenderStepped:Connect(function(Delta)
		local FPS = math.round(1/Delta)
		local TimeString = DateTime.now():FormatLocalTime("dddd h:mm:ss A", "en-us")

		FPSLabel.Text = `FPS: {FPS}`
		TimeLabel.Text = `The time is {TimeString}`
	end)
end

--// Demo Window
local Window = ReGui:Window({
	Title = "Dear ReGui Demo",
	Size = UDim2.new(0, 400, 0, 300),
}):Center()

Window:Label({
	Text = `Dear ReGui says hello! ({ReGui:GetVersion()})`
})

print(Window.ParentCanvas)

local Help = Window:CollapsingHeader({
	Title = "Help"
})

Help:Separator({
	Text = "ABOUT THIS DEMO:"	
})
Help:BulletText({
	Rows = {
		"Sections below are demonstrating many aspects of the library.",
	}
})

Help:Separator({
	Text = "PROGRAMMER GUIDE:"	
})
Help:BulletText({
	Rows = {
		"See example FAQ, examples, and documentation at https://depso.gitbook.io/regui",
	}
})
Help:Indent():BulletText({
	Rows = {
		"See example applications in the /examples folder.",
	}
})

local ConfigurationHeader = Window:CollapsingHeader({
	Title = "Configuration"
})

local Style = ConfigurationHeader:TreeNode({
	Title = "Style"
})
Style:Combo({
	Selected = "DarkTheme",
	Label = "Theme",
	Items = ReGui.ThemeConfigs,
	Callback = function(self, Name)
		Window:SetTheme(Name)
	end,
})

Style:Separator({
	Text = "Color controls:"
})

local Row = Style:Row()
Row:Button({
	Text = "Refresh colors",
	Callback = function()
		Window:SetTheme()
		print("Elements:", Window.ElementsList)
	end,
})

local WindowOptions = Window:CollapsingHeader({
	Title = "Window options"
}):Table({
	MaxColumns = 3 -- Per row
}):NextRow()

local Options = {
	NoResize = false,
	NoTitleBar = false,
	NoClose = false,
	NoCollapse = false,
	--NoTabsBar = false, --:TabsWindow only
	OpenOnDoubleClick = true,
	NoBringToFrontOnFocus = false,
	NoMove = false,
	NoSelect = false,
	NoScrollBar = false,
	NoBackground = false
}

for Key, Value in pairs(Options) do
	local Column = WindowOptions:NextColumn()

	Column:Checkbox({
		Value = Value,
		Label = Key,
		Callback = function(self, Value)
			Window:UpdateConfig({
				[Key] = Value
			})
		end,
	})
end

local Widgets = Window:CollapsingHeader({
	Title = "Widgets"
})

local DemosOrder = {
	"Basic", 
	"Tooltips", 
	"Tree Nodes", 
	"Collapsing Headers",
	"Bullets",
	"Text",
	"Images",
	"Videos",
	"Combo", 
	"Tabs", 
	"Plot widgets", 
	"Multi-component Widgets",
	"Progress Bars",
	"Picker Widgets",
	"Console",
	"List",
	--"Selectable", 
	--"Group", 
	"Indent", 
	"Viewport", 
	"Keybinds", 
	"Input",
	"Text Input", 
}

local WidgetDemos = {
	["Basic"] = function(Header)
		--// General
		Header:Separator({Text="General"})

		local Row = Header:Row()
		local Label = Row:Label({
			Text = "Thanks for clicking me!",
			Visible = false,
			LayoutOrder = 2
		})
		Row:Button({
			Callback = function()
				Label.Visible = not Label.Visible
			end,
		})

		Header:Checkbox()

		local RadioRow = Header:Row()
		RadioRow:Radiobox({Label="radio a"})
		RadioRow:Radiobox({Label="radio b"})
		RadioRow:Radiobox({Label="radio c"})

		local ButtonsRow = Header:Row()
		for i = 1,7 do
			local Hue = i / 7.0
			ButtonsRow:Button({
				Text = "Click",
				BackgroundColor3 = Color3.fromHSV(Hue, 0.6, 0.6)
			})
		end

		local Tooltip = Header:Button({
			Text = "Tooltip"
		})

		ReGui:SetItemTooltip(Tooltip, function(Canvas)
			Canvas:Label({
				Text = "I am a tooltip"
			})
		end)

		--// Inputs
		Header:Separator({Text="Inputs"})

		Header:InputText({
			Value = "Hello world!"
		})
		Header:InputText({
			Placeholder = "Enter text here",
			Label = "Input text (w/ hint)",
			Value = "Hello world!"
		})
		Header:InputInt({
			Value = 50,
		})
		Header:InputInt({
			Label = "Input Int (w/ limit)",
			Value = 5,
			Maximum = 10,
			Minimum = 1
		})

		--// Drags
		Header:Separator({Text="Drags"})

		Header:DragInt()

		Header:DragInt({
			Maximum = 100,
			Minimum = 0,
			Label = "Drag Int 0..100",
			Format = "%d%%"
		})

		Header:DragFloat({
			Maximum = 1,
			Minimum = 0,
			Value = 0.5
		})

		--// Sliders
		Header:Separator({Text="Sliders"})

		Header:SliderInt({
			Format = "%.d/%s",
			Value = 5,
			Minimum = 1,
			Maximum = 32,
			ReadOnly = false,
		}):SetValue(8)

		Header:SliderInt({
			Label = "Slider Int (w/ snap)",
			Value = 1,
			Minimum = 1,
			Maximum = 8,
			Type = "Snap"
		})

		Header:SliderFloat({
			Label = "Slider Float", 
			Minimum = 0.0, 
			Maximum = 1.0, 
			Format = "Ratio = %.3f"
		})

		Header:SliderFloat({
			Label = "Slider Angle", 
			Minimum = -360, 
			Maximum = 360, 
			Format = "%.f deg"
		})

		Header:SliderEnum({
			Items = {"Fire", "Earth", "Air", "Water"},
			Value = 2,
		})

		Header:SliderEnum({
			Items = {"Fire", "Earth", "Air", "Water"},
			Value = 2,
			Disabled = true,
			Label = "Disabled Enum"
		})

		Header:SliderProgress({
			Label = "Progress Slider",
			Value = 8,
			Minimum = 1,
			Maximum = 32,
		})

		--// Selectors/Pickers
		Header:Separator({Text="Selectors/Pickers"})

		Header:InputColor3({
			Value = ReGui.Accent.Light,
			Label = "Color 1",
			--Callback = print
		})

		Header:SliderColor3({
			Value = ReGui.Accent.Light,
			Label = "Color 2"
		})

		Header:InputCFrame({
			Value = CFrame.new(1,1,1),
			Minimum = CFrame.new(0,0,0),
			Maximum = CFrame.new(200, 100, 50),
			Label = "CFrame 1",
			--Callback = print
		})

		Header:SliderCFrame({
			Value = CFrame.new(1,1,1),
			Minimum = CFrame.new(0,0,0),
			Maximum = CFrame.new(200, 100, 50),
			Label = "CFrame 2"
		})

		Header:Combo({
			Selected = 1,
			Items = {
				"AAAA", 
				"BBBB", 
				"CCCC", 
				"DDDD", 
				"EEEE", 
				"FFFF", 
				"GGGG", 
				"HHHH", 
				"IIIIIII", 
				"JJJJ", 
				"KKKKKKK"
			}
		})
	end,
	["Tooltips"] = function(Header)
		--// General
		Header:Separator({Text="General"})
		
		--// Basic
		local Basic = Header:Button({
			Text = "Basic",
			Size = UDim2.fromScale(1, 0)
		})
		ReGui:SetItemTooltip(Basic, function(Canvas)
			Canvas:Label({
				Text = "I am a tooltip"
			})
		end)
		
		--// Fancy
		local Fancy = Header:Button({
			Text = "Fancy",
			Size = UDim2.fromScale(1, 0)
		})
		ReGui:SetItemTooltip(Fancy, function(Canvas)
			Canvas:Label({
				Text = "I am a fancy tooltip"
			})
			Canvas:Image({
				Image = 18395893036
			})

			local Time = Canvas:Label()
			while wait() do
				Time.Text = `Sin(time) = {math.sin(tick())}`
			end
		end)
		
		--// Double
		local Fancy = Header:Button({
			Text = "Double tooltip",
			Size = UDim2.fromScale(1, 0)
		})
		for i = 1,3 do
			ReGui:SetItemTooltip(Fancy, function(Canvas)
				Canvas:Label({
					Text = `I am tooltip {i}`
				})
			end)
		end
	end,
	["Videos"] = function(Header)
		local Video = Header:VideoPlayer({
			Video = 5608327482,
			Looped = true,
			Ratio = 16 / 9,
			RatioAspectType = Enum.AspectType.FitWithinMaxSize,
			RatioAxis = Enum.DominantAxis.Width,
			Size = UDim2.fromScale(1, 1)
		})
		Video:Play()

		local Controls = Header:Row({
			Expanded = true
		})
		Controls:Button({
			Text = "Pause",
			Callback = function()
				Video:Pause()
			end,
		})
		Controls:Button({
			Text = "Play",
			Callback = function()
				Video:Play()
			end,
		})

		--// Wait for the video to load
		if not Video.IsLoaded then 
			Video.Loaded:Wait()
		end

		local TimeSlider = Controls:SliderInt({
			Format = "%.f",
			Value = 0,
			Minimum = 0,
			Maximum = Video.TimeLength,
			Callback = function(self, Value)
				Video.TimePosition = Value
			end,
		})

		game:GetService("RunService").RenderStepped:Connect(function(Delta)
			TimeSlider:SetValue(Video.TimePosition)
		end)
	end,
	["Tree Nodes"] = function(Header)
		for i = 1,5 do
			local Tree = Header:TreeNode({
				Title = `Child {i}`,
				Collapsed = i ~= 1
			})

			local Row = Tree:Row()
			Row:Label({Text="Blah blah"})
			Row:SmallButton({Text="Button"})
		end
		
		Header:TreeNode({
			Title = `With icon & NoArrow`,
			NoArrow = true,
			Icon = ReGui.Icons.Image,
		})
	end,
	["Collapsing Headers"] = function(Header)
		local Second

		Header:Checkbox({
			Value = true,
			Label = "Show 2nd header",
			Callback = function(self, Value)
				if Second then 
					Second:SetVisible(Value)
				end
			end,
		})
		Header:Checkbox({
			Value = true,
			Label = "2nd has arrow",
			Callback = function(self, Value)
				if Second then 
					Second:SetArrowVisible(Value)
				end
			end,
		})

		local First = Header:CollapsingHeader({
			Title = "Header",
		})
		for i = 1, 5 do 
			First:Label({Text=`Some content {i}`})
		end

		Second = Header:CollapsingHeader({
			Title = "Second Header",
		})

		for i = 1, 5 do 
			Second:Label({Text=`More content {i}`})
		end
	end,
	["Bullets"] = function(Header)
		Header:BulletText({
			Rows = {
				"Bullet point 1",
				"Bullet point 2\nOn multiple lines",
			}
		})

		Header:TreeNode():BulletText({
			Rows = {"Another bullet point"}
		})

		Header:Bullet():Label({
			Text = "Bullet point 3 (two calls)"
		})

		Header:Bullet():SmallButton()
	end,
	["Text"] = function(Header)
		local Colorful = Header:TreeNode({Title="Colorful Text"})
		Colorful:Label({
			TextColor3 = Color3.fromRGB(255, 0, 255),
			Text = "Pink",
			NoTheme = true
		})
		Colorful:Label({
			TextColor3 = Color3.fromRGB(255, 255, 0),
			Text = "Yellow",
			NoTheme = true
		})
		Colorful:Label({
			TextColor3 = Color3.fromRGB(59, 59, 59),
			Text = "Disabled",
			NoTheme = true
		})

		local Wrapping = Header:TreeNode({Title="Word Wrapping"})
		Wrapping:Label({
			Text = [[This text should automatically wrap on the edge of the window. The current implementation for text wrapping follows simple rules suitable for English and possibly other languages.]],
			TextWrapped = true
		})

		local Paragraph

		Wrapping:SliderInt({
			Label = "Wrap width",
			Value = 400,
			Minimum = 20,
			Maximum = 600,
			Callback = function(self, Value)
				if not Paragraph then return end
				Paragraph.Size = UDim2.fromOffset(Value, 0)
			end,
		})

		Wrapping:Label({Text="Test paragraph:"})
		Paragraph = Wrapping:Label({
			Text = [[The lazy dog is a good dog. This paragraph should fit. Testing a 1 character word. The quick brown fox jumps over the lazy dog.]],
			TextWrapped = true,
			Border = true,
			BorderColor = Color3.fromRGB(255, 255, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromOffset(400, 0)
		})
	end,
	["Images"] = function(Header)
		Header:Label({
			TextWrapped = true,
			Text="Below we are displaying the icons (which are the ones builtin to ReGui in this demo). Hover the texture for a zoomed view!"
		})
		Header:Label({
			TextWrapped = true,
			Text=`There is a total of {ReGui:GetDictSize(ReGui.Icons)} icons in this demo!`
		})

		local List = Header:List({
			Border = true
		})

		local TooltipLabel 
		local TooltipImage

		--// Asign Tooltip to image for displaying the Icon name
		ReGui:SetItemTooltip(List, function(Canvas)
			TooltipLabel = Canvas:Label()
			TooltipImage = Canvas:Image({
				Size = UDim2.fromOffset(50,50)
			})
		end)

		for Name, ImageUrl in ReGui.Icons do
			--// Create the Image object
			local Image = List:Image({
				Image = ImageUrl,
				Size = UDim2.fromOffset(30, 30)
			})

			ReGui:DetectHover(Image, {
				MouseEnter = true,
				OnInput = function()
					TooltipLabel.Text = Name
					TooltipImage.Image = ImageUrl
				end,
			})
		end
	end,
	["Tabs"] = function(Header)
		--// Basic
		local Basic = Header:TreeNode({Title="Basic"})
		local TabSelector = Basic:TabSelector()

		local Names = {"Avocado", "Broccoli", "Cucumber"}
		for _, Name in next, Names do
			TabSelector:CreateTab({Name=Name}):Label({
				Text = `This is the {Name} tab!\nblah blah blah blah blah`
			})
		end

		--// Advanced 
		local Advanced = Header:TreeNode({Title="Advanced & Close Button"})
		local TabSelector = Advanced:TabSelector()

		local Names = {"Artichoke", "Beetroot", "Celery", "Daikon"}

		for _, Name in next, Names do
			local Tab = TabSelector:CreateTab({
				Name = Name,
				Closeable = true
			})

			Tab:Label({
				Text = `This is the {Name} tab!\nblah blah blah blah blah`
			})
		end

		Advanced:Button({
			Text="Add tab",
			Callback = function()
				TabSelector:CreateTab({
					Closeable = true
				}):Label({
					Text = "I am an odd tab."
				})
			end,
		})
	end,
	["Plot widgets"] = function(Header)
		local Graph = Header:PlotHistogram({
			Points = {0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2}
		})

		Header:Button({
			Text = "Generate new graph",
			Callback = function()
				local Points = {}

				for I = 1, math.random(5, 10) do
					table.insert(Points, math.random(1, 10))
				end

				Graph:PlotGraph(Points)
			end,
		})
	end,
	["Multi-component Widgets"] = function(Header)
		Header:Separator({Text="2-wide"})

		Header:InputInt2({
			Value = {10, 50},
			Minimum = {0,0},
			Maximum = {20,100},
			Callback = function(self, Values)
				print("1:", Values[1], "2:", Values[2])
			end,
		})
		Header:SliderInt2()
		Header:SliderFloat2()
		Header:DragInt2()
		Header:DragFloat2()

		Header:Separator({Text="3-wide"})

		Header:InputInt3()
		Header:SliderInt3()
		Header:SliderFloat3()
		Header:DragInt3()
		Header:DragFloat3()

		Header:Separator({Text="4-wide"})

		Header:InputInt4()
		Header:SliderInt4()
		Header:SliderFloat4()
		Header:DragInt4()
		Header:DragFloat4()
	end,
	["Progress Bars"] = function(Header)
		local ProgressBar = Header:ProgressBar({
			Label = "Loading...",
			Value = 80
		})

		spawn(function()
			local Percentage = 0
			while wait(0.02) do
				Percentage += 1
				ProgressBar:SetPercentage(Percentage % 100)
			end
		end)
	end,
	["Picker Widgets"] = function(Header)
		--// Color pickers
		Header:Separator({Text="Color pickers"})
		Header:DragColor3({
			Value = ReGui.Accent.Light
		})
		Header:SliderColor3({
			Value = ReGui.Accent.Red
		})
		Header:InputColor3({
			Value = ReGui.Accent.Green
		})

		--// CFrame pickers
		Header:Separator({Text="CFrame pickers"})
		Header:DragCFrame({
			Value = CFrame.new(1,1,1),
			Minimum = CFrame.new(0,0,0),
			Maximum = CFrame.new(200, 100, 50),
		})
		Header:SliderCFrame()
		Header:InputCFrame()
	end,
	["Console"] = function(Header)
		--// Basic
		local Basic = Header:TreeNode({Title="Basic"})
		local BasicConsole = Basic:Console({
			ReadOnly = true,
			AutoScroll = true,
			MaxLines = 50
		})

		--// Advanced
		local Advanced = Header:TreeNode({Title="Advanced & RichText"})
		local AdvancedConsole = Advanced:Console({
			ReadOnly = true,
			AutoScroll = true,
			RichText = true,
			MaxLines = 50
		})

		--// Editor
		local Editor = Header:TreeNode({Title="Editor"})
		Editor:Console({
			Value = "print('Hello world!')",
			LineNumbers = true
		})

		coroutine.wrap(function()
			while wait() do
				local Date = DateTime.now():FormatLocalTime("h:mm:ss A", "en-us")

				AdvancedConsole:AppendText(
					`<font color="rgb(240, 40, 10)">[Random]</font>`, 
					math.random()
				)
				BasicConsole:AppendText(
					`[{Date}] Hello world!`
				)
			end
		end)()
	end,
	["Combo"] = function(Header)
		Header:Combo({
			WidthFitPreview = true,
			Label = "WidthFitPreview",
			Selected = 1,
			Items = {
				"AAAAAAAAAAAA",
				"BBB",
				"C",
			},
		})

		Header:Separator({Text="One-liner variants"})

		Header:Combo({
			Label = "Combo 1 (array)",
			Selected = 1,
			Items = {
				"AAAA", 
				"BBBB", 
				"CCCC", 
				"DDDD", 
				"EEEE", 
				"FFFF", 
				"GGGG", 
				"HHHH", 
				"IIIIIII", 
				"JJJJ", 
				"KKKKKKK"
			}
		})
		Header:Combo({
			Label = "Combo 1 (dict)",
			Selected = "AAA",
			Items = {
				AAA = "Apple",
				BBB = "Banana",
				CCC = "Orange",
			},
			Callback = print,
		})
		Header:Combo({
			Label = "Combo 2 (function)",
			Selected = 1,
			GetItems = function()
				return {
					"aaa",
					"bbb",
					"ccc",
				}
			end,
		})
	end,
	["Indent"] = function(Header)
		Header:Label({Text="This is not indented"})

		local Indent = Header:Indent({Offset=30})
		Indent:Label({Text="This is indented by 30 pixels"})

		local Indent2 = Indent:Indent({Offset=30})
		Indent2:Label({Text="This is indented by 30 more pixels"})
	end,
	["Viewport"] = function(Header)
		local Rig = ReGui:InsertPrefab("R15 Rig")

		local Viewport = Header:Viewport({
			Size = UDim2.new(1, 0, 0, 200),
			Clone = true, --// Otherwise will parent
			Model = Rig,
		})

		--// Fetch the new model from the viewport
		local Model = Viewport.Model
		Model:PivotTo(CFrame.new(0, -2.5, -5))

		--// Rotate the rig
		local RunService = game:GetService("RunService")
		RunService.RenderStepped:Connect(function(DeltaTime)
			local Rotation = CFrame.Angles(0, math.rad(30*DeltaTime), 0) 
			local Pivot = Model:GetPivot() * Rotation

			Model:PivotTo(Pivot)
		end)
	end,
	["List"] = function(Header)
		local List = Header:List()

		for i = 1, 10 do
			List:Button({Text=`Resize the window! {i}`})
		end
	end,
	["Keybinds"] = function(Header)
		local TestCheckbox = Header:Checkbox({
			Value = true
		})

		Header:Keybind({
			Label = "Toggle checkbox",
			--Value = Enum.KeyCode.Q,
			IgnoreGameProcessed = false,
			OnKeybindSet = function(self, KeyId) -- KeyId: (Enum.UserInputType | Enum.KeyCode)
				warn("[OnKeybindSet] .Value ->", KeyId)
			end,
			Callback = function(self, KeyId)
				print(KeyId)
				TestCheckbox:Toggle()
			end,
		})

		Header:Keybind({
			Label = "Keybind (w/ Q & Left-Click blacklist)",
			KeyBlacklist = {
				Enum.UserInputType.MouseButton1,
				Enum.KeyCode.Q
			}
		})

		Header:Keybind({
			Label = "Toggle UI visibility",
			Value = Enum.KeyCode.E,
			Callback = function()
				local IsVisible = Window.Visible
				Window:SetVisible(not IsVisible)
			end,
		})
	end,
	["Input"] = function(Header)
		Header:InputText({Label="One Line Text"})
		Header:InputTextMultiline({Label="Multiline Text"})
		Header:InputInt({Label="Input int"})
	end,
	["Text Input"] = function(Header)
		--// Multiline
		local Multiline = Header:TreeNode({Title="Multiline"})
		Multiline:InputTextMultiline({
			Size = UDim2.new(1,0,0,117),
			Value = [[/*The Pentium FOOF bug, shorthand for FO OF C7 C8,
the hexadecimal encoding of one offending instruction,
more formally, the invalid operand with locked CMPXCHG8B
instruction bug, is a design flaw in the majority of
Intel Pentium, Pentium MMX, and Pentium OverDrive
processors (all in the P5 microarchitecture).#
*/]]
		})
	end,
}

for _, Title in DemosOrder do
	local Header = Widgets:TreeNode({
		Title=Title
	})
	local Generate = WidgetDemos[Title]

	if Generate then
		task.spawn(Generate, Header)
	end
end

local Windows = Window:CollapsingHeader({
	Title = "Popups & child windows"
})

--local Popups = Windows:TreeNode({Title="Popups"})
--local Row = Popups:Row()

--local SelectedText = Row:Label({
--	Text = "",
--	LayoutOrder = 2
--})

--Popups:Button({
--	Text = "Select..",
--	Callback = function(self)
--		local Names = {"Bream", "Haddock", "Mackerel", "Pollock", "Tilefish"}

--		local Popup = Popups:PopupCanvas({
--			Object = self
--		})

--		Popup:Separator({Text="Aquarium"})

--		for _, Name in Names do
--			Popup:Button({
--				Text = Name,
--				Callback = function(self)
--					SelectedText.Text = Name
--					Popup:ClosePopup()
--				end,
--			})
--		end
--	end,
--})

--// ChildWindows
local ChildWindows = Windows:TreeNode({Title="Child windows"})
local ChildWindow = ChildWindows:Window({
	Size = UDim2.fromOffset(300, 200),
	NoMove = true,
	NoClose = true,
	NoCollapse = true,
	NoResize = true
})

ChildWindow:Label({Text="Hello, world!"})
ChildWindow:Button({Text = "Save"})
ChildWindow:InputText({Label="string"})
ChildWindow:SliderFloat({Label = "float", Minimum = 0.0, Maximum = 1.0})

--// Modals
local Modals = Windows:TreeNode({Title="Modals"})
Modals:Label({
	Text="Modal windows are like popups but the user cannot close them by clicking outside.",
	TextWrapped = true
})

Modals:Button({
	Text = "Delete..",
	Callback = function()
		local ModalWindow = Modals:PopupModal({
			Title = "Delete?"
		})

		ModalWindow:Label({
			Text = "All those beautiful files will be deleted.\nThis operation cannot be undone!",
			TextWrapped = true
		})
		ModalWindow:Separator()

		ModalWindow:Checkbox({
			Value = false,
			Label = "Don't ask me next time"
		})

		local Row = ModalWindow:Row({
			Expanded = true
		})
		Row:Button({
			Text = "Okay",
			Callback = function()
				ModalWindow:ClosePopup()
			end,
		})
		Row:Button({
			Text = "Cancel",
			Callback = function()
				ModalWindow:ClosePopup()
			end,
		})
	end,
})

Modals:Button({
	Text = "Stacked modals..",
	Callback = function()
		--// First window
		local Stacked1 = Modals:PopupModal({
			Title = "Stacked 1"
		})

		Stacked1:Label({
			Text = `Hello from Stacked The First\nUsing Theme["ModalWindowDimBg"] behind it.`,
			TextWrapped = true
		})
		Stacked1:Combo({
			Items = {"aaaa", "bbbb", "cccc", "dddd", "eeee"}
		})
		Stacked1:DragColor3({
			Value = Color3.fromRGB(102, 178, 0)
		})

		Stacked1:Button({
			Text = "Add another modal..",
			Callback = function()
				--// Second window
				local Stacked2 = Modals:PopupModal({
					Title = "Stacked 2"
				})

				Stacked2:Label({
					Text = "Hello from Stacked The Second!",
					TextWrapped = true
				})

				Stacked2:DragColor3({
					Value = Color3.fromRGB(102, 178, 0)
				})

				Stacked2:Button({
					Text = "Close",
					Callback = function()
						Stacked2:ClosePopup()
					end,
				})
			end,
		})

		Stacked1:Button({
			Text = "Close",
			Callback = function()
				Stacked1:ClosePopup()
			end,
		})
	end,
})

local TablesNColumns = Window:CollapsingHeader({
	Title = "Tables & Columns"
})
local Basic = TablesNColumns:TreeNode({
	Title = "Basic"
})

local BasicTable = Basic:Table()
for RowCount = 1, 3 do
	local Row = BasicTable:Row()
	for ColumnCount = 1, 3 do
		local Column = Row:Column()
		for i = 1, 4 do
			Column:Label({Text=`Row {i} Column {ColumnCount}`})
		end
	end
end

local Borders = TablesNColumns:TreeNode({
	Title = "Borders, background"
})

local BasicTable = Borders:Table({
	RowBackground = true,
	Border = true,
	MaxColumns = 3 -- Per row
})

for RowCount = 1, 5 do
	local Row = BasicTable:NextRow()
	for ColumnCount = 1, 3 do
		local Column = Row:NextColumn()
		Column:Label({Text=`Hello {ColumnCount},{RowCount}`})
	end
end

local Headers = TablesNColumns:TreeNode({
	Title = "With headers"
})

local HeadersTable = Headers:Table({
	Border = true,
	RowBackground = true,
	MaxColumns = 3 -- Per row
})

local Rows = {"One", "Two", "Three"}

for Line = 1, 7 do
	if Line == 1 then
		Row = HeadersTable:HeaderRow()
	else
		Row = HeadersTable:Row()
	end
	
	for Count, RowHeader in Rows do
		if Line == 1 then
			local Column = Row:Column()
			Column:Label({Text=RowHeader})
			continue
		end
		
		local Column = Row:NextColumn()
		Column:Label({Text=`Hello {Count},{Line}`})
	end
end