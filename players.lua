require "constants"
require "map"


-- Add the given position to the front of the given snake.
function addSnakePos(snake, x, y, playerTile)
    TileMap[y][x] = playerTile
    snake.pos = {next = snake.pos, x = x, y = y}
end

-- Remove the tail of the given snake.
function delSnakePos(snake)
    if snake.pos == nil then return end

    local prev = snake.pos

    while snake.pos.next do
        prev = snake.pos
        snake = snake.pos.next
    end
    prev.pos.next = nil
end

-- Create initial players.
function createPlayers()
    -- {Positions linked list, direction enum}
    Snake1 = {pos = nil, dir = nil}
    Snake2 = {pos = nil, dir = nil}

    -- Randomise initial directions of movement
    Snake1.dir = love.math.random(MOVING_UP, MOVING_RIGHT)
    Snake2.dir = love.math.random(MOVING_UP, MOVING_RIGHT)

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

    addSnakePos(Snake1, xPosP1, yPosP1, TILE_PLAYER_1)
    addSnakePos(Snake2, xPosP2, yPosP2, TILE_PLAYER_2)
end

-- TODO: Implement
function movePlayer(snake, playerTile)
    x, y = snake.pos.x, snake.pos.y - 1
    if not isBlocked(x, y) then
        addSnakePos(snake, x, y, playerTile)
    end
end

