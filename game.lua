require "conf"
require "constants"
require "filesystem"
require "globals"
require "interface"
require "localisation"
require "map"
require "players"


-- Check that the game config has the required values.
function assertConfig()
    assert(Config.window.width >= 128 and Config.window.width <= 1920,
            STRINGS[LANG].INVALID_SCREEN_WIDTH)
    assert(Config.window.height >= 128 and Config.window.height <= 1080,
            STRINGS[LANG].INVALID_SCREEN_HEIGHT)
    assert(not Config.window.resizable, STRINGS[LANG].WARNING_WINDOW_RESIZING)
    assert(not Config.console, STRINGS[LANG].WARNING_CONSOLE)

    assert(Config.modules.audio   , STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.event   , STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.graphics, STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.image   , STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.joystick, STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.keyboard, STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.math    , STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.mouse   , STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.physics , STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.sound   , STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.system  , STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.timer   , STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.window  , STRINGS[LANG].MISSING_MODULE)
    assert(Config.modules.thread  , STRINGS[LANG].MISSING_MODULE)
end

-- Initialise the game state.
function createState()
    GameState    = STATE_MENU       -- Current game state
    TimeToMove   = 0                -- Keep track of when to advance state
    Intents      = {}               -- Player intent queue
    LossPlayer1  = false            -- If player one loses from the move
    LossPlayer2  = false            -- If player two loses from the move
    ScorePlayer1 = 0                -- Score of player 1
    ScorePlayer2 = 0                -- Score of player 2
    HighScores   = loadHighScores() -- Load the high scores
end

-- Initialise the game.
function initGame()
    createState()
    createMap()
    createPlayers()
    createInterface()

    generateFood()
end

-- Handle the given player intent.
function handleIntent(intent)
    if intent == INTENT_PLAYER_1_UP then
        if Snake1.dir == MOVING_DOWN then reverseSnake(Snake1) end
        Snake1.dir = MOVING_UP
    elseif intent == INTENT_PLAYER_1_LEFT then
        if Snake1.dir == MOVING_RIGHT then reverseSnake(Snake1) end
        Snake1.dir = MOVING_LEFT
    elseif intent == INTENT_PLAYER_1_DOWN then
        if Snake1.dir == MOVING_UP then reverseSnake(Snake1) end
        Snake1.dir = MOVING_DOWN
    elseif intent == INTENT_PLAYER_1_RIGHT then
        if Snake1.dir == MOVING_LEFT then reverseSnake(Snake1) end
        Snake1.dir = MOVING_RIGHT
    elseif intent == INTENT_PLAYER_2_UP then
        if Snake2.dir == MOVING_DOWN then reverseSnake(Snake2) end
        Snake2.dir = MOVING_UP
    elseif intent == INTENT_PLAYER_2_LEFT then
        if Snake2.dir == MOVING_RIGHT then reverseSnake(Snake2) end
        Snake2.dir = MOVING_LEFT
    elseif intent == INTENT_PLAYER_2_DOWN then
        if Snake2.dir == MOVING_UP then reverseSnake(Snake2) end
        Snake2.dir = MOVING_DOWN
    elseif intent == INTENT_PLAYER_2_RIGHT then
        if Snake2.dir == MOVING_LEFT then reverseSnake(Snake2) end
        Snake2.dir = MOVING_RIGHT
    elseif intent == INTENT_START_GAME then
        GameState = STATE_PLAYING
    elseif intent == INTENT_PAUSE_GAME then
        GameState = STATE_PAUSED
    elseif intent == INTENT_EXIT_GAME then
        -- TODO: Clean up to avoid exceptional termination
        love.event.quit()
    elseif intent == INTENT_OPEN_MENU then
        GameState = STATE_MENU
    elseif intent == INTENT_VIEW_HIGHSCORE then
        GameState = STATE_HIGHSCORE
    elseif intent == INTENT_RESTART_GAME then
        if GameState == STATE_GAME_OVER then
            initGame()
            GameState = STATE_MENU
        end
    end
end

-- Handle the player intents in the intent queue while clearing it.
function handleIntents()
    while #Intents > 0 do
        handleIntent(Intents[1])
        table.remove(Intents, 1)
    end
end

-- Add the given intent to the end of the intent queue.
function addIntent(intent)
    table.insert(Intents, intent)
end

-- Handle which tiles the players are about to move to, return whether
-- the players should grow from food or not.
function handleNextTiles(x1, y1, x2, y2)
    local growP1, growP2

    -- Tie if they both move to the same tile simultaneously
    if x1 == x2 and y1 == y2 then
        LossPlayer1 = true
        LossPlayer1 = true
        addCollisionTile(x1, y1)
        return false, false
    end

    -- Loss for player in question if the tile is currently blocked
    if isBlocked(x1, y1) then
        LossPlayer1 = true
        addCollisionTile(x1, y1)
    end
    if isBlocked(x2, y2) then
        LossPlayer2 = true
        addCollisionTile(x2, y2)
    end

    if LossPlayer1 or LossPlayer2 then
        return false, false
    end

    if TileMap[y1][x1] == TILE_FOOD then
        growP1 = true
        ScorePlayer1 = ScorePlayer1 + SCORE_FOOD
    end
    if TileMap[y2][x2] == TILE_FOOD then
        growP2 = true
        ScorePlayer2 = ScorePlayer2 + SCORE_FOOD
    end

    return growP1, growP2
end

-- Check and save possible high score.
-- Assume scores are sorted in descending order.
function checkHighScore()
    local highestScore = math.max(ScorePlayer1, ScorePlayer2)
    local betterThan = (#HighScores == 0) and 1 or nil

    for i = 1, #HighScores do
        if highestScore >= HighScores[i] then
            betterThan = i
            break
        end
    end

    if betterThan then
        table.insert(HighScores, betterThan, highestScore)
        if #HighScores > SCORES_TO_SAVE then
            table.remove(HighScores) -- Remove lowest score
        end
        saveHighScores()
    end
end

-- Handle possible game over state.
function handleGameOver()
    if LossPlayer1 or LossPlayer2 then
        if LossPlayer1 and not LossPlayer2 then
            ScorePlayer2 = ScorePlayer2 + SCORE_WIN
        elseif LossPlayer2 and not LossPlayer1 then
            ScorePlayer1 = ScorePlayer1 + SCORE_WIN
        end
        GameState = STATE_GAME_OVER

        checkHighScore()
    end
end

-- Update the game state.
function updateState(dt)
    if GameState ~= STATE_PLAYING then
        handleIntents()
    elseif GameState == STATE_PLAYING then
        TimeToMove = TimeToMove + dt
        if TimeToMove < SPEED_GAME then return end
        TimeToMove = 0

        handleIntents()

        local x1, y1, x2, y2 = getNextPositions()
        local grow1, grow2 = handleNextTiles(x1, y1, x2, y2)

        handleGameOver()

        if GameState ~= STATE_GAME_OVER then
            moveSnake(Snake1, x1, y1, TILE_PLAYER_1, grow1)
            moveSnake(Snake2, x2, y2, TILE_PLAYER_2, grow2)

            if grow1 or grow2 then generateFood() end
        end
    end
end

-- Keypress callback.
function love.keypressed(key)
    if key == "escape" then
        if GameState == STATE_MENU then
            addIntent(INTENT_EXIT_GAME)
        elseif GameState == STATE_HIGHSCORE then
            addIntent(INTENT_OPEN_MENU)
        elseif GameState == STATE_PLAYING then
            addIntent(INTENT_PAUSE_GAME)
        elseif GameState == STATE_PAUSED then
            addIntent(INTENT_START_GAME)
        elseif GameState == STATE_GAME_OVER then
            addIntent(INTENT_RESTART_GAME)
        end
    elseif key == "w" then
        if GameState == STATE_PLAYING then
            addIntent(INTENT_PLAYER_1_UP)
        end
    elseif key == "a" then
        if GameState == STATE_PLAYING then
            addIntent(INTENT_PLAYER_1_LEFT)
        end
    elseif key == "s" then
        if GameState == STATE_PLAYING then
            addIntent(INTENT_PLAYER_1_DOWN)
        elseif GameState == STATE_MENU then
            GameState = STATE_PLAYING
        end
    elseif key == "d" then
        if GameState == STATE_PLAYING then
            addIntent(INTENT_PLAYER_1_RIGHT)
        end
    elseif key == "up" then
        if GameState == STATE_PLAYING then
            addIntent(INTENT_PLAYER_2_UP)
        end
    elseif key == "left" then
        if GameState == STATE_PLAYING then
            addIntent(INTENT_PLAYER_2_LEFT)
        end
    elseif key == "down" then
        if GameState == STATE_PLAYING then
            addIntent(INTENT_PLAYER_2_DOWN)
        end
    elseif key == "right" then
        if GameState == STATE_PLAYING then
            addIntent(INTENT_PLAYER_2_RIGHT)
        end
    elseif key == "h" then
        if GameState == STATE_MENU then
            addIntent(INTENT_VIEW_HIGHSCORE)
        end
    end
end

-- Mouse click callback.
function love.mousepressed(x, y, button)
    if GameState == STATE_MENU then
        if hasMouseover(MenuButtons[1]) then
            addIntent(INTENT_START_GAME)
        end
        if hasMouseover(MenuButtons[2]) then
            addIntent(INTENT_VIEW_HIGHSCORE)
        end
        if hasMouseover(MenuButtons[3]) then
            addIntent(INTENT_EXIT_GAME)
        end
    elseif GameState == STATE_HIGHSCORE then
        if hasMouseover(MenuButtons[4]) then
            addIntent(INTENT_OPEN_MENU)
        end
    end
end
