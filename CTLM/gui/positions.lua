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
--POSITIONS SETTINGS
------------------------------------------------------------------------------------------------------
function CTLM.gui.CTLM_settings_positions_open(event)
    local player = game.get_player(event.player_index);
    if player.gui.center.CTLM_settings_positions ~= nil then
        --Open button has been hit twice. Perform close action instead.
        CTLM.gui.CTLM_settings_positions_close(event);
        return;
    end
end

function CTLM.gui.CTLM_settings_positions_close(event)
    local player = game.get_player(event.player_index);
    if player.gui.center.CTLM_settings_positions ~= nil then
        player.gui.center.CTLM_settings_positions.destroy();
    end
end

function CTLM.gui.CTLM_settings_positions_save(event)
    local player = game.get_player(event.player_index);
end
