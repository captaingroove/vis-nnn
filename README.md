# Use nnn as a file picker

Use [nnn](https://github.com/jarun/nnn) as a file picker for [vis](https://github.com/martanne/vis).
To work properly without trashing the terminal after exiting vis this plugin needs at least commit 47ac03a911eff0f743d1ee45efc51fc8f68dcbb8 of vis.

## Usage

In vis:

`:nnn`

## Configuration

In visrc.lua:

```lua
plugin_vis_nnn = require('plugins/vis-nnn')

-- Path to the nnn executable (default: "nnn")
plugin_vis_nnn.nnn_path = "nnn"

-- Arguments passed to nnn (default: "")
plugin_vis_nnn.nnn_args = "-RuA"

-- Mapping configuration example (<Space>n)
vis.events.subscribe(vis.events.INIT, function()
    vis:map(vis.modes.NORMAL, " n", ":nnn<Enter>", "run nnn filemanager in current dir")
end)

-- Get a list of files with exported nnn() function
local myfunc = function()
	local files = plugin_vis_nnn.nnn()
	for _, file in pairs(files) do
		-- do something with file
	end
end
```
