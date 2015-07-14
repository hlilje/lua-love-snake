require "constants"
require "game"


-- Initialise the menu buttons.
function createMenuButtons()
    MenuButtons      = {}

    local numButtons = 3
    local offset     = MENU_BUTTON_HEIGHT + 40
    local w, h       = love.graphics.getWidth(), love.graphics.getHeight()
    local x          = (w / 2) - (MENU_BUTTON_WIDTH / 2)
    local y          = (h / 2) - (MENU_BUTTON_HEIGHT / 2) - (offset * (numButtons - 1) / 2)
    local colour     = {100, 100, 100}

    for i = 1, numButtons do
        MenuButtons[i] = {x = x,
                          y = y + (i - 1) * offset,
                          w = MENU_BUTTON_WIDTH,
                          h = MENU_BUTTON_HEIGHT,
                          colour = colour}
    end
end

-- Initialise the game interface.
function createInterface()
    local font = love.graphics.newFont(14)
    love.graphics.setFont(font)

    createMenuButtons()
end

-- Draw the game menu.
function drawMenu()
    love.graphics.setBackgroundColor(0, 0, 0)

    for i = 1, #MenuButtons do
        local btn = MenuButtons[i]
        love.graphics.setColor(btn.colour);
        love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h);
    end
end

-- Draw the player score.
function drawScore()
    local x, y = 20, 20

    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score P1: " .. ScorePlayer1, x, y)
    love.graphics.print("Score P2: " .. ScorePlayer2, x, y + 20)
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
