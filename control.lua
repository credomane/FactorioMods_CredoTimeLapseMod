--[[
The MIT License (MIT)

Copyright (c) 2016 Credomane

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

--Factorio provided libs
require "util";

MOD_FULLNAME = "CredoTimeLapseMod";
MOD_SHORTNAME = "CTLM";
MOD_VERSION = "0.0.1";

--CTLM libs
require "CTLM.main";


remote.add_interface(MOD_SHORTNAME, CTLM.remote)

--Register event handlers! I'm lame and functions are named after their triggering event.
script.on_init(CTLM.init);
script.on_configuration_changed(CTLM.configuration_changed);

script.on_event(defines.events.on_gui_click, CTLM.gui_click);
script.on_event(defines.events.on_player_created, CTLM.player_created);
script.on_event(defines.events.on_tick, CTLM.tick);

--------------------------------------------------
-----  Helper functions are the bees knees  ------
--------------------------------------------------

-- Shamelessly copied from http://lua-users.org/wiki/StringRecipes
function string.starts(String, Start)
   return string.sub(String, 1, string.len(Start)) == Start;
end

-- Shamelessly copied from http://lua-users.org/wiki/StringRecipes
function string.ends(String, End)
   return End=='' or string.sub(String, -string.len(End)) == End;
end

function string.trimStart(String, trim)
    return string.sub(String, string.len(trim)+1);
end

function string.trimEnd(String, trim)
    return string.sub(String, 1, string.len(String)-string.len(trim));
end
