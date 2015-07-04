require "constants"

-- Create the game map.
function createMap(width, height)
    TileMap = {} -- [y][x]

    local mapWidth  = width / SIZE_TILE
    local mapHeight = height / SIZE_TILE

    -- Set all tiles as free
    for i = 1, mapHeight do
        TileMap[i] = {}
        for j = 1, mapWidth do
            TileMap[i][j] = TILE_FREE
        end
    end

    -- Set all surrounding tiles as occupied
    for i = 1, mapWidth  do TileMap[1][i]         = TILE_BLOCKED end
    for i = 1, mapWidth  do TileMap[mapHeight][i] = TILE_BLOCKED end
    for i = 1, mapHeight do TileMap[i][1]         = TILE_BLOCKED end
    for i = 1, mapHeight do TileMap[i][mapWidth]  = TILE_BLOCKED end
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

-- Draw the game map.
function drawMap()
    for i = 1, #TileMap do
        for j = 1, #TileMap[i] do
            colourTile(TileMap[i][j], j - 1, i - 1)
        end
    end
end

-- Load the game.
function love.load()
    createMap(love.graphics.getDimensions())
end

-- Draw the game.
function love.draw()
    drawMap()
end
