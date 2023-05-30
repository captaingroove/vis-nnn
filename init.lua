--- Copyright (C) 2023  Jörg Bakker
---
--- FIXME vis doesn't restore the terminal properly after exiting when 'nnn' has been called.
--- We should introduce save_screen_state() and restore_screen_state() functions in vis.
--- For general curses test code, see: /home/jorg/cc/testlab/curses/leave_curses.c
--- There already are functions ui_curses_save() and ui_curses_restore()
--- which are used in vis_pipe() and do exactly this but setting the
--- terminal to shell mode for the executed command
--- TODO need to call curses functions: def_prog_mode(); endwin();
--- TODO need to call curses function: reset_prog_mode() and
---      hide the curses cursor after exiting nnn
--- TODO make nnn options configurable
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
    vis:redraw()
    return true;
end, "Select file to open with nnn")

return module
