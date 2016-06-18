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

--[[
    This isn't the file you are wanting to edit.
    /config/ folder has the actual default config values used by the mod. :)
]]

--Factorio provided libs
require "defines"

require "config.defaults"
require "config.player_defaults"
require "config.position_defaults"

if not CTLM then CTLM = {} end
if not CTLM.config then CTLM.config = {} end

--Fix/install config!
function CTLM.config.init()
    CTLM.log("[config] init()");
    if not global.config then
        global.config = CTLM.config.deepCopy(config.defaults);
    end

    if not global.players then
        global.players = {};
    end

    if not global.positions then
        global.positions = {};
    end
end

function CTLM.config.hardreset()
    CTLM.log("[config] hardreset()");
    global.config = nil;
    global.players = nil;
    global.positions = nil;

    CTLM.config.init();
end

function CTLM.config.new_player(player)
    if type(player) == "string" or type(player) == "integer" then
        --Probably an index or name of a player. Get the player from the game variable.
        player = game.get_player(player);
    end

    CTLM.log("[config] new_player(" .. player.name .. ")");

    if not global.players[player.name] then
        global.players[player.name] = CTLM.config.deepCopy(config.player_defaults);
        --Stored for when we just pass around a lua table of this player with out the proceeding named index.
        global.players[player.name].name = player.name;
    end
end

function CTLM.config.new_position(position)
    CTLM.log("[config] new_position()");
    if type(position) ~= "table" then
        CTLM.log("Invalid position type given as parameter '" .. type(position) .. "'.");
        return false;
    elseif type(position) == "table" and not position.name then
        CTLM.log("position table is not valid.");
        return false;
    end

    if not global.positions[position.name] then
        global.positions[position.name] = CTLM.config.deepCopy(config.position_defaults);
        --Stored for when we just pass around a lua table of this position with out the proceeding named index.
        global.positions[position.name].name = position.name;
    end

    for key,value in pairs(position) do
        global.positions[position.name][key] = value;
    end
end

------------------------------------------------------------------------------------------------------
--Special functions
------------------------------------------------------------------------------------------------------

-- Found on Internet. Original author unknown.
-- deep copies a table to avoid references as that would be bad. :/
function CTLM.config.deepCopy(object)
    CTLM.log("[config] deepCopy()");
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
