
--Factorio provided libs
require "defines";
require "util";

MOD_NAME = "CTLM";
MOD_VERSION = "0.0.1";

--CTLM libs
require "CTLM.main";


remote.add_interface(MOD_NAME, CTLM.remote)

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
function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

-- Shamelessly copied from http://lua-users.org/wiki/StringRecipes
function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end
