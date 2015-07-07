require "constants"
require "map"


-- Insert the given position to the front of the given snake.
function addSnakePos(snake, x, y, playerTile)
    TileMap[y][x] = playerTile
    table.insert(snake.pos, 1, {x = x, y = y})
end

-- Remove the tail of the given snake.
function delSnakePos(snake)
    local x, y = snake.pos[#snake.pos].x, snake.pos[#snake.pos].y
    TileMap[y][x] = TILE_FREE
    table.remove(snake.pos)
end

-- Create initial players.
function createPlayers()
    -- {Positions table (stack), direction enum}
    Snake1 = {pos = {}, dir}
    Snake2 = {pos = {}, dir}

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

-- Return the next position the given snake will move to.
function getNextSnakePos(snake)
    local x, y

    if snake.dir == MOVING_UP then
        x = snake.pos[1].x
        y = snake.pos[1].y - 1
    elseif snake.dir == MOVING_LEFT then
        x = snake.pos[1].x - 1
        y = snake.pos[1].y
    elseif snake.dir == MOVING_DOWN then
        x = snake.pos[1].x
        y = snake.pos[1].y + 1
    elseif snake.dir == MOVING_RIGHT then
        x = snake.pos[1].x + 1
        y = snake.pos[1].y
    end

    return x, y
end

-- Get the next positions the players will move to.
function getNextPositions()
    local x1, y1, x2, y2

    x1, y1 = getNextSnakePos(Snake1)
    x2, y2 = getNextSnakePos(Snake2)

    return x1, y1, x2, y2
end

-- Move the given snake to the given tile, don't delete tail if grow == true.
function moveSnake(snake, x, y, playerTile, grow)
    addSnakePos(snake, x, y, playerTile)
    if not grow then delSnakePos(snake) end
end

-- Reverse the given snake.
-- TODO: Reverse entire table
function reverseSnake(snake)
    local headX, headY = snake.pos[1].x, snake.pos[1].y
    local tailX, tailY = snake.pos[#snake.pos].x, snake.pos[#snake.pos].y
    snake.pos[1].x = tailX
    snake.pos[1].y = tailY
    snake.pos[#snake.pos].x = headX
    snake.pos[#snake.pos].y = headY
end
