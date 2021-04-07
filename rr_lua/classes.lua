function INIT_ai()

    -- Set up basic Variables
    ai = {}
    ai.towns = {}
    ai.routes = {}
    ai.landmarks = {}
    ai.units = {}
    ai.unitGroup = CreateGroup()

    --------
    --  Add new things to the fold
    --------

    -- Adds a new town to the map.  (NEEDS to be extended with additional RECTs)
    function ai.addTown(name, hostileForce)

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

    function ai.extendTown(name, rect)
        RegionAddRect(ai.towns[name].region, rect)

        return true
    end

    -- Add a new landmark
    function ai.addLandmark(town, name, rect, types, unit, radius, maxCapacity)
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

    -- Adds a route that villagers can take when moving
    function ai.addRoute(name, type)

        -- Set up the route Vars
        ai.routes[name] = {}
        ai.routes[name].name = name
        ai.routes[name].type = type
        ai.routes[name].steps = {}
        ai.routes[name].stepCount = 0

        return true
    end

    -- Adds a unit that exists into the fold to be controlled by the AI. Defaults to Day shift.
    function ai.addUnit(town, type, unit, name, shift)

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

    function ai.townState(town, state)

        if tableContains(ai.towns[town].states, state) then
            ai.towns[town].state = state
            ai.towns[town].stateCurrent = state

            ai.updateTown(town, state)

            return true
        end

        return false
    end

    function ai.townHostileForce(town, force)

        ai.towns[town].force = force
        return true

    end

    function ai.townVulnerableUnits(town, flag)

        ForGroup(ai.towns[town].units, function()
            local unit = GetEnumUnit()

            SetUnitInvulnerable(unit, flag)
        end)

        return true

    end

    function ai.townUnitsHurt(town, low, high, kill)

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

    function ai.townUnitsSetLife(town, low, high)

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

    -- Adds at the end of the selected route, a new place for a unit to move to.
    function ai.routeAddStep(route, rect, time, lookAtRect, animation, speed)

        -- Set default values if one wasn't specified
        speed = speed or nil
        animation = animation or "stand 1"
        lookAtRect = lookAtRect or nil
        time = time or 0

        -- Add Event to Rect Entering Trigger
        TriggerRegisterEnterRectSimple(ai.unitEntersRegion, rect)

        -- Update the count of steps in the route
        local stepCount = ai.routes[route].stepCount + 1

        -- Add the step to the route
        ai.routes[route].stepCount = stepCount
        ai.routes[route].steps[stepCount] = {
            optionCount = 1,
            options = {}
        }

        ai.routes[route].steps[stepCount].optionCount = 1
        ai.routes[route].steps[stepCount].options[1] = {
            rect = rect,
            x = GetRectCenterX(rect),
            y = GetRectCenterY(rect),
            time = time,
            speed = speed,
            lookAtRect = lookAtRect,
            animation = animation
        }

        return true

    end

    -- Adds an additional option to the picked route step
    function ai.routeAddAction(route, step, rect, time, lookAtRect, animation, speed)

        -- Set default values if one wasn't specified
        speed = speed or nil
        animation = animation or "stand 1"
        lookAtRect = lookAtRect or nil
        time = time or 0

        -- Update the Option Count for the Route
        local stepCount = ai.routes[name].stepCount
        local optionCount = ai.routes[name].steps[stepCount].optionCount + 1

        -- Add the Option to the Step in the Route
        ai.routes[name].steps[stepCount].optionCount = optionCount
        ai.routes[name].steps[stepCount].options[optionCount] =
            {
                rect = rect,
                x = GetRectCenterX(rect),
                y = GetRectCenterY(rect),
                time = time,
                speed = speed,
                lookAtRect = lookAtRect,
                animation = animation
            }

        return true

    end

    function ai.routeGetStepCount(route)
        return ai.routes[route].stepCount
    end

    function ai.routeGetOptionCount(route, step)
        return ai.routes[route].steps[step].optionCount
    end

    --------
    --  UNIT ACTIONS
    --------

    function ai.unitAddRoute(unit, route)
        local handleId = GetHandleId(unit)

        if ai.routes[route] ~= nil then
            table.insert(ai.units[handleId].routes, route)
            return true
        end

        return false

    end

    function ai.unitRemoveRoute(unit, route)
        local handleId = GetHandleId(unit)
        local routes = ai.units[handleId].routes

        if tableContains(routes, route) then
            ai.units[handleId].routes = tableRemoveValue(routes, route)
            return true
        end

        return false
    end

    function ai.unitKill(unit)
        local handleId = GetHandleId(unit)
        local data = ai.units[handleId]
        ai.units[handleId] = nil
        GroupRemoveUnit(ai.unitGroup, unit)
        GroupRemoveUnit(ai.towns[data.town].units, unit)

        KillUnit(unit)

        return true
    end

    function ai.unitRemove(unit)
        local handleId = GetHandleId(unit)
        local data = ai.units[handleId]
        ai.units[handleId] = nil
        GroupRemoveUnit(ai.unitGroup, unit)
        GroupRemoveUnit(ai.towns[data.town].units, unit)

        RemoveUnit(unit)

        return true
    end

    function ai.unitPause(unit, flag)
        local handleId = GetHandleId(unit)

        PauseUnit(unit, flag)
        ai.units[handleId].paused = flag

        return true
    end

    function ai.unitPickRoute(unit, route, step)
        local data = ai.units[GetHandleId(unit)]

        if #data.routes == 0 and route == nil then
            return false
        end

        route = route or data.routes[GetRandomInt(1, #data.routes)]
        step = step or 1

        local optionNumber = GetRandomInt(1, ai.routes[route].steps[step].optionCount)
        local option = ai.routes[route].steps[step].options[optionNumber]

        ai.units[data.id].stateCurrent = "moving"
        ai.units[data.id].route = route
        ai.units[data.id].step = step
        ai.units[data.id].option = optionNumber
        ai.units[data.id].xDest = option.x
        ai.units[data.id].yDest = option.y
        ai.units[data.id].optionSpeed = option.speed
        ai.units[data.id].optionTime = option.time
        ai.units[data.id].optionLookAtRect = option.lookAtRect
        ai.units[data.id].optionAnimation = option.animation

        SetUnitMoveSpeed(unit, option.speed)
        IssuePointOrderById(unit, oid.move, option.x, option.y)

        return true

    end

    -- Set the Unit State
    function ai.unitSetState(unit, state)
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

    ai.unitSTATE = {}

    --
    -- MOVE
    function ai.unitSTATE.move(unit)
        local data = ai.units[GetHandleId(unit)]

        if #data.routes == 0 and route == nil then
            return false
        end

        local route = data.routes[GetRandomInt(1, #data.routes)]

        ai.unitPickRoute(unit)

        return true
    end

    --
    -- RETURN HOME
    function ai.unitSTATE.returnHome(unit)
        local data = ai.units[GetHandleId(unit)]

        ai.units[data.id].stateCurrent = "returningHome"
        ai.units[data.id].route = nil
        ai.units[data.id].step = 0
        ai.units[data.id].option = 0
        ai.units[data.id].xDest = nil
        ai.units[data.id].yDest = nil
        ai.units[data.id].optionSpeed = nil
        ai.units[data.id].optionTime = nil
        ai.units[data.id].optionLookAtRect = nil
        ai.units[data.id].optionAnimation = nil

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
        local data = ai.units[GetHandleId(unit)]

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
        local data = ai.units[GetHandleId(unit)]

        return true
    end

    --------
    --  TRIGGERS
    --------

    function ai.INIT_triggers()

        --------
        --  UNIT LOOPS
        --------

        local t = CreateTrigger()
        TriggerRegisterTimerEventPeriodic(t, 2)
        TriggerAddAction(t, function()

            local u, data, handleId
            local g = CreateGroup()
            GroupAddGroup(ai.unitGroup, g)

            -- Loop through the Units and check to see if they need anything
            u = FirstOfGroup(g)
            while u ~= nil do
                handleId = GetHandleId(unit)
                data = ai.units[handleId]

                GroupRemoveUnit(g, u)
                u = FirstOfGroup(g)
            end
            DestroyGroup(g)

        end)

        -- Trigger Unit enters a Rect in a Route
        ai.unitEntersRegion = CreateTrigger()
        TriggerAddAction(ai.unitEntersRegion, function()
            local unit = GetEnteringUnit()

            debugfunc(function()
                print("Entering")

                if IsUnitInGroup(unit, ai.unitGroup) then

                    local handleId = GetHandleId(unit)
                    local data = ai.units[handleId]

                    PolledWait(0.5)

                    -- If the Rect isn't the targetted end rect, ignore any future actions
                    if not RectContainsUnit(ai.routes[data.route].steps[data.step].options[data.option].rect, unit) then
                        print("DOESN'T CONTAIN")
                        return false
                    end

                    local order = oid.move
                    local i = 1
                    local tick = 0.1
                    while order == oid.move and i < 2 do
                        order = GetUnitCurrentOrder(unit)
                        PolledWait(tick)
                        i = i + tick
                    end

                    
                    -- If current State is moving
                    if data.stateCurrent == "moving" then

                        ai.units[data.id].stateCurrent = "waiting"

                        if data.optionLookAtRect ~= nil then
                            local x = GetUnitX(unit)
                            local y = GetUnitY(unit)

                            -- Get the angle to the rect and find a point 10 units in that direction
                            local facingAngle = angleBetweenCoordinates(x, y, GetRectCenterX(data.optionLookAtRect),
                                                    GetRectCenterY(data.optionLookAtRect))
                            local xNew, yNew = polarProjectionCoordinates(x, y, 10, facingAngle)
                            IssuePointOrderById(unit, oid.move, xNew, yNew)

                            order = oid.move
                            i = 1
                            while order == oid.move and i < 2 do
                                order = GetUnitCurrentOrder(unit)
                                PolledWait(tick)
                                i = i + tick
                            end
                        end

                        if data.optionAnimation ~= nil then
                            print(data.optionAnimation)
                            SetUnitAnimation(unit, data.optionAnimation)
                        end

                        PolledWait(data.optionTime)

                        local routeSteps = ai.routes[data.route].stepCount

                        print(routeSteps .. ":" .. data.step)

                        if routeSteps == data.step then
                            ai.unitSetState(unit, "returnHome")
                        else
                            ai.unitPickRoute(unit, data.route, (data.step + 1))
                        end
                    end
                end
            end, "Entering")
        end)

    end

    --------
    --  INIT
    --------

    function ai.init()
        ai.INIT_triggers()

    end

    ai.init()
end

--------
--  Main -- This runs everything
--------
do
    debugfunc(function()
        INIT_ai()
        print("AI INIT")
    end, "Init")
end
