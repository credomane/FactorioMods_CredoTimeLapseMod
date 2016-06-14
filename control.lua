
--Factorio provided libs
require "util"
require "defines"

--CTLM libs
require "config.defaults"


local MOD_NAME = "CTLM";
local MOD_VERSION = 0.1;
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

    self.printall("Load");
    for index, player in ipairs(game.players) do
        if player.valid and player.connected then
            self.printall("Load.player: " + player.name);
        end
    end
end

function CTLM:playerCreated(event)
    self.addPlayer(event.player_index);

    self.printall("playerCreated");
    for index, player in ipairs(game.players) do
        if player.valid and player.connected then
            self.printall("playerCreated.player: " + player.name);
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
        for index, player in ipairs(game.players) do
            if player.valid and player.connected and config.players[index] and config.players[index].enabled then
                self.playerScreenshot(index);
            end
        end

        for index, surface in ipairs(game.surfaces) do
            if surface.valid and config.surfaces[index] and config.surfaces[index].enabled then
                self.surfaceScreenshot(index);
            end
        end
    end
end

--Helper functions are the bees knees!
function CTLM:addPlayer(index)
    if not config.players[index] then
        config.players[index] = self.tableCopy(config_defaults.player_defaults);
    end
end

function CTLM:addSurface(index)
    if not config.surfaces[index] then
        config.surfaces[index] = self.tableCopy(config_defaults.surface_defaults);
    end
end

function CTLM:printall(msg)
    for index, player in ipairs(game.players) do
        if player.valid and player.connected then
            player.print(msg);
        end
    end
end


function CTLM:tableCopy(obj)
  if type(obj) ~= 'table' then return obj end
  local res = {}
  for k, v in pairs(obj) do res[self.TableCopy(k)] = self.TableCopy(v) end
  return res
end

function CTLM:playerScreenshot(index)
    self.printall("player.screenshot: " + game.players[index].name);
end

function CTLM:surfaceScreenshot(index)
    self.printall("surface.screenshot: " + game.surfaces[index].name);
end

--Register event handlers!
script.on_init(CTLM.init);
script.on_load(CTLM.load);
script.on_event(defines.events.on_tick, CTLM.tick);
script.on_event(defines.events.on_player_created, CTLM.playerCreated);
--script.on_event(defines.events.on_surface_created, CTLM.surfaceCreated); -- Event doesn't exist. Checking for new surfaces only when opening surface gui for now. :(
