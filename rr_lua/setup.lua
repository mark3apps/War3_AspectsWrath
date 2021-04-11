function INIT_Config()
    Debugfunc(function()
        -- Add Towns
        ai.town.New("Farms", udg_townVillageForce)

        -- Add Routes
        ai.route.New("Main", "inTown")

        ai.route.Step(gg_rct_R01_01, 100)
        ai.route.Trigger(gg_trg_Action_Test)
        ai.route.Action(10, gg_rct_R01_01L, "Attack 1")
        ai.route.Action(10, gg_rct_R01_02L, "Attack 1", true)

        ai.route.Step(gg_rct_R01_02)
        ai.route.Action(4, gg_rct_R01_02L, "Stand Victory 1", true)

        ai.route.Step(gg_rct_R01_03)
        ai.route.Action(3, gg_rct_R01_03L, "Stand Defend")

        ai.route.Step(gg_rct_R01_04, 100)
        ai.route.Action(5, gg_rct_R01_04L, "Stand Ready")

        ai.route.Finish(100)

        -- Create the Unit
        local g = CreateGroup()
        g = GetUnitsInRectAll(GetPlayableMapRect())

        local u = FirstOfGroup(g)
        while u ~= nil do

            ai.unit.New("Farms", "villager", u, "Peasant", "day")
            ai.unit.AddRoute(u, "Main")

            GroupRemoveUnit(g, u)
            u = FirstOfGroup(g)
        end
        DestroyGroup(g)
    end, "Testing")
    print("Working")

    -- Testing Trigger
    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 2)
    TriggerAddAction(t, function()

        -- THIS IS ALL YOU NEED TO MAKE A UNIT GO
        local g = CreateGroup()
        g = GetUnitsInRectAll(GetPlayableMapRect())

        local u = FirstOfGroup(g)
        while u ~= nil do

            Debugfunc(function()
                ai.unit.State(u, "Move")
            end, "Testing")

            PolledWait(GetRandomReal(4, 10))

            GroupRemoveUnit(g, u)
            u = FirstOfGroup(g)
        end
        DestroyGroup(g)
    end)

end

