function INIT_ai()
    ai = {}

    ai.data = {}

    --------
    --  Add new things to the fold
    --------

    -- Adds a new town to the map.  (NEEDS to be extended with additional RECTs)
    function ai.addTown(name, force)

        -- Init the Town
        ai[name] = {}
        ai[name].name = name

        -- Set Up Unit Group
        ai[name].units = CreateGroup()

        -- Set up Landmarks
        ai[name].residence = {}
        ai[name].safehouse = {}
        ai[name].barracks = {}
        ai[name].patrol = {}
        ai[name].playarea = {}
        ai[name].gathering = {}
        ai[name].sightseeing = {}

        -- Set the town aligence
        ai[name].force = force

        -- Set up the regions and rects to be extended
        ai[name].region = nil
        ai[name].rects = {}

        return true
    end

    function ai.extendTown(name, rect)

    end

    function ai.addLandmark(town, types, name, unit, rect, rectLookAt, radius, maxCapacity)

    end

    function ai.addUnit(town, type, unit, name, shift)

    end

    function ai.INIT_triggers()

    end

    function ai.init()

    end

    ai.init()
end
