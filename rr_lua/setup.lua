
-- Add Towns
ai.addTown("village", udg_townVillageForce)

-- Add Routes
ai.addRoute("Main", "inTown")
ai.routeAddStep(gg_rct_R01_01, 5, gg_rct_R01_01L, "Attack 1", 50)
ai.routeAddStep(gg_rct_R01_02, 2, gg_rct_R01_02L, "Stand 2", 200)
ai.routeAddStep(gg_rct_R01_03, 5, gg_rct_R01_03L, "Stand 4", 250)
ai.routeAddStep(gg_rct_R01_04, 5, gg_rct_R01_04L, "Stand Ready", 75)


local u = CreateUnit(Player(0), FourCC("hfoo"),-399.4, -54.2, 143.563)
ai.addUnit("village", "villager", u, "villagerA", "day")
ai.unitAddRoute(u, "Main")
