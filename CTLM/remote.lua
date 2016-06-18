
--Factorio provided libs
require "defines"

if not CTLM then CTLM = {} end
if not CTLM.remote then CTLM.remote = {} end

---[[
function CTLM.remote.hardreset()
    CTLM.log("[remote] hardreset();");
    CTLM.hardreset();
end
--]]

