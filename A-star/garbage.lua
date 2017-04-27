-- Main File
-- Info:    [here]
-- Authors: [here]
-- Date:    [here]

require "table_utils"
require "other_utils"
require "candidate"
require "Q_Algo"

-- constant values, memory locations & other useful things
local SCORE_FIRST_DIGIT = 0x00E0 -- Score: 9xxxxxx
local SCORE_SECOND_DIGIT = 0x00E1 -- Score: x9xxxxx
local SCORE_THIRD_DIGIT = 0x00E2 -- Score: xx9xxxx
local SCORE_FOURTH_DIGIT = 0x00E3 -- Score: xxx9xxx
local SCORE_FIFTH_DIGIT = 0x00E4 -- Score: xxxx9xx
local SCORE_SIXTH_DIGIT = 0x00E5 -- Score: xxxxx9x
local SCORE_SEVENTH_DIGIT = 0x00E6 -- Score: xxxxxx9
local PLAYER_XPOS = 0x0203 -- Player's x position
local PLAYER_CURRENT_LIVES = 0x0487 --Player's current lives count
local TXT_INCR              = 9      --vertical px text block separation

-- constant values which describe the state of the algorithm
local MAX_CANDIDATES        = 400    --Number of candidates generated
local MAX_CONTROLS_PER_CAND = 1000   --Number of controls that each candidate has
local FRAME_MAX_PER_CONTROL = 20     --Number of frames that each control will last

-- init savestate & setup rng
math.randomseed(os.time());
ss = savestate.create();
savestate.save(ss);

local candidates = {};



while not contains_winner(candidates) do
	for curr=1,MAX_CANDIDATES do
		if candidates[curr].been_modified then
			savestate.load(ss);
			local player_x_val;
			local cnt = 0;
			local real_inp = 1;
			local max_cont = FRAME_MAX_PER_CONTROL * MAX_CONTROLS_PER_CAND

			for i = 1, max_cont do
				gui.text(0, TXT_INCR * 2, "Cand: "..curr)

				joypad.set(1, candidates[curr].inputs[real_inp]);

				--player_x_val = memory.readbyte(PLAYER_XPOS);
				
				score = tonumber(memory.readbyte(SCORE_FIRST_DIGIT)..
					memory.readbyte(SCORE_SECOND_DIGIT)..
					memory.readbyte(SCORE_THIRD_DIGIT)..
					memory.readbyte(SCORE_FOURTH_DIGIT)..
					memory.readbyte(SCORE_FIFTH_DIGIT)..
					memory.readbyte(SCORE_SIXTH_DIGIT)..
					memory.readbyte(SCORE_SEVENTH_DIGIT));
					
					

				gui.text(0, TXT_INCR * 3, "Fitness: "..score);
				
	        
				local d_state = memory.readbyte(PLAYER_CURRENT_LIVES);
				
				if d_state < 2 then
					gui.text(0, TXT_INCR * 4, "DYING");
					break;
				else
					gui.text(0, TXT_INCR * 4, "ALIVE");
				end

				if tonumber(score) >= 30001 then
					gui.text(0, TXT_INCR * 4, "WINNING");
					candidates[curr].has_won = true;
					break;
				end
	        
				tbl = joypad.get(1);
				gui.text(0, TXT_INCR * 5, "Input: "..ctrl_tbl_btis(tbl));
				gui.text(0, TXT_INCR * 6, "Curr Chromosome: "..real_inp);
				
				cnt = cnt + 1;
				if cnt == FRAME_MAX_PER_CONTROL then
					cnt = 0;
					real_inp = real_inp + 1;
				end
				
				candidates[curr].fitness = score;
				emu.frameadvance();
			end
		end
		candidates[curr].been_modified = false;
	end	
	
	
	--sort
	table.sort(candidates, function(a, b) return a.fitness > b.fitness end);
	print(candidates[1].fitness);
	
	--Add methods for Q-learning algo from Q-learning algo file here!!!
	
	
end

--]]
print("WINNER!");
