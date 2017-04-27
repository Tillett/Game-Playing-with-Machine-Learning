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
local MAX_NODES = 3000;
local MAX_SUCCESSES = 10;

-- init savestate & setup rng
math.randomseed(os.time());
ss = savestate.create();
savestate.save(ss);

local nodes = {};
local successes = {};
local success_number = 0;
local has_won = false;

local iterator = 0;
local currentNode = iterator;
local currentInputBin = generate_input();
local currentInputDec = generate_input_decimal(currentInputBin);
local isDead;
local x_val = memory.readbyte(PLAYER_XPOS_ADDR);
local highestScore;
local bestPerformance = 0;
local possibleBestString = {};
local bestString = {};
local modelString = {};

local winningString ={26, 26, 9, 25, 26, 42, 26, 10, 26, 41, 42, 57, 25, 10, 25, 26, 58, 57, 42, 9, 10, 58, 25, 57, 9, 42, 10, 58, 42, 25, 57,
 41, 26, 10, 57, 10, 25, 25, 25, 9, 10, 42, 58, 25, 57, 58, 26, 58, 25, 41, 26, 57, 41, 10, 10, 57, 26, 25, 25, 25, 9, 57,
 25, 57, 25, 10, 41, 25, 25, 9, 26, 41, 9, 41, 41, 25, 26, 42, 9, 26, 41, 25, 10, 9, 9, 26, 41, 41, 58, 25, 58, 41, 58, 
41, 41, 41, 25, 9, 10, 57, 57, 26, 58, 57, 42, 26, 42, 10, 58, 58, 10, 42, 10, 42, 58, 42, 58, 57, 9, 9, 26, 58, 57, 9, 
25, 41, 41, 58, 41, 57, 58, 57, 26, 57, 42, 57, 41, 58, 42, 57, 42, 9, 58, 10}

savestate.load(ss);
input_beginning_string(winningString);

-- done!
