-- Main File
-- Info:    [here]
-- Authors: [here]
-- Date:    [here]

require "table_utils"
require "other_utils"
require "candidate"
require "genetic_algo"

-- constant values, memory locations & other useful things
local PLAYER_XPAGE_ADDR     = 0x6D --Player's page (screen) address
local PLAYER_PAGE_WIDTH     = 256  -- Width of pages
local PLAYER_XPOS_ADDR      = 0x86 --Player's position on the x-axis
local PLAYER_STATE_ADDR     = 0x000E --Player's state (dead/dying)
local PLAYER_VIEWPORT_ADDR  = 0x00B5 --Player's viewport status (falling)
local PLAYER_DOWN_HOLE      = 3      --VP val for falling into hole
local PLAYER_DYING_STATE    = 0x0B   --State value for dying player
local PLAYER_DEAD_STATE     = 0x06   --(CURRENTLY UNUSED!) State value for dead player
local PLAYER_FLOAT_STATE    = 0x001D --Used to check if player has won
local PLAYER_FLAGPOLE       = 0x03   --Player is sliding down flagpole.
local GAME_TIMER_ONES		= 0x07fA --Game Timer first digit
local GAME_TIMER_TENS		= 0x07f9 --Game Timer second digit
local GAME_TIMER_HUNDREDS	= 0x07f8 --Game Time third digit

-- constant values which describe the state of the genetic algorithm
local MAX_CANDIDATES        = 200    --Number of candidates generated
local MAX_CONTROLS_PER_CAND = 1000   --Number of controls that each candidate has
local FRAME_MAX_PER_CONTROL = 20     --Number of frames that each control will last
--local FH_SELECT_FACTOR	= 1.2	 --GA crossover selection front-heaviness
--local NUM_CH_GEN          = 5      --number of children generated.
local GA_SEL_TOPPERC        = .075    --top X percent used for selection/crossover.
local GA_MUTATION_RATE      = 0.008  --GA mutation rate

-- init savestate & setup rng
math.randomseed(os.time());
ss = savestate.create();
savestate.save(ss);

local candidates = generate_candidates(MAX_CANDIDATES, MAX_CONTROLS_PER_CAND);
local winning_cand = gen_candidate.new();

while not contains_winner(candidates) do
	for curr=1,MAX_CANDIDATES do
		if candidates[curr].been_modified then
			savestate.load(ss);
			local player_x_val;
			local cnt = 0;
			local real_inp = 1;
			local max_cont = FRAME_MAX_PER_CONTROL * MAX_CONTROLS_PER_CAND

			for i = 1, max_cont do
                disp_text(2, "Candidate: "..curr);
				joypad.set(1, candidates[curr].inputs[real_inp]);

				player_x_val = mem_read(PLAYER_XPAGE_ADDR) * PLAYER_PAGE_WIDTH + 
	                           mem_read(PLAYER_XPOS_ADDR);
						   
				game_time = (mem_read(GAME_TIMER_HUNDREDS) * 100) +
							(mem_read(GAME_TIMER_TENS) * 10)      +
							mem_read(GAME_TIMER_ONES);

				disp_text(3, "Fitness: "..player_x_val);
	        
				local p_state = mem_read(PLAYER_STATE_ADDR);
				local f_state = mem_read(PLAYER_VIEWPORT_ADDR);

				if p_state == PLAYER_DYING_STATE or f_state >= PLAYER_DOWN_HOLE then
					break;
				end
				
				local win_state = mem_read(PLAYER_FLOAT_STATE);
				if win_state == PLAYER_FLAGPOLE then
					candidates[curr].has_won = true;
					candidates[curr].win_time = game_time;
					break;
				end
	        
				tbl = joypad.get(1);
				disp_text(4, "Input: "..ctrl_tbl_btis(tbl));
				disp_text(5, "Curr Chromosome: "..real_inp);
				
				cnt = cnt + 1;
				if cnt == FRAME_MAX_PER_CONTROL then
					cnt = 0;
					real_inp = real_inp + 1;
				end
				
				candidates[curr].fitness = player_x_val;
				emu.frameadvance();
			end
		end
		candidates[curr].been_modified = false;
	end	
	--sort
	table.sort(candidates, function(a, b) return a.fitness > b.fitness end);
	print(candidates[1].fitness);
	--ga_crossover
	--ga_crossover(candidates, MAX_CANDIDATES, MAX_CONTROLS_PER_CAND, FH_SELECT_FACTOR, NUM_CH_GEN);
    ga_crossover(candidates, GA_SEL_TOPPERC);
	--ga_mutate
	ga_mutate(candidates, MAX_CANDIDATES, GA_MUTATION_RATE);
end

print("WINNER!");

for i=1, MAX_CANDIDATES do
	if candidates[i].has_won then
		winning_cand = candidates[i];
		file = io.open("winning_data"..i..".txt", "w");
			for j=1, tablelength(winning_cand.inputs) do
				file:write(ctrl_tbl_btis(winning_cand.inputs[j]), "\n");
			end
		file:close();
		print("Candidate #: "..i.."  ".."Winning Time: "..winning_cand.win_time);
	end
end