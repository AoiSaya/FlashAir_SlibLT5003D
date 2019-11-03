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
local libDir = myDir.."lib/"
local fontDir= myDir.."font/"
local led	 = require(libDir.."SlibLT5003D")
local jfont  = require(libDir.."SlibJfont")
local k1010	 = jfont:open("mplus_j10r.sef")
local k1005	 = jfont:open("mplus_f10r.sef")

local strEUC, euc_length, p
local bitmap,fh,fw,d
local data = {}
local BE = bit32.extract

local n_disp = 1
local wait = 50
local str= {
"こんにちは世界!　",
"FlashAir ",
"Demonstration  ",
}

led:setup(n_disp)
jfont:setFont(k1005,k1010)

for i=1,10 do
	data[i] = 0
end
while 1 do
--chkBreak(2000)
	for _,strUTF8 in ipairs(str) do
		strEUC, euc_length = jfont:utf82euc(strUTF8)
		p=1
		while p<=#strEUC do
			bitmap,fh,fw,p = jfont:getFont(strEUC, p)
			for i=1,fw do
				data = {table.unpack(data,2)} -- scroll
				d = i<=fw and bitmap[i] or 0
				d = BE(d,0)*512+BE(d,1)*256+BE(d,2)*128+BE(d,3)*64+BE(d,4)*32
				   +BE(d,5)*16 +BE(d,6)*8  +BE(d,7)*4  +BE(d,8)*2 +BE(d,9) -- bit reverse
				data[10] = d
				for j=1,wait do
					led:write(data)
				end
				chkBreak()
			end
			collectgarbage()
		end
	end
end
