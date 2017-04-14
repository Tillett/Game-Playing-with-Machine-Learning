--[[ Candidate File
 Info: Representation of the candidates for each generation.
	   Each candidate is represented by a random selection of binary inputs.
 
 Authors: Austin Auger, Catherine Dougherty, Michael Tillett, Scott Jeffery
 Date:    2017
--]]

gen_candidate = {
    time = 0,
	fitness = 0, 
    has_won = false,
    been_modified = true,
	win_time = 0
}
gen_candidate.__index = gen_candidate;


function gen_candidate.new()
	local self = setmetatable({}, gen_candidate);
	self.inputs = {};
    self.input_fit = {};
	return self;
end

function generate_candidates(num_cands, num_controls)
    local ret = {};
    for i=1, num_cands do
        local cand = gen_candidate.new();
        for j = 1, num_controls do
            cand.inputs[j] = generate_input();
            cand.input_fit[j] = 0;
        end
    ret[i] = cand;
    end
    return ret;
end

function generate_input()
    local lrv = random_bool();
    return {
        Up      = random_bool(),
        Down    = random_bool(),
        Left    = lrv,
        Right   = not lrv,
        A       = random_bool(),
        B       = random_bool(),
		X		= random_bool(),
		Y		= random_bool(),
        start   = false,
        select  = false
    };
end