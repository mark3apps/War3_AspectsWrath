
-- AI FUNCTIONS
--
-- INIT_ai() -- This needs to be run at initialization
--
--  Functions to Add new things to the fold
--  [ ]    ai.addTown(name, force, {states})                         -- Adds a new town to the map.  (NEEDS to be extended with additional RECTs)
--  [ ]    ai.extendTown(name, rect)                                       -- Adds an additional RECT to a town that already exists
--  [ ]    ai.addLandmark(town, {types}, name, unit, rect, rectLook, maxCapacity)   -- Sets up a new landmark in a town that will be used by Units
--  [ ]    ai.addUnit(town, {types}, unit, name, {states}, unitLink)          -- Adds a unit into the fold to be controlled by the AI
--
--  Town States
--  [ ]    normal      -- The town is reporting everything is fine.
--  [ ]    danger      -- The town is reporting that it is in Danger.
--  [ ]    gather      -- The town is reporting that everyone needs to gather in the town center
--  [ ]    abandon     -- The town is reporting that everyone should Abandon the Town.
--
--  Landmark Types
--  [ ]    residence   -- This landmark will allow Units to sleep in it.
--  [ ]    safehouse   -- This landmark will allow Units to Hide in it when Fleeing from Danger.
--  [ ]    barracks    -- This landmark can house soldiers to be deployed if the town is under attack.
--  [ ]    playarea    -- This landmark is an area to play in.
--  [ ]    gathering   -- This landmark is used to gather get the Units to gather together.
--  [ ]    sight       -- This landmark is a sight seeing area where Units will move to and hang out at.
--
--  Landmark States
--  [ ]    normal      -- The Landmark is not reporting anything wierd
--  [ ]    danger      -- The Landmark is reporting danger around it's perimeter
--
--  Unit States Available
--  [ ]    relax       -- Unit will stay where it's at and maybe run some specific animations.
--  [ ]    move        -- Unit will move around to a different spot inside it's current town.
--  [ ]    travel      -- Unit will travel to a new town.
--  [ ]    sleep       -- Unit will look for a residence to sleep in for the night.
--  [ ]    play        -- Unit will go to a designated "play" area and run through pre-assigned routes / things.
--  [ ]    patrol      -- Unit will patrol around the town.  Looking for enemies to attack.
--  [ ]    defend      -- Unit will defend the town until all threats have been eliminated.
--  [ ]    attack      -- Unit will attack the specified town.
--  [ ]    flee        -- Unit will try to run away. (Either to nearest safehouse, or the nearest allied Town)


function INIT_ai()
    ai = {}

    ai.data = {}

    function ai.addTown(name, rect, force)


    end

    function ai.extendTown(name, rect)


    end


    function ai.addLandmark(name, town, unit, rect, maxCapacity)

    end


    function ai.addUnit(unit, town, states, unitLink)

    end


    function ai.INIT_triggers()

    end


    function ai.init()

    end

    ai.init()
end
