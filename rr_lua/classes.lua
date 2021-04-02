
-- AI FUNCTIONS
--
-- INIT_ai() -- This needs to be run at Map initialization as a custom script
--
-----------
--FUNCTIONS
--  * means optional variable
--
--  Add new things to the fold
--  [ ] ai.addTown(name, force, {states})                           -- Adds a new town to the map.  (NEEDS to be extended with additional RECTs)
--  [ ] ai.addLandmark(town, {types}, name, unit, rect, rectLookAt, maxCapacity)   -- Sets up a new landmark in a town that will be used by Units
--  [ ] ai.addUnit(town, type, unit, name, shift*)                  -- Adds a unit into the fold to be controlled by the AI. Defaults to Day shift.
--
--  Extend Objects
--  [ ] ai.extendTown(name, rect)                                   -- Adds an additional RECT to a town that already exists
--
--
--
-----------
--STATES
--
--  Town States
--  [ ] normal      -- The town is reporting everything is fine.
--  [ ] danger      -- The town is reporting that it is in Danger.
--  [ ] gather      -- The town is reporting that everyone needs to gather in the town center
--  [ ] abandon     -- The town is reporting that everyone should Abandon the Town.
--
--  Landmark States
--  [ ] normal      -- The Landmark is not reporting anything wierd
--  [ ] danger      -- The Landmark is reporting danger around it's perimeter
--
--  Unit States Available
--  [ ] relax       -- Unit will stay where it's at and maybe run some specific animations.
--  [ ] move        -- Unit will move around to a different spot inside it's current town.
--  [ ] travel      -- Unit will travel to a new town.
--  [ ] gather      -- Unit will move to the Town gathering spot, pick a random spot to stand in.
--  [ ] sleep       -- Unit will look for a residence to sleep in for the night.
--  [ ] play        -- Unit will go to a designated "play" area and run through pre-assigned routes / things.
--  [ ] patrol      -- Unit will patrol around the town.  Looking for enemies to attack during his shift.
--  [ ] defend      -- Unit will defend the town until all threats have been eliminated.
--  [ ] guard       -- Unit will stand in a position and will guard it always during his shift.
--  [ ] attack      -- Unit will attack the specified town.
--  [ ] follow      -- Unit will follow it's attached unit
--  [ ] flee        -- Unit will try to run away. (Either to nearest safehouse, or the nearest allied Town)
--
--
--
-----------
--TYPES
--
--  Landmark Types
--  [ ] residence   -- This landmark will allow Units to sleep in it.
--  [ ] safehouse   -- This landmark will allow Units to Hide in it when Fleeing from Danger.
--  [ ] barracks    -- This landmark can house soldiers to be deployed if the town is under attack.
--  [ ] playarea    -- This landmark is an area to play in.
--  [ ] gathering   -- This landmark is used to gather get the Units to gather together.
--  [ ] sight       -- This landmark is a sight seeing area where Units will move to and hang out at.
--
--
--  Unit Types
--  [ ] villager    -- Ordinary villager.  Will go about business, will always run away, and never fight.  Slows down when hurt, won't leave town.
--          {relax, move, gather, sleep, flee}
--
--  [ ] militia     -- Appears as an ordinary villager but if town is in danger and contains a barracks, go to it and transform into a milita and fight.
--          {relax, move, gather, sleep, flee, defend}
--
--  [ ] soldier     -- protects the town, never leaves the town unless told to attack another town.  Will always fight when under attack.
--          {relax, move, gather, sleep, guard, patrol, defend, attack}
--
--  [ ] traveler    -- Will go about business, will always run away, and never fight.  Slows down when hurt, will travel to other towns.
--          {relax, move, sleep, travel}
--
--  [ ] follower    -- Will always follow it's lead unit. (Good for pack mules, that type of thing)  If lead unit dies, will flee to it's town and become a villager.
--          {follow}
--
--  [ ] child       -- Will play during the day, or sight see.
--          {move, sleep, play}
--
--  [ ] custom      -- No states will be added to this unit.  Will need to manually set up what unit will do.


function INIT_ai()
    ai = {}

    ai.data = {}

    function ai.addTown(name, rect, force)


    end

    function ai.extendTown(name, rect)


    end


    function ai.addLandmark(name, town, unit, rect, maxCapacity)

    end


    function ai.addUnit(town, type, shift, unit, name, unitFollow)

    end


    function ai.INIT_triggers()

    end


    function ai.init()

    end

    ai.init()
end
