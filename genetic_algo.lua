require "candidate"
require "other_utils"

function ga_crossover(tbl, count, controls)
	-- kill worst candidate
	table.remove(tbl, count);
	-- select parent candidates
	local idx1 = gauss_rand(1, count-1, 1.2);
	print(idx1);
	local idx2 = gauss_rand(1, count-1, 1.2);
	print(idx2);
	-- create child
	local child = gen_candidate:new();
	for i = 1, controls do
		local rval = random_bool();
		if rval == true then
			child.inputs[i] = deepcopy(tbl[idx1].inputs[i]);
		else
			child.inputs[i] = deepcopy(tbl[idx2].inputs[i]);
		end
	end
	tbl[count] = child;
end

function ga_mutate(tbl, count, mutation_rate)
	local rand_max = 1/mutation_rate;
	for i=1, count do
		for j=1, #(tbl[i].inputs) do
			if math.random(1, rand_max) == 1 then
				tbl[i].inputs[j] = { 
				up      = random_bool(),
				down    = random_bool(),
				left    = lrv,
				right   = not lrv,
				A       = random_bool(),
				B       = random_bool(),
				start   = false,
				select  = false
			}
			end
		end
	end
end