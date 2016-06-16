--[[
    Default settings used when a player is added to the config for the first time.
    All settings can be changed through the ingame menu.
    Please try not to edit this file.
    I can't stop you though; so do what you want. :D
]]

if not config then config = {} end
if not config.player_defaults then config.player_defaults = {} end

config.player_defaults.enabled = false;


config.player_defaults.dayOnly = true;

config.player_defaults.width = 1920;
config.player_defaults.height = 1080;
config.player_defaults.zoom = 1; -- zoom > 0; Zoom level is allowed to be a decimal. i.e. 0.12345

config.player_defaults.show_gui = false;

config.player_defaults.show_altinfo = false;
