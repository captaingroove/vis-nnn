--- Copyright (C) 2023  Jörg Bakker
---
--- FIXME vis doesn't restore the terminal properly after exiting when 'nnn' has been called.
--- There already are functions ui_curses_save() and ui_curses_restore()
--- which are used in vis_pipe() and do exactly this but setting the
--- terminal to shell mode for the executed command
---
--- As we also would need to execute shell calls to curses programs
--- with the ':!' command, we probably would need to add a new
--- command to the sam commands (sam.c)
---
--- The curses functions needed for terminal save/restore are:
--- def_prog_mode(); endwin(); curs_set(1);
--- reset_prog_mode(); curs_set(1);
---
--- TODO make nnn options configurable
---
module = {}

vis:command_register("nnn", function(argv, force, win, selection, range)
    local pickfile_name = os.tmpname()

	--- Better use the vis internal function to execute a shell command
	--- as it handles terminal saving and restoring
    vis:command(string.format(":!nnn -RuA -p %s", pickfile_name))
    -- status = vis:pipe(vis.win.file, 0, 0, string.format("nnn -RuA -p %s", pickfile_name))
    -- os.execute(string.format("nnn -RuA -p %s", pickfile_name))

    local pickfile = io.open(pickfile_name)
    if not pickfile then
	    vis:redraw()
		return false
    end
    local output = {}
    for line in pickfile:lines() do
        table.insert(output, line)
    end
    local success, msg, status = pickfile:close()
    os.remove(pickfile_name)
    if success and output[1] ~= nil then
        vis:feedkeys(string.format(":e '%s'<Enter>", output[1]))
    end
    -- vis:redraw()
    return true;
end, "Select file to open with nnn")

return module
