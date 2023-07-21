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
		return nil
	end
	local files  = {}
	for line in pickfile:lines() do
		table.insert(files, line)
	end
	pickfile:close()
	os.remove(pickfile_name)
	return files
end

vis:command_register("nnn", function(argv, force, win, selection, range)
	local files = module.nnn()
	if files and files[1] ~= nil then
		local file = table.remove(files, 1)
		vis:command("e " .. file)
	end
	for _, file in pairs(files) do
		vis:command("open " .. file)
	end
end, "Select file(s) to open with nnn")

return module
