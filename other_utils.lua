--[[ Utilities File
 Info:    
 
 Authors: Austin Auger, Michael Tillett
 Date:    2017
--]]

--Read Ram address function
function mem_read(addr)
    return memory.readbyte(addr);
end
--function for displaying the information in our scripts GUI
function disp_text(offset, text)
    local REAL_OFF = 9;
    gui.text(0, offset*REAL_OFF, text);
end
--random bool generator
function random_bool()
    return math.random(1, 10) > 5;
end
--Gaussian Random Function
function gauss_rand(minv, maxv, fh)
    return math.floor((minv + (maxv - minv) * math.random()^fh));
end
--a function used to make a complete copy of a table
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
--Fucntion for getting the length of a table
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
--fuction for checking if a candidate has won within the table of candidates
function contains_winner(table)
    for i=1,#table do
        if table[i].has_won then
            return true;
        end
    end
    return false;
end

--The next three functions are used to convert the raw input binary string of the controller to an actual string for use in display 

function bti(bl)
    return (bl and 1) or 0
end

function btis(bl)
    return (bl and "1") or "0"
end

function ctrl_tbl_btis(tbl)
    return (
        btis( tbl.up    )..
        btis( tbl.down  )..
        btis( tbl.left  )..
        btis( tbl.right )..
        btis( tbl.A     )..
        btis( tbl.B     ))
end