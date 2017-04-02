--[[ Main Script File
 Info:    
 This is the main script that is set to run. This is where all the magic happens. This is a project to use a genetic algorithm
 to play the classic NES game Super Mario Bros. The program uses a ROM and the game is owned by Michael Tillett.
 Things to know: 
 Generations are made up of candidates which are individual runs of mario trying to get through a level until he dies,
 runs out of time or completes the level. Candidates are made up of a string of six binary inputs that represent button presses on a controller
 (up, down, left, right, A, B). Genes are made of these strings of inputs and a weight to each input(determined by fitness). The fitness 
 value is a function of how far right on the x-axis of each level mario can get till completion. Crossover and mutation will be explained in 
 the genetic_algo.lua file.
 
 Authors: Austin Auger, Michael Tillett, Catherine Dougherty
 Date:    2017
--]]

--required lua files for function calls and candidate "object"
require "table_utils"
require "other_utils"
require "candidate"
require "genetic_algo"

-- Constant values, memory locations & other useful things. 
-- Information that is stored in these variables are being pulled from specific RAM addresses of the game.
local PLAYER_XPAGE_ADDR     = 0x6D   --Player's page (screen) address
local PLAYER_PAGE_WIDTH     = 256    -- Width of pages
local PLAYER_XPOS_ADDR      = 0x86   --Player's position on the x-axis
local PLAYER_STATE_ADDR     = 0x000E --Player's state (dead/dying)
local PLAYER_VIEWPORT_ADDR  = 0x00B5 --Player's viewport status (falling)
local PLAYER_YPOS_ADDR      = 0x00CE --Player's y position address
local PLAYER_VPORT_HEIGHT   = 256    --raw height of viewport pages
local PLAYER_DOWN_HOLE      = 460    --VP+ypos val for falling into hole
local PLAYER_DYING_STATE    = 0x0B   --State value for dying player
local PLAYER_DEAD_STATE     = 0x06   --(CURRENTLY UNUSED!) State value for dead player
local PLAYER_FLOAT_STATE    = 0x001D --Used to check if player has won
local PLAYER_FLAGPOLE       = 0x03   --Player is sliding down flagpole.
local GAME_TIMER_ONES       = 0x07fA --Game Timer first digit
local GAME_TIMER_TENS       = 0x07f9 --Game Timer second digit
local GAME_TIMER_HUNDREDS   = 0x07f8 --Game Time third digit
local GAME_TIMER_MAX        = 400    --Max time allotted by game

-- Constant values which describe the state of the genetic algorithm
local MAX_CANDIDATES        = 300    --Number of candidates generated
local MAX_CONTROLS_PER_CAND = 1000   --Number of controls that each candidate has
local FRAME_MAX_PER_CONTROL = 20     --Number of frames that each control will last
local GA_SEL_NUMPAR         = 30     --Number of parents (in total)
local GA_SEL_NUMSAMP        = 10      --Number of samples for each parent run.
local GA_MUTATION_RATE      = 0.009  --GA mutation rate
local GA_XVTIME_DELTA       = 75     --Delta for time v. distance

-- Creation of initial savestate which saves the moment the script is started and acts as a reset point for every condidate
-- Set up for random number generation
math.randomseed(os.time());
ss = savestate.create();
savestate.save(ss);

-- candidates - Creation of the candidates table
-- winning_cand - Creation of a variable to store the winning candidate
-- gen_count - Counter to keep track of the current Generation (Pool of candidates)
local candidates = generate_candidates(MAX_CANDIDATES, MAX_CONTROLS_PER_CAND);
local gen_count = 1;

while true do

    -- This inner loop will reset every time mario dies or times out for as many candidates are fixed in MAX_CANDIDATES
    for curr=1,MAX_CANDIDATES do
    
        -- Load current savestate
        -- accum - Creation of an accumulator that is used in finding the fitness from the start to the end of an input(used in weighing each gene)
        -- player_x_value - variable to store the players current x-axis position. Defined in the next loop
        -- cnt - a counter used in switching inputs(genes) using the FRAME_MAX_PER_CONTROL variable later on
        -- real_input - counter to tell which input(genes) you are currently on
        -- max_cont - how many genes a candidate is alloted. Used in next loop
        savestate.load(ss);
        local accum = 0;
        local player_x_val;
        local cnt = 0;
        local real_inp = 1;
        local max_cont = FRAME_MAX_PER_CONTROL * MAX_CONTROLS_PER_CAND;
        
        -- Loop which will happen for the max amount of inputs a candidate is allotted. Breaks if the candidate dies, time expires, or wins
        for i = 1, max_cont do
        
            --[[ disp_text - Built in lua function for displaying information in the top right of the screen. Items Displayed in order of display:
                 Name of Algorithm
                 Current Generation
                 Current Candidate
                 Current Candidates Fitness
                 Candidates Current Input
                 Candidates Current Number
            --]]
            disp_text(1, "Spicy Algorithm")
            disp_text(2, "Generation: "..gen_count)
            disp_text(3, "Candidate: "..curr);
            
            -- set the built in emulator joypad to press whatever randomly generated input string is created.
            -- player_x_val definition
            -- game_time - a variable that holds the current game time.
            joypad.set(1, candidates[curr].inputs[real_inp]);
            player_x_val = mem_read(PLAYER_XPAGE_ADDR) * PLAYER_PAGE_WIDTH + 
                           mem_read(PLAYER_XPOS_ADDR);
            game_time = (mem_read(GAME_TIMER_HUNDREDS) * 100) +
                        (mem_read(GAME_TIMER_TENS) * 10)      +
                        mem_read(GAME_TIMER_ONES);

            disp_text(4, "Fitness: "..player_x_val);
        
            -- p_state - variable which holds the value of marios current state. Used to tell if mario has died.
            -- f_state - variable to tell if mario is falling into a pit. Counted as dying.
            -- All states are pulled from RAM addresses
            -- if statement - Loop break when marios state is seen as dead or has fallin in a hole
            local p_state = mem_read(PLAYER_STATE_ADDR);
            local f_state = (mem_read(PLAYER_VIEWPORT_ADDR) * PLAYER_VPORT_HEIGHT) + mem_read(PLAYER_YPOS_ADDR);
            if p_state == PLAYER_DYING_STATE or f_state >= PLAYER_DOWN_HOLE then
                break;
            end
            
            -- win_state - variable that holds the state that tells whether a candidate has won(Jumped onto a flagpole at the end of the level)
            -- if statement - If a candidate has a winning stated, set has_won(defined in candidate) to true, store the current game time, break loop
            local win_state = mem_read(PLAYER_FLOAT_STATE);
            if win_state == PLAYER_FLAGPOLE then
                candidates[curr].has_won = true;
                candidates[curr].win_time = game_time;
                break;
            end
            
            -- tbl - variable to hold the current binary input data
            -- ctrl_tbl_btis - defines in the other_utils.lua file
            tbl = joypad.get(1);
            disp_text(5, "Input: "..ctrl_tbl_btis(tbl));
            disp_text(6, "# Input: "..real_inp);
            
            -- cnt counter increasing with the frames
            -- if statement - used to set a weight to each intput(gene) at the end of the 20 frame limit
            cnt = cnt + 1;
            if cnt == FRAME_MAX_PER_CONTROL then
                candidates[curr].input_fit[real_inp] = player_x_val - accum;
                accum = player_x_val;
                cnt = 0;
                real_inp = real_inp + 1;
            end
            
            -- Set the current candidates fitness before moving to the next candidate
            -- Set the current candidates time of death
            -- built in lua function
            candidates[curr].fitness = player_x_val;
            candidates[curr].time = GAME_TIMER_MAX - game_time;
            emu.frameadvance();
        end
    end 
    --if we have winners, we're done!
    if contains_winner(candidates) then
        break;
    end
    table.sort(candidates, 
        function(a, b)
            if math.abs(a.fitness - b.fitness) < GA_XVTIME_DELTA then
                if a.time < b.time then
                    return true;
                else
                    return false;
                end
            elseif a.fitness > b.fitness then
                return true;
            else
                return false;
            end
        end);
    print(candidates[1].fitness);
    ga_crossover(candidates, GA_SEL_NUMPAR, GA_SEL_NUMSAMP);
    ga_mutate(candidates, MAX_CANDIDATES, GA_MUTATION_RATE);
    
    gen_count = gen_count + 1;
end

print("WINNER!");

while true do
    for k=1, MAX_CANDIDATES do
        if candidates[k].has_won then
            savestate.load(ss);
            local cnt = 0;
            local real_inp = 1;
            local max_cont = FRAME_MAX_PER_CONTROL * MAX_CONTROLS_PER_CAND;
        
            for i = 1, max_cont do
                disp_text(1, "Spicy Algorithm WINNER")
                disp_text(2, "Candidate: "..k);
                
                joypad.set(1, candidates[k].inputs[real_inp]);
                player_x_val = mem_read(PLAYER_XPAGE_ADDR) * PLAYER_PAGE_WIDTH + 
                               mem_read(PLAYER_XPOS_ADDR);

                disp_text(3, "Fitness: "..player_x_val);
        
                local win_state = mem_read(PLAYER_FLOAT_STATE);
                if win_state == PLAYER_FLAGPOLE then
                    break;
                end

                tbl = joypad.get(1);
                disp_text(4, "Input: "..ctrl_tbl_btis(tbl));
                disp_text(5, "# Input: "..real_inp);

                cnt = cnt + 1;
                if cnt == FRAME_MAX_PER_CONTROL then
                    cnt = 0;
                    real_inp = real_inp + 1;
                end

                emu.frameadvance();
            end
        end
    end
end

--TRASH AREA
--[[ Unused variables and function calls for previous GA method (Elitism method)
local FH_SELECT_FACTOR  = 1.2    --GA crossover selection front-heaviness
local NUM_CH_GEN          = 5      --number of children generated.
ga_crossover(candidates, MAX_CANDIDATES, MAX_CONTROLS_PER_CAND, FH_SELECT_FACTOR, NUM_CH_GEN);
]]--

