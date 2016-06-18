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
require "defines";
require "util";

--CTLM libs
require "CTLM.config";
require "CTLM.gui";
require "CTLM.remote";

if not CTLM then CTLM = {} end

------------------------------------------------------------------------------------------------------
--EVENT HANDLERS
------------------------------------------------------------------------------------------------------

--on_init()
function CTLM.init()
    CTLM.log("[main] init()");
    CTLM.config.init();
    CTLM.gui.init();
end

--on_configuration_changed()
function CTLM.configuration_changed()
    CTLM.log("[main] configuration_changed()");
end

--on_gui_click
function CTLM.gui_click(event)
    CTLM.log("Gui element was clicked [" .. event.element.name .. "]");
    if string.starts(event.element.name, "CTLM_") then
        CTLM.gui.click(event);
    end
end

--on_player_created()
function CTLM.player_created(event)
    CTLM.log("[main] player_created(" .. event.player_index .. ")");
    local player = game.get_player(event.player_index);
    if player.valid then
        CTLM.config.new_player(player);
        CTLM.gui.new_player(player);
    else
        CTLM.log("[main] Invalid player.");
    end
end

--on_tick()
function CTLM.tick()
    local curTick = game.tick;
    --I really dislike my mod being the left most and pushing evoGUI over.
    -- So this is my fugly hack. :(
    -- Wish mods could specify a sorting order between 1 and 100!
    if curTick == 2 then
        CTLM.gui.hardreset();
    end

    if game.speed > 3 or not global.config.enabled then
        return;
    end

    if curTick % global.config.screenshotInterval == 0 then
        --Time to loop through and take them screenshots!
        CTLM.log("Taking screenshots...");
        local screenshotTaken = false;
        for index, player in ipairs(game.players) do
            local configPlayer = global.players[player.name];
            if player.valid and player.connected and configPlayer and configPlayer.enabled then
                screenshotTaken = true;
                CTLM.screenshotPlayer(configPlayer);
            end
        end

        for index, position in ipairs(global.positions) do
            if position.enabled then
                screenshotTaken = true;
                CTLM.screenshotPosition(position);
            end
        end

        if screenshotTaken then
            CTLM.config.set("screenshotNumber", global.config.screenshotNumber + 1);
        end
    end
end

--------------------------------------
--extra functions!
--------------------------------------

function CTLM.hardreset()
    CTLM.config.hardreset();
    CTLM.gui.hardreset()
end
--------------------------------------
--screenshot functions!
--------------------------------------

function CTLM.screenshotPlayer(configPlayer)
    CTLM.log("[main] screenshotPlayer("  .. configPlayer.Name .. ")");
    local player = CTLM.getPlayerByName(configPlayer.name);
    if not player then return nil end

    local currentTime = game.daytime;

    if configPlayer.dayOnly then
        game.daytime = 0;
    end

    game.take_screenshot({
        player = player,
        resolution = { configPlayer.width, configPlayer.height },
        zoom = configPlayer.zoom,
        path = genFilename("player", configPlayer.name),
        configPlayer.show_gui,
        configPlayer.show_altinfo
    });

    game.daytime = currentTime;
    CTLM.log("CTLM.screenshotPlayer: " .. configPlayer.name);
end

function CTLM.screenshotPosition(configPosition)
    CTLM.log("[main] screenshotPosition("  .. configPosition.Name .. ")");
    local currentTime = game.daytime;

    if configPosition.dayOnly then
        game.daytime = 0;
    end

    game.take_screenshot({
--        surface = game.get_surface(configPosition.surface),
        position = { configPosition.positionX, configPosition.positionY },
        resolution = { configPosition.width, configPosition.height },
        zoom = configPosition.zoom,
        path = genFilename("position", configPosition.name),
        configPosition.show_gui,
        configPosition.show_altinfo
    });

    game.daytime = currentTime;
    CTLM.log("CTLM.screenshotPosition: " .. configPosition.name);
end

--File name to save screenshot as
function CTLM.GenFilename(screenshotType, screenshotName)
    CTLM.log("[main] GenFilename(" .. MOD_NAME .. "/" .. screenshotType .. "/" .. screenshotName .. "/" .. string.format("%05d", global.config.screenshotNumber) .. ".png" .. ")");
    return MOD_NAME .. "/" .. screenshotType .. "/" .. screenshotName .. "/" .. string.format("%05d", global.config.screenshotNumber) .. ".png";
end

function CTLM.log(msg)
    if type(msg) == "table" then
        msg = "[" .. msg[1] .. "] [" .. msg[2] .. "] " .. msg[3];
    end

    msg = "[CTLM] " .. msg;

    if game then
        game.write_file(MOD_NAME .. "/debug.log", msg .. "\n", true);

        for index, player in ipairs(game.players) do
            player.print(msg)
        end
    end
end
