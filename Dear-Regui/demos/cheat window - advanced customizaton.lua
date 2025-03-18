local RunService = game:GetService("RunService")

local ReGui = require(game.ReplicatedStorage.ReGui)
ReGui:Init()
ReGui:DefineTheme("Cherry", {
	TitleAlign = Enum.TextXAlignment.Center,
	TextDisabled = Color3.fromRGB(120, 100, 120),
	Text = Color3.fromRGB(200, 180, 200),
	
	FrameBg = Color3.fromRGB(25, 20, 25),
	FrameBgTransparency = 0.4,
	FrameBgActive = Color3.fromRGB(120, 100, 120),
	FrameBgTransparencyActive = 0.4,
	
	CheckMark = Color3.fromRGB(150, 100, 150),
	SliderGrab = Color3.fromRGB(150, 100, 150),
	ButtonsBg = Color3.fromRGB(150, 100, 150),
	CollapsingHeaderBg = Color3.fromRGB(150, 100, 150),
	CollapsingHeaderText = Color3.fromRGB(200, 180, 200),
	RadioButtonHoveredBg = Color3.fromRGB(150, 100, 150),
	
	WindowBg = Color3.fromRGB(35, 30, 35),
	TitleBarBg = Color3.fromRGB(35, 30, 35),
	TitleBarBgActive = Color3.fromRGB(50, 45, 50),
	
	Border = Color3.fromRGB(50, 45, 50),
	ResizeGrab = Color3.fromRGB(50, 45, 50),
	RegionBgTransparency = 1,
})

--// Tabs
local Window = ReGui:Window({
	Title = "Cherry",
	Theme = "Cherry",
	NoClose = true,
	Size = UDim2.new(0, 600, 0, 400),
}):Center()

local ModalWindow = Window:PopupModal({
	Title = "Modal Example",
	AutoSize = "Y"
})

ModalWindow:Label({
	Text = [[Hello, this is a modal. 
Thank you for using Depso's ReGui 😁]],
	TextWrapped = true
})
ModalWindow:Separator()

ModalWindow:Button({
	Text = "Okay",
	Callback = function()
		ModalWindow:ClosePopup()
	end,
})

local Group = Window:List({
	UiPadding = 2,
	HorizontalFlex = Enum.UIFlexAlignment.Fill,
})

local TabsBar = Group:List({
	Border = true,
	UiPadding = 5,
	BorderColor = Window:GetThemeKey("Border"),
	BorderThickness = 1,
	HorizontalFlex = Enum.UIFlexAlignment.Fill,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	AutomaticSize = Enum.AutomaticSize.None,
	FlexMode = Enum.UIFlexMode.None,
	Size = UDim2.new(0, 40, 1, 0),
	CornerRadius = UDim.new(0, 5)
})
local TabSelector = Group:TabSelector({
	NoTabsBar = true,
	Size = UDim2.fromScale(0.5, 1)
})

local function CreateTab(Name: string, Icon)
	local Tab = TabSelector:CreateTab({
		Name = Name
	})

	local List = Tab:List({
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		UiPadding = 1,
		Spacing = 10
	})

	local Button = TabsBar:Image({
		Image = Icon,
		Ratio = 1,
		RatioAxis = Enum.DominantAxis.Width,
		Size = UDim2.fromScale(1, 1),
		Callback = function(self)
			TabSelector:SetActiveTab(Tab)
		end,
	})

	ReGui:SetItemTooltip(Button, function(Canvas)
		Canvas:Label({
			Text = Name
		})
	end)

	return List
end

local function CreateRegion(Parent, Title)
	local Region = Parent:Region({
		Border = true,
		BorderColor = Window:GetThemeKey("Border"),
		BorderThickness = 1,
		CornerRadius = UDim.new(0, 5)
	})

	Region:Label({
		Text = Title
	})

	return Region
end

local General = CreateTab("General", 139650104834071)
local Settings = CreateTab("Settings", ReGui.Icons.Settings)

--// General Tab
local AimbotSection = CreateRegion(General, "Aimbot") 
local ESPSection = CreateRegion(General, "ESP") 

AimbotSection:Checkbox({
	Label = "Enabled",
	Value = false,
	Callback = function(self, Value)
		--Aimbot_Settings.Enabled = Value
	end
})

AimbotSection:Combo({
	Label = "Update Mode",
	Items = {"RenderStepped", "Stepped", "Heartbeat"},
	Selected = 1,
	Callback = function(self, Value)
		--Aimbot_DeveloperSettings.UpdateMode = Value
	end
})

AimbotSection:Combo({
	Label = "Team Check Option",
	Items = {"TeamColor", "Team"},
	Selected = 1,
	Callback = function(self, Value)
		--Aimbot_DeveloperSettings.TeamCheckOption = Value
	end
})

AimbotSection:SliderInt({
	Label = "Rainbow Speed",
	Default = 1.5 * 10,
	Minimum = 5,
	Maximum = 30,
	Callback = function(self, Value)
		--Aimbot_DeveloperSettings.RainbowSpeed = Value / 10
	end
})

AimbotSection:Button({
	Text = "Refresh",
	Callback = function(self)
		--Aimbot.Restart()
	end
})

AimbotSection:Separator({
	Text = "Properties"	
})

AimbotSection:Combo({
	Label = "Lock Mode",
	Items = {"CFrame", "mousemoverel"},
	Selected = 1,
	Callback = function(self, Value)

	end
})

AimbotSection:Combo({
	Label = "Lock Part",
	Items = {"Head", "Torso", "Random"},
	Selected = 1,
	Callback = function(self, Value)

	end
})

AimbotSection:Keybind({
	Label = "Trigger Key",
	Value = Enum.KeyCode.MouseRightButton,
	IgnoreGameProcessed = true,
	Callback = function(self, KeyCode)

	end,
})

AimbotSection:SliderInt({
	Label = "Field Of View",
	Value = 100,
	Minimum = 0,
	Maximum = 720,
	Callback = function(self, Value)

	end
})

AimbotSection:SliderInt({
	Label = "Transparency",
	Value = 1,
	Minimum = 1,
	Maximum = 10,
	Callback = function(self, Value)

	end
})

AimbotSection:SliderInt({
	Label = "Thickness",
	Minimum = 1,
	Maximum = 5,
	Callback = function(self, Value)

	end
})

ESPSection:Combo({
	Label = "Update Mode",
	Items = {"RenderStepped", "Stepped", "Heartbeat"},
	Selected = 1,
	Callback = function(self, Value)
		--ESP_DeveloperSettings.UpdateMode = Value
	end
})

ESPSection:Combo({
	Label = "Team Check Option",
	Items = {"TeamColor", "Team"},
	Selected = 1,
	Callback = function(self, Value)
		--ESP_DeveloperSettings.TeamCheckOption = Value
	end
})

ESPSection:SliderInt({
	Label = "Rainbow Speed",
	Value = 1 * 10,
	Minimum = 5,
	Maximum = 30,
	Callback = function(self, Value)
		--ESP_DeveloperSettings.RainbowSpeed = Value / 10
	end
})

ESPSection:SliderInt({
	Label = "Width Boundary",
	Value = 1.5 * 10,
	Minimum = 5,
	Maximum = 30,
	Callback = function(self, Value)
		--ESP_DeveloperSettings.WidthBoundary = Value / 10
	end
})

ESPSection:Button({
	Text = "Refresh",
	Callback = function(self)
		--ESP:Restart()
	end
})

--// Settings
local OptionsSection = CreateRegion(Settings, "Options") 
local ConfigSection = CreateRegion(Settings, "Configurations") 

OptionsSection:Keybind({
	Label = "Show / Hide GUI",
	Value = Enum.KeyCode.RightShift,
	Callback = function(_, NewKeybind)
		local IsVisible = Window.Visible
		Window:SetVisible(not IsVisible)
	end
})

OptionsSection:Button({
	Text = "Unload Script",
	Callback = function()
		Window:Close()
	end
})

--// Configurations
ConfigSection:Combo({
	Label = "Config",
	Items = {
		"Legit",
		"Rage",
		"Blatant"
	},
	Selected = 1,
})
