require "constants"
require "globals"


-- Initialise the menu buttons.
function createMenuButtons()
    MenuButtons      = {}

    local numButtons = 3
    local offset     = MENU_BUTTON_HEIGHT + 40
    local w, h       = love.graphics.getDimensions()
    local x          = (w / 2) - (MENU_BUTTON_WIDTH / 2)
    local y          = (h / 2) - (MENU_BUTTON_HEIGHT / 2) - (offset * (numButtons - 1) / 2)
    local texts      = {"Start Game", "High Score", "Exit Game"}

    for i = 1, numButtons do
        MenuButtons[i] = {x      = x,
                          y      = y + (i - 1) * offset,
                          w      = MENU_BUTTON_WIDTH,
                          h      = MENU_BUTTON_HEIGHT,
                          colour = COLOUR_BUTTON,
                          text   = texts[i]}
    end
end

-- Initialise the game interface.
function createInterface()
    FontGeneral  = love.graphics.newFont(14)
    FontButton   = love.graphics.newFont(18)
    FontGameOver = love.graphics.newFont(24)
    love.graphics.setFont(FontGeneral)

    createMenuButtons()
end

-- Draw the game menu.
function drawMenu()
    love.graphics.setBackgroundColor(COLOUR_BACKGROUND)
    love.graphics.setFont(FontButton)

    for i = 1, #MenuButtons do
        local btn = MenuButtons[i]
        love.graphics.setColor(btn.colour)
        love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h)
        love.graphics.setColor(COLOUR_FONT_GENERAL)
        love.graphics.print(btn.text, btn.x + (btn.w / 2) - 50, btn.y + 10)
    end
end

-- Draw the player score.
function drawScore()
    local x, y = 20, 20

    love.graphics.setFont(FontGeneral)
    love.graphics.setColor(COLOUR_FONT_GENERAL)
    love.graphics.print("Score P1: " .. ScorePlayer1, x, y)
    love.graphics.print("Score P2: " .. ScorePlayer2, x, y + 20)
end

-- Draw the game over screen (overlay).
function drawGameOverScreen()
    local w, h         = love.graphics.getDimensions()
    local offset       = 60
    local x, y         = (w / 2) - 100, (h / 2) - (offset * 2)
    local gameOverText = ""

    if LossPlayer1 and LossPlayer2 then
        gameOverText = "TIED"
    elseif LossPlayer1 and not LossPlayer2 then
        gameOverText = "PLAYER 2 WINS"
    elseif LossPlayer2 and not LossPlayer1 then
        gameOverText = "PLAYER 1 WINS"
    end

    love.graphics.setFont(FontGameOver)
    love.graphics.setColor(COLOUR_FONT_GAME_OVER)

    love.graphics.print("GAME OVER", x, y)
    love.graphics.print(gameOverText, x, y + offset)
    love.graphics.print("Score P1: " .. ScorePlayer1, x, y + (offset * 2))
    love.graphics.print("Score P2: " .. ScorePlayer2, x, y + (offset * 3))
end

-- Return true if the given button has mouseover.
function hasMouseover(button)
    local x, y = love.mouse.getPosition()

    if x >= button.x and x <= (button.x + button.w) then
        if y >= button.y and y <= (button.y + button.h) then
            return true
        end
    end

    return false
end
