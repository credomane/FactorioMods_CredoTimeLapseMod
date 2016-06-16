--[[
    Default settings used when a position is added to the config for the first time.
    All settings can be changed through the ingame menu.
    Please try not to edit this file.
    I can't stop you though; so do what you want. :D
]]

if not config then config = {} end
if not config.position_defaults then config.position_defaults = {} end

config.position_defaults.enabled = false;
config.position_defaults.name = "temp";
config.position_defaults.surface = "nauvis";

config.position_defaults.dayOnly = true;

config.position_defaults.width = 1920;
config.position_defaults.height = 1080;
config.position_defaults.zoom = 0.65; -- zoom > 0; Zoom level is allowed to be a decimal. i.e. 0.12345

config.position_defaults.positionX = 0;
config.position_defaults.positionY = 0;

config.position_defaults.show_gui = false;
config.position_defaults.show_altinfo = true;

