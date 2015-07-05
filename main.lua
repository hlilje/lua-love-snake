require "game"
require "map"
require "players"


-- Load the game.
function love.load()
    TimeToMove = 0 -- Keep track of when to advance state
    createMap(love.graphics.getDimensions())
    createPlayers()
end

-- Update the game state.
function love.update(dt)
    updateState(dt)
end

-- Draw the game.
function love.draw()
    drawMap()
end
