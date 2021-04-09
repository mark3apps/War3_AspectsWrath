function INIT_ai()

    -- Set up basic Variables
    ai = {}

    -- Set up Function Bases
    ai.town = {}
    ai.unit = {}
    ai.landmark = {}
    ai.route = {}
    ai.trig = {}
    ai.unitSTATE = {}

    ai.towns = {}
    ai.routes = {}
    ai.landmarks = {}
    ai.units = {}
    ai.unitGroup = CreateGroup()

    --------
    --  Add new things to the fold
    --------

    -- Adds a new town to the map.  (NEEDS to be extended with additional RECTs)
    function ai.town.new(name, hostileForce)

        -- Init the Town
        ai.towns[name] = {}
        ai.towns[name].name = name
        ai.towns[name].paused = false
        ai.towns[name].state = "auto"
        ai.towns[name].stateCurrent = "normal"
        ai.towns[name].states = {"auto", "normal", "danger", "pause", "abadon", "gather"}

        -- Set Up Unit Group
        ai.towns[name].units = CreateGroup()
        ai.towns[name].unitCount = 0

        -- Set up Landmarks
        ai.towns[name].residence = {}
        ai.towns[name].safehouse = {}
        ai.towns[name].barracks = {}
        ai.towns[name].patrol = {}
        ai.towns[name].gathering = {}

        -- Sets the Player group that the town will behave hostily towards
        ai.towns[name].hostileForce = hostileForce

        -- Set up the regions and rects to be extended
        ai.towns[name].region = CreateRegion()
        ai.towns[name].rects = {}

        return true
    end

    function ai.town.extend(name, rect)
        RegionAddRect(ai.towns[name].region, rect)

        return true
    end

    -- Add a new landmark
    function ai.landmark.new(town, name, rect, types, unit, radius, maxCapacity)
        unit = unit or nil
        radius = radius or 600
        maxCapacity = maxCapacity or 500

        local handleId = GetHandleId(rect)

        -- Add initial variables to the table
        ai.landmarks[name] = {}
        ai.landmarks[name] {
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
        for i = 1, #ai.landmarks[name].types do
            ai.towns[town][ai.landmarks[name].type[i]] = name
        end

    end

    -- Adds a unit that exists into the fold to be controlled by the AI. Defaults to Day shift.
    function ai.unit.new(town, type, unit, name, shift)

        shift = shift or "day"

        local handleId = GetHandleId(unit)

        -- Add to Unit groups
        GroupAddUnit(ai.towns[town].units, unit)
        GroupAddUnit(ai.unitGroup, unit)

        -- Update Unit Count
        ai.towns[town].unitCount = CountUnitsInGroup(ai.towns[town].units)
        ai.units.count = CountUnitsInGroup(ai.unitGroup)

        ai.units[handleId] = {}
        ai.units[handleId] = {
            id = handleId,
            unitType = GetUnitTypeId(unit),
            unitName = GetUnitName(unit),
            paused = false,
            town = town,
            name = name,
            shift = shift,
            state = "auto",
            type = type,
            route = nil,
            step = 1,
            routes = {},
            xHome = GetUnitX(unit),
            yHome = GetUnitY(unit),
            xDest = nil,
            yDest = nil
        }

        if type == "villager" then
            ai.units[handleId].states = {"relax", "move", "sleep"}
            ai.units[handleId].stateCurrent = "relax"

        end

        return true
    end

    --------
    --  TOWN ACTIONS
    --------

    function ai.town.state(town, state)

        if tableContains(ai.towns[town].states, state) then
            ai.towns[town].state = state
            ai.towns[town].stateCurrent = state

            ai.updateTown(town, state)

            return true
        end

        return false
    end

    function ai.town.hostileForce(town, force)

        ai.towns[town].force = force
        return true

    end

    function ai.town.vulnerableUnits(town, flag)

        ForGroup(ai.towns[town].units, function()
            local unit = GetEnumUnit()

            SetUnitInvulnerable(unit, flag)
        end)

        return true

    end

    function ai.town.unitsHurt(town, low, high, kill)

        ForGroup(ai.towns[town].units, function()
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

    function ai.town.unitsSetLife(town, low, high)

        ForGroup(ai.towns[town].units, function()
            local unit = GetEnumUnit()
            local percentLife = GetRandomInt(low, high)

            SetUnitLifePercentBJ(unit, percentLife)
        end)

        return true
    end

    --------
    --  ROUTE ACTIONS
    --------

    -- Adds a route that villagers can take when moving
    function ai.route.new(name, type)

        -- Set up the route Vars
        ai.route[name] = {}
        ai.route[name].name = name
        ai.route[name].type = type
        ai.route[name].step = {}
        ai.route[name].stepCount = 0

        return true
    end

    -- Adds at the end of the selected route, a new place for a unit to move to.
    function ai.route.step(route, rect, speed, walk)

        -- Set default values if one wasn't specified
        speed = speed or nil
        walk = walk or false

        -- Add Event to Rect Entering Trigger
        print("Adding")
        TriggerRegisterEnterRectSimple(ai.trig.unitEntersRegion, rect)
        print("Added")

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
            action = {}
        }

        return true

    end

    -- Adds an additional action to the picked route step
    function ai.route.action(route, time, lookAtRect, animation, loop)

        -- Set default values if one wasn't specified
        animation = animation or nil
        lookAtRect = lookAtRect or nil
        loop = loop or false

        -- Update the action Count for the Route
        local stepCount = ai.route.stepCount(route)
        local actionCount = ai.route.actionCount(route, stepCount) + 1

        -- Add the action to the Step in the Route
        ai.route[route].step[stepCount].actionCount = actionCount
        ai.route[route].step[stepCount].action[actionCount] =
            {
                type = "action",
                time = time,
                lookAtRect = lookAtRect,
                animation = animation
            }

        return true

    end

    function ai.route.trigger(route, trigger)
        -- Update the action Count for the Route
        local stepCount = ai.route.stepCount(route)
        local actionCount = ai.route.actionCount(route, stepCount) + 1

        -- Add the action to the Step in the Route
        ai.route[route].step[stepCount].actionCount = actionCount
        ai.route[route].step[stepCount].action[actionCount] =
            {
                type = "trigger",
                trigger = trigger
            }
    end

    function ai.route.funct(route, funct)
        -- Update the action Count for the Route
        local stepCount = ai.route.stepCount(route)
        local actionCount = ai.route.actionCount(route, stepCount) + 1

        -- Add the action to the Step in the Route
        ai.route[route].step[stepCount].actionCount = actionCount
        ai.route[route].step[stepCount].action[actionCount] =
            {
                type = "function",
                funct = funct
            }
    end

    function ai.route.stepCount(route)
        return ai.route[route].stepCount
    end

    function ai.route.actionCount(route, step)
        return ai.route[route].step[step].actionCount
    end

    --------
    --  UNIT ACTIONS
    --------

    function ai.unit.addRoute(unit, route)
        local handleId = GetHandleId(unit)

        if ai.route[route] ~= nil then
            table.insert(ai.units[handleId].routes, route)
            return true
        end

        return false

    end

    function ai.unit.removeRoute(unit, route)
        local handleId = GetHandleId(unit)
        local routes = ai.units[handleId].routes

        if tableContains(routes, route) then
            ai.units[handleId].routes = tableRemoveValue(routes, route)
            return true
        end

        return false
    end

    function ai.unit.kill(unit)
        local handleId = GetHandleId(unit)
        local data = ai.units[handleId]
        ai.units[handleId] = nil
        GroupRemoveUnit(ai.unitGroup, unit)
        GroupRemoveUnit(ai.towns[data.town].units, unit)

        KillUnit(unit)

        return true
    end

    function ai.unit.remove(unit)
        local handleId = GetHandleId(unit)
        local data = ai.units[handleId]
        ai.units[handleId] = nil
        GroupRemoveUnit(ai.unitGroup, unit)
        GroupRemoveUnit(ai.towns[data.town].units, unit)

        RemoveUnit(unit)

        return true
    end

    function ai.unit.pause(unit, flag)
        local handleId = GetHandleId(unit)

        PauseUnit(unit, flag)
        ai.units[handleId].paused = flag

        return true
    end

    function ai.unit.pickRoute(unit, route, stepNumber)
        local data = ai.units[GetHandleId(unit)]

        if #data.routes == 0 and route == nil then
            return false
        end

        route = route or data.routes[GetRandomInt(1, #data.routes)]
        stepNumber = stepNumber or 1

        local step = ai.route[route].step[stepNumber]

        ai.units[data.id].stateCurrent = "moving"
        ai.units[data.id].route = route
        ai.units[data.id].stepNumber = stepNumber
        ai.units[data.id].actionNumber = 1
        ai.units[data.id].xDest = step.x
        ai.units[data.id].yDest = step.y
        ai.units[data.id].speed = step.speed

        SetUnitMoveSpeed(unit, step.speed)
        IssuePointOrderById(unit, oid.move, step.x, step.y)

        return true

    end

    -- Set the Unit State
    function ai.unit.state(unit, state)
        local data = ai.units[GetHandleId(unit)]

        if tableContains(ai.units[data.id].states, state) then
            ai.units[data.id].state = state

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
    function ai.unitSTATE.move(unit)
        local data = ai.units[GetHandleId(unit)]

        if #data.routes == 0 and route == nil then
            return false
        end

        local route = data.routes[GetRandomInt(1, #data.routes)]

        ai.unit.pickRoute(unit)

        return true
    end

    --
    -- RETURN HOME
    function ai.unitSTATE.returnHome(unit)
        local data = ai.units[GetHandleId(unit)]

        ai.units[data.id].stateCurrent = "returningHome"
        ai.units[data.id].route = nil
        ai.units[data.id].stepNumber = nil
        ai.units[data.id].actionNumber = nil
        ai.units[data.id].xDest = nil
        ai.units[data.id].yDest = nil
        ai.units[data.id].speed = nil

        ai.units[data.id].stateCurrent = "moving"

        IssuePointOrderById(unit, oid.move, data.xHome, data.yHome)

        return true
    end

    --------
    --  UNIT STATES TRANSIENT
    --------

    --
    -- MOVING
    function ai.unitSTATE.moving(unit)
        local data = ai.units[GetHandleId(unit)]

        if GetUnitCurrentOrder(unit) ~= oid.move then
            IssuePointOrderById(unit, oid.move, data.xDest, data.yDest)
        end

        return true
    end

    --
    -- WAITING
    function ai.unitSTATE.waiting(unit)

        -- Do nothing, come on now, what did you think was going to be here??
        return true
    end

    --
    -- RETURNING HOME
    function ai.unitSTATE.returningHome(unit)
        local data = ai.units[GetHandleId(unit)]

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

    -- ai.TRIGunitLoop = CreateTrigger()
    -- TriggerRegisterTimerEventPeriodic(ai.TRIGunitLoop, 2)
    -- TriggerAddAction(ai.TRIGunitLoop, function()

    --     local u, data, handleId
    --     local g = CreateGroup()
    --     GroupAddGroup(ai.unitGroup, g)

    --     -- Loop through the Units and check to see if they need anything
    --     u = FirstOfGroup(g)
    --     while u ~= nil do
    --         handleId = GetHandleId(unit)
    --         data = ai.units[handleId]

    --         GroupRemoveUnit(g, u)
    --         u = FirstOfGroup(g)
    --     end
    --     DestroyGroup(g)

    -- end)

    -- Trigger Unit enters a Rect in a Route
    ai.trig.unitEntersRegion = CreateTrigger()
    TriggerAddAction(ai.trig.unitEntersRegionn, function()
        print("Triggered")

        local unit = GetEnteringUnit()

        debugfunc(function()

            -- If Unit is an AI Unit
            if IsUnitInGroup(unit, ai.unitGroup) then
                print("Here we Are")
                local handleId = GetHandleId(unit)
                local data = ai.units[handleId]

                PolledWaitPrecise(0.5)

                -- If the Rect isn't the targetted end rect, ignore any future actions
                if not RectContainsUnit(ai.route[data.route].step[data.step].rect, unit) then
                    print("NOT IN REGION")
                    return false
                end

                -- Set up Locals
                local tick = 0.1

                print("YAY!")
                local order = oid.move
                local i = 1
                while order == oid.move and i < 2 do
                    order = GetUnitCurrentOrder(unit)
                    PolledWaitPrecise(tick)
                    i = i + tick
                end

                -- If current State is moving
                if data.stateCurrent == "moving" then

                    -- Change State to "Waiting"
                    ai.units[data.id].stateCurrent = "waiting"
                    local action = ai.route[data.route].step[data.stepNumber].action[data.actionNumber]

                    if action.type == "action" then
                        if action.lookAtRect ~= nil then
                            local x = GetUnitX(unit)
                            local y = GetUnitY(unit)

                            -- Get the angle to the rect and find a point 10 units in that direction
                            local facingAngle = angleBetweenCoordinates(x, y, GetRectCenterX(action.lookAtRect),
                                                    GetRectCenterY(action.lookAtRect))
                            local xNew, yNew = polarProjectionCoordinates(x, y, 10, facingAngle)
                            IssuePointOrderById(unit, oid.move, xNew, yNew)

                            order = oid.move
                            i = 1
                            while order == oid.move and i < 2 do
                                order = GetUnitCurrentOrder(unit)
                                PolledWaitPrecise(tick)
                                i = i + tick
                            end
                        end

                        if action.animation ~= nil then
                            print(action.animation)
                            SetUnitAnimation(unit, action.animation)
                        end

                        PolledWaitPrecise(action.time)

                    elseif data.type == "trigger" then

                        -- Set Data that needs to get passed to trigger
                        udg_AI_TriggeringUnit = unit

                        print("Trying!")
                        -- Run the trigger (Checking Conditions)
                        ConditionalTriggerExecute(action.trigger)
                        print("working!")

                    end

                    local routeSteps = ai.route[data.route].stepCount

                    print(routeSteps .. ":" .. data.step)

                    if routeSteps == data.step then
                        ai.unit.state(unit, "returnHome")
                    else
                        ai.unit.pickRoute(unit, data.route, (data.step + 1))
                    end
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
    debugfunc(function()
        INIT_ai()
        print("AI INIT")
    end, "Init")
end
