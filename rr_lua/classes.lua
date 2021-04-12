---@diagnostic disable: lowercase-global
--------------
-- Village AI
-- Credit: Mark Wright (KickKing)
-- v0.1.0
--------------
--
--
--
--
---Init Village AI
---@param overallTick number
---@param overallSplit number
function INIT_AI(overallTick, overallSplit)

    -- Set Overall Tick if a value isn't specified
    overallTick = overallTick or 2
    overallSplit = overallSplit or 5

    -- Set up Table
    ai = {
        town = {},
        townNames = {},
        unit = {},
        landmark = {},
        landmarkNames = {},
        route = {rects = {}},
        trig = {},
        unitSTATE = {},
        townSTATE = {},
        landmarkSTATE = {},
        tick = overallTick,
        split = overallSplit,
        unitGroup = CreateGroup()
    }

    --------
    --  LANDMARK ACTIONS
    --------

    ---Add a new landmark
    ---@param town string
    ---@param name string
    ---@param rect table
    ---@param types table
    ---@param unit table
    ---@param radius number
    ---@param maxCapacity number
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

    ---Adds a new town to the map.  (NEEDS to be extended with additional RECTs)
    ---@param name string
    ---@param activityProbability number
    ---@param tickMultiplier number
    ---@return boolean
    function ai.town.New(name, activityProbability, tickMultiplier)

        activityProbability = activityProbability or 5
        tickMultiplier = tickMultiplier or 1

        -- Add to list of towns
        table.insert(ai.townNames, name)

        -- Init the Town
        ai.town[name] = {

            -- Add Town Name
            name = name,
            hostileForce = nil,

            -- States
            state = "Auto",
            stateCurrent = "Normal",
            states = {
                "Auto", "Normal", "Danger", "Pause", "Paused", "Abadon",
                "Gather"
            },

            -- Units
            units = CreateGroup(),
            unitCount = 0,

            -- AI Activity Probability
            activityProbability = activityProbability,

            -- AI Intelligence Tick
            tickMultiplier = tickMultiplier,

            -- Set Up Landmarks
            residence = {},
            safehouse = {},
            barracks = {},
            gathering = {},

            -- Set Up town Regions
            region = CreateRegion(),
            rects = {}
        }

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
            if not kill and percentLife <= 0 then percentLife = 1 end

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

    ---Adds a route that villagers can take when Moving
    ---@param name  string  @Route Name
    ---@param loop  boolean @Whether or not the route is a loop
    ---@param type  string  @inTown or outOfTown
    ---@return      boolean @True if successful
    function ai.route.New(name, loop, type)

        ai.routeSetup = name
        -- Set up the route Vars
        ai.route[name] = {
            name = name,
            type = type,
            step = {},
            stepCount = 0,
            endSpeed = nil,
            loop = loop
        }

        return true
    end

    ---Adds at the end of the selected route, a new place for a unit to move to.
    ---@param rect          rect    @The Rect (GUI Region) that the unit will walk to
    ---@param speed         number  @OPTIONAL: Walk/Run speed of unit.  (under 100 will walk) Default is unit default speed
    ---@param order         number  @OPTIONAL: the order to use to move.  Default of move
    ---@param animationTag  string  @OPTIONAL: an anim tag to add to the unit while walking
    ---@return              boolean @True if successful
    function ai.route.Step(rect, speed, order, animationTag)

        -- Set default values if one wasn't specified
        local route = ai.routeSetup
        speed = speed or nil
        order = order or oid.move

        -- Add Event to Rect Entering Trigger if not already added
        if not TableContains(ai.route.rects, rect) then
            table.insert(ai.route.rects, rect)
            TriggerRegisterEnterRectSimple(ai.trig.UnitEntersRegion, rect)
        end

        -- Update the count of steps in the route
        local stepCount = ai.route[route].stepCount + 1

        -- Add the step to the route
        ai.route[route].stepCount = stepCount

        ai.route[route].step[stepCount] =
            {
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

    ---Adds an additional action to the picked route step
    ---@param time number
    ---@param lookAtRect rect
    ---@param animation string
    ---@param loop boolean
    ---@return boolean
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
            {type = "trigger", trigger = trigger}
    end

    function ai.route.Funct(funct)
        -- Update the action Count for the Route
        local route = ai.routeSetup
        local stepCount = ai.route.StepCount(route)
        local actionCount = ai.route.ActionCount(route, stepCount) + 1

        -- Add the action to the Step in the Route
        ai.route[route].step[stepCount].actionCount = actionCount
        ai.route[route].step[stepCount].action[actionCount] =
            {type = "function", funct = funct}

        return true
    end

    function ai.route.Finish(speed)
        speed = speed or nil

        ai.route[ai.routeSetup].endSpeed = speed

        return true
    end

    function ai.route.StepCount(route) return ai.route[route].stepCount end

    function ai.route.ActionCount(route, step)
        return ai.route[route].step[step].actionCount
    end

    --------
    --  UNIT ACTIONS
    --------

    -- Adds a unit that exists into the fold to be controlled by the AI. Defaults to Day shift.
    function ai.unit.New(town, type, unit, name, shift, radius)

        shift = shift or "day"
        radius = radius or 600

        local handleId = GetHandleId(unit)
        local x = GetUnitX(unit)
        local y = GetUnitY(unit)

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
            enemies = 0,
            alertedAllies = 0,
            tick = ai.tick * ai.town[town].tickMultiplier,
            loop = GetRandomReal(0, ai.tick * ai.town[town].tickMultiplier),
            shift = shift,
            state = "Auto",
            type = type,
            walking = false,
            speed = GetUnitMoveSpeed(unit),
            speedDefault = GetUnitMoveSpeed(unit),
            route = nil,
            radius = radius,
            looped = false,
            stepNumberStart = 0,
            stepNumber = 0,
            actionNumber = 0,
            routes = {},
            xHome = x,
            yHome = y,
            rectHome = Rect(x - 100, y - 100, x + 100, y + 100),
            facingHome = GetUnitFacing(unit),
            xDest = nil,
            yDest = nil
        }

        if type == "villager" then
            ai.unit[handleId].states = {
                "Relax", "Move", "Sleep", "ReturnHome", "Moving",
                "ReturningHome", "Waiting"
            }
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

    --- Kill the Unit
    ---@param unit any
    function ai.unit.Kill(unit)
        local handleId = GetHandleId(unit)
        local data = ai.unit[handleId]
        ai.unit[handleId] = nil
        GroupRemoveUnit(ai.unitGroup, unit)
        GroupRemoveUnit(ai.town[data.town].units, unit)

        KillUnit(unit)

        return true
    end

    --- Remove the Unit from the AI (Unit will be controlled as if it was an ordinary Unit)
    ---@param unit any
    function ai.unit.Remove(unit)
        local handleId = GetHandleId(unit)
        local data = ai.unit[handleId]
        ai.unit[handleId] = nil
        GroupRemoveUnit(ai.unitGroup, unit)
        GroupRemoveUnit(ai.town[data.town].units, unit)

        return true
    end

    --- Pause the Unit
    ---@param unit any
    ---@param flag boolean @If true the unit will pause, if false the unit will unpause
    function ai.unit.Pause(unit, flag)
        local handleId = GetHandleId(unit)

        PauseUnit(unit, flag)
        ai.unit[handleId].paused = flag

        return true
    end

    --- Pick a Route from the Units avalable routes and set it up
    ---@param unit any @REQUIRED The Unit in the AI system
    ---@param route string @OPTIONAL if you want a specific route chosen else it will pick one
    ---@param stepNumber integer @OPTIONAL if you want a specific Step chosen else it will start at the beginning
    ---@param actionNumber integer @OPTIONAL if you want a specific Action chosen else it will start at the beginning
    function ai.unit.PickRoute(unit, route, stepNumber, actionNumber)
        local data = ai.unit[GetHandleId(unit)]

        if #data.routes == 0 and route == nil then return false end

        route = route or data.routes[GetRandomInt(1, #data.routes)]

        local routeData = ai.route[route]

        if stepNumber == nil then
            if routeData.loop == true then
                local newDistance = 0
                local distance = 9999999
                local x = GetUnitX(unit)
                local y = GetUnitY(unit)

                for i = 1, routeData.stepCount do
                    newDistance = DistanceBetweenCoordinates(x, y,
                                                             routeData.step[i].x,
                                                             routeData.step[i].y)
                    if distance > newDistance then
                        distance = newDistance
                        stepNumber = i
                    end
                end
            end

            stepNumber = stepNumber - 1
        end

        stepNumber = stepNumber or 0
        actionNumber = actionNumber or 0

        ai.unit[data.id].route = route
        ai.unit[data.id].stepNumber = stepNumber
        ai.unit[data.id].looped = false
        ai.unit[data.id].stepNumberStart = stepNumber
        ai.unit[data.id].actionNumber = actionNumber

        return true
    end

    --- Run next Step in a Units Current Route
    ---@param unit any
    function ai.unit.NextStep(unit)
        local data = ai.unit[GetHandleId(unit)]

        local stepNumber = ai.unit[data.id].stepNumber + 1

        --print(stepNumber .. " " .. ai.route[data.route].stepCount)

        -- If there are no more steps, return
        if stepNumber > ai.route[data.route].stepCount then return false end

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

    --- Run the units next Route Action
    ---@param unit any
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

            -- Change State to "Waiting"
            ai.unit[data.id].stateCurrent = "Waiting"

            if action.type == "action" then

                if action.lookAtRect ~= nil then
                    local x = GetUnitX(unit)
                    local y = GetUnitY(unit)

                    -- Get the angle to the rect and find a point 10 units in that direction
                    local facingAngle = AngleBetweenCoordinates(x, y,
                                                                GetRectCenterX(
                                                                    action.lookAtRect),
                                                                GetRectCenterY(
                                                                    action.lookAtRect))

                    -- Get Position 10 units away in the correct direction
                    local xNew, yNew = PolarProjectionCoordinates(x, y, 10,
                                                                  facingAngle)

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

                    QueueUnitAnimation(unit, "Stand")
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

                ai.unit[data.id].stateCurrent = "Moving"
            end
        end

        return true
    end

    --- Set the Unit State
    ---@param unit any @The unit in the AI system
    ---@param state string @Takes a Unit State
    function ai.unit.State(unit, state)
        local data = ai.unit[GetHandleId(unit)]

        if TableContains(ai.unit[data.id].states, state) then
            ai.unit[data.id].state = state

            ai.unitSTATE[state](unit)

            return true
        end

        return false
    end

    --- Update the Units intel
    ---@param unit any @The unit in the AI system
    function ai.unit.Intel(unit)

        local data = ai.unit[GetHandleId(unit)]

        local u

        local enemies = 0
        local alertedAllies = 0
        local g = CreateGroup()
        local l = GetUnitLoc(unit)

        g = GetUnitsInRangeOfLocAll(data.radius, l)

        u = FirstOfGroup(g)
        while u ~= nil do

            -- Look for alerted Allies or Enemy units
            if IsUnitInForce(u, ai.town[data.town].hostileForce) then
                enemies = enemies + 1
            elseif IsUnitInGroup(u, ai.unitGroup) and
                ai.unit[GetHandleId(u)].alerted == true then
                alertedAllies = alertedAllies + 1
            end

            GroupRemoveUnit(g, u)
            u = FirstOfGroup(g)
        end
        DestroyGroup(g)
        RemoveLocation(l)

        ai.unit[data.id].enemies = enemies
        ai.unit[data.id].alertedAllies = alertedAllies
    end

    function ai.unit.MoveToNextStep(unit)

        local data = ai.unit[GetHandleId(unit)]

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
        while success do success = ai.unit.NextAction(unit) end

        -- Run next Step
        if ai.unit[data.id].looped and ai.unit[data.id].stepNumber >
            data.stepNumberStart then

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
        else

            success = ai.unit.NextStep(unit)

            -- If route is finished Send unit Home
            if not success then

                if ai.route[data.route].loop then
                    ai.unit[data.id].looped = true
                    ai.unit[data.id].stepNumber = 0
                    ai.unit[data.id].actionNumber = 0
                    success = ai.unit.NextStep(unit)
                else

                    local speed = ai.route[data.route].endSpeed or
                                      data.speedDefault

                    if speed < 100 then
                        BlzSetUnitRealFieldBJ(unit,
                                              UNIT_RF_ANIMATION_WALK_SPEED,
                                              100.00)
                        AddUnitAnimationPropertiesBJ(true, "cinematic", unit)
                        ai.unit[data.id].walk = true
                    else
                        BlzSetUnitRealFieldBJ(unit,
                                              UNIT_RF_ANIMATION_WALK_SPEED,
                                              270.00)
                        AddUnitAnimationPropertiesBJ(false, "cinematic", unit)
                        ai.unit[data.id].walk = false
                    end

                    SetUnitMoveSpeed(unit, speed)

                    ai.unit.State(unit, "ReturnHome")
                end
            end
        end

        return true
    end

    --------
    --  UNIT STATES
    --------

    --
    --- MOVE STATE
    ---@param unit any @The unit in the AI system
    function ai.unitSTATE.Move(unit)
        local data = ai.unit[GetHandleId(unit)]

        if #data.routes == 0 and data.route == nil then return false end

        local route = data.routes[GetRandomInt(1, #data.routes)]

        ai.unit.PickRoute(unit)
        ai.unit.NextStep(unit)

        return true
    end

    --
    --- RELAX STATE
    ---@param unit any @The unit in the AI system
    function ai.unitSTATE.Relax(unit)
        local data = ai.unit[GetHandleId(unit)]

        local prob = GetRandomInt(1, 100)

        --print("Trying " .. GetUnitName(unit))

        if ai.town[data.town].activityProbability >= prob then

            -- Order Unit to Move onto one of it's routes
            if TableContains(data.states, "Move") then
                ai.unit.State(unit, "Move")
            end

        end

    end

    --- RETURN HOME
    ---@param unit any @The unit in the AI system
    function ai.unitSTATE.ReturnHome(unit)
        local data = ai.unit[GetHandleId(unit)]

        ai.unit[data.id].stateCurrent = "ReturningHome"
        ai.unit[data.id].route = nil
        ai.unit[data.id].stepNumber = nil
        ai.unit[data.id].actionNumber = nil
        ai.unit[data.id].xDest = nil
        ai.unit[data.id].yDest = nil
        ai.unit[data.id].speed = nil

        --print("x:" .. data.xHome .. " y:" .. data.yHome)
        IssuePointOrderById(unit, oid.move, data.xHome, data.yHome)

        return true
    end

    --------
    --  UNIT STATES TRANSIENT
    --------

    --- Moving State
    ---@param unit any @The unit in the AI system
    function ai.unitSTATE.Moving(unit)
        local data = ai.unit[GetHandleId(unit)]

        if GetUnitCurrentOrder(unit) ~= oid.move then
            -- If the Rect isn't the targetted end rect, ignore any future actions
            if RectContainsUnit(ai.route[data.route].step[data.stepNumber].rect,
                                unit) then
                --ai.unit.MoveToNextStep(unit)
            else
                IssuePointOrderById(unit, oid.move, data.xDest, data.yDest)
            end

        end

        return true
    end

    --- Waiting State
    ---@param unit any @The unit in the AI system
    function ai.unitSTATE.Waiting(unit)

        -- Do nothing, come on now, what did you think was going to be here??
        return true
    end

    --- Returning Home State
    ---@param unit any @The unit in the AI system
    function ai.unitSTATE.ReturningHome(unit)
        local data = ai.unit[GetHandleId(unit)]

        local x = GetUnitX(unit)
        local y = GetUnitY(unit)

        if GetUnitCurrentOrder(unit) ~= oid.move then
            if not RectContainsUnit(data.rectHome, unit) then
                IssuePointOrderById(unit, oid.move, data.xHome, data.yHome)

            else
                ai.unit[data.id].stateCurrent = "Relax"
                local xNew, yNew = PolarProjectionCoordinates(x, y, 10,
                                                              data.facingHome)
                IssuePointOrderById(unit, oid.move, xNew, yNew)
            end
        end

        return true
    end

    --------
    --  TRIGGERS
    --------

    --------
    --  UNIT LOOPS
    --------

    -- Loop to get on Unit Intellegence
    ai.trig.UnitLoop = CreateTrigger()
    TriggerRegisterTimerEventPeriodic(ai.trig.UnitLoop, (ai.tick / ai.split))

    DisableTrigger(ai.trig.UnitLoop)
    TriggerAddAction(ai.trig.UnitLoop, function()

        -- Set up Local Variables
        local u, data, handleId
        local g = CreateGroup()

        -- Add all AI units to the group
        GroupAddGroup(ai.unitGroup, g)

        -- Loop through the Units and check to see if they need anything
        u = FirstOfGroup(g)
        while u ~= nil do
            data = ai.unit[GetHandleId(u)]

            ai.unit[data.id].loop = data.loop + (ai.tick / ai.split)

            -- Check to see if it's time to have the Unit Update itself
            if ai.unit[data.id].loop >
                (data.tick * ai.town[data.town].tickMultiplier) then
                ai.unit[data.id].loop = 0

                -- Run the routine for the unit's current state
                ai.unit.Intel(u)
                ai.unit.State(u, data.stateCurrent)

            end

            GroupRemoveUnit(g, u)
            u = FirstOfGroup(g)
        end
        DestroyGroup(g)

    end)

    -- Trigger Unit enters a Rect in a Route
    ai.trig.UnitEntersRegion = CreateTrigger()
    DisableTrigger(ai.trig.UnitEntersRegion)
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
                    if not RectContainsUnit(
                        ai.route[data.route].step[data.stepNumber].rect, unit) then
                        return false
                    end
                else
                    return false
                end

                ai.unit.MoveToNextStep(unit)
            end
        end, "Entering")
    end)

    --------
    --  INIT
    --------

    --- Start Running the AI
    function ai.Start()

        -- Add Tick Event and Start Unit Loop Inteligence
        EnableTrigger(ai.trig.UnitLoop)

        -- Enable Unit Route Management
        EnableTrigger(ai.trig.UnitEntersRegion)

    end

    --- Stop Running the AI
    function ai.Stop()

        -- Stop Unit Intelligence
        DisableTrigger(ai.trig.UnitLoop)

        -- Enable Unit Route Management
        DisableTrigger(ai.trig.UnitEntersRegion)

    end
end

--------
--  Main -- This runs everything
--------
function INIT_LUA()
    Debugfunc(function()

        -- Init AI
        INIT_AI(3, 5)

        -- Set up AI
        INIT_Config()

        -- Start Running the AI
        ai.Start()

    end, "Init")
end
