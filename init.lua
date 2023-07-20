--- Copyright (C) 2023  Jörg Bakker
---

local module = {}
module.nnn_path = "nnn"
module.nnn_args = ""

module.nnn = function()
	local pickfile_name = os.tmpname()
	local command = module.nnn_path .. " " .. module.nnn_args .. " -p " .. pickfile_name
	local status = vis:pipe(vis.win.file, {start = 1, finish = 0}, command, true)
	local pickfile = io.open(pickfile_name)
	if not pickfile then
		vis:redraw()
		return
	end
	local files  = {}
	for line in pickfile:lines() do
		table.insert(files, line)
	end
	local success, msg, status = pickfile:close()
	os.remove(pickfile_name)
	if success then
		return files
	end
end

vis:command_register("nnn", function(argv, force, win, selection, range)
	local files = module.nnn()
	if files and files[1] ~= nil then
		vis:command("e " .. files[1])
	end
	return true;
end, "Select file to open with nnn")

return module
