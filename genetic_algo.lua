--[[ Genetic Algorithm File
 Info:    
 
 Authors: Austin Auger, Michael Tillett
 Date:    2017
--]]

require "candidate"
require "other_utils"

--hmm, this looks complicated.
function ga_transmogrify_mutation(curr_rate, base, max_val, step_val, sample_vec, num_same, delta)
    local ret_rate = curr_rate;
    local same_cnt = 0;
    --when this is called, first slot guaranteed to be filled!
    for i=2,#sample_vec do
        --uninitiliazed slots (early run) are set to -1, an impossible fitness value
        print(i.. "th sample: "..sample_vec[i]);
        if sample_vec[i] > -1 then
            if math.abs(sample_vec[1] - sample_vec[i]) <= delta then
                same_cnt = same_cnt + 1;
            end
        end
    end

    if same_cnt >= num_same then
        ret_rate = ret_rate + step_val;
    else
        ret_rate = ret_rate - step_val;
    end

    print("# SAME: "..same_cnt);
    print("ret rate: "..ret_rate);
    ret_rate = clamp(ret_rate, base, max_val);

    return ret_rate;
end

function ga_selection_best_of_copy(tbl, indices)
    local best_fit = -1;
    local best = nil;
    for i=1,#indices do
        if tbl[indices[i]].fitness > best_fit then
            best = tbl[indices[i]];
            best_fit = tbl[indices[i]].fitness;
        end
    end

    local ret = gen_candidate.new();
    for i=1,#(best.inputs) do
        ret.inputs[i] = deepcopy(best.inputs[i]);
        ret.input_fit[i] = best.input_fit[i];
    end

    return ret;
end

function ga_selection_random_indices(count, max)
    local ret = {};
    for i=1, count do
        ret[i] = math.random(1, max);
    end
    return ret;
end

function ga_selection(tbl, num_parents, num_samples)
    local ret = {};
    for i=1, num_parents do
        local random_indices = ga_selection_random_indices(num_samples, #tbl);
        local best = ga_selection_best_of_copy(tbl, random_indices);
        ret[i] = best;
    end

    return ret;
end

function ga_crossover(tbl, num_parents, num_samples)
    --extract top x perc from table
    local top = ga_selection(tbl, num_parents, num_samples);
    local top_max_ind = #top;
    --inject new generation into old table
    local max_cont = #(tbl[1].inputs);
    for i=1, #tbl do
        local p1 = math.random(1,top_max_ind);
        local p2 = math.random(1,top_max_ind);
        for j = 1, max_cont do
            if top[p1].input_fit[j] == top[p2].input_fit[j] then
                local rval = random_bool();
                if rval then
                    tbl[i].inputs[j] = deepcopy(top[p1].inputs[j]);
                else
                    tbl[i].inputs[j] = deepcopy(top[p2].inputs[j]);
                end
            elseif top[p1].input_fit[j] > top[p2].input_fit[j] then
                tbl[i].inputs[j] = deepcopy(top[p1].inputs[j]);
            else
                tbl[i].inputs[j] = deepcopy(top[p2].inputs[j]);
            end
            tbl[i].input_fit[j] = 0;
        end
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