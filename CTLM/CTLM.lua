
--Factorio provided libs
require "defines"
require "util"

--CTLM libs
require "CTLM.config"
require "CTLM.gui"

if not CTLM then CTLM = {} end
if not CTLM.config then CTLM.config = {} end
if not CTLM.gui then CTLM.gui = {} end

function CTML.init()
    CTLM.log("BEG on_init");
    CTMLconfig.init();
    CTMLgui.init();
    CTLM.load();
    CTLM.log("END on_init");
end

function CTML.load()
    CTLM.log("BEG on_load");
    CTMLconfig.initConfig()
    CTLM.log("END on_load");
end

function CTML.tick()
    if game.speed > 3 or not CTLMconfig.enabled then
        return;
    end

    if game.tick % (game.speed * CTLMconfig.screenshotInterval ) == 0 then
        --Time to loop through and take them screenshots!
        CTLM.log("Taking screenshots...");
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
    CTML.log("playerScreenshot: " .. game.players[index].name);
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
    CTML.log("positionScreenshot: " .. game.positions[index].name);
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

function CTML.log(msg)
    if game then
        game.write_file(MOD_NAME .. "/debug.log", msg .. "\n", true);

        for index, player in ipairs(game.players) do
            player.print(message)
        end
    else
        error(serpent.dump(message, {compact = false, nocode = true, indent = ' '}))
    end
end
