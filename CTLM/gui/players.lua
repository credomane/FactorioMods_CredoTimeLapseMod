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

--Factorio provided libs
require "defines"

if not CTLM then CTLM = {} end
if not CTLM.gui then CTLM.gui = {} end

------------------------------------------------------------------------------------------------------
--PLAYERS SETTINGS
------------------------------------------------------------------------------------------------------
function CTLM.gui.CTLM_settings_players_open(event)
    local player = game.get_player(event.player_index);
    if player.gui.center.CTLM_settings_players ~= nil then
        return;
    end

    --root frame
    local rootFrame = player.gui.center.add({
        type="frame",
        direction="vertical",
        name="CTLM_settings_players",
        caption={"settings.players.title"}
    });

    --root frame buttons
    local buttons = rootFrame.add({type="flow", name="buttons", direction="horizontal"});
    buttons.style.minimal_width = 500;
    buttons.style.maximal_width = 1000;
    buttons.add({type="button", name="CTLM_settings_players_close", caption={"settings.close"}});

    --main frame
    local mainFrame = rootFrame.add({
        type="frame",
        name="main",
        direction="vertical",
        caption={"settings.players.header"},
        style="naked_frame_style"
    });

    local subFrameCounter = 0;
    local function newSubFrame()
        local frame = mainFrame.add({
            type="frame",
            name="sub" .. subFrameCounter,
            direction="horizontal",
            style="naked_frame_style"
        });
        subFrameCounter = subFrameCounter + 1;
        return frame;
    end

    local subFrame = newSubFrame();
    local buttonCounter = 0;
    for index, player in pairs(game.players) do
        local playerName = CTLM.getPlayerName(player);

        if not global.players[player.index] then
            global.players[player.index] = CTLM.deepCopy(config.player_defaults);
            global.players[player.index].name = playerName;
        end

        subFrame.add({type="button", name="CTLM_settings_playerEdit_open_" .. player.index, caption=playerName});

        buttonCounter = buttonCounter + 1;
        if buttonCounter % 5 == 0 then
            subFrame = newSubFrame();
        end
    end
end

function CTLM.gui.CTLM_settings_players_close(event)
    local player = game.get_player(event.player_index);
    if player.gui.center.CTLM_settings_players ~= nil then
        player.gui.center.CTLM_settings_players.destroy();
    end
end

function CTLM.gui.CTLM_settings_players_save(event)
    local player = game.get_player(event.player_index);
end

------------------------------------------------------------------------------------------------------
--PLAYER EDIT SETTINGS
------------------------------------------------------------------------------------------------------
function CTLM.gui.CTLM_settings_playerEdit_open(event)
    local player = game.get_player(event.player_index);
    local playerEditName = string.trimStart(event.element.name, "CTLM_settings_playerEdit_open_");

    if player.gui.center.CTLM_settings_playerEdit ~= nil then
        player.gui.center.CTLM_settings_playerEdit.destroy();
    end

    --root frame
    local rootFrame = player.gui.center.add({
        type="frame",
        direction="vertical",
        name="CTLM_settings_playerEdit",
        caption={"settings.playerEdit.title"}
    });

    --main frame
    local mainFrame = rootFrame.add({
        type="frame",
        name="main",
        direction="vertical",
        caption=playerEditName,
        style="naked_frame_style"
    });

    --[beg] Main frame -> player enabled setting
    local enabled_flow = mainFrame.add({type="flow", name="enabled_flow", direction="horizontal"});
    enabled_flow.add({type="checkbox", name="checkbox", caption={"settings.playerEdit.enabled"}, state=global.players[player.index].enabled});
    --[end] Main frame -> player enabled setting

    --[beg] Main frame -> dayOnly setting
    local dayOnly_flow = mainFrame.add({type="flow", name="dayOnly_flow", direction="horizontal"});
    dayOnly_flow.add({type="checkbox", name="checkbox", caption={"settings.playerEdit.dayOnly"}, state=global.players[player.index].dayOnly});
    --[end] Main frame -> dayOnly setting

    --[beg] Main frame -> width setting
    local width_flow = mainFrame.add({type="flow", name="width_flow", direction="horizontal"});
    width_flow.add({type="label", caption={"settings.playerEdit.width"}});
    local textfield = width_flow.add({type="textfield", name="textfield", style="number_textfield_style"});
    textfield.text=global.players[player.index].width;
    textfield.style.minimal_width = 50;
    textfield.style.maximal_width = 50;
    --[end] Main frame -> width setting

    --[beg] Main frame -> height setting
    local height_flow = mainFrame.add({type="flow", name="height_flow", direction="horizontal"});
    height_flow.add({type="label", caption={"settings.playerEdit.height"}});
    local textfield = height_flow.add({type="textfield", name="textfield", style="number_textfield_style"});
    textfield.text=global.players[player.index].height;
    textfield.style.minimal_width = 50;
    textfield.style.maximal_width = 50;
    --[end] Main frame -> height setting

    --[beg] Main frame -> zoom setting
    local zoom_flow = mainFrame.add({type="flow", name="zoom_flow", direction="horizontal"});
    zoom_flow.add({type="label", caption={"settings.playerEdit.zoom"}});
    local textfield = zoom_flow.add({type="textfield", name="textfield", style="number_textfield_style"});
    textfield.text=global.players[player.index].zoom;
    textfield.style.minimal_width = 50;
    textfield.style.maximal_width = 50;
    --[end] Main frame -> zoom setting

    --[beg] Main frame -> showGui setting
    local showGui_flow = mainFrame.add({type="flow", name="showGui_flow", direction="horizontal"});
    showGui_flow.add({type="checkbox", name="checkbox", caption={"settings.playerEdit.showGui"}, state=global.players[player.index].showGui});
    --[end] Main frame -> showGui setting

    --[beg] Main frame -> showAltInfo setting
    local showAltInfo_flow = mainFrame.add({type="flow", name="showAltInfo_flow", direction="horizontal"});
    showAltInfo_flow.add({type="checkbox", name="checkbox", caption={"settings.playerEdit.showAltInfo"}, state=global.players[player.index].showAltInfo});
    --[end] Main frame -> showAltInfo setting

    --Main frame buttons
    local buttons = rootFrame.add({type="flow", name="buttons", direction="horizontal"});
    buttons.style.minimal_width = 500;
    buttons.style.maximal_width = 1000;
    buttons.add({type="button", name="CTLM_settings_playerEdit_close", caption={"settings.cancel"}});
    buttons.add({type="button", name="CTLM_settings_playerEdit_save", caption={"settings.save"}});

end

function CTLM.gui.CTLM_settings_playerEdit_close(event)
    local player = game.get_player(event.player_index);
    if player.gui.center.CTLM_settings_playerEdit ~= nil then
        player.gui.center.CTLM_settings_playerEdit.destroy();
    end
end

function CTLM.gui.CTLM_settings_playerEdit_save(event)
    local player = game.get_player(event.player_index);
    local PlayerEditFrame = player.gui.center.CTLM_settings_playerEdit.main;
    local playerEditName = PlayerEditFrame.caption;
    local enabled = PlayerEditFrame.enabled_flow.checkbox.state;
    local dayOnly = PlayerEditFrame.dayOnly_flow.checkbox.state;
    local width = tonumber(PlayerEditFrame.width_flow.textfield.text);
    local height = tonumber(PlayerEditFrame.height_flow.textfield.text);
    local zoom = tonumber(PlayerEditFrame.zoom_flow.textfield.text);
    local showGui = PlayerEditFrame.showGui_flow.checkbox.state;
    local showAltInfo = PlayerEditFrame.showAltInfo_flow.checkbox.state;

    local playerEditPlayer = game.get_player(playerEditName);
    global.players[player.index].enabled = enabled;
    global.players[player.index].dayOnly = dayOnly;
    global.players[player.index].width = width;
    global.players[player.index].height = height;
    global.players[player.index].zoom = zoom;
    global.players[player.index].showGui = showGui;
    global.players[player.index].showAltInfo = showAltInfo;
end
