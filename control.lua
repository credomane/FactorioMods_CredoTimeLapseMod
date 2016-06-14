
--Factorio provided libs
require "util"
require "defines"

--CTLM libs
require "config.defaults"


local MOD_NAME = "CTLM";
local MOD_VERSION = "0.0.1";
local CONFIG_NAME = MOD_NAME .. "_config";
local CTLM = {};
local config = {};

function CTLM:init()
    self.printall("Init");
    for index, player in ipairs(game.players) do
        if player.valid and player.connected then
            self.printall("Init.player: " + player.name);
        end
    end
end

function CTLM:load()
    _G[ CONFIG_NAME ] = _G[ CONFIG_NAME ] or config_defaults;
    config = _G[ CONFIG_NAME ];

    if not config.version then
        config.version = MOD_VERSION;
    end

    self.printall("Load");
    for index, player in ipairs(game.players) do
        if player.valid and player.connected then
            self.printall("Load.player: " + player.name);
        end
    end
end

function CTLM:tick()
    if game.speed > 3 then
        config.gameSpeedTooFast=true;
    else
        config.gameSpeedTooFast=false;
    end

    if config.gameSpeedTooFast or not config.enabled then
        return;
    end

    if game.tick % (game.speed * config.screenshotInterval ) == 0 then
        --Time to loop through them screenshots!
        local screenshotTaken = false;
        for index, player in ipairs(game.players) do
            if player.valid and player.connected and config.players[index] and config.players[index].enabled then
                screenshotTaken = true;
                self.playerScreenshot(index);
            end
        end

        for index, position in ipairs(config.positions) do
            if config.positions[index] and config.positions[index].enabled then
                screenshotTaken = true;
                self.positionScreenshot(index);
            end
        end

        for index, surface in ipairs(game.surfaces) do
            if surface.valid and config.surfaces[index] and config.surfaces[index].enabled then
                screenshotTaken = true;
                self.surfaceScreenshot(index);
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

--CTLM:*screenshot functions!
function CTLM:playerScreenshot(index)
    local currentTime = game.daytime;
    if config.players[index].dayOnly then
        game.daytime = 0;
    end

    game.take_screenshot({
        player = game.players[index],
        resolution = { config.players[index].width, config.players[index].height },
        zoom = config.players[index].zoom,
        path = self.genFilename("player", game.players[index].name),
        config.players[index].show_gui,
        config.players[index].show_altinfo
    });

    game.daytime = currentTime;
    self.printall("playerScreenshot: " + game.players[index].name);
end

function CTLM:positionScreenshot(index)
    local currentTime = game.daytime;
    if config.positions[index].dayOnly then
        game.daytime = 0;
    end

    game.take_screenshot({
--        surface = game.surfaces[index],
        position = { config.positions[index].positionX, config.positions[index].positionY },
        resolution = { config.positions[index].width, config.positions[index].height },
        zoom = config.positions[index].zoom,
        path = self.genFilename("position", game.positions[index].name),
        config.positions[index].show_gui,
        config.positions[index].show_altinfo
    });

    game.daytime = currentTime;
    self.printall("positionScreenshot: " + game.positions[index].name);
end

function CTLM:surfaceScreenshot(index)
    local currentTime = game.daytime;
    if config.surfaces[index].dayOnly then
        game.daytime = 0;
    end

    game.take_screenshot({
        surface = game.surfaces[index]
        position = { config.surfaces[index].positionX, config.surfaces[index].positionY },
        resolution = { config.surfaces[index].width, config.surfaces[index].height },
        zoom = config.surfaces[index].zoom,
        path = self.genFilename("player", game.surfaces[index].name),
        config.surfaces[index].show_gui,
        config.surfaces[index].show_altinfo
    });

    game.daytime = currentTime;
    self.printall("surfaceScreenshot: " + game.surfaces[index].name);
end

--CTLM:add*(index) functions
function CTLM:addPlayer(index)
    if not config.players[index] then
        config.players[index] = self.tableCopy(config_defaults.player_defaults);
    end
end

function CTLM:addPosition(index)
    if not config.positions[index] then
        config.positions[index] = self.tableCopy(config_defaults.position_defaults);
    end
end

function CTLM:addSurface(index)
    if not config.surfaces[index] then
        config.surfaces[index] = self.tableCopy(config_defaults.surface_defaults);
    end
end

--File name to save screenshot as
function CTLM:GenFilename(screenshotType, screenshotName)
    return MOD_NAME .. "/" .. screenshotType .. "/" .. screenshotName .. "/" .. string.format("%05d", config.screenshotNumber) .. ".png";
end

--Print a message to ALL players currently connected. Only used in debugging but left in release so it isn't lost.
function CTLM:printall(msg)
    for index, player in ipairs(game.players) do
        if player.valid and player.connected then
            player.print(msg);
        end
    end
end

--Special function to "deep" copy a table to about references. That would be bad. :/
function CTLM:tableCopy(obj)
  if type(obj) ~= 'table' then return obj end
  local res = {}
  for k, v in pairs(obj) do res[self.TableCopy(k)] = self.TableCopy(v) end
  return res
end

--Register event handlers!
script.on_init(CTLM.init);
script.on_load(CTLM.load);
script.on_event(defines.events.on_tick, CTLM.tick);

