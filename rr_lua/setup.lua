function INIT_Config()
    -- Add Towns
    ai.addTown("village", udg_townVillageForce)

    -- Add Routes
    ai.addRoute("Main", "inTown")
    ai.routeAddStep("Main", gg_rct_R01_01, 5, gg_rct_R01_01L, "Attack 1", 50)
    ai.routeAddStep("Main", gg_rct_R01_02, 2, gg_rct_R01_02L, "Stand Victory 1", 200)
    ai.routeAddStep("Main", gg_rct_R01_03, 5, gg_rct_R01_03L, "Stand Defend", 250)
    ai.routeAddStep("Main", gg_rct_R01_04, 5, gg_rct_R01_04L, "Stand Ready", 75)

    -- Create the Unit
    local g = CreateGroup()
    g = GetUnitsInRectAll(GetPlayableMapRect())

    local u = FirstOfGroup(g)
    while u ~= nil do

        ai.addUnit("village", "villager", u, "villager" .. GetRandomInt(10000, 50000), "day")
        ai.unitAddRoute(u, "Main")

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
            ai.unitSetState(u, "move")
            PolledWait(GetRandomReal(0.4, 2))

            GroupRemoveUnit(g, u)
            u = FirstOfGroup(g)
        end
        DestroyGroup(g)
    end)
end
