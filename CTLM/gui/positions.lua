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
--POSITIONS SETTINGS
------------------------------------------------------------------------------------------------------
function CTLM.gui.CTLM_settings_positions_open(event)
    local player = game.players[event.player_index];
    if player.gui.center.CTLM_settings_positions ~= nil then
        return;
    end

    --root frame
    local rootFrame = player.gui.center.add({
        type="frame",
        direction="vertical",
        name="CTLM_settings_positions",
        caption={"settings.positions.title"}
    });

    --root frame buttons
    local buttons = rootFrame.add({type="flow", name="buttons", direction="horizontal"});
    buttons.style.minimal_width = 500;
    buttons.style.maximal_width = 1000;
    buttons.add({type="button", name="CTLM_settings_positions_close", caption={"settings.close"}});
    buttons.add({type="button", name="CTLM_settings_positions_add", caption={"settings.positions.add"}});

    --main frame
    local mainFrame = rootFrame.add({
        type="frame",
        name="main",
        direction="vertical",
        caption={"settings.positions.header"},
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
    for index, position in pairs(global.positions) do
        subFrame.add({type="button", name="CTLM_settings_positionEdit_open_" .. index, caption=position.name});

        buttonCounter = buttonCounter + 1;
        if buttonCounter % 5 == 0 then
            subFrame = newSubFrame();
        end
    end
end

function CTLM.gui.CTLM_settings_positions_close(event)
    local player = game.players[event.player_index];
    if player.gui.center.CTLM_settings_positions ~= nil then
        player.gui.center.CTLM_settings_positions.destroy();
    end
end

function CTLM.gui.CTLM_settings_positions_add(event)
    local player = game.players[event.player_index];
    global.config.lastPosition = global.config.lastPosition + 1;
    local positionIndex = global.config.lastPosition;
    local positionName = "New Position " .. positionIndex;
    if not global.positions[positionIndex] then
        global.positions[positionIndex] = CTLM.deepCopy(config.position_defaults);
        global.positions[positionIndex].name = positionName;
    end

    local fakeEvent = {};
    fakeEvent.element = {name = "CTLM_settings_positionEdit_open_" .. positionIndex};
    fakeEvent.player_index = event.player_index;

    CTLM.gui.CTLM_settings_positions_close(event);
    CTLM.gui.CTLM_settings_positions_open(event);
    CTLM.gui.CTLM_settings_positionEdit_open(fakeEvent);
    CTLM.msgPlayer(player, "New position added. Please configure it.");
end

------------------------------------------------------------------------------------------------------
--POSITION EDIT SETTINGS
------------------------------------------------------------------------------------------------------
function CTLM.gui.CTLM_settings_positionEdit_open(event)
    local player = game.players[event.player_index];
    local positionKey = tonumber(string.trimStart(event.element.name, "CTLM_settings_positionEdit_open_"));

    if player.gui.center.CTLM_settings_positionEdit ~= nil then
        player.gui.center.CTLM_settings_positionEdit.destroy();
    end

    --root frame
    local rootFrame = player.gui.center.add({
        type="frame",
        direction="vertical",
        name="CTLM_settings_positionEdit",
        caption={"settings.positionEdit.title"}
    });

    --main frame
    local mainFrame = rootFrame.add({
        type="frame",
        name="main",
        direction="vertical",
        caption=global.positions[positionKey].name,
        style="naked_frame_style"
    });

    --[beg] Main frame -> player index Label
    local index_flow = mainFrame.add({type="flow", name="index_flow", direction="horizontal"});
    index_flow.style.minimal_width = 250;
    index_flow.style.maximal_width = 750;
    index_flow.add({type="label", name="indexLabel", caption={"settings.positionEdit.indexLabel"}});
    index_flow.add({type="label", name="index", caption=positionKey});
    --[end] Main frame -> player enabled setting

    --[beg] Main frame -> player enabled setting
    mainFrame.add({type="checkbox", name="posEnabled", caption={"settings.positionEdit.enabled"}, state=global.positions[positionKey].enabled});
    --[end] Main frame -> player enabled setting

    --[beg] Main frame -> name setting
    local name_flow = mainFrame.add({type="flow", name="name_flow", direction="horizontal"});
    name_flow.style.minimal_width = 250;
    name_flow.style.maximal_width = 750;
    name_flow.add({type="label", caption={"settings.positionEdit.name"}});
    local textfield = name_flow.add({type="textfield", name="textfield", style="number_textfield_style"});
    textfield.text=global.positions[positionKey].name;
    textfield.style.minimal_width = 250;
    textfield.style.maximal_width = 250;
    --[end] Main frame -> width setting

    --[beg] Main frame -> surface setting
    local surface_flow = mainFrame.add({type="flow", name="surface_flow", direction="horizontal"});
    surface_flow.style.minimal_width = 250;
    surface_flow.style.maximal_width = 750;
    surface_flow.add({type="label", caption={"settings.positionEdit.surface"}});
    local textfield = surface_flow.add({type="textfield", name="textfield", style="number_textfield_style"});
    textfield.text=global.positions[positionKey].surface;
    textfield.style.minimal_width = 250;
    textfield.style.maximal_width = 250;
    --[end] Main frame -> width setting

    --[beg] Main frame -> dayOnly setting
    local dayOnly_flow = mainFrame.add({type="flow", name="dayOnly_flow", direction="horizontal"});
    dayOnly_flow.style.minimal_width = 250;
    dayOnly_flow.style.maximal_width = 750;
    dayOnly_flow.add({type="checkbox", name="checkbox", caption={"settings.positionEdit.dayOnly"}, state=global.positions[positionKey].dayOnly});
    --[end] Main frame -> dayOnly setting

    --[beg] Main frame -> width setting
    local width_flow = mainFrame.add({type="flow", name="width_flow", direction="horizontal"});
    width_flow.style.minimal_width = 250;
    width_flow.style.maximal_width = 750;
    width_flow.add({type="label", caption={"settings.positionEdit.width"}});
    local textfield = width_flow.add({type="textfield", name="textfield", style="number_textfield_style"});
    textfield.text=global.positions[positionKey].width;
    textfield.style.minimal_width = 75;
    textfield.style.maximal_width = 100;
    --[end] Main frame -> width setting

    --[beg] Main frame -> height setting
    local height_flow = mainFrame.add({type="flow", name="height_flow", direction="horizontal"});
    height_flow.style.minimal_width = 250;
    height_flow.style.maximal_width = 750;
    height_flow.add({type="label", caption={"settings.positionEdit.height"}});
    local textfield = height_flow.add({type="textfield", name="textfield", style="number_textfield_style"});
    textfield.text=global.positions[positionKey].height;
    textfield.style.minimal_width = 75;
    textfield.style.maximal_width = 100;
    --[end] Main frame -> height setting

    --[beg] Main frame -> zoom setting
    local zoom_flow = mainFrame.add({type="flow", name="zoom_flow", direction="horizontal"});
    zoom_flow.style.minimal_width = 250;
    zoom_flow.style.maximal_width = 750;
    zoom_flow.add({type="label", caption={"settings.positionEdit.zoom"}});
    local textfield = zoom_flow.add({type="textfield", name="textfield", style="number_textfield_style"});
    textfield.text=global.positions[positionKey].zoom;
    textfield.style.minimal_width = 75;
    textfield.style.maximal_width = 100;
    --[end] Main frame -> zoom setting

    --[beg] Main frame -> positionX setting
    local positionX_flow = mainFrame.add({type="flow", name="positionX_flow", direction="horizontal"});
    positionX_flow.style.minimal_width = 250;
    positionX_flow.style.maximal_width = 750;
    positionX_flow.add({type="label", caption={"settings.positionEdit.positionX"}});
    local textfield = positionX_flow.add({type="textfield", name="textfield", style="number_textfield_style"});
    textfield.text=global.positions[positionKey].positionX;
    textfield.style.minimal_width = 75;
    textfield.style.maximal_width = 100;
    --[end] Main frame -> positionX setting

    --[beg] Main frame -> positionY setting
    local positionY_flow = mainFrame.add({type="flow", name="positionY_flow", direction="horizontal"});
    positionY_flow.style.minimal_width = 250;
    positionY_flow.style.maximal_width = 750;
    positionY_flow.add({type="label", caption={"settings.positionEdit.positionY"}});
    local textfield = positionY_flow.add({type="textfield", name="textfield", style="number_textfield_style"});
    textfield.text=global.positions[positionKey].positionY;
    textfield.style.minimal_width = 75;
    textfield.style.maximal_width = 100;
    --[end] Main frame -> positionY setting

    --[beg] Main frame -> showAltInfo setting
    local showAltInfo_flow = mainFrame.add({type="flow", name="showAltInfo_flow", direction="horizontal"});
    showAltInfo_flow.style.minimal_width = 250;
    showAltInfo_flow.style.maximal_width = 750;
    showAltInfo_flow.add({type="checkbox", name="checkbox", caption={"settings.positionEdit.showAltInfo"}, state=global.positions[positionKey].showAltInfo});
    --[end] Main frame -> showAltInfo setting

    --Main frame buttons
    local buttons = rootFrame.add({type="flow", name="buttons", direction="horizontal"});
    buttons.style.minimal_width = 500;
    buttons.style.maximal_width = 1000;
    buttons.add({type="button", name="CTLM_settings_positionEdit_close", caption={"settings.cancel"}});
    buttons.add({type="button", name="CTLM_settings_positionEdit_save", caption={"settings.save"}});

    local button_spacer1 = buttons.add({type="flow", name="CTLM_settings_positionEdit_spacer1"});
    button_spacer1.style.minimal_width = 50;
    button_spacer1.style.maximal_width = 50;

    buttons.add({type="button", name="CTLM_settings_positionEdit_playerPos", caption={"settings.positionEdit.playerPos"}});

    local button_spacer2 = buttons.add({type="flow", name="CTLM_settings_positionEdit_spacer2"});
    button_spacer2.style.minimal_width = 50;
    button_spacer2.style.maximal_width = 50;

    local buttonDelete = buttons.add({type="button", name="CTLM_settings_positionEdit_delete_" .. positionKey, caption={"settings.delete"}});
    buttonDelete.style.font_color = {r=1};
end

function CTLM.gui.CTLM_settings_positionEdit_close(event)
    local player = game.players[event.player_index];
    if player.gui.center.CTLM_settings_positionEdit ~= nil then
        player.gui.center.CTLM_settings_positionEdit.destroy();
    end
end

function CTLM.gui.CTLM_settings_positionEdit_save(event)
    local player = game.players[event.player_index];
    local positionEditFrame = player.gui.center.CTLM_settings_positionEdit.main;
    local positionKey = tonumber(positionEditFrame.index_flow.index.caption);
    local enabled = positionEditFrame.posEnabled.state;
    local name = positionEditFrame.name_flow.textfield.text;
    local surface = positionEditFrame.surface_flow.textfield.text;
    local dayOnly = positionEditFrame.dayOnly_flow.checkbox.state;
    local width = tonumber(positionEditFrame.width_flow.textfield.text);
    local height = tonumber(positionEditFrame.height_flow.textfield.text);
    local zoom = tonumber(positionEditFrame.zoom_flow.textfield.text);
    local positionX = tonumber(positionEditFrame.positionX_flow.textfield.text);
    local positionY = tonumber(positionEditFrame.positionY_flow.textfield.text);
    local showAltInfo = positionEditFrame.showAltInfo_flow.checkbox.state;

    global.positions[positionKey].enabled = enabled;

    if name ~= nil and name ~= '' then
        global.positions[positionKey].name = name;
    else
        CTLM.msgPlayer(player, "Position name is invalid. Continuing to use previous value.");
    end

    if surface ~= nil and surface ~= '' then
        global.positions[positionKey].surface = surface;
    else
        CTLM.msgPlayer(player, "Position surface is invalid. Continuing to use previous value.");
    end

    global.positions[positionKey].dayOnly = dayOnly;

    if width ~= nil then
        global.positions[positionKey].width = width;
    else
        CTLM.msgPlayer(player, "Image width not a valid number. Continuing to use previous value.");
    end

    if height ~= nil then
        global.positions[positionKey].height = height;
    else
        CTLM.msgPlayer(player, "Image height not a valid number. Continuing to use previous value.");
    end

    if zoom ~= nil then
        global.positions[positionKey].zoom = zoom;
    else
        CTLM.msgPlayer(player, "Image zoom not a valid number. Continuing to use previous value.");
    end

    if positionX ~= nil then
        global.positions[positionKey].positionX = positionX;
    else
        CTLM.msgPlayer(player, "Position X not a valid number. Continuing to use previous value.");
    end

    if positionY ~= nil then
        global.positions[positionKey].positionY = positionY;
    else
        CTLM.msgPlayer(player, "Position Y not a valid number. Continuing to use previous value.");
    end

    global.positions[positionKey].showAltInfo = showAltInfo;

    CTLM.msgPlayer(player, "Position " .. name .. " saved.");
end

function CTLM.gui.CTLM_settings_positionEdit_delete(event)
    local player = game.players[event.player_index];
    local positionEditFrame = player.gui.center.CTLM_settings_positionEdit.main;
    local positionKey = tonumber(positionEditFrame.index_flow.index.caption);
    local name = global.positions[positionKey].name;

    global.positions[positionKey] = nil;
    CTLM.msgPlayer(player, "Position " .. name .. " deleted.");
end

function CTLM.gui.CTLM_settings_positionEdit_playerPos(event)
    local player = game.players[event.player_index];
    local positionEditFrame = player.gui.center.CTLM_settings_positionEdit.main;
    positionEditFrame.positionX_flow.textfield.text=string.format("%.2f", player.position.x);
    positionEditFrame.positionY_flow.textfield.text=string.format("%.2f", player.position.y);
end
