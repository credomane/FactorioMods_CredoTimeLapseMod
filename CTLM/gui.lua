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

--CTLM libs
require "CTLM.gui.main";
require "CTLM.gui.players";
require "CTLM.gui.positions";

if not CTLM then CTLM = {} end
if not CTLM.gui then CTLM.gui = {} end

function CTLM.gui.init()
    for key, player in pairs(game.players) do
        CTLM.gui.create_main_button(player);
    end
end

function CTLM.gui.hardreset()
    for key, player in pairs(game.players) do
        local root = player.gui.top.CTLM_mainbutton;
        if root then
            player.gui.top.CTLM_mainbutton.destroy();
        end
    end

    CTLM.gui.init();
end

function CTLM.gui.newPlayer(player)
    CTLM.gui.create_main_button(player);
end

function CTLM.gui.create_main_button(player)
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


--By the code this is horrid. Why doesn't the Factorio API allow registering a callback handler directly in the GUI.add function!
function CTLM.gui.click(event)

    --MAIN SETTINGS
    if event.element.name == "CTLM_mainbutton" then
        CTLM.gui.CTLM_settings_players_close(event);
        CTLM.gui.CTLM_settings_playerEdit_close(event);
        CTLM.gui.CTLM_settings_positions_close(event);
        CTLM.gui.CTLM_settings_positionEdit_close(event);
        CTLM.gui.CTLM_settings_main_open(event);
    elseif event.element.name == "CTLM_settings_main_close" then
        CTLM.gui.CTLM_settings_main_close(event);
    elseif event.element.name == "CTLM_settings_main_save" then
        CTLM.gui.CTLM_settings_main_save(event);

    --PLAYERS SETTINGS
    elseif event.element.name == "CTLM_settings_players_open" then
        CTLM.gui.CTLM_settings_main_close(event);
        CTLM.gui.CTLM_settings_players_open(event);
    elseif event.element.name == "CTLM_settings_players_close" then
        CTLM.gui.CTLM_settings_players_close(event);
        CTLM.gui.CTLM_settings_playerEdit_close(event);
        CTLM.gui.CTLM_settings_main_open(event);

    --PLAYER EDIT SETTINGS
    elseif string.starts(event.element.name, "CTLM_settings_playerEdit_open") then
        CTLM.gui.CTLM_settings_playerEdit_open(event);
        CTLM.gui.CTLM_settings_players_open(event);
    elseif string.starts(event.element.name, "CTLM_settings_playerEdit_close") then
        CTLM.gui.CTLM_settings_playerEdit_close(event);
    elseif string.starts(event.element.name, "CTLM_settings_playerEdit_save") then
        CTLM.gui.CTLM_settings_playerEdit_save(event);
        CTLM.gui.CTLM_settings_playerEdit_close(event);

    --POSITIONS SETTINGS
    elseif event.element.name == "CTLM_settings_positions_open" then
        CTLM.gui.CTLM_settings_main_close(event);
        CTLM.gui.CTLM_settings_positions_open(event);
    elseif event.element.name == "CTLM_settings_positions_close" then
        CTLM.gui.CTLM_settings_positions_close(event);
        CTLM.gui.CTLM_settings_positionEdit_close(event);
        CTLM.gui.CTLM_settings_main_open(event);
    elseif event.element.name == "CTLM_settings_positions_add" then
        CTLM.gui.CTLM_settings_positions_add(event);

    --PLAYER EDIT SETTINGS
    elseif string.starts(event.element.name, "CTLM_settings_positionEdit_open") then
        CTLM.gui.CTLM_settings_main_close(event);
        CTLM.gui.CTLM_settings_positionEdit_open(event);
    elseif string.starts(event.element.name, "CTLM_settings_positionEdit_close") then
        CTLM.gui.CTLM_settings_positionEdit_close(event);
    elseif string.starts(event.element.name, "CTLM_settings_positionEdit_save") then
        CTLM.gui.CTLM_settings_positionEdit_save(event);
        CTLM.gui.CTLM_settings_positionEdit_close(event);
        CTLM.gui.CTLM_settings_positions_close(event);
        CTLM.gui.CTLM_settings_positions_open(event);
    elseif string.starts(event.element.name, "CTLM_settings_positionEdit_delete") then
        CTLM.gui.CTLM_settings_positionEdit_delete(event);
        CTLM.gui.CTLM_settings_positionEdit_close(event);
        CTLM.gui.CTLM_settings_positions_close(event);
        CTLM.gui.CTLM_settings_positions_open(event);
    end
end
