--[[
    Default settings used when the mod is loaded for the first time in a world.
    All settings can be changed through the ingame menu.
    Please try not to edit this file.
    I can't stop you though so do what you want. :D
]]

config_defaults = {};
config_defaults.version = MOD_VERSION;

config_defaults.players = {};
config_defaults.positions = {};
config_defaults.surfaces = {};

config_defaults.enabled = false; -- Mod requires some basic config in gui first.

config_defaults.saveFolder = "temp"; -- saves to script-output/CTLM/<saveFolder>/
config_defaults.screenshotNumber = 0; -- Last number used for a screenshot to prevent overwriting older screenshots.
config_defaults.screenshotInterval = 18000; --[[Approximately 5 minutes worth of game ticks.
    WARNING: mod will NOT take screenshots when game.speed is greater than 3!
    Interval is in game ticks. Formula for approximate minutes is x * y * z;
    x=desired minutes
    y=60; which is 60 seconds in a minute.
    z=60; which is 60 ticks in a second.
]]

config_player_defaults = {};
config_player_defaults.enabled = false;
config_player_defaults.zoom = 1; -- zoom > 0; Zoom level is allowed to be a decimal. i.e. 0.12345
config_player_defaults.width = 1920;
config_player_defaults.height = 1080;
config_player_defaults.show_gui = false;
config_player_defaults.show_altinfo = false;
config_player_defaults.dayOnly = true;


config_position_defaults = {};
config_position_defaults.enabled = true;
config_position_defaults.zoom = 0.65; -- zoom > 0; Zoom level is allowed to be a decimal. i.e. 0.12345
config_position_defaults.width = 1920;
config_position_defaults.height = 1080;
config_position_defaults.positionX = 0;
config_position_defaults.positionY = 0;
config_position_defaults.show_gui = false;
config_position_defaults.show_altinfo = true;
config_position_defaults.dayOnly = true;

config_surface_defaults = {};
config_surface_defaults.enabled = false;
config_surface_defaults.zoom = 0.65; -- zoom > 0; Zoom level is allowed to be a decimal. i.e. 0.12345
config_surface_defaults.width = 1920;
config_surface_defaults.height = 1080;
config_surface_defaults.positionX = 0;
config_surface_defaults.positionY = 0;
config_surface_defaults.show_gui = false;
config_surface_defaults.show_altinfo = true;
config_surface_defaults.dayOnly = true;
