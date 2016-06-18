
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
