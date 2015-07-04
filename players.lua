require "constants"
require "map"


-- Create initial player positions.
function createPlayers()
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

    TileMap[yPosP1][xPosP1] = TILE_PLAYER_1
    TileMap[yPosP2][xPosP2] = TILE_PLAYER_2
end
