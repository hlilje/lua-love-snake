-- General game constants
SPEED_GAME     = 0.15 -- Delay until game state advancement in seconds
SCORES_TO_SAVE = 10   -- Number of high scores to save

-- Map numbers
NUM_TILES_X          = 64 -- Number of tiles in x direction
NUM_TILES_Y          = 48 -- Number of tiles in y direction
NUM_RANDOM_OBSTACLES = 20 -- Max number of random walk obstacles on the map
LENGTH_RANDOM_WALK   = 50 -- Max length of random walks on the map

-- Score quanta
SCORE_FOOD = 100
SCORE_WIN  = 1000

-- Game element sizes in pixels
MENU_BUTTON_WIDTH  = 200
MENU_BUTTON_HEIGHT = 40

-- Font sizes in points
SIZE_FONT_GENERAL = 14
SIZE_FONT_BUTTON  = 18
SIZE_FONT_ALERT   = 24

-- Entity colours
COLOUR_BLOCKED   = {0, 0, 0}
COLOUR_FREE      = {255, 255, 255}
COLOUR_PLAYER_1  = {255, 0, 0}
COLOUR_PLAYER_2  = {0, 0, 255}
COLOUR_FOOD      = {0, 255, 0}
COLOUR_COLLISION = {255, 255, 0}

-- Interface colours
COLOUR_BACKGROUND       = {0, 0, 0}
COLOUR_BUTTON           = {100, 100, 100}
COLOUR_FONT_GENERAL     = {0, 0, 0}
COLOUR_FONT_GENERAL_INV = {255, 255, 255}
COLOUR_FONT_ALERT       = {100, 50, 50}

-- File names
FILE_HIGHSCORES = "highscores.txt"

-- Game state enums
STATE_MENU      = 0
STATE_HIGHSCORE = 1
STATE_PLAYING   = 2
STATE_PAUSED    = 3
STATE_GAME_OVER = 4

-- Tile enums
TILE_FREE      = 0
TILE_BLOCKED   = 1
TILE_PLAYER_1  = 2
TILE_PLAYER_2  = 3
TILE_FOOD      = 4
TILE_COLLISION = 5

-- Player intent enums
INTENT_PLAYER_1_UP    = 0
INTENT_PLAYER_1_LEFT  = 1
INTENT_PLAYER_1_DOWN  = 2
INTENT_PLAYER_1_RIGHT = 3
INTENT_PLAYER_2_UP    = 4
INTENT_PLAYER_2_LEFT  = 5
INTENT_PLAYER_2_DOWN  = 6
INTENT_PLAYER_2_RIGHT = 7
INTENT_START_GAME     = 8
INTENT_PAUSE_GAME     = 9
INTENT_EXIT_GAME      = 10
INTENT_OPEN_MENU      = 11
INTENT_VIEW_HIGHSCORE = 12
INTENT_RESTART_GAME   = 13

-- Player movement direction enums
MOVING_UP    = 0
MOVING_LEFT  = 1
MOVING_DOWN  = 2
MOVING_RIGHT = 3
