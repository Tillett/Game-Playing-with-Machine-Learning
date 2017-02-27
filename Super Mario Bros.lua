-- Main File
-- Info:    [here]
-- Authors: [here]
-- Date:    [here]

require "table_utils"
require "other_utils"
require "candidate"

-- constant values, memory locations & other useful things
local PLAYER_XPAGE_ADDR     = 0x071A --Player's page (screen) address
local PLAYER_XSUBP_ADDR     = 0x071C --Player's position within page
local PLAYER_STATE_ADDR     = 0x000E --Player's state (dead/dying)
local PLAYER_VIEWPORT_ADDR  = 0x00B5 --Player's viewport status (falling)
local PLAYER_DOWN_HOLE      = 3      --VP val for falling into hole
local PLAYER_DYING_STATE    = 0x0B   --(CURRENTLY UNUSED!) State value for dying player
local PLAYER_DEAD_STATE     = 0x06   --State value for dead player
local TXT_INCR              = 9      --vertical px text block separation

-- constant values which describe the state of the genetic algorithm
local MAX_CANDIDATES        = 500    --Number of candidates generated
local MAX_CONTROLS_PER_CAND = 1000   --Number of controls that each candidate has
local FRAME_MAX_PER_CONTROL = 20     --Number of frames that each control will last
local CROSSOVER_RATE        = 0.7    --GA crossover rate
local MUTATION_RATE         = 0.001  --GA  

-- init savestate & setup rng
math.randomseed(os.time());
ss = savestate.create();
savestate.save(ss);

--early test
local test_cand = gen_candidate:new();
for i = 1, MAX_CONTROLS_PER_CAND do
    -- we generate L/R first to avoid pushing both at same time!
    local lrv = random_bool()

    test_cand.inputs[i] = { 
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

while true do
    savestate.load(ss);
    local player_x_val;
    local cnt = 0;
    local real_inp = 1;
    local max = FRAME_MAX_PER_CONTROL * MAX_CONTROLS_PER_CAND

    for i = 1, max do
        gui.text(0, TXT_INCR * 2, "Cand: 1")

        joypad.set(1, test_cand.inputs[real_inp]);

        player_x_val = memory.readbyte(PLAYER_XPAGE_ADDR)*255 + 
                       memory.readbyte(PLAYER_XSUBP_ADDR);

        gui.text(0, TXT_INCR * 3, "Best Horiz: "..player_x_val);
        
        local p_state = memory.readbyte(PLAYER_STATE_ADDR);
        local f_state = memory.readbyte(PLAYER_VIEWPORT_ADDR);

        if p_state == PLAYER_DYING_STATE or f_state >= PLAYER_DOWN_HOLE then
            gui.text(0, TXT_INCR * 4, "DYING");
            break
        else
            gui.text(0, TXT_INCR * 4, "ALIVE");
        end
        
        tbl = joypad.get(1);
        gui.text(0, TXT_INCR * 5, "Input: "..ctrl_tbl_btis(tbl));
        gui.text(0, TXT_INCR * 6, "Curr Chromosome: "..real_inp);

        cnt = cnt + 1;
        if cnt == FRAME_MAX_PER_CONTROL then
            cnt = 0
            real_inp = real_inp + 1
        end
        emu.frameadvance();
    end
end