-- Utility File
-- Info:    [here]
-- Authors: [here]
-- Date:    [here]

function random_bool()
	return math.random(1, 10) > 5;
end

function gauss_rand(minv, maxv, fh)
	return math.floor((minv + (maxv - minv) * math.random()^fh));
end

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