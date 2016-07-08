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
require "util";

if not CTLM then CTLM = {} end
if not CTLM.update then CTLM.update = {} end

function CTLM.update.doUpdate(oldVersion, newVersion)
    CTLM.msgAll({"Updater", "Version changed from " .. oldVersion .. " to " .. newVersion .. "."});

    if oldVersion > newVersion then
        CTLM.msgAll({"Updater", "Version downgrade detected. I can't believe you've done this."});
        return;
    end

    if oldVersion < "0.0.7" then
        CTLM.update.to_0_0_7();
    end

    CTLM.init();
    CTLM.gui.init();
end

------------------------------------------------------------------------------------------------------
--INDIVIDUAL UPDATER FUNCTIONS
------------------------------------------------------------------------------------------------------

--Create the global.config.noticesEnabled = config.defaults.noticesEnabled
function CTLM.update.to_0_0_7()
    global.config.noticesEnabled = config.defaults.noticesEnabled;
end
