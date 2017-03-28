--[[ Genetic Algorithm File
 Info:    
 
 Authors: Austin Auger, Michael Tillett
 Date:    2017
--]]

require "candidate"
require "other_utils"

function ga_crossover(tbl, topperc)
    --extract top x perc from table
    local top = {};
    local cross_perc_ind = math.floor(topperc*(#tbl));
    local top_max_cont = #(tbl[1].inputs);
    for i=1, cross_perc_ind do
        top[i] = gen_candidate.new();
        for j=1, top_max_cont do
            top[i].inputs[j] = deepcopy(tbl[i].inputs[j]);
            top[i].input_fit = tbl[i].input_fit;
        end
    end
    --kill off bottom x perc of the worst boys
	for i=1, cross_perc_ind do
         table.remove(tbl, #tbl);
    end
	 --inject children into bottom x perc of old table
    local max_cont = #(tbl[1].inputs);
    for i=1, cross_perc_ind do
        local p1 = math.random(1,cross_perc_ind);
        local p2 = math.random(1,cross_perc_ind);
		local child = gen_candidate.new();
        for j = 1, max_cont do
            if top[p1].input_fit[j] > top[p2].input_fit[j] then
                child.inputs[j] = deepcopy(top[p1].inputs[j]);
            else
                child.inputs[j] = deepcopy(top[p2].inputs[j]);
            end
            child.input_fit[j] = 0;
        end
		table.insert(tbl, 1, child);
    end
end


function ga_mutate(tbl, count, mutation_rate)
    local rand_max = 1/mutation_rate;
    for i=1, count do
        for j=1, #(tbl[i].inputs) do
            if math.random(1, rand_max) == 1 then
                tbl[i].inputs[j] = generate_input();
            end
        end
    end
end

--TRASH AREA
--[[ Unused functions for previously used crossover method (Elitism Method)
-- function ga_crossover(tbl, count, controls, fhf, ncg)
     -- kill worst candidate
     for i=1, ncg do
         table.remove(tbl, #tbl);
     end
     -- select parent candidates
     local idx1 = gauss_rand(1, #tbl, fhf);
     print(idx1);
     local idx2 = gauss_rand(1, #tbl, fhf);
     print(idx2);
     -- create child
     for i=1, ncg do
         local child = gen_candidate:new();
         for i = 1, controls do
             local rval = random_bool();
             if rval == true then
                 child.inputs[i] = deepcopy(tbl[idx1].inputs[i]);
             else
                 child.inputs[i] = deepcopy(tbl[idx2].inputs[i]);
             end
         end
         table.insert(tbl, 1, child);
     end
 end
--]]