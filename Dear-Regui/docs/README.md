# Dear ReGui
Dear ReGui is a retained dear ImGui library remake designed to be used on Roblox!
This is perfect for beginners and performance.

Demo place: https://www.roblox.com/games/136436665525145/ReGui-Demo \
Documentation: https://depso.gitbook.io/regui

## Notices
- ReGui will have bugs, please report any bugs by opening an issue on Github
- For suggestions or questions, please visit the [discussions page](https://github.com/depthso/Dear-ReGui/discussions)
- If you would like to fork this, please read the [Forking](#forking) section
- Technical documentation and addional infomation such as commonly asked questions can be found on the [Gitbook documentation](https://depso.gitbook.io/regui)

## Demo
The best way to learn ReGUI is to look through the Demo window which comes bundled with ReGUI.
The demo window is updated every significant update such as an addition of an element or a flag has been renamed.

https://github.com/depthso/Dear-ReGui/blob/main/Demo%20window.lua

## Usage
ReGui can be used on any GUI type you want such as CoreGui, PlayerGui, BillboardGui, PluginGui, and SurfaceGui.
Installation is as simple as importing the rbxm model into your project and connecting a client script to begin using it!

ReGui requires prefabs as it does not generate the base elments required for many elements such as the Window.

See the [Getting Started - Installing](https://depso.gitbook.io/regui/getting-started/installing) section for more details

Once you have installed ReGUI into your project, it can be used by any client script anywhere!
```lua
local Window = ReGui:Window({
	Title = "Hello world!",
	Size = UDim2.fromOffset(300, 200)
})

Window:Label({Text="Hello, world!"})
Window:Button({
	Text = "Save",
	Callback = function()
		MySaveFunction()
	end,
})
Window:InputText({Label="string"})
Window:SliderFloat({Label = "float", Minimum = 0.0, Maximum = 1.0})
```

<img src="https://github.com/user-attachments/assets/9181571f-39c3-42bc-8677-3a433c92e6e3" width="400px">

## Gallery
<table>
	<tr>
		<td width="50%">
			<img src="https://github.com/user-attachments/assets/a2f7c6bd-17fa-460a-b6d4-c033720cce3a">
		</td>
  		<td width="50%">
			<img src="https://github.com/user-attachments/assets/08cff202-d6b9-4b26-b54d-454a93566202">
		</td>
	</tr>
	<tr>
		<td>
			Advanced customization example
			<img src="https://github.com/user-attachments/assets/c2e9be5d-819b-4620-9a0f-b99f42e21886">
		</td>
		<td>
			Demo window  
			<img src="https://github.com/user-attachments/assets/f1324da5-81c2-41f1-bc51-73b381592c97">
		</td>
	</tr>
</table>

## Forking
If you would like to create a fork of ReGui, please read the steps below

### Custom module
If you are going to edit the module and publish it, please create a copy of the [Prefabs](https://create.roblox.com/store/asset/71968920594655) 
as the module will quickly become outdated and cause issues with the Prefabs. Currently you only need to download a copy of the `main.lua` file

### Custom Prefabs
Using custom prefabs with ReGUI is very simple. 
To use custom prefabs you can point the library's `Prefabs` to the custom prefabs in the `:Init` call. For externally using custom prefabs, replace `rbxassetid://{ReGui.PrefabsId}` with `rbxassetid://PrefabsID` and replace `PrefabsID` with the id of your custom prefabs that you have published on Roblox.

ReGui prefabs asset: [Prefabs Gui - Roblox](https://create.roblox.com/store/asset/71968920594655)

#

<table>
	<tr>
		<img src="/docs/images/Dear ReGui.png" width="30%">
	</tr>
	<tr>
		<p>Dear ReGui, a retained dear ImGui library remake for Roblox developed by depso</p>
	</tr>
</table>
