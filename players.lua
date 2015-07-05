require "constants"
require "map"


-- Add the given position to the front of the given snake.
function addSnakePos(snake, x, y)
    -- TODO: Check that there is no name clash
    Snake1 = {next = Snake1, x = x, y = y}
end

-- Remove the tail of the given snake
function delSnakePos(snake)
    if snake == nil then return end

    local prev = snake

    while snake.next do
        prev = snake
        snake = snake.next
    end
    prev.next = nil
end

function updatePlayers(dt)
    TimeToMove = TimeToMove + dt
    if TimeToMove >= SPEED_GAME then
        TimeToMove = 0
        print("MOVE")
    end
end

-- Create initial player positions.
function createPlayers()
    Snake1, Snake2 = nil, nil

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

    Snake1 = addSnakePos(Snake1, xPosP1, yPosP1)

    TileMap[yPosP1][xPosP1] = TILE_PLAYER_1
    TileMap[yPosP2][xPosP2] = TILE_PLAYER_2
end
