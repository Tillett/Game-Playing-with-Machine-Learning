local FLOAT_ADDR = 0x001D;

while true do
	local val = memory.readbyte(FLOAT_ADDR);
	gui.text(0, 9, val);
	emu.frameadvance();
end