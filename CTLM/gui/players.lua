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

    --players frame buttons
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

    local playerName = "";
    for index, player in pairs(game.players) do
        if not player.name or player.name == "" then
            playerName = "UnnamedPlayer" .. player.index;
        else
            playerName = player.name;
        end
        if not global.players[playerName] then
            global.players[playerName] = CTLM.deepCopy(config.player_defaults);
        end

        mainFrame.add({type="button", name="CTLM_settings_player_button_" .. playerName, caption=playerName});
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
