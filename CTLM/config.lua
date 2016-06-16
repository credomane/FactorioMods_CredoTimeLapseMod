--[[
    This isn't the file you are wanting to edit.
    configdefaults.lua has the actual default config values used by the mod. :)
]]

require "config.defaults"
require "config.player_defaults"
require "config.position_defaults"

if not CTLM then CTLM = {} end
if not CTLM.config then CTLM.config = {} end
if not CTLM.gui then CTLM.gui = {} end

--Fix/install config!
function CTML.config.init()
    if not global.config then
        global.config = CTLM.config.deepCopy(config_defaults);
    end
    CTLM.config._conf = global.config;
end

------------------------------------------------------------------------------------------------------
--Special function to "deep" copy a table to avoid references. That would be bad. :/
function CTML.config.deepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end
