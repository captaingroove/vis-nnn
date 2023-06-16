# Use nnn as a file picker

Use [nnn](https://github.com/jarun/nnn) as a file picker for [vis](https://github.com/martanne/vis).
To work properly, this plugin currently needs two patches for vis:

https://github.com/martanne/vis/pull/1104 and https://github.com/martanne/vis/pull/1105

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
```
