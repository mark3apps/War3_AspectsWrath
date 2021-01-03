function spawnAddBases()

    -- addBase(baseName, alliedStart, alliedEnd, alliedCondition, fedStart, fedEnd, fedCondition, destination)

    spawn.addBase(
        "arcane",
        gg_rct_Left_Arcane,
        gg_rct_Right_Start_Bottom,
        gg_unit_h003_0015,
        gg_rct_Right_Arcane,
        gg_rct_Left_Start_Top,
        gg_unit_h003_0007,
        3
    )
    spawn.addBase(
        "arcaneCreep",
        gg_rct_Left_Arcane,
        gg_rct_Left_Elemental_Start,
        gg_unit_h003_0015,
        gg_rct_Right_Arcane,
        gg_rct_Right_Elemental_Start,
        gg_unit_h003_0007,
        7
    )
    spawn.addBase(
        "arcaneHero",
        gg_rct_Arcane_Hero_Left,
        gg_rct_Right_Start_Bottom,
        gg_unit_hars_0017,
        gg_rct_Arcane_Hero_Right,
        gg_rct_Left_Start_Top,
        gg_unit_hars_0158,
        3
    )
    spawn.addBase(
        "arcaneTop",
        gg_rct_Arcane_Left_Top,
        gg_rct_Right_Start_Bottom,
        gg_unit_hars_0355,
        gg_rct_Arcane_Right_Top,
        gg_rct_Left_Start_Top,
        gg_unit_hars_0293,
        3
    )
    spawn.addBase(
        "arcaneBottom",
        gg_rct_Arcane_Left_Bottom,
        gg_rct_Right_Start_Bottom,
        gg_unit_hars_0292,
        gg_rct_Arcane_Right_Bottom,
        gg_rct_Left_Start_Top,
        gg_unit_hars_0303,
        3
    )
    spawn.addBase(
        "blacksmith",
        gg_rct_Blacksmith_Left,
        gg_rct_Right_Everything,
        gg_unit_n00K_0802,
        gg_rct_Blacksmith_Right,
        gg_rct_Left_Everything,
        gg_unit_n00K_0477,
        2
    )
    spawn.addBase(
        "blacksmithCreep",
        gg_rct_Blacksmith_Left,
        gg_rct_Zombie_End_Left,
        gg_unit_n00K_0802,
        gg_rct_Blacksmith_Right,
        gg_rct_Zombie_End_Right,
        gg_unit_n00K_0477,
        10
    )
    spawn.addBase(
        "castle",
        gg_rct_Left_Hero,
        gg_rct_Right_Everything,
        gg_unit_h00E_0033,
        gg_rct_Right_Hero,
        gg_rct_Left_Everything,
        gg_unit_h00E_0081,
        2
    )
    spawn.addBase(
        "cityElves",
        gg_rct_City_Elves_Left,
        gg_rct_Right_Everything,
        gg_unit_hvlt_0207,
        gg_rct_City_Elves_Right,
        gg_rct_Left_Everything,
        gg_unit_hvlt_0406,
        2
    )
    spawn.addBase(
        "cityFront",
        gg_rct_Front_Town_Left,
        gg_rct_Right_Everything,
        gg_unit_n00B_0364,
        gg_rct_Front_City_Right,
        gg_rct_Left_Everything,
        gg_unit_n00B_0399,
        2
    )
    spawn.addBase(
        "citySide",
        gg_rct_Left_City,
        gg_rct_Right_Everything,
        gg_unit_n00B_0102,
        gg_rct_Right_City,
        gg_rct_Left_Everything,
        gg_unit_n00B_0038,
        2
    )
    spawn.addBase(
        "kobold",
        gg_rct_Furbolg_Left,
        gg_rct_Right_Start_Top,
        gg_unit_ngt2_0525,
        gg_rct_Furbolg_Right,
        gg_rct_Left_Start_Bottom,
        gg_unit_ngt2_0455,
        1
    )
    spawn.addBase(
        "highElves",
        gg_rct_Left_High_Elves,
        gg_rct_Right_Start_Top,
        gg_unit_nheb_0109,
        gg_rct_Right_High_Elves,
        gg_rct_Left_Start_Bottom,
        gg_unit_nheb_0036,
        1
    )
    spawn.addBase(
        "highElvesCreep",
        gg_rct_Left_High_Elves,
        gg_rct_Aspect_of_Forest_Left,
        gg_unit_nheb_0109,
        gg_rct_Right_High_Elves,
        gg_rct_Aspect_of_Forest_Right,
        gg_unit_nheb_0036,
        9
    )
    spawn.addBase(
        "merc",
        gg_rct_Camp_Bottom,
        gg_rct_Right_Start_Bottom,
        gg_unit_n001_0048,
        gg_rct_Camp_Top,
        gg_rct_Left_Start_Top,
        gg_unit_n001_0049,
        3
    )
    spawn.addBase(
        "mine",
        gg_rct_Left_Workshop,
        gg_rct_Right_Start_Bottom,
        gg_unit_h006_0074,
        gg_rct_Right_Workshop,
        gg_rct_Left_Start_Top,
        gg_unit_h006_0055,
        3
    )
    spawn.addBase(
        "naga",
        gg_rct_Naga_Left,
        gg_rct_Right_Start_Top,
        gg_unit_nntt_0135,
        gg_rct_Naga_Right,
        gg_rct_Left_Start_Bottom,
        gg_unit_nntt_0132,
        1
    )
    spawn.addBase(
        "murloc",
        gg_rct_Murloc_Spawn_Left,
        gg_rct_Right_Start_Top,
        gg_unit_nmh1_0735,
        gg_rct_Murloc_Spawn_Right,
        gg_rct_Left_Start_Bottom,
        gg_unit_nmh1_0783,
        1
    )
    spawn.addBase(
        "nagaCreep",
        gg_rct_Naga_Left,
        gg_rct_Murloc_Left,
        gg_unit_nntt_0135,
        gg_rct_Naga_Right,
        gg_rct_Murloc_Right,
        gg_unit_nntt_0132,
        8
    )
    spawn.addBase(
        "nightElves",
        gg_rct_Left_Tree,
        gg_rct_Right_Start_Top,
        gg_unit_e003_0058,
        gg_rct_Right_Tree,
        gg_rct_Left_Start_Bottom,
        gg_unit_e003_0014,
        1
    )
    spawn.addBase(
        "orc",
        gg_rct_Left_Orc,
        gg_rct_Right_Start_Top,
        gg_unit_o001_0075,
        gg_rct_Right_Orc,
        gg_rct_Left_Start_Bottom,
        gg_unit_o001_0078,
        1
    )
    spawn.addBase(
        "shipyard",
        gg_rct_Left_Shipyard,
        gg_rct_Shipyard_End,
        gg_unit_eshy_0120,
        gg_rct_Right_Shipyard,
        gg_rct_Shipyard_End,
        gg_unit_eshy_0047,
        1
    )
    spawn.addBase(
        "hshipyard",
        gg_rct_Human_Shipyard_Left,
        gg_rct_Right_Shipyard,
        gg_unit_hshy_0011,
        gg_rct_Human_Shipyard_Right,
        gg_rct_Left_Shipyard,
        gg_unit_hshy_0212,
        3
    )
    spawn.addBase(
        "town",
        gg_rct_Left_Forward_Camp,
        gg_rct_Right_Start_Bottom,
        gg_unit_h00F_0029,
        gg_rct_Right_Forward,
        gg_rct_Left_Start_Top,
        gg_unit_h00F_0066,
        3
    )
    spawn.addBase(
        "undead",
        gg_rct_Undead_Left,
        gg_rct_Right_Start,
        gg_unit_u001_0262,
        gg_rct_Undead_Right,
        gg_rct_Left_Start,
        gg_unit_u001_0264,
        2
    )
end

function spawnAddUnits()
    -- addUnit(baseName, unitType, numOfUnits, {waves}, levelStart, levelEnd)

    -- Arcane Spawn
    spawn.addUnit("arcane", "h00C", 2, {5, 6, 7, 8, 9}, 3, 12) -- Sorcress
    spawn.addUnit("arcane", "hgry", 1, {2, 3, 4, 5, 6, 8, 10}, 10, 12) -- Gryphon Rider

    -- Arcane Creep Spawn
    spawn.addUnit("arcaneCreep", "narg", 2, {1, 2, 3, 4}, 2, 12) -- Battle Golem
    spawn.addUnit("arcaneCreep", "hwt2", 1, {1, 2, 3, 4}, 3, 12) -- Water Elemental (Level 2)
    spawn.addUnit("arcaneCreep", "hwt3", 1, {1, 2, 3, 4}, 4, 12) -- Water Elemental (Level 3)
    spawn.addUnit("arcaneCreep", "h00K", 1, {1, 2, 3, 4, 5, 10}, 6, 12) -- Magi Defender

    -- Arcane Hero Sapwn
    spawn.addUnit("arcaneHero", "n00A", 1, {5, 6}, 7, 12) -- Supreme Wizard
    spawn.addUnit("arcaneHero", "nsgg", 1, {4, 6}, 9, 12) -- Seige Golem

    -- Arcane Top Spawn
    spawn.addUnit("arcaneTop", "narg", 4, {4, 5, 6}, 2, 12) -- Battle Golem
    spawn.addUnit("arcaneTop", "hwt2", 1, {4, 5, 6}, 4, 12) -- Water Elemental (Level 2)
    spawn.addUnit("arcaneTop", "hwt3", 1, {5, 6}, 8, 12) -- Water Elemental (Level 3)

    -- Arcane Bottom Spawn
    spawn.addUnit("arcaneBottom", "narg", 4, {1, 2, 3}, 2, 12) -- Battle Golem
    spawn.addUnit("arcaneBottom", "hwt2", 1, {1, 2, 3}, 4, 12) -- Water Elemental (Level 2)
    spawn.addUnit("arcaneBottom", "hwt3", 1, {2, 3}, 8, 12) -- Water Elemental (Level 3)

    -- Blacksmith Spawn
    spawn.addUnit("blacksmith", "hfoo", 1, {1, 2, 3, 4, 5}, 3, 12) -- Footman 1
    spawn.addUnit("blacksmith", "h00L", 1, {1, 2, 3, 4}, 4, 12) -- Knight
    spawn.addUnit("blacksmith", "h00L", 1, {1, 2, 3, 4}, 5, 12) -- Knight
    spawn.addUnit("blacksmith", "h017", 1, {1, 2, 3}, 6, 12) -- Scarlet Commander
    spawn.addUnit("blacksmith", "hmtm", 1, {3, 8}, 7, 12) -- Catapult
    spawn.addUnit("blacksmith", "h00D", 1, {2}, 10, 12) -- Commander of the Guard

    -- Blacksmith Creep Spawn
    spawn.addUnit("blacksmithCreep", "h007", 4, {1, 2, 3, 4}, 1, 6) -- Militia
    spawn.addUnit("blacksmithCreep", "nhea", 1, {1, 2, 3, 4}, 3, 12) -- Archer
    spawn.addUnit("blacksmithCreep", "hspt", 1, {1, 2, 3, 4}, 5, 12) -- Tower Guard
    spawn.addUnit("blacksmithCreep", "h011", 2, {1, 2, 3, 4, 5}, 8, 12) -- Scarlet Commander
    spawn.addUnit("blacksmithCreep", "hcth", 2, {1, 2, 3, 4, 5}, 11, 12) -- Captian

    -- Castle Spawn
    spawn.addUnit("castle", "h018", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 8, 12) -- Commander

    -- City Elves
    spawn.addUnit("cityElves", "nhea", 1, {1, 2, 3, 4, 5, 6}, 1, 3) -- Archer
    spawn.addUnit("cityElves", "hspt", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 2, 3) -- Tower Guard
    spawn.addUnit("cityElves", "hspt", 2, {1, 2, 3, 4, 5, 6, 7}, 4, 5) -- Tower Guard
    spawn.addUnit("cityElves", "nchp", 1, {1, 2, 3, 4}, 3, 12) -- Mystic
    spawn.addUnit("cityElves", "hspt", 3, {1, 2, 3, 4, 5, 6}, 6, 12) -- Tower Guard
    spawn.addUnit("cityElves", "nhea", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 4, 12) -- Archer
    spawn.addUnit("cityElves", "nchp", 1, {1, 2, 3, 4, 5, 6, 7}, 7, 12) -- Mystic

    -- City Front Spawn
    spawn.addUnit("cityFront", "h007", 2, {2, 3, 4, 5, 6, 7}, 1, 2) -- Militia 1
    spawn.addUnit("cityFront", "h015", 3, {2, 3, 4, 5, 6, 7}, 3, 5) -- Militia 2
    spawn.addUnit("cityFront", "hfoo", 3, {2, 3, 4, 5, 6, 7}, 4, 12) -- Footman 1
    spawn.addUnit("cityFront", "hcth", 2, {2, 3, 4, 5, 6}, 6, 12) -- Captian

    -- City Side Spawn
    spawn.addUnit("citySide", "h015", 1, {6, 7, 8, 9, 10}, 1, 2) -- Militia 1
    spawn.addUnit("citySide", "hfoo", 2, {6, 7, 8, 9, 10}, 2, 12) -- Footman 1
    spawn.addUnit("citySide", "h015", 2, {1, 2, 3, 4, 6}, 3, 12) -- Militia 1

    -- Kobold Spawn
    spawn.addUnit("kobold", "nkob", 2, {1, 2, 3, 4, 5, 6, 7, 8, 9}, 1, 12) -- Kobold
    spawn.addUnit("kobold", "nkot", 1, {1, 2, 3, 5, 7, 9}, 3, 12) -- Kobold Tunneler
    spawn.addUnit("kobold", "nkog", 1, {1, 3, 5, 7, 9}, 4, 12) -- Kobold Geomancer
    spawn.addUnit("kobold", "nkol", 1, {4, 6, 8}, 5, 12) -- Kobold Taskmaster

    -- High Elves
    spawn.addUnit("highElves", "earc", 2, {1, 2, 3, 4, 5}, 1, 12) -- Ranger
    spawn.addUnit("highElves", "e000", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 2, 12) -- Elite Ranger
    spawn.addUnit("highElves", "hhes", 4, {1, 2, 3, 4}, 4, 12) -- Swordsman
    spawn.addUnit("highElves", "nemi", 1, {1, 2, 3, 4, 5, 6}, 5, 12) -- Emmisary

    -- High Elves Creep
    spawn.addUnit("highElvesCreep", "hhes", 2, {1, 2, 3, 4}, 1, 12) -- Swordsman
    spawn.addUnit("highElvesCreep", "nhea", 1, {1, 2, 3, 4, 5}, 2, 12) -- Archer
    spawn.addUnit("highElvesCreep", "nemi", 1, {1, 2, 3, 4}, 4, 12) -- Emmisary
    spawn.addUnit("highElvesCreep", "h010", 2, {1, 2, 3, 4, 5}, 5, 12) -- Elven Guardian

    -- Merc Spawn
    spawn.addUnit("merc", "nooL", 4, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 1, 12) -- Rogue
    spawn.addUnit("merc", "n003", 2, {4, 5, 6, 7, 8, 9, 10}, 2, 12) -- Merc Archer
    spawn.addUnit("merc", "n002", 3, {2, 3, 4, 7, 8, 9, 10}, 3, 12) -- Merc
    spawn.addUnit("merc", "n008", 1, {1, 2, 3, 4, 5, 6, 8, 9, 10}, 4, 12) -- Enforcer
    spawn.addUnit("merc", "nass", 1, {6, 7, 8, 9, 10}, 5, 12) -- Assasin
    spawn.addUnit("merc", "n004", 1, {7, 8, 9, 10}, 1, 12) -- Wizard Warrior
    spawn.addUnit("merc", "n005", 1, {7, 8, 9, 10}, 6, 12) -- Bandit Lord

    -- Mine Spawn
    spawn.addUnit("mine", "h001", 1, {2, 3, 4, 5, 6}, 2, 12) -- Morter Team
    spawn.addUnit("mine", "h008", 2, {1, 2, 3, 4, 5, 6, 7, 8}, 3, 12) -- Rifleman
    spawn.addUnit("mine", "h013", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 4, 12) -- Rifleman Long
    spawn.addUnit("mine", "ncg2", 2, {1, 2, 3, 4, 5, 6, 7}, 4, 12) -- Clockwerk Goblin
    spawn.addUnit("mine", "hmtt", 1, {1, 3, 5, 7}, 5, 12) -- Seige Engine
    spawn.addUnit("mine", "n00F", 1, {2, 3, 4, 5, 6, 7}, 6, 12) -- Automaton

    -- Murloc Spawn
    spawn.addUnit("murloc", "nmcf", 4, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 1, 12) -- Mur'gul Cliffrunner
    spawn.addUnit("murloc", "nnmg", 1, {2, 4, 6, 7, 8}, 2, 12) -- Mur'gul Reaver
    spawn.addUnit("murloc", "nmsn", 1, {1, 3, 4, 6, 9}, 3, 12) -- Mur'gul Snarecaster
    spawn.addUnit("murloc", "nmtw", 1, {1, 3, 6}, 6, 12) -- Mur'gul Tidewarrior

    -- Naga Spawn
    spawn.addUnit("naga", "nmyr", 2, {1, 3, 4, 6, 7, 9, 10}, 1, 12) -- Naga Myrmidon
    spawn.addUnit("naga", "nnsw", 1, {4, 5, 7, 9, 10}, 3, 12) -- Naga Siren
    spawn.addUnit("naga", "nnrg", 1, {5, 8, 9, 10}, 6, 12) -- Naga Royal Guard
    spawn.addUnit("naga", "nhyc", 1, {1, 3, 5, 8, 9}, 9, 12) -- Dragon Turtle

    -- Naga Creep Spawn
    spawn.addUnit("nagaCreep", "nmyr", 2, {1, 2, 3, 4}, 2, 12) -- Naga Myrmidon
    spawn.addUnit("nagaCreep", "nnsw", 1, {2, 3, 4, 5}, 3, 12) -- Naga Siren
    spawn.addUnit("nagaCreep", "nsnp", 2, {2, 3, 4, 5, 6}, 5, 12) -- Snap Dragon

    -- Night Elves Spawn
    spawn.addUnit("nightElves", "nwat", 1, {3, 4, 5, 6, 7, 8, 9}, 2, 12) -- Sentry
    spawn.addUnit("nightElves", "edry", 1, {1, 4, 5, 7, 9}, 3, 12) -- Dryad
    spawn.addUnit("nightElves", "edoc", 2, {1, 3, 5, 7, 9}, 4, 12) -- Druid of the Claw
    spawn.addUnit("nightElves", "e005", 1, {2, 4, 6, 8}, 5, 12) -- Mountain Giant
    spawn.addUnit("nightElves", "nwnr", 1, {5, 10}, 9, 12) -- Ent

    -- Orc Spawn
    spawn.addUnit("orc", "o002", 2, {1, 3, 4, 5, 6, 7, 8, 9, 10}, 1, 12) -- Grunt
    spawn.addUnit("orc", "o002", 2, {5, 6, 7, 8, 9}, 3, 12) -- Grunt
    spawn.addUnit("orc", "nftr", 1, {4, 5, 7, 8, 9, 10}, 2, 12) -- Spearman
    spawn.addUnit("orc", "nogo", 3, {2, 4, 6, 8, 10}, 4, 12) -- Ogre
    spawn.addUnit("orc", "nw2w", 1, {1, 3, 5, 7, 9}, 3, 12) -- Warlock
    spawn.addUnit("orc", "owad", 1, {1, 6, 9}, 6, 12) -- Orc Warchief
    -- spawn.addUnit("orc", "ocat", 1, {1,5}, 6, 12)  -- Demolisher

    -- Human Shipyard Spawn
    spawn.addUnit("hshipyard", "hdes", 1, {2, 4}, 1, 2) -- Human Frigate
    spawn.addUnit("hshipyard", "hdes", 1, {2, 4, 8}, 3, 4) -- Human Frigate
    spawn.addUnit("hshipyard", "hdes", 1, {2, 4, 6, 8}, 5, 12) -- Human Frigate
    spawn.addUnit("hshipyard", "hbsh", 1, {3, 8}, 6, 12) -- Human Battleship

    -- Night Elf Shipyard Spawn
    spawn.addUnit("shipyard", "edes", 1, {1, 6}, 2, 3) -- Night Elf Frigate
    spawn.addUnit("shipyard", "edes", 1, {1, 3, 6}, 4, 5) -- Night Elf Frigate
    spawn.addUnit("shipyard", "edes", 1, {1, 3, 6, 10}, 6, 12) -- Night Elf Frigate
    spawn.addUnit("shipyard", "ebsh", 1, {3, 7}, 7, 12) -- Night Elf Battleship

    -- Town Spawn
    spawn.addUnit("town", "h007", 3, {1, 2, 3, 4, 5}, 1, 5) -- Militia
    spawn.addUnit("town", "h007", 2, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 3, 12) -- Militia
    spawn.addUnit("town", "hcth", 1, {1, 2, 3, 4}, 2, 12) -- Captian
    spawn.addUnit("town", "n00X", 2, {1, 2, 3, 4, 6, 8}, 3, 12) -- Arbalist
    spawn.addUnit("town", "hfoo", 5, {1, 2, 5, 6, 8}, 5, 12) -- Footman
    spawn.addUnit("town", "h00L", 2, {1, 3, 7, 9}, 4, 12) -- Knight

    -- Undead Spawn
    spawn.addUnit("undead", "ugho", 4, {1, 2, 3, 4, 5, 6, 7, 8, 9}, 1, 12) -- Ghoul
    spawn.addUnit("undead", "uskm", 2, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 2, 12) -- Skeleton Mage
    spawn.addUnit("undead", "unec", 1, {1, 2, 3, 4, 5, 6, 7}, 3, 12) -- Necromancer
    spawn.addUnit("undead", "nerw", 1, {1, 6}, 4, 12) -- Warlock
    spawn.addUnit("undead", "nfgl", 1, {2, 5, 8}, 5, 12) -- Giant Skeleton

    return true
end

