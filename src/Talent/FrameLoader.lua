-- in 1.31 and upto 1.32.9 PTR (when I wrote this). Frames are not correctly saved and loaded, breaking the game.
-- This runs all functions added to it with a 0s delay after the game was loaded.
do
    local data = {}
    local real = MarkGameStarted
    local timer
    
    function FrameLoaderAdd(func)
        table.insert(data, func)
    end
    function MarkGameStarted()
        real()
        local trigger = CreateTrigger()
        timer = CreateTimer()
        TriggerRegisterGameEvent(trigger, EVENT_GAME_LOADED)
        TriggerAddAction(trigger, function()
            TimerStart(timer, 0, false, function()
                for _,v in ipairs(data) do v() end
            end)
            
        end)
    end
end