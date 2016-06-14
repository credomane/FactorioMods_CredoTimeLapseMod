
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
    for _, player in ipairs(game.players) do
        if player.valid and player.connected then
            self.printall("Init.player: " + player.name);
        end
    end
end

function CTLM:load()
    _G[ CONFIG_NAME ] = _G[ CONFIG_NAME ] or config_defaults;
    config = _G[ CONFIG_NAME ];

    self.printall("Load");
    for _, player in ipairs(game.players) do
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

    if config.gameSpeedTooFast and not config.enabled then
        return;
    end

    if game.tick % (game.speed * config.screenshotInterval ) == 0 then
end

--Helper functions are the bees knees!
function CTLM:printall(msg)
    for _, player in ipairs(game.players) do
        if player.valid and player.connected then
            player.print(msg);
        end
    end
end

function CTLM:playerScreenshot(index)
    if game.
end

--Register event handlers!
script.on_init(CTLM.init);
script.on_load(CTLM.load);
script.on_tick(CTLM.tick);
