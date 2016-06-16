
--Factorio provided libs
require "defines"
require "util"

--CTLM libs
require "config.defaults"
require "CTLMgui"


MOD_NAME = "CTLM";
MOD_VERSION = "0.0.1";

if not CTLM then CTLM = {} end
if not CTLMconfig then CTLMconfig = {} end
if not CTLMgui then CTLMgui = {} end

--Ran first time [only] mod is installed into a game world.
function CTML.init()
debuglog("BEG on_init");
    CTLM.load();
debuglog("END on_init");
end

--Ran everytime a world is loaded that has a reference to this mod.
function CTML.load()
debuglog("BEG on_load");
    CTLM.initConfig()
debuglog("END on_load");
end

function CTML.tick()
    if game.speed > 3 or not CTLMconfig.enabled then
        return;
    end

    if game.tick % (game.speed * CTLMconfig.screenshotInterval ) == 0 then
        --Time to loop through them screenshots!
        debuglog("Taking screenshots...");
        local screenshotTaken = false;
        for index, player in ipairs(game.players) do
            if player.valid and player.connected and CTLMconfig.players[player.name] and CTLMconfig.players[player.name].enabled then
                screenshotTaken = true;
                playerScreenshot(player.name);
            end
        end

        for index, position in ipairs(CTLMconfig.positions) do
            if CTLMconfig.positions[index] and CTLMconfig.positions[index].enabled then
                screenshotTaken = true;
                positionScreenshot(index);
            end
        end

        for index, surface in pairs(game.surfaces) do
            if surface.valid and CTLMconfig.surfaces[surface.name] and CTLMconfig.surfaces[surface.name].enabled then
                screenshotTaken = true;
                surfaceScreenshot(surface.name);
            end
        end

        if screenshotTaken then
            CTLMconfig.screenshotNumber = CTLMconfig.screenshotNumber + 1;
        end
    end
end

--------------------------------------
--Helper functions are the bees knees!
--------------------------------------

--Fix/install config!
function CTML.initConfig()
    if not global.config then
        global.config = deepCopy(config_defaults);
    end
    CTLMconfig = global.config;
end

--screenshot functions!
function CTML.playerScreenshot(index)
    local currentTime = game.daytime;
    if CTLMconfig.players[index].dayOnly then
        game.daytime = 0;
    end

    game.take_screenshot({
        player = game.players[index],
        resolution = { CTLMconfig.players[index].width, CTLMconfig.players[index].height },
        zoom = CTLMconfig.players[index].zoom,
        path = genFilename("player", game.players[index].name),
        CTLMconfig.players[index].show_gui,
        CTLMconfig.players[index].show_altinfo
    });

    game.daytime = currentTime;
    printall("playerScreenshot: " .. game.players[index].name);
end

function CTML.positionScreenshot(index)
    local currentTime = game.daytime;
    if CTLMconfig.positions[index].dayOnly then
        game.daytime = 0;
    end

    game.take_screenshot({
--        surface = game.surfaces[index],
        position = { CTLMconfig.positions[index].positionX, CTLMconfig.positions[index].positionY },
        resolution = { CTLMconfig.positions[index].width, CTLMconfig.positions[index].height },
        zoom = CTLMconfig.positions[index].zoom,
        path = genFilename("position", game.positions[index].name),
        CTLMconfig.positions[index].show_gui,
        CTLMconfig.positions[index].show_altinfo
    });

    game.daytime = currentTime;
    printall("positionScreenshot: " .. game.positions[index].name);
end

function CTML.surfaceScreenshot(index)
    local currentTime = game.daytime;
    if CTLMconfig.surfaces[index].dayOnly then
        game.daytime = 0;
    end

    game.take_screenshot({
        surface = game.surfaces[index],
        position = { CTLMconfig.surfaces[index].positionX, CTLMconfig.surfaces[index].positionY },
        resolution = { CTLMconfig.surfaces[index].width, CTLMconfig.surfaces[index].height },
        zoom = CTLMconfig.surfaces[index].zoom,
        path = genFilename("surface", game.surfaces[index].name),
        CTLMconfig.surfaces[index].show_gui,
        CTLMconfig.surfaces[index].show_altinfo
    });

    game.daytime = currentTime;
    printall("surfaceScreenshot: " .. game.surfaces[index].name);
end

--add*(index) functions
function CTML.addPlayer(index)
    if not CTLMconfig.players[index] then
        CTLMconfig.players[index] = deepCopy(config_player_defaults);
    end
end

function CTML.addPosition(index)
    if not CTLMconfig.positions[index] then
        CTLMconfig.positions[index] = deepCopy(config_position_defaults);
    end
end

function CTML.addSurface(index)
    if not CTLMconfig.surfaces[index] then
        CTLMconfig.surfaces[index] = deepCopy(config_surface_defaults);
    end
end

--File name to save screenshot as
function CTML.GenFilename(screenshotType, screenshotName)
    return MOD_NAME .. "/" .. screenshotType .. "/" .. screenshotName .. "/" .. string.format("%05d", CTLMconfig.screenshotNumber) .. ".png";
end

--Print a message to ALL players currently connected. Only used in debugging but left in release so it isn't lost.
function CTML.printall(msg)
    for index, player in ipairs(game.players) do
        if player.valid and player.connected then
            player.print(msg);
        end
    end
end

function CTML.debug(msg)
    if not game then
        return;
    end
    if CTLMdebug then
        game.write_file(MOD_NAME .. "/debug.log", msg .. "\n", true);
    end
end

--Special function to "deep" copy a table to avoid references. That would be bad. :/
function CTML.deepCopy(object)
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
