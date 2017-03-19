-- Candidate File
-- Info:    [here]
-- Authors: [here]
-- Date:    [here]

gen_candidate = { 
	fitness = 0, 
    has_won = false,
    been_modified = true,
	win_time = 0
}
gen_candidate.__index = gen_candidate;

function gen_candidate.new()
	local self = setmetatable({}, gen_candidate);
	self.inputs = {};
	return self;
end

function generate_candidates(num_cands, num_controls)
    local ret = {};
    for i=1, num_cands do
        local cand = gen_candidate.new();
        for j = 1, num_controls do
            cand.inputs[j] = generate_input();
        end
    ret[i] = cand;
    end
    return ret;
end

function generate_input()
    local lrv = random_bool();
    return {
        up      = random_bool(),
        down    = random_bool(),
        left    = lrv,
        right   = not lrv,
        A       = random_bool(),
        B       = random_bool(),
        start   = false,
        select  = false
    };
end