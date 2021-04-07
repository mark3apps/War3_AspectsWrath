function INIT_Config()
    -- Add Towns
    ai.add.town("Farms", udg_townVillageForce)

    -- Add Routes
    ai.route.new("Main", "inTown")
    ai.route.step("Main", gg_rct_R01_01, 50, true)
    ai.route.action("Main", 5, gg_rct_R01_01L, "Attack 1", true)

    ai.route.step("Main", gg_rct_R01_02, 200)
    ai.route.action("Main", 2, gg_rct_R01_02L, "Stand Victory 1", true)

    ai.route.step("Main", gg_rct_R01_03, 250)
    ai.route.action("Main", 5, gg_rct_R01_03L, "Stand Defend")

    ai.route.step("Main", gg_rct_R01_04, 75)
    ai.route.action("Main", 5, gg_rct_R01_04L, "Stand Ready")

    -- Create the Unit
    local g = CreateGroup()
    g = GetUnitsInRectAll(GetPlayableMapRect())

    local u = FirstOfGroup(g)
    while u ~= nil do

        ai.add.unit("Farms", "villager", u, "Peasant", "day")
        ai.unit.addRoute(u, "Main")

        GroupRemoveUnit(g, u)
        u = FirstOfGroup(g)
    end
    DestroyGroup(g)

    -- Testing Trigger
    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 2)
    TriggerAddAction(t, function()

        -- THIS IS ALL YOU NEED TO MAKE A UNIT GO
        local g = CreateGroup()
        g = GetUnitsInRectAll(GetPlayableMapRect())

        local u = FirstOfGroup(g)
        while u ~= nil do
            ai.unit.state(u, "move")

            PolledWait(GetRandomReal(0.4, 2))

            GroupRemoveUnit(g, u)
            u = FirstOfGroup(g)
        end
        DestroyGroup(g)
    end)
end
