require "constants"
require "map"


-- Add the given position to the front of the given snake by returning it.
function addSnakePos(snake, x, y, playerTile)
    TileMap[y][x] = playerTile

    return {next = snake, x = x, y = y}
end

-- Remove the tail of the given snake.
function delSnakePos(snake)
    if snake == nil then return end

    local prev = snake

    while snake.next do
        prev = snake
        snake = snake.next
    end
    prev.next = nil
end

-- Create initial player positions.
function createPlayers()
    Snake1, Snake2 = nil, nil

    -- TODO: Create snake containers
    -- Randomise initial directions of movement
    Snake1Dir = love.math.random(MOVING_UP, MOVING_RIGHT)
    Snake2Dir = love.math.random(MOVING_UP, MOVING_RIGHT)

    local xPosP1, yPosP1, xPosP2, xPosP2 = 1, 1, 1, 1

    -- Randomise starting positions for players until they are unblocked
    repeat
        xPosP1 = love.math.random(1, MAP_WIDTH)
        yPosP1 = love.math.random(1, MAP_HEIGHT)
    until not isBlocked(xPosP1, yPosP1)

    repeat
        xPosP2 = love.math.random(1, MAP_WIDTH)
        yPosP2 = love.math.random(1, MAP_HEIGHT)
    until not isBlocked(xPosP2, yPosP2)

    Snake1 = addSnakePos(Snake1, xPosP1, yPosP1, TILE_PLAYER_1)
    Snake2 = addSnakePos(Snake2, xPosP2, yPosP2, TILE_PLAYER_2)
end
