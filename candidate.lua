-- Candidate File
-- Info:    [here]
-- Authors: [here]
-- Date:    [here]

gen_candidate = { 
	fitness = 0, 
    has_won = false
}
gen_candidate.__index = gen_candidate;

function gen_candidate.new()
	local self = setmetatable({}, gen_candidate);
	self.inputs = {};
	return self;
end