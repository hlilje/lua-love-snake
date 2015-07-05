require "constants"


-- Initialise the game state.
function createState()
    TimeToMove = 0   -- Keep track of when to advance state
    Intents    = nil -- Player intent queue
end

-- Add the given intent to the end of the intent queue.
function addIntent(intent)
    if Intents == nil then
        Intents = {next = nil, intent = intent}
        return
    end

    print("Add intent " .. intent)

    local last = Intents

    while last.next do
        last = last.next
    end
    last.next = {next = nil, intent = intent}
end

-- Keypress callback.
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "w" then
        addIntent(INTENT_PLAYER_1_UP)
    elseif key == "a" then
        addIntent(INTENT_PLAYER_1_LEFT)
    elseif key == "s" then
        addIntent(INTENT_PLAYER_1_DOWN)
    elseif key == "d" then
        addIntent(INTENT_PLAYER_1_RIGHT)
    elseif key == "up" then
        addIntent(INTENT_PLAYER_2_UP)
    elseif key == "left" then
        addIntent(INTENT_PLAYER_2_LEFT)
    elseif key == "down" then
        addIntent(INTENT_PLAYER_2_DOWN)
    elseif key == "right" then
        addIntent(INTENT_PLAYER_2_RIGHT)
    end
end

-- Handle the intents in the intent queue while clearing it.
function handleIntents()
    -- TODO: Implement

    while Intents do
        print("Handle intent " .. Intents.intent)
        Intents = Intents.next
    end
    Intents = nil -- Remove final reference
end

-- Update the game state.
function updateState(dt)
    TimeToMove = TimeToMove + dt
    if TimeToMove < SPEED_GAME then return end
    TimeToMove = 0

    handleIntents()
end
