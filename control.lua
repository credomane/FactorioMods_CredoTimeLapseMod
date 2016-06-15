
--Factorio provided libs
require "util"
require "defines"

--CTLM libs
require "config.defaults"


MOD_NAME = "CTLM";
MOD_VERSION = "0.0.1";

config = {};

function init()
debuglog("BEG on_init");
    initConfig()
    load();
debuglog("END on_init");
end

function load()
debuglog("BEG on_load");
    initConfig()
debuglog("END on_load");
end

function tick()
    if game.speed > 3 or not config.enabled then
        return;
    end

    if game.tick % (game.speed * config.screenshotInterval ) == 0 then
        --Time to loop through them screenshots!
        debuglog("Taking screenshots...");
        local screenshotTaken = false;
        for index, player in ipairs(game.players) do
            if player.valid and player.connected and config.players[index] and config.players[index].enabled then
                screenshotTaken = true;
                playerScreenshot(index);
            end
        end

        for index, position in ipairs(config.positions) do
            if config.positions[index] and config.positions[index].enabled then
                screenshotTaken = true;
                positionScreenshot(index);
            end
        end

        for index, surface in pairs(game.surfaces) do
            if surface.valid and config.surfaces[index] and config.surfaces[index].enabled then
                screenshotTaken = true;
                surfaceScreenshot(index);
            end
        end

        if screenshotTaken then
            config.screenshotNumber = config.screenshotNumber + 1;
        end
    end
end

--------------------------------------
--Helper functions are the bees knees!
--------------------------------------

--Fix/install config!
function initConfig()
    if not global.config then
        global.config = deepCopy(config_defaults);
    end
    config = global.config;
end

--screenshot functions!
function playerScreenshot(index)
    local currentTime = game.daytime;
    if config.players[index].dayOnly then
        game.daytime = 0;
    end

    game.take_screenshot({
        player = game.players[index],
        resolution = { config.players[index].width, config.players[index].height },
        zoom = config.players[index].zoom,
        path = genFilename("player", game.players[index].name),
        config.players[index].show_gui,
        config.players[index].show_altinfo
    });

    game.daytime = currentTime;
    printall("playerScreenshot: " .. game.players[index].name);
end

function positionScreenshot(index)
    local currentTime = game.daytime;
    if config.positions[index].dayOnly then
        game.daytime = 0;
    end

    game.take_screenshot({
--        surface = game.surfaces[index],
        position = { config.positions[index].positionX, config.positions[index].positionY },
        resolution = { config.positions[index].width, config.positions[index].height },
        zoom = config.positions[index].zoom,
        path = genFilename("position", game.positions[index].name),
        config.positions[index].show_gui,
        config.positions[index].show_altinfo
    });

    game.daytime = currentTime;
    printall("positionScreenshot: " .. game.positions[index].name);
end

function surfaceScreenshot(index)
    local currentTime = game.daytime;
    if config.surfaces[index].dayOnly then
        game.daytime = 0;
    end

    game.take_screenshot({
        surface = game.surfaces[index],
        position = { config.surfaces[index].positionX, config.surfaces[index].positionY },
        resolution = { config.surfaces[index].width, config.surfaces[index].height },
        zoom = config.surfaces[index].zoom,
        path = genFilename("surface", game.surfaces[index].name),
        config.surfaces[index].show_gui,
        config.surfaces[index].show_altinfo
    });

    game.daytime = currentTime;
    printall("surfaceScreenshot: " .. game.surfaces[index].name);
end

--add*(index) functions
function addPlayer(index)
    if not config.players[index] then
        config.players[index] = deepCopy(config_player_defaults);
    end
end

function addPosition(index)
    if not config.positions[index] then
        config.positions[index] = deepCopy(config_position_defaults);
    end
end

function addSurface(index)
    if not config.surfaces[index] then
        config.surfaces[index] = deepCopy(config_surface_defaults);
    end
end

--File name to save screenshot as
function GenFilename(screenshotType, screenshotName)
    return MOD_NAME .. "/" .. screenshotType .. "/" .. screenshotName .. "/" .. string.format("%05d", config.screenshotNumber) .. ".png";
end

--Print a message to ALL players currently connected. Only used in debugging but left in release so it isn't lost.
function printall(msg)
    for index, player in ipairs(game.players) do
        if player.valid and player.connected then
            player.print(msg);
        end
    end
end

function debug(msg)
    if not game then
        return;
    end
--    if config.debug then
        game.write_file(MOD_NAME .. "/debug.log", msg .. "\n", true);
--    end
end

--Special function to "deep" copy a table to avoid references. That would be bad. :/
function deepCopy(object)
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

--Register event handlers!
script.on_init(init);
script.on_load(load);
script.on_event(defines.events.on_tick, tick);

