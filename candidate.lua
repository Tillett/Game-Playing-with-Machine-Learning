--[[ Candidate File
 Info: Representation of the candidates for each generation.
	   Each candidate is represented by a random selection of binary inputs.
 
 Authors: Austin Auger, Catherine Dougherty, Michael Tillett
 Date:    2017
--]]

--Our candidate "object"
--Variable for time, which holds the game time
--Variable for fitness, which holds the x-position of the candidate
--has_won which is a boolean flag for telling whether this candidate has completed a level
--been_modified which is a now unused variable used in an old implementation of the algorithm, but was left in for possible future used
--win_time which is a variable that holds the candidates winning time
gen_candidate = {
    time = 0,
    fitness = 0, 
    has_won = false,
    been_modified = true,
    win_time = 0
}
gen_candidate.__index = gen_candidate;

--This is a function to generate a single candidate
function gen_candidate.new()
    local self = setmetatable({}, gen_candidate);
    self.inputs = {};
    self.input_fit = {};
    return self;
end

--This is a function which generates a table of candidates with their given inputs
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

--A function to randomize the generation of the binary input string sent to controller
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