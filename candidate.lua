-- Candidate File
-- Info:    [here]
-- Authors: [here]
-- Date:    [here]

gen_candidate = { fitness = 0, 
    inputs = {},
    has_won = false, 
    new = function (self, o)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
        return o
    end
    }