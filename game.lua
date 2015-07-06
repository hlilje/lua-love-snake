require "constants"
require "map"
require "players"


-- Initialise the game state.
function createState()
    TimeToMove = 0   -- Keep track of when to advance state
    Intents    = nil -- Player intent queue
end

-- Add the given intent to the end of the intent queue.
function addIntent(intent)
    print("Add intent " .. intent)

    if Intents == nil then
        Intents = {next = nil, intent = intent}
        return
    end

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

-- Handle the given player intent.
function handleIntent(intent)
    print("Handle intent " .. Intents.intent)
    if intent == INTENT_PLAYER_1_UP then
        Snake1.dir = MOVING_UP
    elseif intent == INTENT_PLAYER_1_LEFT then
        Snake1.dir = MOVING_LEFT
    elseif intent == INTENT_PLAYER_1_DOWN then
        Snake1.dir = MOVING_DOWN
    elseif intent == INTENT_PLAYER_1_RIGHT then
        Snake1.dir = MOVING_RIGHT
    elseif intent == INTENT_PLAYER_2_UP then
        Snake2.dir = MOVING_UP
    elseif intent == INTENT_PLAYER_2_LEFT then
        Snake2.dir = MOVING_LEFT
    elseif intent == INTENT_PLAYER_2_DOWN then
        Snake2.dir = MOVING_DOWN
    elseif intent == INTENT_PLAYER_2_RIGHT then
        Snake2.dir = MOVING_RIGHT
    end
end

-- Handle the player intents in the intent queue while clearing it.
function handleIntents()
    while Intents do
        local temp = Intents.next
        handleIntent(Intents.intent)
        Intents.next = nil -- Might not help garbage collection
        Intents = temp
    end
end

-- Update the game state.
function updateState(dt)
    TimeToMove = TimeToMove + dt
    if TimeToMove < SPEED_GAME then return end
    TimeToMove = 0

    handleIntents()
end
