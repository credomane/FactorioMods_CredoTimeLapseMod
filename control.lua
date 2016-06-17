
--Factorio provided libs
require "defines";
require "util";

MOD_NAME = "CTLM";
MOD_VERSION = "0.0.1";

--CTLM libs
require "CTLM.CTLM";

--Register event handlers! I'm lame and functions are named after their triggering event.
script.on_init(CTLM.init);
script.on_configuration_changed(CTLM.config.configuration_changed);

script.on_load(function()
    local status, err = pcall(CTLM.load);
    if err then
        CTLM.log({"err_generic", "on_load", err});
    end
end);

script.on_event(defines.events.on_player_created, function(event)
    local status, err = pcall(CTLM.player_created, event);
    if err then
        CTLM.log({"err_generic", "on_player_created", err});
    end
end);

script.on_event(defines.events.on_tick, function(event)
    local status, err = pcall(CTLM.tick, event);
    if err then
        CTLM.log({"err_generic", "on_tick", err});
    end
end);

script.on_event(defines.events.on_gui_click, function(event)
    CTLM.log("Gui element was clicked [" .. event.element.name .. "].");
    if not string.starts_with(event.element.name, "CTLM_") then
        return;
    end

    local status, err = pcall(CTLM.gui.click, event);

    if err then
        if event.element.valid then
            CTLM.log({"err_specific", "on_gui_click", event.element.name, err});
        else
            CTLM.log({"err_generic", "on_gui_click", err});
        end
    end
end);
