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

function CTLM.gui.init()
    CTLM.log("[gui] init()");
    for key, player in pairs(game.players) do
        CTLM.gui.create_main_button(player);
    end
end

function CTLM.gui.hardreset()
    CTLM.log("[gui] hardreset()");
    for key, player in pairs(game.players) do
        local root = player.gui.top.CTLM_mainbutton;
        if root then
            player.gui.top.CTLM_mainbutton.destroy();
        end
    end
end

function CTLM.gui.new_player(player)
    CTLM.log("[gui] new_player(" .. player.name .. ")");
    CTLM.gui.create_main_button(player);
end

function CTLM.gui.click()
    CTLM.log("[gui] click()");
end


function CTLM.gui.create_main_button(player)
    CTLM.log("[gui] create_main_button(" .. player.name .. ")");
    local root = player.gui.top.CTLM_mainbutton;
    local destroyed = false;
    if root then
        player.gui.top.CTLM_mainbutton.destroy();
        destroyed = true;
    end

    if not root or destroyed then
        local root = player.gui.top;
        if not root.CTLM_mainbutton then
            root.add({
                type="button",
                name="CTLM_mainbutton",
                caption="CTLM"
            });
        end
    end
end
