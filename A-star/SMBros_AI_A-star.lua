-- Main File
-- Info:    [here]
-- Authors: [here]
-- Date:    [here]

require "table_utils"
require "other_utils"
require "candidate"
require "Q_Algo"

--Mario RAM addresses
local PLAYER_XPAGE_ADDR     = 0x6D   --Player's page (screen) address
local PLAYER_PAGE_WIDTH     = 256    -- Width of pages
local PLAYER_XPOS_ADDR      = 0x86   --Player's position on the x-axis
local PLAYER_STATE_ADDR     = 0x000E --Player's state (dead/dying)
local PLAYER_VIEWPORT_ADDR  = 0x00B5 --Player's viewport status (falling)
local PLAYER_YPOS_ADDR      = 0x00CE --Player's y position address
local PLAYER_VPORT_HEIGHT   = 256    --raw height of viewport pages
local PLAYER_DOWN_HOLE      = 3    --VP+ypos val for falling into hole
local PLAYER_DYING_STATE    = 0x0B   --State value for dying player
local PLAYER_DEAD_STATE     = 0x06   --(CURRENTLY UNUSED!) State value for dead player
local PLAYER_FLOAT_STATE    = 0x001D --Used to check if player has won
local PLAYER_FLAGPOLE       = 0x03   --Player is sliding down flagpole.
local GAME_TIMER_ONES       = 0x07fA --Game Timer first digit
local GAME_TIMER_TENS       = 0x07f9 --Game Timer second digit
local GAME_TIMER_HUNDREDS   = 0x07f8 --Game Time third digit
local GAME_TIMER_MAX        = 400    --Max time allotted by game

--Qish Learning Constants
local MAX_NODES = 30;
local MAX_SUCCESSES = 10;

-- init savestate & setup rng
math.randomseed(os.time());
ss = savestate.create();
savestate.save(ss);

local nodes = {};
local successes = {};
local success_number = 1;
local has_won = false;

local iterator = 0;
local currentNode = iterator;
local currentInputBin = generate_input();
local currentInputDec = generate_input_decimal(currentInputBin);
local isDead;
local x_val;
local highestScore;
local bestPerformance = 0;
local possibleBestString = {};
local bestString = {};
local modelString = {};


while (success_number < MAX_SUCCESSES) or (success_number == MAX_SUCCESSES) do
	iterator = 0;
	currentNode = iterator;
	savestate.load(ss);
	x_val = memory.readbyte(PLAYER_XPAGE_ADDR);
	
	nodes[currentNode] = gen_candidate.new(list_copy_unknown_size(bestString), x_val);
	input_beginning_string(nodes[currentNode].input_string);
	
	while not (iterator >= MAX_NODES) and not has_won do
		
		--generate input
		currentInputBin = generate_input();
		currentInputDec = generate_input_decimal(currentInputBin);
		
		--set inputs to joypad and advance frames
		advance_frames(currentInputBin);
		
		if((memory.readbyte(PLAYER_STATE_ADDR) == PLAYER_DYING_STATE) or (memory.readbyte(PLAYER_STATE_ADDR) == PLAYER_DEAD_STATE)) or (memory.readbyte(PLAYER_VIEWPORT_ADDR) >= PLAYER_DOWN_HOLE) then
			isDead = true;
		else
			isDead = false;
		end
		
		x_val = memory.readbyte(PLAYER_XPAGE_ADDR);
		--print(x_val);
		
		if not isDead then
			
			if(memory.readbyte(PLAYER_FLOAT_STATE) == PLAYER_FLAGPOLE) then
				has_won = true;
			else
				has_won = false;
			end
			
			if not has_won then
				if nodes[currentNode].next_states[currentInputDec] == nil then
					iterator = iterator + 1;
					nodes[currentNode].next_states[currentInputDec] = iterator;
					nodes[iterator] = gen_candidate.new(list_copy_and_add(nodes[currentNode].input_string, currentInputDec), x_val);
					currentNode = iterator;
				else
					currentNode = nodes[currentNode].next_states[currentInputDec];
				end
			end
		else
			
			currentNode = 0;
			savestate.load(ss);
			--input the set string if tree was already trimmed
			input_beginning_string(nodes[currentNode].input_string);
		end
	end
	
	if not has_won then
		highestScore = 0;
		
		for i = 0, MAX_NODES do
			if nodes[i].fitness > highestScore then
				highestScore = nodes[i].fitness;
				possibleBestString = list_copy_unknown_size(nodes[i].input_string);
			end
		end
		
		--this makes sure it doesn't keep running in place and remembering useless information
		if bestPerformance < highestScore then
			print("Score "..highestScore.." beat score "..bestPerformance);
			bestString = list_copy_and_subtract(possibleBestString, 5);
			print(bestString);
			bestPerformance = highestScore;
		else
			print("Score "..highestScore.." did not beat "..bestPerformance);
		end
	else
		--save the success
		successes[success_number] = list_copy_unknown_size(nodes[currentNode].input_string);
		print(successes[success_number]);
		print("succeded");
		
		--increment the success count
		success_number = success_number + 1;
		
		--reset performance memory
		bestPerformance = 0;
		highestScore = 0;
		bestString = {};
		nodes = {};
		has_won = false;
	end
end

-- create model here
modelString = generate_model_string(successes, MAX_SUCCESSES);

-- execute model here
savestate.load(ss);
print("Model");
print(modelString);
input_beginning_string(modelString);

-- done!


