-- Load the game high scores from file, create the file if it doesn't exist.
-- Return a table of the scores in descending order.
function loadHighScores()
    local file
    local ok, err
    local highScores = {}

    if love.filesystem.exists(FILE_HIGHSCORES) then
        file = love.filesystem.newFile(FILE_HIGHSCORES)
        -- Open existing file
        ok, err = file:open("r")
        if not ok then
            io.stderr:write(err)
        end
    else
        file = love.filesystem.newFile(FILE_HIGHSCORES)
        ok, err = file:open("w")
        if not ok then
            io.stderr:write(err)
        else
            -- Create empty file
            ok, err = file:write("")
            if not ok then
                io.stderr:write(err)
            end
        end
    end

    -- Read all lines from file
    local i = 1
    for line in file:lines() do
        highScores[i] = tonumber(line)
        i = i + 1
    end

    if not ok then
        file:close()
        love.event.quit()
    end

    file:close()

    -- Sort score in descending order
    table.sort(highScores, function(a, b) return a > b end)

    return highScores
end

-- Save the current high scores to file, create the file if it doesn't exist.
function saveHighScores()
    local file
    local ok, err
    local highScores = {}

    -- Creates file if not present
    file = love.filesystem.newFile(FILE_HIGHSCORES)
    ok, err = file:open("w")
    if not ok then
        io.stderr:write(err)
    else
        -- Clear file contents
        ok, err = file:write("")
        if not ok then
            io.stderr:write(err)
        else
            -- Write high scores to file
            for i = 1, #HighScores do
                ok, err = love.filesystem.append(FILE_HIGHSCORES, HighScores[i] .. '\n')
                if not ok then
                    io.stderr:write(err)
                end
            end
        end
    end

    -- Flush data to disk
    ok, err = file:flush()
    if not ok then
        io.stderr:write(err)
    end

    if not ok then
        file:close()
        love.event.quit()
    end

    file:close()
end
