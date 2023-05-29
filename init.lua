-- Copyright (C) 2023  Jörg Bakker
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as
-- published by the Free Software Foundation, either version 3 of the
-- License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.


--- FIXME vis doesn't restore the terminal properly after exiting when 'nnn' has been called
--- solutions:
--- 1. 'e' alias for vis always appends a call to the clear(1) command
--- 2. introduce save_screen_state() and restore_screen_state() functions in vis
---    for test code, see: /home/jorg/cc/testlab/curses/leave_curses.c
---    there already are functions ui_curses_save() and ui_curses_restore()
---    which are used in vis_pipe()
---    these new functions could be added to vis.h (also in lua vis module then ...?)
--- FIXME also need to hide the cursor when leaving 'nnn' with curs_set(0)
module = {}

vis:command_register("nnn", function(argv, force, win, selection, range)
	--- TODO need to call curses functions: def_prog_mode(); endwin();
	--- TODO need to hide the curses cursor after exiting nnn
	--- TODO need to check if more than one file was selected
	--- TODO need to handle more than one instance of vis running nnn
    local file = io.popen("nnn -RuA -p-")
    local output = {}
    for line in file:lines() do
        table.insert(output, line)
    end
    local success, msg, status = file:close()
    if status == 0 and output[1] ~= nil then
        vis:feedkeys(string.format(":e '%s'<Enter>", output[1]))
    end
    --- TODO need to call curses function: reset_prog_mode()
    vis:redraw()
    return true;
end, "Select file to open with nnn")

return module
