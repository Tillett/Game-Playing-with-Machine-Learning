require "table_utils"
require "other_utils"

math.randomseed(os.time())
local PLAYER_DIRECTION_ADDR = 0x003
local PL_LEFT 				= 0
local PL_RIGHT 				= 1
local ONSCREEN_PX_ADDR 		= 0x071D
local PLAYER_STATE_ADDR 	= 0x000E
local PLAYER_VIEWPORT_ADDR  = 0x00B5
local PLAYER_DOWN_HOLE 		= 3
local PLAYER_DYING_STATE 	= 0x0B
local PLAYER_DEAD_STATE 	= 0x06
local FRAME_MAX_PER_CONTROL = 20
local xval 					= 0
--local table = {}

local candidate = { fitness = 0, 
	inputs = {}, 
	new = function (self, o)
		o = o or {}
		setmetatable(o, self)
		self.__index = self
		return o
	end
	}

local candidates = {  } -- new list of candidates

local testCand = candidate:new();

for i = 1, 100 do 
	testCand.inputs[i] = { 
		up 		= random_bool(),
		down 	= random_bool(),
		left 	= random_bool(),
		right 	= random_bool(),
		A 		= random_bool(),
		B 		= random_bool(),
		start 	= false,
		select 	= false
	 }
end

while true do
	local cnt = 0;
	local j = 1;
	local max = FRAME_MAX_PER_CONTROL*table.getn(testCand.inputs);

	for i = 1, max do
		--joypad.set(1, testCand.inputs[j]);

		local onscreen_px = memory.readbyte(ONSCREEN_PX_ADDR);
		if onscreen_px ~= lframe then
			xval = xval + onscreen_px;
		end
		gui.text(0, 15, xval);
		local pstate = memory.readbyte(PLAYER_STATE_ADDR)
		local fstate = memory.readbyte(PLAYER_VIEWPORT_ADDR);
		if pstate == PLAYER_DYING_STATE or fstate >= PLAYER_DOWN_HOLE then
			gui.text(0, 33, "DYING!");
		end
		lframe = memory.readbyte(ONSCREEN_PX_ADDR);
		gui.text(0, 50, table.tostring(joypad.get(1)));
		emu.frameadvance();

		cnt = cnt + 1;
		if cnt == FRAME_MAX_PER_CONTROL then
			cnt = 0
			j = j + 1
		end

		gui.text(0, 67, j);
	end
end