
--Factorio provided libs
require "defines"
require "util"

--CTLM libs
require "CTLM.config"
require "CTLM.gui"

if not CTLM then CTLM = {} end
if not CTLM.config then CTLM.config = {} end
if not CTLM.gui then CTLM.gui = {} end

function CTLM.init()
    CTLM.log("BEG on_init");
    CTLM.config.init();

    for _, player in pairs(game.players) do
        CTLM.config.new_player(player)
    end

    CTLM.gui.init();
    CTLM.load();
    CTLM.log("END on_init");
end

function CTLM.load()
    CTLM.log("BEG on_load");
    CTLM.config.init()
    CTLM.gui.init()
    CTLM.log("END on_load");
end

function CTLM.tick()
    if game.speed > 3 or not CTLM.config.get("enabled") then
        return;
    end

    if game.tick % (game.speed * CTLM.config.get("screenshotInterval")) == 0 then
        --Time to loop through and take them screenshots!
        CTLM.log("Taking screenshots...");
        local screenshotTaken = false;
        for index, player in ipairs(game.players) do
            local configPlayer = CTLM.config.get_player(player.name);
            if player.valid and player.connected and configPlayer and configPlayer.enabled then
                screenshotTaken = true;
                CTLM.screenshotPlayer(configPlayer);
            end
        end

        for index, position in ipairs(CTLM.config.get_positions()) do
            if position.enabled then
                screenshotTaken = true;
                CTLM.screenshotPosition(position);
            end
        end

        if screenshotTaken then
            CTLM.config.set("screenshotNumber", CTLM.config.get("screenshotNumber") + 1);
        end
    end
end

--------------------------------------
--Helper functions are the bees knees!
--------------------------------------

function CTLM.getPlayerByName(name)
    for index, player in pairs(game.players) do
        if player.name == name then
            return player;
        end
    end
    return nil;
end


--------------------------------------
--screenshot functions!
--------------------------------------

function CTLM.screenshotPlayer(configPlayer)
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
    local currentTime = game.daytime;

    if configPosition.dayOnly then
        game.daytime = 0;
    end

    game.take_screenshot({
--        surface = game.surfaces[configPosition.surface],
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
    return MOD_NAME .. "/" .. screenshotType .. "/" .. screenshotName .. "/" .. string.format("%05d", CTLM.config.get("screenshotNumber")) .. ".png";
end

function CTLM.log(msg)
    if type(msg) == "table" then
        for key,value in pairs(msg) do
            msg = value .. "[" .. key .. "] ";
        end
    end

    msg = "[CTLM] " .. msg;

    if game then
        game.write_file(MOD_NAME .. "/debug.log", msg .. "\n", true);

        for index, player in ipairs(game.players) do
            player.print(msg)
        end
    else
        error(serpent.dump(msg, {compact = false, nocode = true, indent = ' '}))
    end
end
