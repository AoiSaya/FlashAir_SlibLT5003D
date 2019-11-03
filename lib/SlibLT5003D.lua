-----------------------------------------------
-- SoraMame library of 	LED10x10 with LT-5003D for W4.00.04
-- Copyright (c) 2019, AoiSaya
-- All rights reserved.
-- 2019/11/04 rev.0.01
-----------------------------------------------
-- http:--akizukidenshi.com/catalog/g/gI-00040/
-- 74HC595 x 3 = 8bit x 3
-- [- - D9 D8 D7 D6 D5 D4] [D3 D2 D1 D0 - - X9 X8] [X7 X6 X5 X4 X3 X2 X1 X0]
-----------------------------------------------

--[[
Pin assign
	PIN SPI	LED10x10
CLK  5
CMD  2	DO 	SI
D0	 7	CLK	SK
D1	 8	CS 	RK
D2	 9	DI
D3	 1	RSV
VCC  4		V
VSS1 3		G
VSS2 6
--]]

local SlibLT5003D = {
}

function SlibLT5003D:setup(n_disp)
	self.n_disp = n_disp

  	fa.spi("mode",0)
  	fa.spi("init",1) -- 1.6MHz
  	fa.spi("bit",24)
  	self:cls()
end

function SlibLT5003D:cls()
  	fa.spi("cs",1)
	fa.spi("write",0xFFF)
  	fa.spi("cs",0)
  	fa.spi("cs",1)
end

function SlibLT5003D:write(bitmap)
	local n_disp = self.n_disp
	local a, b, k
	local d={}

  	fa.spi("cs",1)
	k = 1
	a = 1
	for i=1,11 do
		for j=1,n_disp do
			b = (i==11) and 0 or bitmap[k]
			d[j] = b*4096 + 0xFFF-a
			k = k+1
		end
		a = a+a
		fa.spi("write",d)
	  	fa.spi("cs",0)
	  	fa.spi("cs",1)
	end
end

collectgarbage()
return SlibLT5003D
