--[[
    Default settings used when the mod is loaded for the first time in a world.
    All settings can be changed through the ingame menu.
    Please try not to edit this file.
    I can't stop you though; so do what you want. :D
]]

if not config then config = {} end
if not config.defaults then config.defaults = {} end

config.defaults.enabled = false; -- Mod requires some basic config in gui first.

config.defaults.noticesEnabled = false;

-- Last number used for registering a position in global.positions
config.defaults.lastPosition = 0;

-- saves to script-output/CTLM/<saveFolder>/
config.defaults.saveFolder = "temp";

-- Last number used for a screenshot to prevent overwriting older screenshots.
config.defaults.screenshotNumber = 0;

--[[Approximately 5 minutes worth of game ticks.
    WARNING: mod will NOT take screenshots when game.speed is greater than 3!
        game.screenshot() pauses the game for a screenshot. If game.speed it too fast you could get stuck taking
        screenshot after screenshot and being helpless. This is my poor mans attempt to prevent that.
    WARNING: min value is 600. Approximately 10 seconds. CTLM will set interval to 600 if below 600 or 18000 if invalid.
    NOTICE: I'm lazy. If game.tick % interval == 0 then loop through and take ALL screenshots.
        Opposed to recording the game.tick when interval is changed or a "screenshot" is enabled. Then triggering a screenshot
        every interval after that. Not a problem, IMO but something you should be aware of. :)
    Interval is in game ticks. Formula for approximate minutes is x * y * z;
    x=desired minutes
    y=60; which is 60 seconds in a minute.
    z=60; which is 60 ticks in a second.
]]
config.defaults.screenshotInterval = 18000;
