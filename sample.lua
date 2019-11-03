----------------------------------------------
-- Sample of SlibLT5003D.lua for W4.00.04
-- Copyright (c) 2019, AoiSaya
-- All rights reserved.
-- 2019/11/04 rev.0.01
-----------------------------------------------
function chkBreak(n)
	sleep(n or 0)
	if fa.sharedmemory("read", 0x00, 0x01, "") == "!" then
		error("Break!",2)
	end
end
fa.sharedmemory("write", 0x00, 0x01, "-")

local script_path = function()
	local  str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)")
end

--main
local myDir  = script_path()
led = require (myDir.."lib/SlibLT5003D")
local bitmap={}
local heart={0x070,0x0F8,0x1F8,0x1F0,0x3E0,0x1F0,0x1F8,0x0F8,0x070,0x000}

local n_disp=1

led:setup(n_disp)

for i=1,1000 do
	led:write(heart)
	chkBreak()
end

for i=1,1000 do
	for j=1,10 do
		bitmap[j] = 2^((i+j)%10)
	end
	for j=1,100 do
		led:write(bitmap)
	end
	chkBreak()
end

