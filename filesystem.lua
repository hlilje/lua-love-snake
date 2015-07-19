-- Load the game high scores from file, creates the file if it
-- doesn't exist.
-- Retun a table of the scores in descending order.
function loadHighScores()
    local file = nil
    local highScores = {}

    if love.filesystem.exists(FILE_HIGHSCORES) then
        file = love.filesystem.newFile(FILE_HIGHSCORES)
        -- Open existing file
        ok, err = file:open("r")
        if not ok then
            io.stderr:write(err)
            love.event.quit()
        end
    else
        file = love.filesystem.newFile(FILE_HIGHSCORES)
        ok, err = file:open("w")
        if not ok then
            io.stderr:write(err)
            love.event.quit()
        else
            -- Create empty file
            ok, err = file:write("")
            if not ok then
                io.stderr:write(err)
                love.event.quit()
            end
        end
    end

    -- Read all lines from file
    local i = 1
    for line in file:lines() do
        highScores[i] = tonumber(line)
        i = i + 1
    end

    file:close()

    -- Sort score in descending order
    table.sort(highScores, function(a, b) return a > b end)

    return highScores
end
