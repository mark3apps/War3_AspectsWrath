
-- AI FUNCTIONS
--
-- INIT_ai() -- This needs to be run at Map initialization as a custom script
--
-----------
--FUNCTIONS
--  * means optional variable
--
--  Add new things to the fold
--  [ ] ai.addTown(name, force)                           -- Adds a new town to the map.  (NEEDS to be extended with additional RECTs)
--  [ ] ai.addLandmark(town, {types}, name, unit, rect, rectLookAt, radias, maxCapacity)   -- Sets up a new landmark in a town that will be used by Units
--  [ ] ai.addUnit(town, type, unit, name, shift*)                  -- Adds a unit that exists into the fold to be controlled by the AI. Defaults to Day shift.
--
--  Extend Town Size
--  [ ] ai.extendTown(name, rect)                -- Adds an additional RECT to a town that already exists
--
--  Town Actions
--  [ ] ai.townState(name, state)               -- Changes the town state to the specified state
--  [ ] ai.townVulnerableUnits(name, flag)      -- Sets all units of a town to be vulnerable / invulnerable.
--  [ ] ai.townVulnerableLandmarks(name, flag)  -- Sets all landmarks of a town to be vulnerable / invulnerable.
--  [ ] ai.townHurtUnits(name, low, high)       -- Damages all units of the town by a random percentage from low to high.
--  [ ] ai.townHurtLandmarks(name, low, high)   -- Damages all landmarks of the town by a random percentage from low to high.
--  [ ] ai.townAddUnits(name, amount, unitType) -- Adds additional units of unit type to the town and places them at a random residence.

--  Landmark Actions
--  [ ] ai.landmarkState(rect, state)           -- Changes the landmark state to the specified state
--  [ ] ai.landmarkKill(rect)                   -- Kills the landmark, displacing any Units connected to it.
--
--  Unit Actions
--  [ ] ai.unitState(unit, state)               -- Changes the unit state to the specified state
--  [ ] ai.unitKill(unit)                       -- Kills the unit
--  [ ] ai.unitPause(unit, unitLookAt)          -- Stops the unit and tells it to look at a unit.
--
--  Set Unit Types
--  [ ] ai.unitVillager(unit)                   -- Set unit as a Villager
--  [ ] ai.unitMilitia(unit, unitTypeTransform) -- Set unit as a Militia
--  [ ] ai.unitTraveler(unit)                   -- Set unit as a Soldier
--  [ ] ai.unitFollower(unit, unitFollowing)    -- Set unit as a Follower, also need to specify the unit to follow.
--  [ ] ai.unitChild(unit)                      -- Set unit as a Child
--  [ ] ai.unitCustom(unit, {states})           -- Set unit as a custom type.  Will take on the states selected.
--
-----------
--STATES
--
--  Town States
--  [ ] auto        -- The town will automatically choose what state it should be in.
--  [ ] normal      -- *AUTO* The town is reporting everything is fine.
--  [ ] danger      -- *AUTO* The town is reporting that it is in danger.
--  [ ] pause       -- The town will tell all of it's residences to pause and wait.
--  [ ] gather      -- The town is reporting that everyone needs to gather in the town center
--  [ ] abandon     -- The town is reporting that everyone should Abandon the Town.
--
--  Landmark States
--  [ ] auto        -- The Landmark will automatically choose what state to be in.
--  [ ] normal      -- *AUTO* The Landmark is not reporting anything wierd.
--  [ ] danger      -- *AUTO* The Landmark is reporting danger
--  [ ] off         -- The Landmark is turned off and won't influence any behavior.
--
--  Unit States Available
--  [ ] auto        -- Unit will automatically choose what state to be in.
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
--  [ ] flee        -- Unit will try to run away. (Either to nearest safehouse, or will keep running to landmarks in town if no safehouses)
--  [ ] arm         -- Unit will try to find a barracks and arm himself to fight.
--
--
--
-----------
--TYPES
--
--  Landmark Types (Each landmark can be multiple types)
--  [ ] residence   -- This landmark will allow Units to sleep in it.
--  [ ] safehouse   -- This landmark will allow Units to Hide in it when Fleeing from Danger.
--  [ ] barracks    -- This landmark can house soldiers to be deployed if the town is under attack.
--  [ ] patrol      -- This landmark is used to allow units to patrol it.
--  [ ] playarea    -- This landmark is an area to play in.
--  [ ] gathering   -- This landmark is used to gather get the Units to gather together.
--  [ ] sight       -- This landmark is a sight seeing area where Units will move to and hang out at.
--
--
--  Unit Types (Each unit can only be one type at a time)
--  [ ] villager    -- Ordinary villager.  Will go about business, will always run away, and never fight.  Slows down when hurt, won't leave town.
--          {relax, move, gather, sleep, flee}
--
--  [ ] militia     -- Appears as an ordinary villager but if town is in danger and contains a barracks, go to it and transform into a milita and fight.
--          {relax, move, gather, sleep, arm}
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

    function ai.addTown(name, force)


    end

    function ai.extendTown(name, rect)


    end


    function ai.addLandmark(town, types, name, unit, rect, rectLookAt, radias, maxCapacity)

    end


    function ai.addUnit(town, type, unit, name, shift)

    end


    function ai.INIT_triggers()

    end


    function ai.init()

    end

    ai.init()
end
