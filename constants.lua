SPEED_GAME = 0.15 -- Delay until game state advancement
SIZE_TILE  = 16   -- Tile size in pixels

-- Game state enums
STATE_MENU      = 0
STATE_PLAYING   = 1
STATE_PAUSED    = 2
STATE_GAME_OVER = 3

-- Tile enums
TILE_FREE     = 0
TILE_BLOCKED  = 1
TILE_PLAYER_1 = 2
TILE_PLAYER_2 = 3
TILE_FOOD     = 4

-- Entity colours
COLOUR_BLOCKED  = {0, 0, 0}
COLOUR_FREE     = {255, 255, 255}
COLOUR_PLAYER_1 = {255, 0, 0}
COLOUR_PLAYER_2 = {0, 0, 255}
COLOUR_FOOD     = {0, 255, 0}

-- Player movement direction enums
MOVING_UP    = 0
MOVING_LEFT  = 1
MOVING_DOWN  = 2
MOVING_RIGHT = 3

-- Player intent enums
INTENT_PLAYER_1_UP    = 0
INTENT_PLAYER_1_LEFT  = 1
INTENT_PLAYER_1_DOWN  = 2
INTENT_PLAYER_1_RIGHT = 3
INTENT_PLAYER_2_UP    = 4
INTENT_PLAYER_2_LEFT  = 5
INTENT_PLAYER_2_DOWN  = 6
INTENT_PLAYER_2_RIGHT = 7

-- Score quanta
SCORE_FOOD = 10
SCORE_WIN  = 1000
