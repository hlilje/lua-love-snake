require "map"
require "players"


-- Load the game.
function love.load()
    createMap(love.graphics.getDimensions())
    createPlayers()
end

-- Update the game state.
function love.update(dt)
end

-- Draw the game.
function love.draw()
    drawMap()
end
