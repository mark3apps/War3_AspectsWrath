function spawnSetup()

    -- Set up variables
    spawnTimer = CreateTimer()
    baseSpawn = spawn.new()
    spawnWave = 1
    spawnBaseI = 0

    cycleInterval = 5.00
    baseInterval = 0.4
    waveInterval = 20.00

    -- addBase(baseName, alliedStart, alliedEnd, alliedCondition, fedStart, fedEnd, fedCondition, destination)
 
    baseSpawn.addBase("arcane", gg_rct_Left_Arcane, gg_rct_Right_Start_Bottom, gg_unit_h003_0015, gg_rct_Right_Arcane, gg_rct_Left_Start_Top, gg_unit_h003_0007, 3)
    baseSpawn.addBase("arcaneCreep", gg_rct_Left_Arcane, gg_rct_Left_Elemental_Start, gg_unit_h003_0015, gg_rct_Right_Arcane, gg_rct_Right_Elemental_Start, gg_unit_h003_0007, 7)
    baseSpawn.addBase("arcaneHero", gg_rct_Arcane_Hero_Left, gg_rct_Right_Start_Bottom, gg_unit_hars_0017, gg_rct_Arcane_Hero_Right, gg_rct_Left_Start_Top, gg_unit_hars_0158, 3)
    baseSpawn.addBase("arcaneTop", gg_rct_Arcane_Left_Top, gg_rct_Right_Start_Bottom, gg_unit_hars_0355, gg_rct_Arcane_Right_Top, gg_rct_Left_Start_Top, gg_unit_hars_0293, 3)
    baseSpawn.addBase("arcaneBottom", gg_rct_Arcane_Left_Bottom, gg_rct_Right_Start_Bottom, gg_unit_hars_0292, gg_rct_Arcane_Right_Bottom, gg_rct_Left_Start_Top, gg_unit_hars_0303, 3)
    baseSpawn.addBase("blacksmith", gg_rct_Blacksmith_Left, gg_rct_Right_Start, gg_unit_n00K_0802, gg_rct_Blacksmith_Right, gg_rct_Left_Start, gg_unit_n00K_0477, 2)
    baseSpawn.addBase("blacksmithCreep", gg_rct_Blacksmith_Left, gg_rct_Zombie_End_Left, gg_unit_n00K_0802, gg_rct_Blacksmith_Right, gg_rct_Zombie_End_Right, gg_unit_n00K_0477, 10)
    baseSpawn.addBase("castle", gg_rct_Left_Hero, gg_rct_Right_Start, gg_unit_h00E_0033, gg_rct_Right_Hero, gg_rct_Left_Start, gg_unit_h00E_0081, 2)
    baseSpawn.addBase("cityElves", gg_rct_City_Elves_Left, gg_rct_Right_Start, gg_unit_hvlt_0207, gg_rct_City_Elves_Right, gg_rct_Left_Start, gg_unit_hvlt_0406, 2)
    baseSpawn.addBase("cityFront", gg_rct_Front_Town_Left, gg_rct_Right_Start, gg_unit_n00B_0364, gg_rct_Front_City_Right, gg_rct_Left_Start, gg_unit_n00B_0399, 2)
    baseSpawn.addBase("citySide", gg_rct_Left_City, gg_rct_Right_Start, gg_unit_n00B_0102, gg_rct_Right_City, gg_rct_Left_Start, gg_unit_n00B_0038, 2)
    baseSpawn.addBase("furbolg", gg_rct_Furbolg_Left, gg_rct_Right_Start_Top, gg_unit_n00D_0003, gg_rct_Furbolg_Right, gg_rct_Left_Start_Bottom, gg_unit_n00D_0091, 1)
    baseSpawn.addBase("highElves", gg_rct_Left_High_Elves, gg_rct_Right_Start_Top, gg_unit_nheb_0109, gg_rct_Right_High_Elves, gg_rct_Left_Start_Bottom, gg_unit_nheb_0036, 1)
    baseSpawn.addBase("highElvesCreep", gg_rct_Left_High_Elves, gg_rct_Aspect_of_Forest_Left, gg_unit_nheb_0109, gg_rct_Right_High_Elves, gg_rct_Aspect_of_Forest_Right, gg_unit_nheb_0036, 9)
    baseSpawn.addBase("merc", gg_rct_Camp_Bottom, gg_rct_Right_Start_Bottom, gg_unit_n001_0048, gg_rct_Camp_Top, gg_rct_Left_Start_Top, gg_unit_n001_0049, 3)
    baseSpawn.addBase("mine", gg_rct_Left_Workshop, gg_rct_Right_Start_Bottom, gg_unit_h006_0074, gg_rct_Right_Workshop, gg_rct_Left_Start_Top, gg_unit_h006_0055, 3)
    baseSpawn.addBase("naga", gg_rct_Naga_Left, gg_rct_Right_Start_Top, gg_unit_nntt_0135, gg_rct_Naga_Right, gg_rct_Left_Start_Bottom, gg_unit_nntt_0132, 1)
    baseSpawn.addBase("nagaCreep", gg_rct_Naga_Left, gg_rct_Murloc_Left, gg_unit_nntt_0135, gg_rct_Naga_Right, gg_rct_Murloc_Right, gg_unit_nntt_0132, 8)
    baseSpawn.addBase("nightElves", gg_rct_Left_Tree, gg_rct_Right_Start_Top, gg_unit_e003_0058, gg_rct_Right_Tree, gg_rct_Left_Start_Bottom, gg_unit_e003_0014, 1)
    baseSpawn.addBase("orc", gg_rct_Left_Orc, gg_rct_Right_Start_Top, gg_unit_o001_0075, gg_rct_Right_Orc, gg_rct_Left_Start_Bottom, gg_unit_o001_0078, 1)
    baseSpawn.addBase("shipyard", gg_rct_Left_Shipyard, gg_rct_Right_Start_Top, gg_unit_eshy_0120, gg_rct_Right_Shipyard, gg_rct_Left_Start_Bottom, gg_unit_eshy_0047, 1)
    baseSpawn.addBase("town", gg_rct_Left_Forward_Camp, gg_rct_Right_Start_Bottom, gg_unit_h00F_0029, gg_rct_Right_Forward, gg_rct_Left_Start_Top, gg_unit_h00F_0066, 3)
    baseSpawn.addBase("undead", gg_rct_Undead_Left, gg_rct_Right_Start, gg_unit_unp2_0316, gg_rct_Undead_Right, gg_rct_Left_Start, gg_unit_unp2_0192, 2)
    

    -- addUnit(baseName, unitType, numOfUnits, {waves}, levelStart, levelEnd)

    -- Arcane Spawn
    baseSpawn.addUnit("arcane", "h00C", 2, {5,6,7,8,9}, 3, 12)  -- Sorcress
    baseSpawn.addUnit("arcane", "hgry", 1, {2,4,6,8,10}, 10, 12)  -- Gryphon Rider
 
    -- Arcane Creep Spawn
    baseSpawn.addUnit("arcaneCreep", "narg", 2, {1,2,3,4}, 2, 12)  -- Battle Golem
    baseSpawn.addUnit("arcaneCreep", "hwt2", 1, {1,2,3,4}, 3, 12)  -- Water Elemental (Level 2)
    baseSpawn.addUnit("arcaneCreep", "hwt3", 1, {1,2,3,4}, 4, 12)  -- Water Elemental (Level 3)
    baseSpawn.addUnit("arcaneCreep", "h00K", 1, {1,2,3,4,5,10}, 6, 12)  -- Magi Defender

    -- Arcane Hero Sapwn
    baseSpawn.addUnit("arcaneHero", "n00A", 1, {5,6}, 6, 12)  -- Supreme Wizard
    baseSpawn.addUnit("arcaneHero", "nsgg", 1, {4,6}, 8, 12)  -- Seige Golem

    -- Arcane Top Spawn
    baseSpawn.addUnit("arcaneTop", "narg", 4, {4,5,6}, 2, 12)  -- Battle Golem
    baseSpawn.addUnit("arcaneTop", "hwt2", 1, {4,5,6}, 4, 12)  -- Water Elemental (Level 2)
    baseSpawn.addUnit("arcaneTop", "hwt3", 1, {5,6}, 8, 12)  -- Water Elemental (Level 3)

    -- Arcane Bottom Spawn
    baseSpawn.addUnit("arcaneBottom", "narg", 4, {1,2,3}, 2, 12)  -- Battle Golem
    baseSpawn.addUnit("arcaneBottom", "hwt2", 1, {1,2,3}, 4, 12)  -- Water Elemental (Level 2)
    baseSpawn.addUnit("arcaneBottom", "hwt3", 1, {2,3}, 8, 12)  -- Water Elemental (Level 3)

    -- Blacksmith Spawn
    baseSpawn.addUnit("blacksmith", "h011", 1, {1,2,3,4,5}, 3, 12)  -- Castle Footman
    baseSpawn.addUnit("blacksmith", "h00L", 1, {1,2,3,4}, 4, 12)  -- Knight
    baseSpawn.addUnit("blacksmith", "h00L", 1, {1,2,3,4}, 5, 12)  -- Knight
    baseSpawn.addUnit("blacksmith", "h012", 1, {1,2,3}, 6, 12)  -- Scarlet Commander
    baseSpawn.addUnit("blacksmith", "hmtt", 1, {1,5}, 6, 12)  -- Seige Engine
    baseSpawn.addUnit("blacksmith", "hmtm", 1, {3,8}, 7, 12)  -- Cannon
    baseSpawn.addUnit("blacksmith", "h00D", 1, {2}, 10, 12)  -- Commander of the Guard

    -- Blacksmith Creep Spawn
    baseSpawn.addUnit("blacksmithCreep", "h007", 4, {1,2,3,4}, 1, 6)  -- Militia
    baseSpawn.addUnit("blacksmithCreep", "nhea", 1, {1,2,3,4}, 3, 12)  -- Archer
    baseSpawn.addUnit("blacksmithCreep", "hspt", 1, {1,2,3,4}, 4, 12)  -- Tower Guard
    baseSpawn.addUnit("blacksmithCreep", "h012", 2, {1,2,3,4,5}, 6, 12)  -- Scarlet Commander
    baseSpawn.addUnit("blacksmithCreep", "hcth", 2, {1,2,3,4,5}, 7, 12)  -- Captian

    -- Castle Spawn
    baseSpawn.addUnit("castle", "h00s", 1, {1,2,3,4,5,6,7,8}, 8, 12)  -- Commander

    -- City Elves
    baseSpawn.addUnit("cityElves", "nhea", 1, {1,2,3,4,5,6}, 1, 3)  -- Archer
    baseSpawn.addUnit("cityElves", "hspt", 1, {1,2,3,4,5,6,7,8}, 2, 3)  -- Tower Guard
    baseSpawn.addUnit("cityElves", "hspt", 2, {1,2,3,4,5,6,7}, 4, 5)  -- Tower Guard
    baseSpawn.addUnit("cityElves", "nchp", 1, {1,2,3,4}, 3, 12)  -- Mystic
    baseSpawn.addUnit("cityElves", "hspt", 3, {1,2,3,4,5,6}, 6, 12)  -- Tower Guard
    baseSpawn.addUnit("cityElves", "nhea", 1, {1,2,3,4,5,6,7,8}, 4, 12)  -- Archer
    baseSpawn.addUnit("cityElves", "nchp", 1, {1,2,3,4,5,6,7}, 7, 12)  -- Mystic

    -- City Front Spawn
    baseSpawn.addUnit("cityFront", "h007", 2, {2,3,4,5,6,7}, 1, 2)  -- Militia
    baseSpawn.addUnit("cityFront", "h007", 3, {2,3,4,5,6,7}, 3, 5)  -- Militia
    baseSpawn.addUnit("cityFront", "hfoo", 3, {2,3,4,5,6,7}, 4, 12)  -- Footman
    baseSpawn.addUnit("cityFront", "hcth", 2, {2,3,4,5,6}, 6, 12)  -- Captian

    -- City Side Spawn
    baseSpawn.addUnit("citySide", "h007", 1, {6,7,8,9,10}, 1, 2)  -- Militia
    baseSpawn.addUnit("citySide", "hfoo", 2, {6,7,8,9,10}, 2, 12)  -- Footman
    baseSpawn.addUnit("citySide", "h007", 2, {6,7,8,9,10}, 3, 12)  -- Militia

    -- Furbolg Spawn
    baseSpawn.addUnit("furbolg", "n00E", 2, {1,3,4,5,6,7,8}, 1, 12)  -- Furbolg
    baseSpawn.addUnit("furbolg", "n00G", 1, {1,3,5,7,9}, 3, 12)  -- Furbolg Shaman
    baseSpawn.addUnit("furbolg", "n00E", 2, {2,7,8,9,10}, 4, 12)  -- Furbolg
    

    -- High Elves
    baseSpawn.addUnit("highElves", "earc", 2, {1,2,3,4,5}, 1, 12)  -- Ranger
    baseSpawn.addUnit("highElves", "e000", 1, {1,2,3,4,5,6,7,8}, 2, 12)  -- Elite Ranger
    baseSpawn.addUnit("highElves", "hhes", 4, {1,2,3,4}, 4, 12)  -- Swordsman
    baseSpawn.addUnit("highElves", "nemi", 1, {1,2,3,4,5,6}, 5, 12)  -- Emmisary

    -- High Elves Creep
    baseSpawn.addUnit("highElvesCreep", "hhes", 2, {1,2,3,4}, 1, 12)  -- Swordsman
    baseSpawn.addUnit("highElvesCreep", "nhea", 1, {1,2,3,4,5}, 2, 12)  -- Archer
    baseSpawn.addUnit("highElvesCreep", "nemi", 1, {1,2,3,4}, 4, 12)  -- Emmisary
    baseSpawn.addUnit("highElvesCreep", "h010", 2, {1,2,3,4,5}, 5, 12)  -- Elven Guardian

    -- Merc Spawn
    baseSpawn.addUnit("merc", "n002", 2, {1,2,3,4,5,6,7,8,9,10}, 1, 12)  -- Merc
    baseSpawn.addUnit("merc", "n003", 2, {4,5,6,7,8,9,10}, 2, 12)  -- Merc Archer
    baseSpawn.addUnit("merc", "n002", 2, {7,8,9,10}, 3, 12)  -- Merc
    baseSpawn.addUnit("merc", "n008", 3, {7,8,9,10}, 4, 12)  -- Enforcer
    baseSpawn.addUnit("merc", "nass", 1, {6,7,8,9,10}, 5, 12)  -- Assasin
    baseSpawn.addUnit("merc", "n004", 1, {7,8,9,10}, 1, 12)  -- Wizard Warrior
    baseSpawn.addUnit("merc", "n005", 1, {7,8,9,10}, 6, 12)  -- Bandit Lord

    -- Mine Spawn
    baseSpawn.addUnit("mine", "h001", 1, {2,3,4,5,6}, 2, 12)  -- Morter Team
    baseSpawn.addUnit("mine", "h008", 2, {1,2,3,4,5,6,7,8}, 3, 12)  -- Rifleman
    baseSpawn.addUnit("mine", "h013", 1, {1,2,3,4,5,6,7,8}, 4, 12)  -- Rifleman Long
    baseSpawn.addUnit("mine", "ncg2", 2, {1,2,3,4,5}, 4, 12)  -- Clockwerk Goblin
    baseSpawn.addUnit("mine", "n00F", 1, {2,3,4,5,6,7}, 5, 12)  -- Automaton

    -- Naga Spawn
    baseSpawn.addUnit("naga", "nmyr", 1, {3,4,5,6,7,8,9,10}, 1, 12)  -- Naga Myrmidon
    baseSpawn.addUnit("naga", "nnsw", 1, {4,5,6,7,8,9,10}, 2, 12)  -- Naga Siren
    baseSpawn.addUnit("naga", "nnrg", 1, {5,6,8,9,10}, 5, 12)  -- Naga Royal Guard
    baseSpawn.addUnit("naga", "nhyc", 1, {1,3,5,7,8,9}, 9, 12)  -- Dragon Turtle

    -- Naga Creep Spawn
    baseSpawn.addUnit("nagaCreep", "nmyr", 2, {1,2,3,4}, 2, 12)  -- Naga Myrmidon
    baseSpawn.addUnit("nagaCreep", "nnsw", 1, {2,3,4,5}, 4, 12)  -- Naga Siren
    baseSpawn.addUnit("nagaCreep", "nsnp", 1, {2,3,4,5}, 6, 12)  -- Snap Dragon

    -- Night Elves Spawn
    baseSpawn.addUnit("nightElves", "nwat", 1, {3,4,5,6,7,8,9}, 2, 12)  -- Sentry
    baseSpawn.addUnit("nightElves", "edry", 1, {1,4,5,7,9}, 3, 12)  -- Dryad
    baseSpawn.addUnit("nightElves", "edoc", 2, {1,3,5,7,9}, 4, 12)  -- Druid of the Claw
    baseSpawn.addUnit("nightElves", "e005", 1, {2,4,6,8}, 5, 12)  -- Mountain Giant
    baseSpawn.addUnit("nightElves", "echm", 1, {5,7}, 9, 12)  -- Chimera
    
    -- Orc Spawn
    baseSpawn.addUnit("orc", "o002", 2, {3,5,6,7,8,9,10}, 1, 12)  -- Grunt
    baseSpawn.addUnit("orc", "o002", 2, {6,7,8}, 3, 12)  -- Grunt
    baseSpawn.addUnit("orc", "nftr", 1, {4,5,7,8,9,10}, 2, 12)  -- Spearman
    baseSpawn.addUnit("orc", "nogr", 3, {2,4,6,8,10}, 4, 12)  -- Ogre
    baseSpawn.addUnit("orc", "o004", 1, {6,7,8}, 3, 12)  -- Spirit Walker
    baseSpawn.addUnit("orc", "nogm", 1, {1,6,8}, 4, 12)  -- Ogre Warchief
    baseSpawn.addUnit("orc", "otau", 1, {5,6,7}, 5, 12)  -- Tauren

    -- Shipyard Spawn
    baseSpawn.addUnit("shipyard", "edes", 1, {1,2}, 1, 2)  -- Night Elf Frigate
    baseSpawn.addUnit("shipyard", "edes", 1, {1,2,3,4}, 3, 4)  -- Night Elf Frigate
    baseSpawn.addUnit("shipyard", "edes", 1, {1,3,5,6,7,9}, 5, 12)  -- Night Elf Frigate

    -- Town Spawn
    baseSpawn.addUnit("town", "h007", 3, {1,2,3,4,5}, 1, 5)  -- Militia
    baseSpawn.addUnit("town", "hcth", 1, {1,2,3,4}, 2, 12)  -- Captian
    baseSpawn.addUnit("town", "hfoo", 5, {1,2,3,4,5,6}, 3, 12)  -- Footman
    baseSpawn.addUnit("town", "h00L", 2, {1,3,7,9}, 4, 12)  -- Knight

    -- Undead Spawn
    baseSpawn.addUnit("undead", "ugho", 4, {1,2,3,4,5,6,7}, 1, 12)  -- Ghoul
    baseSpawn.addUnit("undead", "uskm", 1, {1,2,3,4,5,6,7,8,9,10}, 2, 12)  -- Skeleton Mage
    baseSpawn.addUnit("undead", "unec", 1, {1,2,3,4,5,6,7}, 3, 12)  -- Necromancer
    baseSpawn.addUnit("undead", "nerw", 1, {1,6}, 4, 12)  -- Warlock
    baseSpawn.addUnit("undead", "nfgl", 1, {2,5,8}, 5, 12)  -- Flesh Golem

    
    --DisplayTextToForce(GetPlayersAll() , "Spawn Setup")
    StartTimerBJ(spawnTimer, false, 10)
end




function spawnRun()

    trg_spawnRun = CreateTrigger()
    TriggerRegisterTimerExpireEventBJ(trg_spawnRun, spawnTimer)

    TriggerAddAction(trg_spawnRun, function ()

        -- Iterate everything up
        spawnBaseI = spawnBaseI + 1

        if (spawnBaseI > baseSpawn.baseCount() ) then
            spawnBaseI = 0
            spawnWave = spawnWave + 1

            if spawnWave > 10 then
                spawnWave = 1
                StartTimerBJ(spawnTimer, false, cycleInterval)
            else
                StartTimerBJ(spawnTimer, false, waveInterval)
            end

            return true
        else
            StartTimerBJ(spawnTimer, false, baseInterval)
        end
        

        -- Find the Base to Spawn Next
        local baseName = baseSpawn.bases[spawnBaseI]

        -- Spawn the Units at the selected Base
        DisableTrigger(gg_trg_Creeps_keep_going_after_Order)
        baseSpawn.spawnUnits(baseName, udg_INTcreepLevel, spawnWave)
        EnableTrigger(gg_trg_Creeps_keep_going_after_Order)
    end)  
end