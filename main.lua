require "game"
require "interface"
require "map"
require "players"


-- Load the game.
function love.load()
    createState()
    createMap(love.graphics.getDimensions())
    createPlayers()
    createInterface()

    generateFood()
end

-- Update the game state.
function love.update(dt)
    updateState(dt)
end

-- Draw the game.
function love.draw()
    drawMap()
    drawScore()
end
