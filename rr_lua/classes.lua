function INIT_ai()

    -- Set up basic Variables
    ai = {}
    ai.towns = {}
    ai.routes = {}
    ai.landmarks = {}
    ai.units = {}
    ai.units.g = CreateGroup()

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
        ai.landmarks[name].id = handleId
        ai.landmarks[name].alive = true
        ai.landmarks[name].state = "normal"
        ai.landmarks[name].town = town
        ai.landmarks[name].name = name
        ai.landmarks[name].rect = rect
        ai.landmarks[name].types = types
        ai.landmarks[name].unit = unit
        ai.landmarks[name].radius = radius
        ai.landmarks[name].maxCapacity = maxCapacity

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

        -- Add to Town Unit groups
        GroupAddUnit(ai.towns[name].units, unit)
        GroupAddUnit(ai.units.g, unit)

        -- Update Unit Count
        ai.towns[name].unitCount = CountUnitsInGroup(ai.towns[name].units)
        ai.units.count = CountUnitsInGroup(ai.units.g)

        ai.units[handleId] = {}
        ai.units[handleId] = {
            unitType = GetUnitTypeId(unit),
            unitName = GetUnitName(unit),
            town = town,
            name = name,
            shift = shift,
            state = "auto",
            type = type,
            routes = {},
            x = GetUnitX(unit),
            y = GetUnitY(unit)
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

        ForGroup(ai.towns[town].gUnits, function()
            local unit = GetEnumUnit()

            SetUnitInvulnerable(unit, flag)
        end)

        return true

    end

    function ai.townUnitsHurt(town, low, high, kill)

        ForGroup(ai.towns[town].gUnits, function()
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

        ForGroup(ai.towns[town].gUnits, function()
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
    function ai.routeAddStep(rect, time, lookAtRect, animation, speed)

        -- Set default values if one wasn't specified
        speed = speed or nil
        animation = animation or "stand 1"
        lookAtRect = lookAtRect or nil
        time = time or 0

        -- Update the count of steps in the route
        local stepCount = ai.routes[name].stepCount + 1

        -- Add the step to the route
        ai.routes[name].stepCount = stepCount
        ai.routes[name].steps[stepCount] = {
            optionCount = 1,
            options = {}
        }

        ai.routes[name].steps[stepCount].options[1] = {
            rect = rect,
            time = time,
            speed = speed,
            lookAtRect = lookAtRect,
            animation = animation
        }

        return true

    end

    -- Adds an additional option to the picked route step
    function ai.routeAddOption(route, step, rect, time, lookAtRect, animation, speed)

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

    end

    function ai.unitKill(unit)

    end

    function ai.pauseUnit(unit, flag)

    end

    --------
    --  TRIGGERS
    --------

    function ai.INIT_triggers()

    end

    --------
    --  INIT
    --------

    function ai.init()

    end

    ai.init()
end
