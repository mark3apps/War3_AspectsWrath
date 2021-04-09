function INIT_Config()
    debugfunc(function()
        -- Add Towns
        ai.town.new("Farms", udg_townVillageForce)

        -- Add Routes
        ai.route.new("Main", "inTown")
        ai.route.step("Main", gg_rct_R01_01, 500, true)
        ai.route.action("Main", 5, gg_rct_R01_01L, "Attack 1", true)

        ai.route.step("Main", gg_rct_R01_02, 200)
        ai.route.action("Main", 2, gg_rct_R01_02L, "Stand Victory 1", true)
        ai.route.trigger("Main", gg_trg_Action_Test)

        ai.route.step("Main", gg_rct_R01_03, 250)
        ai.route.action("Main", 5, gg_rct_R01_03L, "Stand Defend")

        ai.route.step("Main", gg_rct_R01_04, 75)
        ai.route.action("Main", 5, gg_rct_R01_04L, "Stand Ready")

        -- Create the Unit
        local g = CreateGroup()
        g = GetUnitsInRectAll(GetPlayableMapRect())

        local u = FirstOfGroup(g)
        while u ~= nil do

            ai.unit.new("Farms", "villager", u, "Peasant", "day")
            ai.unit.addRoute(u, "Main")

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

            debugfunc(function()
                ai.unit.state(u, "move")
            end, "Testing")

            PolledWait(GetRandomReal(4, 10))

            GroupRemoveUnit(g, u)
            u = FirstOfGroup(g)
        end
        DestroyGroup(g)
    end)

end

