
--Factorio provided libs
require "defines"
require "util"

MOD_NAME = "CTLM";
MOD_VERSION = "0.0.1";

--CTLM libs
require "CTLM.CTLM"

--Register event handlers! I'm lame and functions are named after their triggering event.
script.on_init(CTLM.init);
script.on_configuration_changed(CTLM.config.configuration_changed);

script.on_load(function()
    local status, err = pcall(CTLM.load)
    if err then CTLM.log({"err_generic", "on_load", err}) end
end);

script.on_event(defines.events.on_player_created, function(event)
    local status, err = pcall(CTLM.config.player_created, event)
    if err then CTLM.log({"err_generic", "on_player_created", err}) end
end);

--Wish there was a dedicated on_surface_created. This is wasting precious cpu time all for a fake surface creation event. ugh.
script.on_event(defines.events.on_chunk_generated, function(event)
    local status, err = pcall(CTLM.config.chunk_generated, event)
    if err then CTLM.log({"err_generic", "on_chunk_generated", err}) end
end);

script.on_event(defines.events.on_tick, function(event)
    local status, err = pcall(CTLM.tick, event)
    if err then CTLM.log({"err_generic", "on_tick", err}) end
end);

script.on_event(defines.events.on_gui_click, function(event)
    local status, err = pcall(CTLM.gui.click, event)

    if err then
        if event.element.valid then
            CTLM.log({"err_specific", "on_gui_click", event.element.name, err})
        else
            CTLM.log({"err_generic", "on_gui_click", err})
        end
    end
end);
