--
-- Functions
--

---Returns the type of a warcraft object as string, e.g. "location", when inputting a location.
---@param input anyWarcraftObject
---@return string
function Wc3Type(input)
    local typeString = type(input)
    if typeString == 'number' then
        return (math.type(input) =='float' and 'real') or 'integer'
    elseif typeString == 'userdata' then
        typeString = tostring(input) --toString returns the warcraft type plus a colon and some hashstuff.
        return string.sub(typeString, 1, (string.find(typeString, ":", nil, true) or 0) -1) --string.find returns nil, if the argument is not found, which would break string.sub. So we need or as coalesce.
    else
        return typeString
    end
end


function dprint(message, level)
    level = level or 1

    if debugprint >= level then
        print("|cff00ff00[debug " .. level .. "]|r " .. tostring(message))
    end
end

function distanceBetweenCoordinates(x1, y1, x2, y2) -- Find Distance between points
    return SquareRoot(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)))
end

function distanceBetweenUnits(unitA, unitB)
    return distanceBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA), GetUnitX(unitB), GetUnitY(unitB))
end

function angleBetweenCoordinates(x1, y1, x2, y2)
    return bj_RADTODEG * Atan2(y2 - y1, x2 - x1)
end

function angleBetweenUnits(unitA, unitB)
    return angleBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA), GetUnitX(unitB), GetUnitY(unitB))
end

function polarProjectionCoordinates(x, y, dist, angle)
    local newX = x + dist * Cos(angle * bj_DEGTORAD)
    local newY = y + dist * Sin(angle * bj_DEGTORAD)
    return newX, newY
end

function try(func, name) -- Turn on runtime logging
    local passed, data = pcall(function()
        func()
        return "func " .. name .. " passed"
    end)
    if not passed then
        print("|cffff0000[ERROR]|r" .. name, passed, data)
    end
end

function CC2Four(num) -- Convert from Handle ID to Four Char
    return string.pack(">I4", num)
end

do
    local data = {}
    function SetTimerData(whichTimer, dat)
        data[whichTimer] = dat
    end

    -- GetData functionality doesn't even require an argument.
    function GetTimerData(whichTimer)
        if not whichTimer then
            whichTimer = GetExpiredTimer()
        end
        return data[whichTimer]
    end

    -- NewTimer functionality includes optional parameter to pass data to timer.
    function NewTimer(dat)
        local t = CreateTimer()
        if dat then
            data[t] = dat
        end
        return t
    end

    -- Release functionality doesn't even need for you to pass the expired timer.
    -- as an arg. It also returns the user data passed.
    function ReleaseTimer(whichTimer)
        if not whichTimer then
            whichTimer = GetExpiredTimer()
        end
        local dat = data[whichTimer]
        data[whichTimer] = nil
        PauseTimer(whichTimer)
        DestroyTimer(whichTimer)
        return dat
    end
end

-- Requires https://www.hiveworkshop.com/threads/lua-timerutils.316957/

do
    local oldWait = PolledWait
    function PolledWait(duration)
        local thread = coroutine.running()
        if thread then
            TimerStart(NewTimer(thread), duration, false, function()
                coroutine.resume(ReleaseTimer())
            end)
            coroutine.yield(thread)
        else
            oldWait(duration)
        end
    end

    local oldTSA = TriggerSleepAction
    function TriggerSleepAction(duration)
        PolledWait(duration)
    end

    local thread
    local oldSync = SyncSelections
    function SyncSelectionsHelper()
        local t = thread
        oldSync()
        coroutine.resume(t)
    end
    function SyncSelections()
        thread = coroutine.running()
        if thread then
            ExecuteFunc("SyncSelectionsHelper")
            coroutine.yield(thread)
        else
            oldSync()
        end
    end

    if not EnableWaits then -- Added this check to ensure compatibilitys with Lua Fast Triggers
        local oldAction = TriggerAddAction
        function TriggerAddAction(whichTrig, userAction)
            oldAction(whichTrig, function()
                coroutine.resume(coroutine.create(function()
                    userAction()
                end))
            end)
        end
    end
end

function pushbackUnits(g, castingUnit, x, y, aoe, damage, tick, duration, factor)
    local u, uX, uY, distance, angle, newDistance, uNewX, uNewY

    local loopTimes = duration / tick
    local damageTick = damage / loopTimes

    if CountUnitsInGroup(g) > 0 then
        for i = 1, loopTimes do

            ForGroup(g, function()
                u = GetEnumUnit()

                if IsUnitAliveBJ(u) then

                    if i == 1 then
                        PauseUnit(u, true)
                    end

                    uX = GetUnitX(u)
                    uY = GetUnitY(u)

                    distance = distanceBetweenCoordinates(x, y, uX, uY)
                    angle = angleBetweenCoordinates(x, y, uX, uY)

                    newDistance = ((aoe + 80) - distance) * 0.13 * factor

                    uNewX, uNewY = polarProjectionCoordinates(uX, uY, newDistance, angle)

                    -- if IsTerrainPathable(uNewX, uNewY, PATHING_TYPE_WALKABILITY) then
                    SetUnitX(u, uNewX)
                    SetUnitY(u, uNewY)
                    -- end

                    if damage > 0 then
                        UnitDamageTargetBJ(castingUnit, u, damageTick, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC)
                    end

                    if i >= loopTimes - 1 then
                        PauseUnit(u, false)
                    end
                else
                    PauseUnit(u, false)
                    GroupRemoveUnit(g, u)
                end
            end)

            PolledWait(tick)
        end
    end
    DestroyGroup(g)
end

function valueFactor(level, base, previousFactor, levelFactor, constant)

    local value = base

    if level > 1 then
        for i = 2, level do
            value = (value * previousFactor) + (i * levelFactor) + (constant)
            print(value)
        end
    end

    print(value)
    return value
end
