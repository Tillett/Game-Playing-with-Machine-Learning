math.randomseed(os.time())
local PLAYER_DIRECTION_ADDR = 0x003
local PL_LEFT = 0
local PL_RIGHT = 1
local ONSCREEN_PX_ADDR = 0x071D
local PLAYER_STATE_ADDR = 0x000E
local PLAYER_DYING_STATE = 0x0B
local xval = 0
local table = {}

local candidate = { fitness = 0, 
	inputs = {}, 
	new = function (self, o)
		o = o or {}
		setmetatable(o, self)
		self.__index = self
		return o
	end
	}

local candidates = { } -- new list of candidates

local testCand = candidate:new

for i = 1, 100 do 
	testCand.inputs[i] = {""};
end

while true do
	--for i = 1, 100 do
		local readval = memory.readbyte(ONSCREEN_PX_ADDR);
		if readval ~= lframe and memory.readbyte(PLAYER_DIRECTION_ADDR) == PL_RIGHT then
			xval = xval + readval;
		end
		gui.text(0, 15, xval);
		if memory.readbyte(PLAYER_STATE_ADDR) == PLAYER_DYING_STATE then
			gui.text(0, 33, "DYING!");
		end
		lframe = memory.readbyte(ONSCREEN_PX_ADDR);
		emu.frameadvance();
	--end
end