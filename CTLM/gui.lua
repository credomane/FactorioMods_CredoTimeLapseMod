
--Factorio provided libs
require "defines"

if not CTLM then CTLM = {} end
if not CTLM.config then CTLM.config = {} end
if not CTLM.gui then CTLM.gui = {} end

function CTLM.gui.init()
    for key, player in pairs(game.players) do
        CTLM.gui.create_main_button(player);
    end
end

function CTLM.gui.click()

end


function CTML.gui.create_main_button(player)
    local root = player.gui.top;
    if not root.CTLM_settings then
        root.add({
            type="button",
            name="CTLM_settings",
            caption="CTLM"
        });
    end
end