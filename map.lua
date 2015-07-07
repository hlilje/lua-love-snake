require "constants"


-- Create the game map.
function createMap(pixelWidth, pixelHeight)
    TileMap = {} -- [y][x]

    MAP_WIDTH  = pixelWidth / SIZE_TILE
    MAP_HEIGHT = pixelHeight / SIZE_TILE

    -- Set all tiles as free
    for i = 1, MAP_HEIGHT do
        TileMap[i] = {}
        for j = 1, MAP_WIDTH do
            TileMap[i][j] = TILE_FREE
        end
    end

    -- Set all surrounding tiles as occupied
    for i = 1, MAP_WIDTH  do TileMap[1][i]          = TILE_BLOCKED end
    for i = 1, MAP_WIDTH  do TileMap[MAP_HEIGHT][i] = TILE_BLOCKED end
    for i = 1, MAP_HEIGHT do TileMap[i][1]          = TILE_BLOCKED end
    for i = 1, MAP_HEIGHT do TileMap[i][MAP_WIDTH]  = TILE_BLOCKED end
end

-- Colour the tile at the given location.
function colourTile(tile, x, y)
    local xPos = x * SIZE_TILE
    local yPos = y * SIZE_TILE

    if tile == TILE_FREE then
        love.graphics.setColor(COLOUR_FREE)
    elseif tile == TILE_BLOCKED then
        love.graphics.setColor(COLOUR_BLOCKED)
    elseif tile == TILE_PLAYER_1 then
        love.graphics.setColor(COLOUR_PLAYER_1)
    elseif tile == TILE_PLAYER_2 then
        love.graphics.setColor(COLOUR_PLAYER_2)
    elseif tile == TILE_FOOD then
        love.graphics.setColor(COLOUR_FOOD)
    end
    love.graphics.rectangle("fill", xPos, yPos, SIZE_TILE, SIZE_TILE)
end

-- Return true if the given position is blocked.
function isBlocked(x, y)
    if x > MAP_WIDTH or x < 1 or y > MAP_HEIGHT or y < 1 then
        return true
    else
        return TileMap[y][x] ~= TILE_FREE and TileMap[y][x] ~= TILE_FOOD
    end
end

-- Return true if the given position is a player tile.
function isPlayer(x, y)
    return TileMap[y][x] == TILE_PLAYER_1 or TileMap[y][x] == TILE_PLAYER_2
end

-- Draw the game map.
function drawMap()
    for i = 1, MAP_HEIGHT do
        for j = 1, MAP_WIDTH do
            colourTile(TileMap[i][j], j - 1, i - 1)
        end
    end
end

-- Randomly place one food on the map.
function generateFood()
    local x, y

    repeat
        x = love.math.random(1, MAP_WIDTH)
        y = love.math.random(1, MAP_HEIGHT)
    until not isBlocked(x, y) and not isPlayer(x, y)

    TileMap[y][x] = TILE_FOOD
end
