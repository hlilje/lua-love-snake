-- Keypress callback.
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "w" then
    elseif key == "a" then
    elseif key == "s" then
    elseif key == "d" then
    elseif key == "up" then
    elseif key == "left" then
    elseif key == "down" then
    elseif key == "right" then
    end
end

-- Update the game state.
function updateState(dt)
    TimeToMove = TimeToMove + dt
    if TimeToMove < SPEED_GAME then return end
    TimeToMove = 0

    print("MOVE")
end
