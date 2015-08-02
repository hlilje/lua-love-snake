require "constants"
require "globals"
require "localisation"


-- Generate solid map borders.
function createSolidMapBorder()
    for i = 1, NUM_TILES_X do TileMap[1][i]           = TILE_BLOCKED end
    for i = 1, NUM_TILES_X do TileMap[NUM_TILES_Y][i] = TILE_BLOCKED end
    for i = 1, NUM_TILES_Y do TileMap[i][1]           = TILE_BLOCKED end
    for i = 1, NUM_TILES_Y do TileMap[i][NUM_TILES_X] = TILE_BLOCKED end
end

-- Generate one random map border.
-- {x, y}Static ~= nil => use loop index. limit = iteration limit.
function createRandomMapBorder(xStatic, yStatic, limit)
    assert(not (xStatic == nil and yStatic == nil))

    local remaining, length = limit, 0
    -- Randomise whether to start blocking or not
    local block = (love.math.random(0, 1) == 1) and false or true

    -- Fill alternating blocked/free segments of random length
    local i = 1
    while i <= limit do
        length = love.math.random(1, remaining)
        if not block then goto continue end
        for j = i, (i + length - 1) do
            if xStatic then
                TileMap[j][xStatic] = TILE_BLOCKED
            elseif yStatic then
                TileMap[yStatic][j] = TILE_BLOCKED
            end
        end
        ::continue::
        block = not block
        remaining = remaining - length
        i = i + length
    end
end

-- Generate random map borders.
function createRandomMapBorders()
    createRandomMapBorder(nil, 1, NUM_TILES_X)
    createRandomMapBorder(nil, NUM_TILES_Y, NUM_TILES_X)
    createRandomMapBorder(1, nil, NUM_TILES_Y)
    createRandomMapBorder(NUM_TILES_X, nil, NUM_TILES_Y)
end

-- Create the game map.
function createMap()
    TileMap = {} -- [y][x]

    local pixelWidth, pixelHeight = love.graphics.getDimensions()

    -- Calculate the size of the tiles
    SizeTileX = pixelWidth / NUM_TILES_X
    SizeTileY = pixelHeight / NUM_TILES_Y

    -- Warn if the resulting tiles are non-square
    if SizeTileX ~= SizeTileY then
        print(STRINGS[LANG].TILE_SIZE_WARNING)
        print("x: " .. SizeTileX, "y: " .. SizeTileY)
    end

    -- Set all tiles as free
    for i = 1, NUM_TILES_Y do
        TileMap[i] = {}
        for j = 1, NUM_TILES_X do
            TileMap[i][j] = TILE_FREE
        end
    end

    -- Set all surrounding tiles as occupied
    createRandomMapBorders()
end

-- Randomly place one food on the map.
function generateFood()
    local x, y

    repeat
        x = love.math.random(1, NUM_TILES_X)
        y = love.math.random(1, NUM_TILES_Y)
    until not isBlocked(x, y) and not isPlayer(x, y)

    TileMap[y][x] = TILE_FOOD
end

-- Mark the given tile coordinates as a collision tile.
function addCollisionTile(x, y)
    TileMap[y][x] = TILE_COLLISION
end

-- Colour the tile at the given location.
function colourTile(tile, x, y)
    local xPos = x * SizeTileX
    local yPos = y * SizeTileY

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
    elseif tile == TILE_COLLISION then
        love.graphics.setColor(COLOUR_COLLISION)
    end
    love.graphics.rectangle("fill", xPos, yPos, SizeTileX, SizeTileY)
end

-- Draw the game map.
function drawMap()
    for i = 1, NUM_TILES_Y do
        for j = 1, NUM_TILES_X do
            colourTile(TileMap[i][j], j - 1, i - 1)
        end
    end
end

-- Return true if the given position is blocked.
function isBlocked(x, y)
    if x > NUM_TILES_X or x < 1 or y > NUM_TILES_Y or y < 1 then
        return true
    else
        return TileMap[y][x] ~= TILE_FREE and TileMap[y][x] ~= TILE_FOOD
    end
end

-- Return true if the given position is a player tile.
function isPlayer(x, y)
    return TileMap[y][x] == TILE_PLAYER_1 or TileMap[y][x] == TILE_PLAYER_2
end
