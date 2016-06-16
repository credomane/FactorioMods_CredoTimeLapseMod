
--Factorio provided libs
require "defines"
require "util"

--CTLM libs
require "config.defaults"
require "CTLM"
require "CTLMgui"


MOD_NAME = "CTLM";
MOD_VERSION = "0.0.1";

if not CTLM then CTLM = {} end
if not CTLMconfig then CTLMconfig = {} end
if not CTLMgui then CTLMgui = {} end


--Register event handlers!
script.on_init(CTLM.modInit);
script.on_load(CTLM.modLoad);
script.on_event(defines.events.on_tick, CTLM.modTick);
