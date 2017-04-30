function hex2rgb(hex)
	hex = tonumber(hex)
	print(hex)
    hex = hex:gsub("0x","")
	need = "#"..hex:sub(2,3,4,5,6,7,8,9)
	--print(need)
    return need
end