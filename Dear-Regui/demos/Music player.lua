local RunService = game:GetService("RunService")

local ReGui = require(game.ReplicatedStorage.ReGui)
ReGui:Init()

local Camera = workspace.CurrentCamera

local AudioPlayer = Instance.new("AudioPlayer", Camera)
AudioPlayer.Asset = "rbxassetid://122863102226559" -- getcustomasset("Holiday.mp3")
AudioPlayer.Volume = 10
AudioPlayer.Looping = true
AudioPlayer.AutoLoad = true

local AudioDeviceOutput = Instance.new("AudioDeviceOutput", AudioPlayer)

local AudioAnalyzer = Instance.new("AudioAnalyzer", AudioPlayer)
AudioAnalyzer.WindowSize = Enum.AudioWindowSize.Large

local OutputWire = Instance.new("Wire", AudioDeviceOutput)
OutputWire.SourceInstance = AudioPlayer
OutputWire.TargetInstance = AudioDeviceOutput

local AnalyzerWire = Instance.new("Wire", AudioDeviceOutput)
AnalyzerWire.SourceInstance = AudioPlayer
AnalyzerWire.TargetInstance = AudioAnalyzer

repeat wait() until AudioPlayer.IsReady

AudioPlayer:Play()

--// Create window
local Window = ReGui:Window({
	Title = "Window",
	Size = UDim2.fromOffset(350, 140),
	NoResize = true
}):Center()

local Graph = Window:PlotHistogram({
	Label = "",
	Minimum = 0,
	Maximum = 1,
	Size = UDim2.new(1, 0, 0, 80)
})

local Controls = Window:Row()
Controls:Button({
	Text = "Pause",
	Callback = function()
		AudioPlayer:Stop()
	end,
})

Controls:Button({
	Text = "Play",
	Callback = function()
		AudioPlayer:Play()
	end,
})

local TimeSlider = Controls:SliderInt({
	Format = "%.f",
	Value = 0,
	Minimum = 0,
	Maximum = AudioPlayer.TimeLength,
	Callback = function(self, Value)
		AudioPlayer.TimePosition = Value
	end,
})

Controls:Expand()

--// https://devforum.roblox.com/t/new-audio-api-beta-elevate-sound-and-voice-in-your-experiences/2848873
local function lerp(lower, upper, fract)
	return upper * fract + lower * (1 - fract)
end
local function getMappedBins(binCount) : {number}	
	local bins = AudioAnalyzer:GetSpectrum()
	if not bins or #bins <= 0 then return end
	
	local result = {}
	for i = 1, binCount do
		local j = math.pow(#bins, i / binCount)
		local lower = math.max(1, math.floor(j))
		local upper = math.min(#bins, math.ceil(j))
		local fract = j - math.floor(j)
		result[i] = lerp(bins[lower], bins[upper], fract)
		result[i] = math.sqrt(result[i]) * 2
		result[i] = math.clamp(result[i], 0, 10)
	end

	return result
end

local BarCount = 20
RunService.RenderStepped:Connect(function()
	local Bins = getMappedBins(BarCount)
	if not Bins then return end
	
	TimeSlider:SetValue(AudioPlayer.TimePosition)
	Graph:PlotGraph(Bins)
end)
