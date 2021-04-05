function INIT_Config()
    -- Add Towns
    ai.addTown("village", udg_townVillageForce)

    -- Add Routes
    ai.addRoute("Main", "inTown")
    ai.routeAddStep("Main", gg_rct_R01_01, 5, gg_rct_R01_01L, "Attack 1", 50)
    ai.routeAddStep("Main", gg_rct_R01_02, 2, gg_rct_R01_02L, "Stand 2", 200)
    ai.routeAddStep("Main", gg_rct_R01_03, 5, gg_rct_R01_03L, "Stand 4", 250)
    ai.routeAddStep("Main", gg_rct_R01_04, 5, gg_rct_R01_04L, "Stand Ready", 75)

    unit1 = CreateUnit(Player(0), FourCC("hfoo"), -399.4, -54.2, 143.563)
    ai.addUnit("village", "villager", unit1, "villagerA", "day")
    ai.unitAddRoute(unit1, "Main")

    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 2)
    TriggerAddAction(t, function()

        print("Working")
        debugfunc(function()
            ai.townVulnerableUnits("village", true)
            ai.unitSetState(unit1, "move")
        end, "Move Unit")
        print("Move Unit")
    end)
end
