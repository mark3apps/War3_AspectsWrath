function INIT_Config()
    -- Add Towns
    ai.add.town("village", udg_townVillageForce)

    -- Add Routes
    ai.add.route("Main", "inTown")
    ai.route.addStep("Main", gg_rct_R01_01, 5, gg_rct_R01_01L, "Attack 1", 50)
    ai.route.addStep("Main", gg_rct_R01_02, 2, gg_rct_R01_02L, "Stand Victory 1", 200)
    ai.route.addStep("Main", gg_rct_R01_03, 5, gg_rct_R01_03L, "Stand Defend", 250)
    ai.route.addStep("Main", gg_rct_R01_04, 5, gg_rct_R01_04L, "Stand Ready", 75)

    -- Create the Unit
    local g = CreateGroup()
    g = GetUnitsInRectAll(GetPlayableMapRect())

    local u = FirstOfGroup(g)
    while u ~= nil do

        ai.add.unit("village", "villager", u, "villager" .. GetRandomInt(10000, 50000), "day")
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
