--This code created by AI team Austin Auger, Michael Tillett, Catherine Dougherty, edited for modified Q-Learning by Aleksandr Fritz
--for use in a similar project. 

gen_candidate = {
    time = 0,
    fitness = 0, 
    has_won = false,
	input_string = {},
	next_states = {}
}
gen_candidate.__index = gen_candidate;


function gen_candidate.new(input_string, score)
    local self = setmetatable({}, gen_candidate);
	self.input_string = input_string;
	self.fitness = score;
	self.next_states = {};
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
	local udv = random_bool();
    return {
        up      = udv,
        down    = not udv,
        left    = false,
        right   = true,
        A       = random_bool(),
        B       = random_bool(),
        start   = false,
        select  = false
    };
end

function generate_input_decimal(inputs)
	local number = 0;
	
	if inputs.up then
		number = number + 1;
	else
		number = number + 2;
	end
	
	if inputs.left then
		number = number + 4;
	else
		number = number + 8;
	end
	
	if inputs.A then
		number = number + 16;
	end
	
	if inputs.B then
		number = number + 32;
	end
	
	return number;
end

function get_next_state(linked_states, input_number, states, state_number)
	local next_state;
	local new_state;
	
	if linked_states[input_number] == nil then
		next_state = gen_candidate.new();
		linked_states[input_number] = next_state;
		new_state = true;
	else
		next_state = linked_states[input_number];
		new_state = false;
	end
	
	return {
		next_state,
		new_state
	};
end