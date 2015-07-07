require "constants"
require "map"
require "players"


-- Initialise the game state.
function createState()
    TimeToMove  = 0     -- Keep track of when to advance state
    Intents     = {}    -- Player intent queue
    LossPlayer1 = false -- If player one loses from the move
    LossPlayer2 = false -- If player two loses from the move
end

-- Add the given intent to the end of the intent queue.
function addIntent(intent)
    table.insert(Intents, intent)
end

-- Keypress callback.
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "w" then
        addIntent(INTENT_PLAYER_1_UP)
    elseif key == "a" then
        addIntent(INTENT_PLAYER_1_LEFT)
    elseif key == "s" then
        addIntent(INTENT_PLAYER_1_DOWN)
    elseif key == "d" then
        addIntent(INTENT_PLAYER_1_RIGHT)
    elseif key == "up" then
        addIntent(INTENT_PLAYER_2_UP)
    elseif key == "left" then
        addIntent(INTENT_PLAYER_2_LEFT)
    elseif key == "down" then
        addIntent(INTENT_PLAYER_2_DOWN)
    elseif key == "right" then
        addIntent(INTENT_PLAYER_2_RIGHT)
    end
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
    end
end

-- Handle the player intents in the intent queue while clearing it.
function handleIntents()
    while #Intents > 0 do
        handleIntent(Intents[1])
        table.remove(Intents)
    end
end

-- Handle which tiles the players are about to move to, return whether
-- the players should grow from food or not.
function handleNextTiles(x1, y1, x2, y2)
    local growP1, growP2

    -- Tie if they both move to the same tile simultaneously
    if x1 == x2 and y1 == y2 then
        LossPlayer1 = true
        LossPlayer1 = true
        return false, false
    end

    -- Loss for given player if the tile is currently blocked
    LossPlayer1 = isBlocked(x1, y1)
    LossPlayer2 = isBlocked(x2, y2)
    if LossPlayer1 or LossPlayer2 then
        return false, false
    end

    if TileMap[y1][x1] == TILE_FOOD then
        growP1 = true
    end
    if TileMap[y2][x1] == TILE_FOOD then
        growP2 = true
    end

    return growP1, growP2
end

-- Update the game state.
function updateState(dt)
    TimeToMove = TimeToMove + dt
    if TimeToMove < SPEED_GAME then return end
    TimeToMove = 0

    handleIntents()

    local x1, y1, x2, y2 = getNextPositions()

    local grow1, grow2 = handleNextTiles(x1, y1, x2, y2)

    -- TODO: Handle game over state
    if LossPlayer1 or LossPlayer2 then
        love.event.quit()
        return
    end

    moveSnake(Snake1, x1, y1, TILE_PLAYER_1, grow1)
    moveSnake(Snake2, x2, y2, TILE_PLAYER_2, grow2)
end
