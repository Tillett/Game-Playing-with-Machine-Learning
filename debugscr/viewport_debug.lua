local VIEWPORT_ADDR = 0x00B5;
local YPOS_ADDR = 0x00CE;

while true do
	local val = (memory.readbyte(VIEWPORT_ADDR) * 256) + memory.readbyte(YPOS_ADDR);
	gui.text(0, 9, val);
	emu.frameadvance();
end