-- Utility File
-- Info:    [here]
-- Authors: [here]
-- Date:    [here]

function random_bool()
	return math.random(1, 10) > 5;
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