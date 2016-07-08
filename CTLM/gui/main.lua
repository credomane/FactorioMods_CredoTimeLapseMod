--[[
The MIT License (MIT)

Copyright (c) 2016 Credomane

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

if not CTLM then CTLM = {} end
if not CTLM.gui then CTLM.gui = {} end

------------------------------------------------------------------------------------------------------
--MAIN SETTINGS
------------------------------------------------------------------------------------------------------
function CTLM.gui.CTLM_settings_main_open(event)
    local player = game.players[event.player_index];
    if player.gui.center.CTLM_settings_main ~= nil then
        --Open button has been hit twice. Perform close action instead.
        CTLM.gui.CTLM_settings_main_close(event);
        return;
    end

    --root frame
    local rootFrame = player.gui.center.add({
        type="frame",
        direction="vertical",
        name="CTLM_settings_main",
        caption={"settings.main.title"}
    });

    --Main frame
    local mainFrame = rootFrame.add({
        type="frame",
        name="mainFrame",
        caption={"settings.main.header"},
        direction="vertical",
        style="naked_frame_style"
    });

    --[beg] Main frame -> mod enabled setting
    mainFrame.add({type="checkbox", name="enabled", caption={"settings.main.enabled"}, state=global.config.enabled});
    --[end] Main frame -> mod enabled setting

    --[beg] Main frame -> debug enabled setting
    mainFrame.add({type="checkbox", name="debugEnabled", caption={"settings.main.debugEnabled"}, state=global.debug});
    --[end] Main frame -> debug enabled setting

    --[beg] Main frame -> debug enabled setting
    mainFrame.add({type="checkbox", name="noticesEnabled", caption={"settings.main.noticesEnabled"}, state=global.config.noticesEnabled});
    --[end] Main frame -> debug enabled setting

    --[beg] Main frame -> saveFolder setting
    local saveFolder_flow = mainFrame.add({type="flow", name="saveFolder_flow", direction="horizontal"});
    saveFolder_flow.add({type="label", caption={"settings.main.savefolder_left"}});
    local textfield = saveFolder_flow.add({type="textfield", name="saveFolder", style="number_textfield_style"});
    textfield.text=global.config.saveFolder;
    textfield.style.minimal_width = 250;
    textfield.style.maximal_width = 250;
    --[end] Main frame -> saveFolder setting

    --[beg] Main frame -> screenshotInterval setting
    local screenshotInterval_flow = mainFrame.add({type="flow", name="screenshotInterval_flow", direction="horizontal"});
    screenshotInterval_flow.add({type="label", caption={"settings.main.screenshotInterval_left"}});
    local textfield = screenshotInterval_flow.add({type="textfield", name="screenshotInterval", style="number_textfield_style"});
    textfield.text=global.config.screenshotInterval;
    screenshotInterval_flow.add({type="label", caption={"settings.main.screenshotInterval_right"}});
    --[end] Main frame -> screenshotInterval setting

    --Main frame screenshot buttons
    local ssButtons_flow = mainFrame.add({type="flow", name="ssButtons_flow", direction="horizontal"});
    local ssButtons = ssButtons_flow.add({type="flow", name="ssbuttons", direction="horizontal"});
    ssButtons.style.minimal_width = 500;
    ssButtons.style.maximal_width = 1000;
    ssButtons.add({type="button", name="CTLM_settings_players_open", caption={"settings.players"}});
    ssButtons.add({type="button", name="CTLM_settings_positions_open", caption={"settings.positions"}});

    --root frame buttons
    local buttons = rootFrame.add({type="flow", name="buttons", direction="horizontal"});
    buttons.style.minimal_width = 500;
    buttons.style.maximal_width = 1000;
    buttons.add({type="button", name="CTLM_settings_main_close", caption={"settings.close"}});
    buttons.add({type="button", name="CTLM_settings_main_save", caption={"settings.save"}});
end

function CTLM.gui.CTLM_settings_main_close(event)
    local player = game.players[event.player_index];
    if player.gui.center.CTLM_settings_main ~= nil then
        player.gui.center.CTLM_settings_main.destroy();
    end
end

function CTLM.gui.CTLM_settings_main_save(event)
    local player = game.players[event.player_index];

    local enabled = player.gui.center.CTLM_settings_main.mainFrame.enabled.state;
    local debugEnabled = player.gui.center.CTLM_settings_main.mainFrame.debugEnabled.state;
    local noticesEnabled = player.gui.center.CTLM_settings_main.mainFrame.noticesEnabled.state;
    local saveFolder = player.gui.center.CTLM_settings_main.mainFrame.saveFolder_flow.saveFolder.text;
    local screenshotInterval = tonumber(player.gui.center.CTLM_settings_main.mainFrame.screenshotInterval_flow.screenshotInterval.text);

    global.config.enabled = enabled;
    global.debug = debugEnabled;
    global.config.noticesEnabled = noticesEnabled;

    if saveFolder ~= nil and saveFolder ~= '' then
        global.config.saveFolder = saveFolder;
    else
        player.print("[CTLM] Save folder is invalid. Continuing to use previous value.");
    end

    if screenshotInterval ~= nil then
        if screenshotInterval < 600 then
            player.print("[CTLM] Screenshot interval too fast. Forced to 600 (10 seconds).");
            screenshotInterval = 600;
        end
        global.config.screenshotInterval = screenshotInterval;
    else
        player.print("[CTLM] Screenshot interval not a valid number. Continuing to use previous value.");
    end

    player.print("[CTLM] Core settings updated.");
end
