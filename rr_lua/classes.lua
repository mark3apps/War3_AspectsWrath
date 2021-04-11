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
