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

--CTLM config defaults
require "config.defaults"
require "config.player_defaults"
require "config.position_defaults"

--CTLM libs
require "CTLM.gui";
require "CTLM.remote";

if not CTLM then CTLM = {} end

------------------------------------------------------------------------------------------------------
--EVENT HANDLERS
------------------------------------------------------------------------------------------------------

--on_init()
function CTLM.init()
    if not global.config then
        global.config = CTLM.deepCopy(config.defaults);
    end

    if not global.players then
        global.players = {};
    end

    if not global.positions then
        global.positions = {};
    end

    if not global.temp then
        global.temp = {};
    end

    if not global.debug then
        global.debug = false;
    end

    CTLM.gui.init();
end

--on_configuration_changed()
function CTLM.configuration_changed()
    CTLM.print({"main", "Configuration changed."});
    CTLM.init();
    CTLM.gui.init();
end

--on_gui_click
function CTLM.gui_click(event)
    if string.starts(event.element.name, "CTLM_") then
        CTLM.gui.click(event);
    end
end

--on_player_created()
function CTLM.player_created(event)
    local player = game.players[event.player_index];
    if player.valid then
        CTLM.newPlayer(player);
        CTLM.gui.newPlayer(player);
    else
        CTLM.print({"main", "Invalid player."});
    end
end

--on_tick()
function CTLM.tick()
    local curTick = game.tick;
    --I really dislike my mod being the left most and pushing evoGUI over.
    -- So this is my fugly hack. :(
    -- Wish mods could specify a sorting order between 1 and 100!
    if curTick == 2 then
        CTLM.gui.hardReset();
    end

    if game.speed > 3 or not global.config.enabled then
        return;
    end

    --[[
        Think I discovered a race-condition.
        Game brightness is updated at the end of a tick (expected)
        THEN screenshots are taken either before or after the game brightness
        update. Really weird. I broke this up into 4 parts when 2 should have
        been enough. Oh well.
    --]]
    -- Take non dayOnly pics now
    if (curTick + 2) % global.config.screenshotInterval == 0 then
        if global.config.noticesEnabled then
            CTLM.print("Taking screenshots...");
        end
        CTLM.takeScreenshots(false);
    end

    -- Prep to take dayOnly pic in next tick. Avoids wierd lighting issues in screenshots
    if (curTick + 1) % global.config.screenshotInterval == 0 then
        global.temp.surfaces={};
        for index, surface in pairs(game.surfaces) do
            global.temp.surfaces[surface.name]={};
            global.temp.surfaces[surface.name].currentTime = surface.daytime;
        end

        for index, player in pairs(game.players) do
            if not global.players[player.index] then
                CTLM.debug({"onTick", "Hmmm... {" .. CTLM.getPlayerName(player) .. "} didn't exist in db but should." });
                CTLM.debug({"onTick", "Created {" .. CTLM.getPlayerName(player) .. "} with default values."});
                CTLM.newPlayer(player);
            end

            if global.players[player.index].dayOnly then
                player.surface.daytime = 0;
            end
        end

        for index, position in pairs(global.positions) do
            if position.dayOnly then
                game.surfaces[position.surface].daytime = 0;
            end
        end
    end

    -- Take dayOnly pics now.
    if curTick % global.config.screenshotInterval == 0 then
        CTLM.takeScreenshots(true);
    end

    -- Done with screenshots now we fix the time to avoid the wierd lighting issue in screenshots!
    if (curTick - 1) % global.config.screenshotInterval == 0 then
        -- Time advanced a few times so add our stored time to the new tick value of time.
        -- Should prevent the day/night cycle from slowing getting out of sync from
        --  where it would be without my meddling.
        for surfaceName, surface in pairs(global.temp.surfaces) do
            local tempTime = game.surfaces[surfaceName].daytime + surface.currentTime;
            if tempTime > 1 then tempTime = tempTime - 1; end
            game.surfaces[surfaceName].daytime = tempTime;
        end

        -- Increment the screenshotNumber while we are at it.
        if global.temp.screenshotTaken then
            global.temp.screenshotTaken = false;
            global.temp.currentTime = 0;
            global.config.screenshotNumber = global.config.screenshotNumber + 1;
        end
    end
end

--------------------------------------
--screenshot functions!
--------------------------------------

function CTLM.takeScreenshots(dayOnly)
    --Time to loop through and take them screenshots!
    for index, player in pairs(game.players) do
        local configPlayer = global.players[player.index];
        if player.valid and player.connected and configPlayer and configPlayer.enabled and (configPlayer.dayOnly == dayOnly) then
            global.temp.screenshotTaken = true;
            game.take_screenshot({
                player = player,
                resolution = { configPlayer.width, configPlayer.height },
                zoom = configPlayer.zoom,
                path = CTLM.genFilename("player", configPlayer.name),
                show_entity_info = configPlayer.showAltInfo
            });
        end
    end

    for index, position in pairs(global.positions) do
        if position.enabled and (position.dayOnly == dayOnly) then
            global.temp.screenshotTaken = true;
            game.take_screenshot({
                surface = game.surfaces[position.surface],
                position = { position.positionX, position.positionY },
                resolution = { position.width, position.height },
                zoom = position.zoom,
                path = CTLM.genFilename("position", position.name),
                show_entity_info = position.showAltInfo
            });
        end
    end
end

--------------------------------------
--Helper functions!
--------------------------------------

--File name to save screenshot as
function CTLM.genFilename(screenshotType, screenshotName)
    return MOD_NAME .. "/" .. global.config.saveFolder .. "/" .. screenshotType .. "/" .. screenshotName .. "/" .. string.format("%05d", global.config.screenshotNumber) .. ".png";
end

function CTLM.print(msg)
    if type(msg) == "table" then
        msg = "[" .. msg[1] .. "] " .. msg[2];
    end

    msg = "[CTLM] " .. msg;

    if game then
        for index, player in pairs(game.players) do
            player.print(msg);
        end
    end
end

function CTLM.debug(msg)

    if type(msg) == "table" then
        msg = "[" .. msg[1] .. "] " .. msg[2];
    end

    msg = "[CTLM] [debug] " .. msg;

    if game then
        game.write_file(MOD_NAME .. "/debug.log", msg .. "\n", true);

        if global.debug then
            for index, player in pairs(game.players) do
                player.print(msg);
            end
        end
    end
end

function CTLM.hardReset()
    global.config = nil;
    global.players = nil;
    global.positions = nil;

    CTLM.init();

    --Wiped the DB. Recreate all players with defaults.
    for index, player in pairs(game.players) do
        CTLM.newPlayer(player);
    end
end

function CTLM.getPlayerName(player)
    local playerName = "";
    if not player.name or player.name == "" then
        playerName = "UnnamedPlayer " .. player.index;
    else
        playerName = player.name;
    end
    return playerName;
end

function CTLM.newPlayer(player)
    local playerName = CTLM.getPlayerName(player);

    if not global.players[player.index] then
        global.players[player.index] = CTLM.deepCopy(config.player_defaults);
        global.players[player.index].name =  playerName;
    end
end

-- Found on Internet. Original author unknown.
-- deep copies a table to avoid references as that would be bad. :/
function CTLM.deepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end
