udg_townVillageForce = nil
udg_TEMP_UnitGroup = nil
udg_AI_TriggeringUnit = nil
udg_AI_TriggeringRegion = nil
udg_AI_TriggeringRoute = ""
udg_AI_TriggeringStep = 0
udg_AI_TriggeringAction = 0
udg_AI_TriggeringState = ""
udg_AI_TriggeringId = 0
gg_rct_R01_01 = nil
gg_rct_R01_02 = nil
gg_rct_R01_03 = nil
gg_rct_R01_04 = nil
gg_rct_R01_01L = nil
gg_rct_R01_02L = nil
gg_rct_R01_03L = nil
gg_rct_R01_04L = nil
gg_trg_Testing = nil
gg_trg_Melee_Initialization = nil
gg_trg_Action_Test = nil
function InitGlobals()
    udg_townVillageForce = CreateForce()
    udg_TEMP_UnitGroup = CreateGroup()
    udg_AI_TriggeringRoute = ""
    udg_AI_TriggeringStep = 0
    udg_AI_TriggeringAction = 0
    udg_AI_TriggeringState = ""
    udg_AI_TriggeringId = 0
end

function INIT_Config()
    Debugfunc(function()
        -- Add Towns
        ai.town.New("Farms", udg_townVillageForce)

        -- Add Routes
        ai.route.New("Main", "inTown")

        ai.route.Step(gg_rct_R01_01, 100)
        ai.route.Trigger(gg_trg_Action_Test)
        ai.route.Action(10, gg_rct_R01_01L, "Attack 1")
        ai.route.Action(10, gg_rct_R01_02L, "Attack 1", true)

        ai.route.Step(gg_rct_R01_02)
        ai.route.Action(4, gg_rct_R01_02L, "Stand Victory 1", true)

        ai.route.Step(gg_rct_R01_03)
        ai.route.Action(3, gg_rct_R01_03L, "Stand Defend")

        ai.route.Step(gg_rct_R01_04, 100)
        ai.route.Action(5, gg_rct_R01_04L, "Stand Ready")

        ai.route.Finish(100)

        -- Create the Unit
        local g = CreateGroup()
        g = GetUnitsInRectAll(GetPlayableMapRect())

        local u = FirstOfGroup(g)
        while u ~= nil do

            ai.unit.New("Farms", "villager", u, "Peasant", "day")
            ai.unit.AddRoute(u, "Main")

            GroupRemoveUnit(g, u)
            u = FirstOfGroup(g)
        end
        DestroyGroup(g)
    end, "Testing")
    print("Working")

    -- Testing Trigger
    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 2)
    TriggerAddAction(t, function()

        -- THIS IS ALL YOU NEED TO MAKE A UNIT GO
        local g = CreateGroup()
        g = GetUnitsInRectAll(GetPlayableMapRect())

        local u = FirstOfGroup(g)
        while u ~= nil do

            Debugfunc(function()
                ai.unit.State(u, "Move")
            end, "Testing")

            PolledWait(GetRandomReal(4, 10))

            GroupRemoveUnit(g, u)
            u = FirstOfGroup(g)
        end
        DestroyGroup(g)
    end)

end


--------------
-- Village AI
-- Credit: Mark Wright (KickKing)
-- v0.1.0
--------------

-- Init the Class
function INIT_AI()

    -- Set up basic Variables
    ai = {}

    -- Set up Function Bases
    ai.town = {}
    ai.unit = {}
    ai.landmark = {}
    ai.route = {}
    ai.trig = {}
    ai.unitSTATE = {}
    ai.townSTATE = {}
    ai.landmarkSTATE = {}

    ai.unitGroup = CreateGroup()

    --------
    --  Add new things to the fold
    --------

    -- Add a new landmark
    function ai.landmark.New(town, name, rect, types, unit, radius, maxCapacity)
        unit = unit or nil
        radius = radius or 600
        maxCapacity = maxCapacity or 500

        local handleId = GetHandleId(rect)

        -- Add initial variables to the table
        ai.landmark[name] = {}
        ai.landmark[name] {
            id = handleId,
            alive = true,
            state = "normal",
            town = town,
            name = name,
            rect = rect,
            x = GetRectCenterX(rect),
            y = GetRectCenterY(rect),
            types = types,
            unit = unit,
            radius = radius,
            maxCapacity = maxCapacity
        }

        -- Add Landmark information to the town
        for i = 1, #ai.landmark[name].types do
            ai.town[town][ai.landmark[name].type[i]] = name
        end

    end

    --------
    --  TOWN ACTIONS
    --------

    -- Adds a new town to the map.  (NEEDS to be extended with additional RECTs)
    function ai.town.New(name, hostileForce)

        -- Init the Town
        ai.town[name] = {}
        ai.town[name].name = name
        ai.town[name].paused = false
        ai.town[name].state = "auto"
        ai.town[name].stateCurrent = "normal"
        ai.town[name].states = {"auto", "normal", "danger", "pause", "abadon", "gather"}

        -- Set Up Unit Group
        ai.town[name].units = CreateGroup()
        ai.town[name].unitCount = 0

        -- Set up Landmarks
        ai.town[name].residence = {}
        ai.town[name].safehouse = {}
        ai.town[name].barracks = {}
        ai.town[name].patrol = {}
        ai.town[name].gathering = {}

        -- Sets the Player group that the town will behave hostily towards
        ai.town[name].hostileForce = hostileForce

        -- Set up the regions and rects to be extended
        ai.town[name].region = CreateRegion()
        ai.town[name].rects = {}

        return true
    end

    function ai.town.Extend(name, rect)
        RegionAddRect(ai.town[name].region, rect)

        return true
    end

    function ai.town.State(town, state)

        if TableContains(ai.town[town].states, state) then
            ai.town[town].state = state
            ai.town[town].stateCurrent = state

            ai.townSTATE[state](town)

            return true
        end

        return false
    end

    function ai.town.HostileForce(town, force)

        ai.town[town].force = force
        return true

    end

    function ai.town.VulnerableUnits(town, flag)

        ForGroup(ai.town[town].units, function()
            local unit = GetEnumUnit()

            SetUnitInvulnerable(unit, flag)
        end)

        return true

    end

    function ai.town.UnitsHurt(town, low, high, kill)

        ForGroup(ai.town[town].units, function()
            local unit = GetEnumUnit()
            local percentLife = GetUnitLifePercent(unit)
            local randInt = GetRandomInt(low, high)

            percentLife = percentLife - randInt
            if not kill and percentLife <= 0 then
                percentLife = 1
            end

            SetUnitLifePercentBJ(unit, percentLife)
        end)

        return true
    end

    function ai.town.UnitsSetLife(town, low, high)

        ForGroup(ai.town[town].units, function()
            local unit = GetEnumUnit()
            local percentLife = GetRandomInt(low, high)

            SetUnitLifePercentBJ(unit, percentLife)
        end)

        return true
    end

    --------
    --  ROUTE ACTIONS
    --------

    -- Adds a route that villagers can take when Moving
    function ai.route.New(name, type)

        ai.routeSetup = name
        -- Set up the route Vars
        ai.route[name] = {}
        ai.route[name].name = name
        ai.route[name].type = type
        ai.route[name].step = {}
        ai.route[name].stepCount = 0
        ai.route[name].endSpeed = nil

        return true
    end

    -- Adds at the end of the selected route, a new place for a unit to move to.
    function ai.route.Step(rect, speed, order, animationTag)

        -- Set default values if one wasn't specified
        local route = ai.routeSetup
        speed = speed or nil
        order = order or oid.move

        -- Add Event to Rect Entering Trigger
        TriggerRegisterEnterRectSimple(ai.trig.UnitEntersRegion, rect)

        -- Update the count of steps in the route
        local stepCount = ai.route[route].stepCount + 1

        -- Add the step to the route
        ai.route[route].stepCount = stepCount

        ai.route[route].step[stepCount] = {
            rect = rect,
            speed = speed,
            x = GetRectCenterX(rect),
            y = GetRectCenterY(rect),
            actionCount = 0,
            order = order,
            action = {},
            animationTag = animationTag
        }

        return true

    end

    -- Adds an additional action to the picked route step
    function ai.route.Action(time, lookAtRect, animation, loop)

        -- Set default values if one wasn't specified
        local route = ai.routeSetup
        animation = animation or nil
        lookAtRect = lookAtRect or nil
        loop = loop or false

        -- Update the action Count for the Route
        local stepCount = ai.route.StepCount(route)
        local actionCount = ai.route.ActionCount(route, stepCount) + 1

        -- Add the action to the Step in the Route
        ai.route[route].step[stepCount].actionCount = actionCount
        ai.route[route].step[stepCount].action[actionCount] =
            {
                type = "action",
                time = time,
                lookAtRect = lookAtRect,
                animation = animation,
                loop = loop
            }

        return true

    end

    function ai.route.Trigger(trigger)
        -- Update the action Count for the Route
        local route = ai.routeSetup
        local stepCount = ai.route.StepCount(route)
        local actionCount = ai.route.ActionCount(route, stepCount) + 1

        -- Add the action to the Step in the Route
        ai.route[route].step[stepCount].actionCount = actionCount
        ai.route[route].step[stepCount].action[actionCount] =
            {
                type = "trigger",
                trigger = trigger
            }
    end

    function ai.route.Funct(funct)
        -- Update the action Count for the Route
        local route = ai.routeSetup
        local stepCount = ai.route.StepCount(route)
        local actionCount = ai.route.ActionCount(route, stepCount) + 1

        -- Add the action to the Step in the Route
        ai.route[route].step[stepCount].actionCount = actionCount
        ai.route[route].step[stepCount].action[actionCount] =
            {
                type = "function",
                funct = funct
            }

        return true
    end

    function ai.route.Finish(speed)
        speed = speed or nil

        ai.route[ai.routeSetup].endSpeed = nil

        return true
    end

    function ai.route.StepCount(route)
        return ai.route[route].stepCount
    end

    function ai.route.ActionCount(route, step)
        return ai.route[route].step[step].actionCount
    end

    --------
    --  UNIT ACTIONS
    --------

    -- Adds a unit that exists into the fold to be controlled by the AI. Defaults to Day shift.
    function ai.unit.New(town, type, unit, name, shift)

        shift = shift or "day"

        local handleId = GetHandleId(unit)

        -- Add to Unit groups
        GroupAddUnit(ai.town[town].units, unit)
        GroupAddUnit(ai.unitGroup, unit)

        -- Update Unit Count
        ai.town[town].unitCount = CountUnitsInGroup(ai.town[town].units)
        ai.unit.count = CountUnitsInGroup(ai.unitGroup)

        ai.unit[handleId] = {}
        ai.unit[handleId] = {
            id = handleId,
            unitType = GetUnitTypeId(unit),
            unitName = GetUnitName(unit),
            paused = false,
            town = town,
            name = name,
            shift = shift,
            state = "Auto",
            type = type,
            walking = false,
            speed = GetUnitMoveSpeed(unit),
            speedDefault = GetUnitMoveSpeed(unit),
            route = nil,
            stepNumber = 0,
            actionNumber = 0,
            routes = {},
            xHome = GetUnitX(unit),
            yHome = GetUnitY(unit),
            facingHome = GetUnitFacing(unit),
            xDest = nil,
            yDest = nil
        }

        if type == "villager" then
            ai.unit[handleId].states = {"Relax", "Move", "Sleep", "ReturnHome", "Moving", "ReturningHome", "Waiting"}
            ai.unit[handleId].stateCurrent = "Relax"

        end

        return true
    end

    function ai.unit.AddRoute(unit, route)
        local handleId = GetHandleId(unit)

        if ai.route[route] ~= nil then
            table.insert(ai.unit[handleId].routes, route)
            return true
        end

        return false

    end

    function ai.unit.RemoveRoute(unit, route)
        local handleId = GetHandleId(unit)
        local routes = ai.unit[handleId].routes

        if TableContains(routes, route) then
            ai.unit[handleId].routes = TableRemoveValue(routes, route)
            return true
        end

        return false
    end

    function ai.unit.Kill(unit)
        local handleId = GetHandleId(unit)
        local data = ai.unit[handleId]
        ai.unit[handleId] = nil
        GroupRemoveUnit(ai.unitGroup, unit)
        GroupRemoveUnit(ai.town[data.town].units, unit)

        KillUnit(unit)

        return true
    end

    function ai.unit.Remove(unit)
        local handleId = GetHandleId(unit)
        local data = ai.unit[handleId]
        ai.unit[handleId] = nil
        GroupRemoveUnit(ai.unitGroup, unit)
        GroupRemoveUnit(ai.town[data.town].units, unit)

        return true
    end

    function ai.unit.Pause(unit, flag)
        local handleId = GetHandleId(unit)

        PauseUnit(unit, flag)
        ai.unit[handleId].paused = flag

        return true
    end

    function ai.unit.PickRoute(unit, route, stepNumber, actionNumber)
        local data = ai.unit[GetHandleId(unit)]

        if #data.routes == 0 and route == nil then
            return false
        end

        route = route or data.routes[GetRandomInt(1, #data.routes)]
        stepNumber = stepNumber or 0
        actionNumber = actionNumber or 0

        ai.unit[data.id].route = route
        ai.unit[data.id].stepNumber = stepNumber
        ai.unit[data.id].actionNumber = actionNumber

        return true
    end

    -- Run next Step in a Units Current Route
    function ai.unit.NextStep(unit)
        local data = ai.unit[GetHandleId(unit)]

        local stepNumber = ai.unit[data.id].stepNumber + 1

        print(stepNumber .. " " .. ai.route[data.route].stepCount)

        -- If there are no more steps, return
        if stepNumber > ai.route[data.route].stepCount then
            return false
        end

        -- Set new Unit Step Info || Reset Action Number
        ai.unit[data.id].stateCurrent = "Moving"
        ai.unit[data.id].stepNumber = stepNumber
        ai.unit[data.id].actionNumber = 0

        local step = ai.route[data.route].step[stepNumber]
        local speed = step.speed or data.speedDefault

        -- Get new Destination for unit
        ai.unit[data.id].xDest = step.x
        ai.unit[data.id].yDest = step.y
        ai.unit[data.id].speed = speed

        if speed <= 100 then
            BlzSetUnitRealFieldBJ(unit, UNIT_RF_ANIMATION_WALK_SPEED, 120.00)
            AddUnitAnimationPropertiesBJ(true, "cinematic", unit)
            ai.unit[data.id].walk = true
        else
            BlzSetUnitRealFieldBJ(unit, UNIT_RF_ANIMATION_WALK_SPEED, 270.00)
            AddUnitAnimationPropertiesBJ(false, "cinematic", unit)
            ai.unit[data.id].walk = false
        end

        SetUnitMoveSpeed(unit, speed)
        IssuePointOrderById(unit, step.order, step.x, step.y)

        return true
    end

    function ai.unit.NextAction(unit)
        local data = ai.unit[GetHandleId(unit)]

        -- Get Default Variable
        local tick = 0.1

        local stepNumber = data.stepNumber
        local actionNumber = ai.unit[data.id].actionNumber + 1

        -- If there are no more actions, return
        if actionNumber > ai.route[data.route].step[stepNumber].actionCount then
            return false
        end

        ai.unit[data.id].actionNumber = actionNumber

        -- If current State is Moving
        if data.stateCurrent == "Moving" then

            -- Get Next Action
            local step = ai.route[data.route].step[stepNumber]
            local action = step.action[actionNumber]

            if action.type == "action" then

                -- Change State to "Waiting"
                ai.unit[data.id].stateCurrent = "Waiting"

                if action.lookAtRect ~= nil then
                    local x = GetUnitX(unit)
                    local y = GetUnitY(unit)

                    -- Get the angle to the rect and find a point 10 units in that direction
                    local facingAngle = AngleBetweenCoordinates(x, y, GetRectCenterX(action.lookAtRect),
                                            GetRectCenterY(action.lookAtRect))

                    -- Get Position 10 units away in the correct direction
                    local xNew, yNew = PolarProjectionCoordinates(x, y, 10, facingAngle)

                    -- Move unit to direction
                    IssuePointOrderById(unit, oid.move, xNew, yNew)

                    -- Wait for unit to stop Moving or 2 seconds
                    local order = oid.move
                    local i = 1
                    while order == oid.move and i < 2 do
                        order = GetUnitCurrentOrder(unit)
                        PolledWait(tick)
                        i = i + tick
                    end
                end

                if action.animation ~= nil then
                    SetUnitAnimation(unit, action.animation)

                    -- Loop Animation if checked
                    if action.loop then
                        for i = 1, math.floor(action.time) do
                            QueueUnitAnimation(unit, action.animation)
                        end
                    end

                end

                PolledWait(action.time)

                -- Change State to "Moving"
                SetUnitAnimation(unit, oid.stop)
                ai.unit[data.id].stateCurrent = "Moving"

            elseif action.type == "trigger" then

                -- Set Temp Global Data that needs to get passed to trigger
                udg_AI_TriggeringUnit = unit
                udg_AI_TriggeringId = data.id
                udg_AI_TriggeringState = data.stateCurrent
                udg_AI_TriggeringRegion = step.rect
                udg_AI_TriggeringRoute = data.route
                udg_AI_TriggeringStep = data.stepNumber
                udg_AI_TriggeringAction = data.actionNumber

                ai.unit[data.id].stateCurrent = "Waiting"

                -- Run the trigger (Ignoring Conditions)
                TriggerExecute(action.trigger)

                while ai.unit[data.id].stateCurrent == "Waiting" do
                    PolledWait(.5)
                end
            end
        end

        return true
    end

    -- Set the Unit State
    function ai.unit.State(unit, state)
        local data = ai.unit[GetHandleId(unit)]

        if TableContains(ai.unit[data.id].states, state) then
            ai.unit[data.id].state = state

            ai.unitSTATE[state](unit)

            return true
        end

        return false
    end

    --------
    --  UNIT STATES
    --------

    --
    -- MOVE
    function ai.unitSTATE.Move(unit)
        local data = ai.unit[GetHandleId(unit)]

        if #data.routes == 0 and route == nil then
            return false
        end

        local route = data.routes[GetRandomInt(1, #data.routes)]

        ai.unit.PickRoute(unit)
        ai.unit.NextStep(unit)

        return true
    end

    --
    -- RETURN HOME
    function ai.unitSTATE.ReturnHome(unit)
        local data = ai.unit[GetHandleId(unit)]

        ai.unit[data.id].stateCurrent = "ReturningHome"
        ai.unit[data.id].route = nil
        ai.unit[data.id].stepNumber = nil
        ai.unit[data.id].actionNumber = nil
        ai.unit[data.id].xDest = nil
        ai.unit[data.id].yDest = nil
        ai.unit[data.id].speed = nil

        print("x:" .. data.xHome .. " y:" .. data.yHome)
        IssuePointOrderById(unit, oid.move, data.xHome, data.yHome)

        return true
    end

    --------
    --  UNIT STATES TRANSIENT
    --------

    --
    -- Moving
    function ai.unitSTATE.Moving(unit)
        local data = ai.unit[GetHandleId(unit)]

        if GetUnitCurrentOrder(unit) ~= oid.move then
            IssuePointOrderById(unit, oid.move, data.xDest, data.yDest)
        end

        return true
    end

    --
    -- WAITING
    function ai.unitSTATE.Waiting(unit)

        -- Do nothing, come on now, what did you think was going to be here??
        return true
    end

    --
    -- RETURNING HOME
    function ai.unitSTATE.ReturningHome(unit)
        local data = ai.unit[GetHandleId(unit)]

        if GetUnitCurrentOrder(unit) ~= oid.move then

            IssuePointOrderById(unit, oid.move, data.xHome, data.yHome)
        end

        return true
    end

    --------
    --  TRIGGERS
    --------

    --------
    --  UNIT LOOPS
    --------

    -- ai.trig.UnitLoop = CreateTrigger()
    -- TriggerRegisterTimerEventPeriodic(ai.TRIGunitLoop, 2)
    -- TriggerAddAction(ai.TRIGunitLoop, function()

    --     local u, data, handleId
    --     local g = CreateGroup()
    --     GroupAddGroup(ai.unitGroup, g)

    --     -- Loop through the Units and check to see if they need anything
    --     u = FirstOfGroup(g)
    --     while u ~= nil do
    --         handleId = GetHandleId(unit)
    --         data = ai.unit[handleId]

    --         GroupRemoveUnit(g, u)
    --         u = FirstOfGroup(g)
    --     end
    --     DestroyGroup(g)

    -- end)

    -- Trigger Unit enters a Rect in a Route
    ai.trig.UnitEntersRegion = CreateTrigger()
    TriggerAddAction(ai.trig.UnitEntersRegion, function()

        local unit = GetEnteringUnit()

        Debugfunc(function()

            -- If Unit is an AI Unit
            if IsUnitInGroup(unit, ai.unitGroup) then

                -- Get Unit Data
                local data = ai.unit[GetHandleId(unit)]

                -- This helps to verify unit will show up as in the target rect
                PolledWait(0.5)

                -- If usit it on a route
                if data.route then

                    -- If the Rect isn't the targetted end rect, ignore any future actions
                    if not RectContainsUnit(ai.route[data.route].step[data.stepNumber].rect, unit) then
                        return false
                    end
                else
                    return false
                end

                -- Set Local Variables
                local success = true
                local tick = 0.1

                -- Wait until unit stops Moving or 2 seconds
                local order = oid.move
                local i = 1
                while order == oid.move and i < 2 do
                    order = GetUnitCurrentOrder(unit)
                    PolledWait(tick)
                    i = i + tick
                end

                -- Keep running actions unit finished with step
                while success do
                    success = ai.unit.NextAction(unit)
                end

                -- Run next Step
                success = ai.unit.NextStep(unit)

                -- If route is finished Send unit Home
                if not success then

                    local speed = ai.route[data.route].endSpeed or data.speedDefault

                    if speed < 100 then
                        BlzSetUnitRealFieldBJ(unit, UNIT_RF_ANIMATION_WALK_SPEED, 100.00)
                        AddUnitAnimationPropertiesBJ(true, "cinematic", unit)
                        ai.unit[data.id].walk = true
                    else
                        BlzSetUnitRealFieldBJ(unit, UNIT_RF_ANIMATION_WALK_SPEED, 270.00)
                        AddUnitAnimationPropertiesBJ(false, "cinematic", unit)
                        ai.unit[data.id].walk = false
                    end

                    SetUnitMoveSpeed(unit, speed)

                    ai.unit.State(unit, "ReturnHome")
                end

            end
        end, "Entering")
    end)

    --------
    --  INIT
    --------

    -- ai.INIT_triggers()
end

--------
--  Main -- This runs everything
--------
function INIT_LUA()
    Debugfunc(function()
        INIT_AI()
        INIT_Config()
    end, "Init")
end

--
-- Functions
--

-- **Credit** KickKing
-- Returns true if the value is found in the table
function TableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- **Credit** KickKing
-- Remove a value from a table
function TableRemoveValue(table, value)
    return table.remove(table, TableFind(table, value))
end

-- **Credit** KickKing
-- Find the indext of a value in a table
function TableFind(tab, el)
    for index, value in pairs(tab) do
        if value == el then
            return index
        end
    end
end

-- **Credit** KickKing
-- get distance without locations
function DistanceBetweenCoordinates(x1, y1, x2, y2)
    return SquareRoot(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)))
end

-- **Credit** KickKing
-- get distance without locations
function DistanceBetweenUnits(unitA, unitB)
    return distanceBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA), GetUnitX(unitB), GetUnitY(unitB))
end

-- **Credit** KickKing
-- get angle without locations
function AngleBetweenCoordinates(x1, y1, x2, y2)
    return bj_RADTODEG * Atan2(y2 - y1, x2 - x1)
end

-- **Credit** KickKing
-- get angle without locations
function AngleBetweenUnits(unitA, unitB)
    return angleBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA), GetUnitX(unitB), GetUnitY(unitB))
end

-- **Credit** KickKing
-- Polar projection with Locations
function PolarProjectionCoordinates(x, y, dist, angle)
    local newX = x + dist * Cos(angle * bj_DEGTORAD)
    local newY = y + dist * Sin(angle * bj_DEGTORAD)
    return newX, newY
end

-- ** Credit** Planetary
-- Wraps your code in a "Try" loop so you can see errors printed in the log at runtime
function Debugfunc(func, name) -- Turn on runtime logging
    local passed, data = pcall(function()
        func()
        return "func " .. name .. " passed"
    end)
    if not passed then
        print("|cffff0000[ERROR]|r" .. name, passed, data)
    end
end

-- **CREDIT** Taysen
-- Converts integer formated types into the 4 digit strings (Opposite of FourCC())
function CC2Four(num) -- Convert from Handle ID to Four Char
    return string.pack(">I4", num)
end

-- **CREDIT** Bribe
-- Timer Utils
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

-- **Credit** KickKing
-- A system that allow you to duplicate the functionality of auto-filling in the Object Editor
function ValueFactor(level, base, previousFactor, levelFactor, constant)

    local value = base

    if level > 1 then
        for i = 2, level do
            value = (value * previousFactor) + (i * levelFactor) + (constant)
        end
    end

    return value
end


-- **Credit** Nestharus (Converted to Lua and turned into object by KickKing)
do
    oid = {
        OFFSET = 851970,
        absorb = 852529,
        acidbomb = 852662,
        acolyteharvest = 852185,
        AImove = 851988,
        ambush = 852131,
        ancestralspirit = 852490,
        ancestralspirittarget = 852491,
        animatedead = 852217,
        antimagicshell = 852186,
        attack = 851983,
        attackground = 851984,
        attackonce = 851985,
        attributemodskill = 852576,
        auraunholy = 852215,
        auravampiric = 852216,
        autodispel = 852132,
        autodispeloff = 852134,
        autodispelon = 852133,
        autoentangle = 852505,
        autoentangleinstant = 852506,
        autoharvestgold = 852021,
        autoharvestlumber = 852022,
        avatar = 852086,
        avengerform = 852531,
        awaken = 852466,
        banish = 852486,
        barkskin = 852135,
        barkskinoff = 852137,
        barkskinon = 852136,
        battleroar = 852099,
        battlestations = 852099,
        bearform = 852138,
        berserk = 852100,
        blackarrow = 852577,
        blackarrowoff = 852579,
        blackarrowon = 852578,
        blight = 852187,
        blink = 852525,
        blizzard = 852089,
        bloodlust = 852101,
        bloodlustoff = 852103,
        bloodluston = 852102,
        board = 852043,
        breathoffire = 852580,
        breathoffrost = 852560,
        build = 851994,
        burrow = 852533,
        cannibalize = 852188,
        carrionscarabs = 852551,
        carrionscarabsinstant = 852554,
        carrionscarabsoff = 852553,
        carrionscarabson = 852552,
        carrionswarm = 852218,
        chainlightning = 852119,
        channel = 852600,
        charm = 852581,
        chemicalrage = 852663,
        cloudoffog = 852473,
        clusterrockets = 852652,
        coldarrows = 852244,
        coldarrowstarg = 852243,
        controlmagic = 852474,
        corporealform = 852493,
        corrosivebreath = 852140,
        coupleinstant = 852508,
        coupletarget = 852507,
        creepanimatedead = 852246,
        creepdevour = 852247,
        creepheal = 852248,
        creephealoff = 852250,
        creephealon = 852249,
        creepthunderbolt = 852252,
        creepthunderclap = 852253,
        cripple = 852189,
        curse = 852190,
        curseoff = 852192,
        curseon = 852191,
        cyclone = 852144,
        darkconversion = 852228,
        darkportal = 852229,
        darkritual = 852219,
        darksummoning = 852220,
        deathanddecay = 852221,
        deathcoil = 852222,
        deathpact = 852223,
        decouple = 852509,
        defend = 852055,
        detectaoe = 852015,
        detonate = 852145,
        devour = 852104,
        devourmagic = 852536,
        disassociate = 852240,
        disenchant = 852495,
        dismount = 852470,
        dispel = 852057,
        divineshield = 852090,
        doom = 852583,
        drain = 852487,
        dreadlordinferno = 852224,
        dropitem = 852001,
        drunkenhaze = 852585,
        earthquake = 852121,
        eattree = 852146,
        elementalfury = 852586,
        ensnare = 852106,
        ensnareoff = 852108,
        ensnareon = 852107,
        entangle = 852147,
        entangleinstant = 852148,
        entanglingroots = 852171,
        etherealform = 852496,
        evileye = 852105,
        faeriefire = 852149,
        faeriefireoff = 852151,
        faeriefireon = 852150,
        fanofknives = 852526,
        farsight = 852122,
        fingerofdeath = 852230,
        firebolt = 852231,
        flamestrike = 852488,
        flamingarrows = 852174,
        flamingarrowstarg = 852173,
        flamingattack = 852540,
        flamingattacktarg = 852539,
        flare = 852060,
        forceboard = 852044,
        forceofnature = 852176,
        forkedlightning = 852586,
        freezingbreath = 852195,
        frenzy = 852561,
        frenzyoff = 852563,
        frenzyon = 852562,
        frostarmor = 852225,
        frostarmoroff = 852459,
        frostarmoron = 852458,
        frostnova = 852226,
        getitem = 851981,
        gold2lumber = 852233,
        grabtree = 852511,
        harvest = 852018,
        heal = 852063,
        healingspray = 852664,
        healingward = 852109,
        healingwave = 852501,
        healoff = 852065,
        healon = 852064,
        hex = 852502,
        holdposition = 851993,
        holybolt = 852092,
        howlofterror = 852588,
        humanbuild = 851995,
        immolation = 852177,
        impale = 852555,
        incineratearrow = 852670,
        incineratearrowoff = 852672,
        incineratearrowon = 852671,
        inferno = 852232,
        innerfire = 852066,
        innerfireoff = 852068,
        innerfireon = 852067,
        instant = 852200,
        invisibility = 852069,
        itemillusion = 852274,
        lavamonster = 852667,
        lightningshield = 852110,
        load = 852046,
        loadarcher = 852142,
        loadcorpse = 852050,
        loadcorpseinstant = 852053,
        locustswarm = 852556,
        lumber2gold = 852234,
        magicdefense = 852478,
        magicleash = 852480,
        magicundefense = 852479,
        manaburn = 852179,
        manaflareoff = 852513,
        manaflareon = 852512,
        manashieldoff = 852590,
        manashieldon = 852589,
        massteleport = 852093,
        mechanicalcritter = 852564,
        metamorphosis = 852180,
        militia = 852072,
        militiaconvert = 852071,
        militiaoff = 852073,
        militiaunconvert = 852651,
        mindrot = 852565,
        mirrorimage = 852123,
        monsoon = 852591,
        mount = 852469,
        mounthippogryph = 852143,
        move = 851986,
        nagabuild = 852467,
        neutraldetectaoe = 852023,
        neutralinteract = 852566,
        neutralspell = 852630,
        nightelfbuild = 851997,
        orcbuild = 851996,
        parasite = 852601,
        parasiteoff = 852603,
        parasiteon = 852602,
        patrol = 851990,
        phaseshift = 852514,
        phaseshiftinstant = 852517,
        phaseshiftoff = 852516,
        phaseshifton = 852515,
        phoenixfire = 852481,
        phoenixmorph = 852482,
        poisonarrows = 852255,
        poisonarrowstarg = 852254,
        polymorph = 852074,
        possession = 852196,
        preservation = 852568,
        purge = 852111,
        rainofchaos = 852237,
        rainoffire = 852238,
        raisedead = 852197,
        raisedeadoff = 852199,
        raisedeadon = 852198,
        ravenform = 852155,
        recharge = 852157,
        rechargeoff = 852159,
        rechargeon = 852158,
        rejuvination = 852160,
        renew = 852161,
        renewoff = 852163,
        renewon = 852162,
        repair = 852024,
        repairoff = 852026,
        repairon = 852025,
        replenish = 852542,
        replenishlife = 852545,
        replenishlifeoff = 852547,
        replenishlifeon = 852546,
        replenishmana = 852548,
        replenishmanaoff = 852550,
        replenishmanaon = 852549,
        replenishoff = 852544,
        replenishon = 852543,
        request_hero = 852239,
        requestsacrifice = 852201,
        restoration = 852202,
        restorationoff = 852204,
        restorationon = 852203,
        resumebuild = 851999,
        resumeharvesting = 852017,
        resurrection = 852094,
        returnresources = 852020,
        revenge = 852241,
        revive = 852039,
        reveal = 852270,
        roar = 852164,
        robogoblin = 852656,
        root = 852165,
        sacrifice = 852205,
        sanctuary = 852569,
        scout = 852181,
        selfdestruct = 852040,
        selfdestructoff = 852042,
        selfdestructon = 852041,
        sentinel = 852182,
        setrally = 851980,
        shadowsight = 852570,
        shadowstrike = 852527,
        shockwave = 852125,
        silence = 852592,
        sleep = 852227,
        slow = 852075,
        slowoff = 852077,
        slowon = 852076,
        smart = 851971,
        soulburn = 852668,
        soulpreservation = 852242,
        spellshield = 852571,
        spellshieldaoe = 852572,
        spellsteal = 852483,
        spellstealoff = 852485,
        spellstealon = 852484,
        spies = 852235,
        spiritlink = 852499,
        spiritofvengeance = 852528,
        spirittroll = 852573,
        spiritwolf = 852126,
        stampede = 852593,
        standdown = 852113,
        starfall = 852183,
        stasistrap = 852114,
        steal = 852574,
        stomp = 852127,
        stoneform = 852206,
        stop = 851972,
        submerge = 852604,
        summonfactory = 852658,
        summongrizzly = 852594,
        summonphoenix = 852489,
        summonquillbeast = 852595,
        summonwareagle = 852596,
        tankdroppilot = 852079,
        tankloadpilot = 852080,
        tankpilot = 852081,
        taunt = 852520,
        thunderbolt = 852095,
        thunderclap = 852096,
        tornado = 852597,
        townbelloff = 852083,
        townbellon = 852082,
        tranquility = 852184,
        transmute = 852665,
        unavatar = 852087,
        unavengerform = 852532,
        unbearform = 852139,
        unburrow = 852534,
        uncoldarrows = 852245,
        uncorporealform = 852494,
        undeadbuild = 851998,
        undefend = 852056,
        undivineshield = 852091,
        unetherealform = 852497,
        unflamingarrows = 852175,
        unflamingattack = 852541,
        unholyfrenzy = 852209,
        unimmolation = 852178,
        unload = 852047,
        unloadall = 852048,
        unloadallcorpses = 852054,
        unloadallinstant = 852049,
        unpoisonarrows = 852256,
        unravenform = 852156,
        unrobogoblin = 852657,
        unroot = 852166,
        unstableconcoction = 852500,
        unstoneform = 852207,
        unsubmerge = 852605,
        unsummon = 852210,
        unwindwalk = 852130,
        vengeance = 852521,
        vengeanceinstant = 852524,
        vengeanceoff = 852523,
        vengeanceon = 852522,
        volcano = 852669,
        voodoo = 852503,
        ward = 852504,
        waterelemental = 852097,
        wateryminion = 852598,
        web = 852211,
        weboff = 852213,
        webon = 852212,
        whirlwind = 852128,
        windwalk = 852129,
        wispharvest = 852214,
        scrollofspeed = 852285,
        cancel = 851976,
        moveslot1 = 852002,
        moveslot2 = 852003,
        moveslot3 = 852004,
        moveslot4 = 852005,
        moveslot5 = 852006,
        moveslot6 = 852007,
        useslot1 = 852008,
        useslot2 = 852009,
        useslot3 = 852010,
        useslot4 = 852011,
        useslot5 = 852012,
        useslot6 = 852013,
        skillmenu = 852000,
        stunned = 851973,
        instant1 = 851991,
        instant2 = 851987,
        instant3 = 851975,
        instant4 = 852019
    }
end

function CreateUnitsForPlayer0()
    local p = Player(0)
    local u
    local unitID
    local t
    local life
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 341.0, -161.7, 261.603, FourCC("hfoo"))
end

function CreateNeutralPassive()
    local p = Player(PLAYER_NEUTRAL_PASSIVE)
    local u
    local unitID
    local t
    local life
    u = BlzCreateUnitWithSkin(p, FourCC("nvk2"), -56.8, 135.6, 109.834, FourCC("nvk2"))
    u = BlzCreateUnitWithSkin(p, FourCC("nvlw"), -481.7, -658.2, 196.046, FourCC("nvlw"))
    u = BlzCreateUnitWithSkin(p, FourCC("nvl2"), -362.7, 506.7, 62.646, FourCC("nvl2"))
    u = BlzCreateUnitWithSkin(p, FourCC("nvlk"), -296.2, -170.4, 72.699, FourCC("nvlk"))
    u = BlzCreateUnitWithSkin(p, FourCC("nvil"), 3.6, 579.1, 188.180, FourCC("nvil"))
end

function CreatePlayerBuildings()
end

function CreatePlayerUnits()
    CreateUnitsForPlayer0()
end

function CreateAllUnits()
    CreatePlayerBuildings()
    CreateNeutralPassive()
    CreatePlayerUnits()
end

function CreateRegions()
    local we
    gg_rct_R01_01 = Rect(1024.0, -480.0, 1568.0, 64.0)
    gg_rct_R01_02 = Rect(224.0, 544.0, 928.0, 1216.0)
    gg_rct_R01_03 = Rect(-960.0, 160.0, -384.0, 832.0)
    gg_rct_R01_04 = Rect(-1216.0, -2048.0, -384.0, -1152.0)
    gg_rct_R01_01L = Rect(576.0, -608.0, 704.0, -480.0)
    gg_rct_R01_02L = Rect(576.0, 160.0, 704.0, 288.0)
    gg_rct_R01_03L = Rect(-1472.0, 96.0, -1344.0, 224.0)
    gg_rct_R01_04L = Rect(-192.0, -416.0, -64.0, -288.0)
end

function Trig_Testing_Actions()
    SetUnitAnimation(GetEnumUnit(), "stand")
    TriggerSleepAction(2)
    TriggerExecute(gg_trg_Action_Test)
    BlzSetUnitRealFieldBJ(BlzGetEventDamageTarget(), UNIT_RF_ANIMATION_WALK_SPEED, 100.00)
    AddUnitAnimationPropertiesBJ(true, "cinematic", GetFilterUnit())
    AddUnitAnimationPropertiesBJ(false, "cinematic", GetFilterUnit())
    AddUnitAnimationPropertiesBJ(false, "cinematic", GetFilterUnit())
end

function InitTrig_Testing()
    gg_trg_Testing = CreateTrigger()
    DisableTrigger(gg_trg_Testing)
    TriggerRegisterEnterRectSimple(gg_trg_Testing, gg_rct_R01_01)
    TriggerAddAction(gg_trg_Testing, Trig_Testing_Actions)
end

function Trig_Melee_Initialization_Actions()
    MeleeStartingVisibility()
        INIT_LUA()
end

function InitTrig_Melee_Initialization()
    gg_trg_Melee_Initialization = CreateTrigger()
    TriggerAddAction(gg_trg_Melee_Initialization, Trig_Melee_Initialization_Actions)
end

function Trig_Action_Test_Actions()
        local id, state = udg_AI_TriggeringId, udg_AI_TriggeringState
    DisplayTextToForce(GetPlayersAll(), GetUnitName(udg_AI_TriggeringUnit))
    SetUnitLifePercentBJ(udg_AI_TriggeringUnit, 50.00)
    TriggerSleepAction(2)
    DisplayTextToForce(GetPlayersAll(), "TRIGSTR_007")
        ai.units[id].stateCurrent = state
end

function InitTrig_Action_Test()
    gg_trg_Action_Test = CreateTrigger()
    TriggerAddAction(gg_trg_Action_Test, Trig_Action_Test_Actions)
end

function InitCustomTriggers()
    InitTrig_Testing()
    InitTrig_Melee_Initialization()
    InitTrig_Action_Test()
end

function RunInitializationTriggers()
    ConditionalTriggerExecute(gg_trg_Melee_Initialization)
end

function InitCustomPlayerSlots()
    SetPlayerStartLocation(Player(0), 0)
    SetPlayerColor(Player(0), ConvertPlayerColor(0))
    SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    SetPlayerRaceSelectable(Player(0), true)
    SetPlayerController(Player(0), MAP_CONTROL_USER)
end

function InitCustomTeams()
    SetPlayerTeam(Player(0), 0)
end

function main()
    SetCameraBounds(-3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    NewSoundEnvironment("Default")
    SetAmbientDaySound("LordaeronSummerDay")
    SetAmbientNightSound("LordaeronSummerNight")
    SetMapMusic("Music", true, 0)
    CreateRegions()
    CreateAllUnits()
    InitBlizzard()
    InitGlobals()
    InitCustomTriggers()
    RunInitializationTriggers()
end

function config()
    SetMapName("TRIGSTR_001")
    SetMapDescription("TRIGSTR_003")
    SetPlayers(1)
    SetTeams(1)
    SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)
    DefineStartLocation(0, 1024.0, -192.0)
    InitCustomPlayerSlots()
    SetPlayerSlotAvailable(Player(0), MAP_CONTROL_USER)
    InitGenericPlayerSlots()
end

