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

    CTLM.gui.init();
end

--on_configuration_changed()
function CTLM.configuration_changed()
    CTLM.log("[main] configuration_changed()");
    CTLM.init();
end

--on_gui_click
function CTLM.gui_click(event)
    if string.starts(event.element.name, "CTLM_") then
        CTLM.gui.click(event);
    end
end

--on_player_created()
function CTLM.player_created(event)
    local player = game.get_player(event.player_index);
    if player.valid then
        CTLM.newPlayer(player);
        CTLM.gui.newPlayer(player);
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

    --[[
        Think I discovered a race-condition.
        Game brightness is updated at the end of a tick (expected)
        THEN screenshots are taken after that (unexpect) rather than when they were
        originally called by the lua code. This is causing my day/night pics to 
        be flipped even though the debug code says everything is fine.
        This is...interesting to say the least.
        Will have to mess with it more later tonight. When I'm not in a rush.
        Being in a rush makes for bad coding. Likely my actual issue.
    --]]
    -- Take non dayOnly pics now and prep to take dayOnly pic in next tick
    if (curTick + 1) % global.config.screenshotInterval == 0 then
CTLM.log("night pics");
        CTLM.takeScreenshots(false);
        global.temp.currentTime = game.daytime;
        game.daytime = 0;
    end

    -- Take dayOnly pics now and restore game.daytime.
    if curTick % global.config.screenshotInterval == 0 then
CTLM.log("day pics");
        CTLM.takeScreenshots(true);
        -- Time advanced a tick. So add our stored time to the new tick value of time.
        -- Should prevent the day/night cycle from slowing getting out of sync from
        --  where it would be without my meddling.
        game.daytime = game.daytime + global.temp.currentTime;
    end

    -- Done with screenshots advance the counter!
    if (curTick - 1) % global.config.screenshotInterval == 0 then
CTLM.log("time reset");
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
    for index, player in ipairs(game.players) do
        local configPlayer = global.players[player.index];
        if player.valid and player.connected and configPlayer and configPlayer.enabled and (configPlayer.dayOnly == dayOnly) then
CTLM.log("Took " .. configPlayer.name);
            global.temp.screenshotTaken = true;
            game.take_screenshot({
                player = player,
                resolution = { configPlayer.width, configPlayer.height },
                zoom = configPlayer.zoom,
                path = CTLM.genFilename("player", configPlayer.name),
                show_gui = configPlayer.showGui,
                show_entity_info = configPlayer.showAltInfo
            });
        end
    end

    for index, position in ipairs(global.positions) do
        if position.enabled and (position.dayOnly == dayOnly) then
CTLM.log("Took " .. position.name);
            global.temp.screenshotTaken = true;
            game.take_screenshot({
                surface = game.get_surface(position.surface),
                position = { position.positionX, position.positionY },
                resolution = { position.width, position.height },
                zoom = position.zoom,
                path = CTLM.genFilename("position", position.name),
                show_gui = position.showGui,
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

function CTLM.hardreset()
    global.config = nil;
    global.players = nil;
    global.positions = nil;

    CTLM.init();
    CTLM.gui.hardreset()
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
