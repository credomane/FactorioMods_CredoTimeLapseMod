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
require "defines"

if not CTLM then CTLM = {} end
if not CTLM.gui then CTLM.gui = {} end

function CTLM.gui.init()
    CTLM.log("[gui] init()");
    for key, player in pairs(game.players) do
        CTLM.gui.create_main_button(player);
    end
end

function CTLM.gui.hardreset()
    CTLM.log("[gui] hardreset()");
    for key, player in pairs(game.players) do
        local root = player.gui.top.CTLM_mainbutton;
        if root then
            player.gui.top.CTLM_mainbutton.destroy();
        end
    end

    CTLM.gui.init();
end

function CTLM.gui.new_player(player)
    CTLM.log("[gui] new_player(" .. player.name .. ")");
    CTLM.gui.create_main_button(player);
end

function CTLM.gui.create_main_button(player)
    CTLM.log("[gui] create_main_button(" .. player.name .. ")");
    local root = player.gui.top.CTLM_mainbutton;
    local destroyed = false;
    if root then
        player.gui.top.CTLM_mainbutton.destroy();
        destroyed = true;
    end

    if not root or destroyed then
        local root = player.gui.top;
        if not root.CTLM_mainbutton then
            root.add({
                type="button",
                name="CTLM_mainbutton",
                caption="CTLM"
            });
        end
    end
end

function CTLM.gui.click(event)
    CTLM.log("[gui] click()");
    --MAIN SETTINGS
    if event.element.name == "CTLM_mainbutton" then
        CTLM.gui.CTLM_settings_main_open(event);
    elseif event.element.name == "CTLM_settings_main_close" then
        CTLM.gui.CTLM_settings_main_close(event);
    elseif event.element.name == "CTLM_settings_main_save" then
        CTLM.gui.CTLM_settings_main_save(event);
    --PLAYERS SETTINGS
    elseif event.element.name == "CTLM_settings_players_open" then
        CTLM.gui.CTLM_settings_players_open(event);
    elseif event.element.name == "CTLM_settings_players_close" then
        CTLM.gui.CTLM_settings_players_close(event);
    elseif event.element.name == "CTLM_settings_players_save" then
        CTLM.gui.CTLM_settings_players_save(event);
    --POSITIONS SETTINGS
    elseif event.element.name == "CTLM_settings_positions_open" then
        CTLM.gui.CTLM_settings_positions_open(event);
    elseif event.element.name == "CTLM_settings_positions_close" then
        CTLM.gui.CTLM_settings_positions_close(event);
    elseif event.element.name == "CTLM_settings_positions_save" then
        CTLM.gui.CTLM_settings_positions_save(event);
    end
end

------------------------------------------------------------------------------------------------------
--MAIN SETTINGS
------------------------------------------------------------------------------------------------------
function CTLM.gui.CTLM_settings_main_open(event)
    local player = game.get_player(event.player_index);
    if player.gui.center.CTLM_settings_main ~= nil then
        --Open button has been hit twice. Perform close action instead.
        CTLM.gui.CTLM_settings_main_close(event);
        return;
    end

    --Main frame
    local root = player.gui.center.add({
        type="frame",
        direction="vertical",
        name="CTLM_settings_main",
        caption={"settings.main.title"}
    });

    --Main frame -> title/header
    local main_settings = root.add({
        type="frame",
        name="core",
        caption={"settings.main.header"},
        direction="vertical",
        style="naked_frame_style"
    });

    --[beg] Main frame -> mod enabled setting
    local enabled_flow = main_settings.add({type="flow", name="enabled_flow", direction="horizontal"});
    enabled_flow.add({type="checkbox", name="checkbox", caption={"settings.main.enabled"}, state=global.config.enabled});
    --[end] Main frame -> mod enabled setting

    --[beg] Main frame -> saveFolder setting
    local saveFolder_flow = main_settings.add({type="flow", name="saveFolder_flow", direction="horizontal"});
    saveFolder_flow.add({type="label", caption={"settings.main.savefolder_left"}});
    local textfield = saveFolder_flow.add({type="textfield", name="textfield", style="number_textfield_style"});
    textfield.text=tostring(global.config.saveFolder);
    saveFolder_flow.add({type="label", caption={"settings.main.interval_right"}});
    --[end] Main frame -> screenshotInterval setting

    --[beg] Main frame -> screenshotInterval setting
    local screenshotInterval_flow = main_settings.add({type="flow", name="screenshotInterval_flow", direction="horizontal"});
    screenshotInterval_flow.add({type="label", caption={"settings.main.interval_left"}});
    local textfield = screenshotInterval_flow.add({type="textfield", name="textfield", style="number_textfield_style"});
    textfield.text=tostring(global.config.screenshotInterval);
    screenshotInterval_flow.add({type="label", caption={"settings.main.interval_right"}});
    --[end] Main frame -> screenshotInterval setting

    --Main frame screenshot buttons
    local ssButtons = root.add({type="flow", name="ssbuttons", direction="horizontal"});
    ssButtons.add({type="button", name="CTLM_settings_players_open", caption={"settings.players"}});
    ssButtons.add({type="button", name="CTLM_settings_positions_open", caption={"settings.positions"}});

    --Main frame buttons
    local buttons = root.add({type="flow", name="buttons", direction="horizontal"});
    buttons.add({type="button", name="CTLM_settings_main_close", caption={"settings.close"}});
    buttons.add({type="button", name="CTLM_settings_main_save", caption={"settings.save"}});
end

function CTLM.gui.CTLM_settings_main_close(event)
    local player = game.get_player(event.player_index);
    if player.gui.center.CTLM_settings_main ~= nil then
        player.gui.center.CTLM_settings_main.destroy();
    end
end

function CTLM.gui.CTLM_settings_main_save(event)
    local player = game.get_player(event.player_index);

    local enabled = player.gui.center.CTLM_settings_main.core.enabled_flow.checkbox.state;
    local saveFolder = tostring(player.gui.center.CTLM_settings_main.core.saveFolder_flow.textfield.text);
    local screenshotInterval = tonumber(player.gui.center.CTLM_settings_main.core.screenshotInterval_flow.textfield.text);

    if enabled ~= global.config.enabled then
        CTLM.log("[gui] new mod enabled state is " .. tostring(enabled));
        global.config.enabled = enabled;
    end
    if saveFolder ~= nil then
        CTLM.log("[gui] new saveFolder " .. tostring(saveFolder));
        global.config.saveFolder = saveFolder;
    end
    if screenshotInterval ~= nil then
        CTLM.log("[gui] new screenshotInterval " .. tostring(screenshotInterval));
        global.config.screenshotInterval = screenshotInterval;
    end
end

------------------------------------------------------------------------------------------------------
--PLAYERS SETTINGS
------------------------------------------------------------------------------------------------------
function CTLM.gui.CTLM_settings_players_open(event)
    local player = game.get_player(event.player_index);
    if player.gui.center.CTLM_settings_main ~= nil then
        --Open button has been hit twice. Perform close action instead.
        CTLM.gui.CTLM_settings_main_close(event);
        return;
    end
end

function CTLM.gui.CTLM_settings_players_close(event)
    local player = game.get_player(event.player_index);
    if player.gui.center.CTLM_settings_players ~= nil then
        player.gui.center.CTLM_settings_players.destroy();
    end
end

function CTLM.gui.CTLM_settings_players_save(event)
    local player = game.get_player(event.player_index);
end

------------------------------------------------------------------------------------------------------
--POSITIONS SETTINGS
------------------------------------------------------------------------------------------------------
function CTLM.gui.CTLM_settings_positions_open(event)
    local player = game.get_player(event.player_index);
    if player.gui.center.CTLM_settings_main ~= nil then
        --Open button has been hit twice. Perform close action instead.
        CTLM.gui.CTLM_settings_main_close(event);
        return;
    end
end

function CTLM.gui.CTLM_settings_positions_close(event)
    local player = game.get_player(event.player_index);
    if player.gui.center.CTLM_settings_positions ~= nil then
        player.gui.center.CTLM_settings_positions.destroy();
    end
end

function CTLM.gui.CTLM_settings_positions_save(event)
    local player = game.get_player(event.player_index);
end
