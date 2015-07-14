require "game"
require "interface"
require "map"
require "players"


-- Load the game.
function love.load()
    assertConfig()

    createState()
    createMap()
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
    if GameState == STATE_MENU then
        drawMenu()
    else
        drawMap()
        drawScore()
    end
end
