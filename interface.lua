require "game"


-- Initialise the game interface.
function createInterface()
    local font = love.graphics.newFont(14)
    love.graphics.setFont(font)
end

-- Draw the player score.
function drawScore()
    local x, y = 20, 20

    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score P1: " .. ScorePlayer1, x, y)
    love.graphics.print("Score P2: " .. ScorePlayer2, x, y + 20)
end
