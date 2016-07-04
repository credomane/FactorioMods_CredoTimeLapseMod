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
if not CTLM.remote then CTLM.remote = {} end

CTLM.hardResetEnabled = false;
CTLM.hardResetCode = nil;

function CTLM.remote.hardreset(resetCode)
    if resetCode then
        resetCode = tonumber(resetCode);
    end
    if not CTLM.hardResetEnabled then
        CTLM.hardResetEnabled = true;
        CTLM.hardResetCode = game.tick; --Lame I know.
        CTLM.print({"remote", "Repeat this command again with paremeter '" .. tostring(CTLM.hardResetCode) .. "' to confirm reset."});
    elseif CTLM.hardResetEnabled and resetCode == CTLM.hardResetCode then
        CTLM.hardResetEnabled = false;
        CTLM.hardResetCode = nil;
        CTLM.print({"remote", "Valid reset code. Resetting..."});
        CTLM.hardReset();
    else
        CTLM.hardResetEnabled = false;
        CTLM.hardResetCode = nil;
        CTLM.print({"remote", "Invalid reset code. Reset canceled."});
    end
end

function CTLM.remote.guireset()
    CTLM.print({"remote", "Resetting GUI button."});
    CTLM.gui.hardReset();
end

