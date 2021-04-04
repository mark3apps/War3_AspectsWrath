function INIT_ai()
    ai = {}

    ai.towns = {}
    ai.routes = {}
    ai.landmarks = {}
    ai.units = {}

    --------
    --  Add new things to the fold
    --------

    -- Adds a new town to the map.  (NEEDS to be extended with additional RECTs)
    function ai.addTown(name, hostileForce)

        -- Init the Town
        ai.towns[name] = {}
        ai.towns[name].name = name

        -- Set Up Unit Group
        ai.towns[name].units = CreateGroup()

        -- Set up Landmarks
        ai.towns[name].residence = {}
        ai.towns[name].safehouse = {}
        ai.towns[name].barracks = {}
        ai.towns[name].patrol = {}
        ai.towns[name].playarea = {}
        ai.towns[name].gathering = {}
        ai.towns[name].sightseeing = {}

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

    function ai.addUnit(town, type, unit, name, shift)

    end

    function ai.INIT_triggers()

    end

    function ai.init()

    end

    ai.init()
end
