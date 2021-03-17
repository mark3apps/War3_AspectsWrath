function init_triggers()
    Trig_moveToNext = CreateTrigger()
    Trig_spawnLoop = CreateTrigger()
    Trig_upgradeCreeps = CreateTrigger()
    Trig_AutoZoom = CreateTrigger()
    Trig_UnitEntersMap = CreateTrigger()
    Trig_UnitDies = CreateTrigger()
    Trig_IssuedOrder = CreateTrigger()
    Trig_aiLoopStates = CreateTrigger()
    Trig_baseLoop = CreateTrigger()
end



function addRegions()

    -- End Rects
    loc:add("arcaneLeft", gg_rct_Left_Mage_Base, "castleLeft", false)
    loc:add("arcaneRight", gg_rct_Right_Mage_Base, "castleRight", true)
    loc:add("castleLeft", gg_rct_Left_Hero)
    loc:add("castleRight", gg_rct_Right_Hero)
    loc:add("startLeft", gg_rct_Left_Start, "castleLeft", false)
    loc:add("startRight", gg_rct_Right_Start, "castleRight", true)
    loc:add("elfLeft", gg_rct_Elf_Base_Left, "castleLeft", false)
    loc:add("elfRight", gg_rct_Elf_Base_Right, "casteRight", true)

    -- Pathing Rects
    loc:add("everythingLeft", gg_rct_Left_Everything, "castleLeft", false)
    loc:add("everythingRight", gg_rct_Right_Everything, "castleRight", true)
    loc:add("bottomLeft", gg_rct_Left_Start_Bottom, "arcaneLeft", false)
    loc:add("bottomRight", gg_rct_Right_Start_Bottom, "elfRight", true)
    loc:add("middleLeft", gg_rct_Left_Start_Middle, "startLeft", false)
    loc:add("middleRight", gg_rct_Right_Start_Middle, "startRight", true)
    loc:add("topLeft", gg_rct_Left_Start_Top, "elfLeft", false)
    loc:add("topRight", gg_rct_Right_Start_Top, "arcaneRight", true)

    -- Spawn Rects
    loc:add("sArcaneLeft", gg_rct_Left_Arcane)
    loc:add("sArcaneRight", gg_rct_Right_Arcane)
    loc:add("sArcaneHeroLeft", gg_rct_Arcane_Hero_Left)
    loc:add("sArcaneHeroRight", gg_rct_Arcane_Hero_Right)
    loc:add("sCampLeft", gg_rct_Camp_Bottom)
    loc:add("sCampRight", gg_rct_Camp_Top)
    loc:add("sCityBlacksmithLeft", gg_rct_Blacksmith_Left)
    loc:add("sCityBlacksmithRight", gg_rct_Blacksmith_Right)
    loc:add("sCityElfLeft", gg_rct_City_Elves_Left)
    loc:add("sCityElfRight", gg_rct_City_Elves_Right)
    loc:add("sCityFrontLeft", gg_rct_Front_Town_Left)
    loc:add("sCityFrontRight", gg_rct_Front_City_Right)
    loc:add("sCitySideLeft", gg_rct_Left_City)
    loc:add("sCitySideRight", gg_rct_Right_City)
    loc:add("sElementalTopLeft", gg_rct_Arcane_Left_Top)
    loc:add("sElementalTopRight", gg_rct_Arcane_Right_Top)
    loc:add("sElementalBottomLeft", gg_rct_Arcane_Left_Bottom)
    loc:add("sElementalBottomRight", gg_rct_Arcane_Right_Bottom)
    loc:add("sElfLeft", gg_rct_Left_High_Elves)
    loc:add("sElfRight", gg_rct_Right_High_Elves)
    loc:add("sElfShipyardLeft", gg_rct_Left_Shipyard)
    loc:add("sElfShipyardRight", gg_rct_Right_Shipyard)
    loc:add("sHeroLeft", gg_rct_Left_Hero)
    loc:add("sHeroRight", gg_rct_Right_Hero)
    loc:add("sHumanShipyardLeft", gg_rct_Human_Shipyard_Left)
    loc:add("sHumanShipyardRight", gg_rct_Human_Shipyard_Right)
    loc:add("sKolboldLeft", gg_rct_Furbolg_Left)
    loc:add("sKolboldRight", gg_rct_Furbolg_Right)
    loc:add("sMurlocLeft", gg_rct_Murloc_Spawn_Left)
    loc:add("sMurlocRight", gg_rct_Murloc_Spawn_Right)
    loc:add("sNagaLeft", gg_rct_Naga_Left)
    loc:add("sNagaRight", gg_rct_Naga_Right)
    loc:add("sOrcLeft", gg_rct_Left_Orc)
    loc:add("sOrcRight", gg_rct_Right_Orc)
    loc:add("sTownLeft", gg_rct_Left_Forward_Camp)
    loc:add("sTownRight", gg_rct_Right_Forward)
    loc:add("sTreeLeft", gg_rct_Left_Tree)
    loc:add("sTreeRight", gg_rct_Right_Tree)
    loc:add("sWorkshopLeft", gg_rct_Left_Workshop)
    loc:add("sWorkshopRight", gg_rct_Right_Workshop)
    loc:add("sUndeadLeft", gg_rct_Undead_Left)
    loc:add("sUndeadRight", gg_rct_Undead_Right)

    -- Creep Rects
    loc:add("cForestLeft", gg_rct_Aspect_of_Forest_Left, "topRight", true)
    loc:add("cForestRight", gg_rct_Aspect_of_Forest_Right, "bottomLeft", false)
    loc:add("cTidesLeft", gg_rct_Murloc_Left, "topRight", true)
    loc:add("cTidesRight", gg_rct_Murloc_Right, "bottomLeft", false)
    loc:add("cDeathMidLeft", gg_rct_Zombie_Mid_Left, "cDeathLeft", true)
    loc:add("cDeathLeft", gg_rct_Zombie_End_Left , "middleRight", true)
    loc:add("cDeathMidRight", gg_rct_Zombie_Mid_Right, "cDeathRight", false)
    loc:add("cDeathRight", gg_rct_Zombie_End_Right, "middleLeft", false)
    loc:add("cStormLeft", gg_rct_Left_Elemental_Start, "bottomRight", true)
    loc:add("cStormRight", gg_rct_Right_Elemental_Start, "topLeft", false)

    -- Define Big Regions
    bottomRegion = CreateRegion()
    middleRegion = CreateRegion()
    topRegion = CreateRegion()

    RegionAddRect(bottomRegion, gg_rct_Big_Bottom_Left)
    RegionAddRect(bottomRegion, gg_rct_Big_Bottom_Left_Center)
    RegionAddRect(bottomRegion, gg_rct_Big_Bottom_Right_Center)
    RegionAddRect(bottomRegion, gg_rct_Big_Bottom_Right)

    RegionAddRect(middleRegion, gg_rct_Big_Middle_Left)
    RegionAddRect(middleRegion, gg_rct_Big_Middle_Left_Center)
    RegionAddRect(middleRegion, gg_rct_Big_Middle_Right_Center)
    RegionAddRect(middleRegion, gg_rct_Big_Middle_Right)

    RegionAddRect(topRegion, gg_rct_Big_Top_Left)
    RegionAddRect(topRegion, gg_rct_Big_Top_Left_Center)
    RegionAddRect(topRegion, gg_rct_Big_Top_Right_Center)
    RegionAddRect(topRegion, gg_rct_Big_Top_Right)
end

function addBases()

    base.add(gg_unit_h003_0015, 3, false, true, true, true) -- Allied Arcane Main
    base.add(gg_unit_h003_0007, 3, false, true, true, true) -- Federation Arcane Main

    base.add(gg_unit_h014_0017, 2, false, true, true, false) -- Allied Arcane Hero
    base.add(gg_unit_h014_0158, 2, false, true, true, false) -- Federation

    base.add(gg_unit_hars_0355, 1, false, true, true, false) -- Allied Arcane Top
    base.add(gg_unit_hars_0293, 1, false, true, true, false) -- Federation
    
    base.add(gg_unit_hars_0292, 1, false, true, true, false) -- Allied Arcane Bottom
    base.add(gg_unit_hars_0303, 1, false, true, true, false) -- Federation
    
    base.add(gg_unit_n00K_0802, 2, false, true, true, true) -- Allied Blacksmith
    base.add(gg_unit_n00K_0477, 2, false, true, true, true) -- Federation
    
    base.add(gg_unit_h00E_0033, 8, true, true, true, true) -- Allied Castle
    base.add(gg_unit_h00E_0081, 8, true, true, true, true) -- Federation
    
    base.add(gg_unit_hvlt_0207, 2, false, true, true, true) -- Allied City Elves
    base.add(gg_unit_hvlt_0406, 2, false, true, true, true) -- Federation
    
    base.add(gg_unit_n00B_0364, 1, false, true, true, true) -- Allied City Front
    base.add(gg_unit_n00B_0399, 1, false, true, true, true) -- Federation
    
    base.add(gg_unit_n00B_0102, 1, false, true, true, true) -- Allied City Side
    base.add(gg_unit_n00B_0038, 1, false, true, true, true) -- Federation
    
    base.add(gg_unit_ngt2_0525, 1, false, true, true, true) -- Allied Kobold
    base.add(gg_unit_ngt2_0455, 1, false, true, true, true) -- Federation
    
    base.add(gg_unit_nheb_0109, 3, false, true, true, true) -- Allied High Elves
    base.add(gg_unit_nheb_0036, 3, false, true, true, true) -- Federation
    
    base.add(gg_unit_n001_0048, 2, false, true, true, true) -- Allied Merc Camp
    base.add(gg_unit_n001_0049, 2, false, true, true, true) -- Federation
        
    base.add(gg_unit_h006_0074, 2, false, true, true, true) -- Allied Mine
    base.add(gg_unit_h006_0055, 2, false, true, true, true) -- Federation
        
    base.add(gg_unit_nmh1_0735, 1, false, true, true, false) -- Allied Murloc
    base.add(gg_unit_nmh1_0783, 1, false, true, true, false) -- Federation
        
    base.add(gg_unit_nntt_0135, 2, false, true, true, true) -- Allied Naga
    base.add(gg_unit_nntt_0132, 2, false, true, true, true) -- Federation
        
    base.add(gg_unit_e003_0058, 3, false, true, true, true) -- Allied Night Elves
    base.add(gg_unit_e003_0014, 3, false, true, true, true) -- Federation
            
    base.add(gg_unit_o001_0075, 2, false, true, true, true) -- Allied Orcs
    base.add(gg_unit_o001_0078, 2, false, true, true, true) -- Federation
            
    base.add(gg_unit_eshy_0120, 1, false, true, true, false) -- Allied Night Elf Shipyard
    base.add(gg_unit_eshy_0047, 1, false, true, true, false) -- Federation
            
    base.add(gg_unit_hshy_0011, 1, false, true, true, false) -- Allied Human Shipyard
    base.add(gg_unit_hshy_0212, 1, false, true, true, false) -- Federation
            
    base.add(gg_unit_h00F_0029, 2, false, true, true, true) -- Allied Town
    base.add(gg_unit_h00F_0066, 2, false, true, true, true) -- Federation
                
    base.add(gg_unit_u001_0262, 2, false, true, true, true) -- Federation Undead
    base.add(gg_unit_u001_0264, 2, false, true, true, true) -- Federation
end

function Init_luaGlobals()

    oid = {
        OFFSET = 851970,
        absorb = 852529,
        acidbomb = 852662,
        acolyteharvest = 852185,
        AImove = 851988,
        ambush = 852131,
        ancestralspirit = 852490,
        ancestralspirittarget = 852491,
        animatedead = 852217,
        antimagicshell = 852186,
        attack = 851983,
        attackground = 851984,
        attackonce = 851985,
        attributemodskill = 852576,
        auraunholy = 852215,
        auravampiric = 852216,
        autodispel = 852132,
        autodispeloff = 852134,
        autodispelon = 852133,
        autoentangle = 852505,
        autoentangleinstant = 852506,
        autoharvestgold = 852021,
        autoharvestlumber = 852022,
        avatar = 852086,
        avengerform = 852531,
        awaken = 852466,
        banish = 852486,
        barkskin = 852135,
        barkskinoff = 852137,
        barkskinon = 852136,
        battleroar = 852099,
        battlestations = 852099,
        bearform = 852138,
        berserk = 852100,
        blackarrow = 852577,
        blackarrowoff = 852579,
        blackarrowon = 852578,
        blight = 852187,
        blink = 852525,
        blizzard = 852089,
        bloodlust = 852101,
        bloodlustoff = 852103,
        bloodluston = 852102,
        board = 852043,
        breathoffire = 852580,
        breathoffrost = 852560,
        build = 851994,
        burrow = 852533,
        cannibalize = 852188,
        carrionscarabs = 852551,
        carrionscarabsinstant = 852554,
        carrionscarabsoff = 852553,
        carrionscarabson = 852552,
        carrionswarm = 852218,
        chainlightning = 852119,
        channel = 852600,
        charm = 852581,
        chemicalrage = 852663,
        cloudoffog = 852473,
        clusterrockets = 852652,
        coldarrows = 852244,
        coldarrowstarg = 852243,
        controlmagic = 852474,
        corporealform = 852493,
        corrosivebreath = 852140,
        coupleinstant = 852508,
        coupletarget = 852507,
        creepanimatedead = 852246,
        creepdevour = 852247,
        creepheal = 852248,
        creephealoff = 852250,
        creephealon = 852249,
        creepthunderbolt = 852252,
        creepthunderclap = 852253,
        cripple = 852189,
        curse = 852190,
        curseoff = 852192,
        curseon = 852191,
        cyclone = 852144,
        darkconversion = 852228,
        darkportal = 852229,
        darkritual = 852219,
        darksummoning = 852220,
        deathanddecay = 852221,
        deathcoil = 852222,
        deathpact = 852223,
        decouple = 852509,
        defend = 852055,
        detectaoe = 852015,
        detonate = 852145,
        devour = 852104,
        devourmagic = 852536,
        disassociate = 852240,
        disenchant = 852495,
        dismount = 852470,
        dispel = 852057,
        divineshield = 852090,
        doom = 852583,
        drain = 852487,
        dreadlordinferno = 852224,
        dropitem = 852001,
        drunkenhaze = 852585,
        earthquake = 852121,
        eattree = 852146,
        elementalfury = 852586,
        ensnare = 852106,
        ensnareoff = 852108,
        ensnareon = 852107,
        entangle = 852147,
        entangleinstant = 852148,
        entanglingroots = 852171,
        etherealform = 852496,
        evileye = 852105,
        faeriefire = 852149,
        faeriefireoff = 852151,
        faeriefireon = 852150,
        fanofknives = 852526,
        farsight = 852122,
        fingerofdeath = 852230,
        firebolt = 852231,
        flamestrike = 852488,
        flamingarrows = 852174,
        flamingarrowstarg = 852173,
        flamingattack = 852540,
        flamingattacktarg = 852539,
        flare = 852060,
        forceboard = 852044,
        forceofnature = 852176,
        forkedlightning = 852586,
        freezingbreath = 852195,
        frenzy = 852561,
        frenzyoff = 852563,
        frenzyon = 852562,
        frostarmor = 852225,
        frostarmoroff = 852459,
        frostarmoron = 852458,
        frostnova = 852226,
        getitem = 851981,
        gold2lumber = 852233,
        grabtree = 852511,
        harvest = 852018,
        heal = 852063,
        healingspray = 852664,
        healingward = 852109,
        healingwave = 852501,
        healoff = 852065,
        healon = 852064,
        hex = 852502,
        holdposition = 851993,
        holybolt = 852092,
        howlofterror = 852588,
        humanbuild = 851995,
        immolation = 852177,
        impale = 852555,
        incineratearrow = 852670,
        incineratearrowoff = 852672,
        incineratearrowon = 852671,
        inferno = 852232,
        innerfire = 852066,
        innerfireoff = 852068,
        innerfireon = 852067,
        instant = 852200,
        invisibility = 852069,
        itemillusion = 852274,
        lavamonster = 852667,
        lightningshield = 852110,
        load = 852046,
        loadarcher = 852142,
        loadcorpse = 852050,
        loadcorpseinstant = 852053,
        locustswarm = 852556,
        lumber2gold = 852234,
        magicdefense = 852478,
        magicleash = 852480,
        magicundefense = 852479,
        manaburn = 852179,
        manaflareoff = 852513,
        manaflareon = 852512,
        manashieldoff = 852590,
        manashieldon = 852589,
        massteleport = 852093,
        mechanicalcritter = 852564,
        metamorphosis = 852180,
        militia = 852072,
        militiaconvert = 852071,
        militiaoff = 852073,
        militiaunconvert = 852651,
        mindrot = 852565,
        mirrorimage = 852123,
        monsoon = 852591,
        mount = 852469,
        mounthippogryph = 852143,
        move = 851986,
        nagabuild = 852467,
        neutraldetectaoe = 852023,
        neutralinteract = 852566,
        neutralspell = 852630,
        nightelfbuild = 851997,
        orcbuild = 851996,
        parasite = 852601,
        parasiteoff = 852603,
        parasiteon = 852602,
        patrol = 851990,
        phaseshift = 852514,
        phaseshiftinstant = 852517,
        phaseshiftoff = 852516,
        phaseshifton = 852515,
        phoenixfire = 852481,
        phoenixmorph = 852482,
        poisonarrows = 852255,
        poisonarrowstarg = 852254,
        polymorph = 852074,
        possession = 852196,
        preservation = 852568,
        purge = 852111,
        rainofchaos = 852237,
        rainoffire = 852238,
        raisedead = 852197,
        raisedeadoff = 852199,
        raisedeadon = 852198,
        ravenform = 852155,
        recharge = 852157,
        rechargeoff = 852159,
        rechargeon = 852158,
        rejuvination = 852160,
        renew = 852161,
        renewoff = 852163,
        renewon = 852162,
        repair = 852024,
        repairoff = 852026,
        repairon = 852025,
        replenish = 852542,
        replenishlife = 852545,
        replenishlifeoff = 852547,
        replenishlifeon = 852546,
        replenishmana = 852548,
        replenishmanaoff = 852550,
        replenishmanaon = 852549,
        replenishoff = 852544,
        replenishon = 852543,
        request_hero = 852239,
        requestsacrifice = 852201,
        restoration = 852202,
        restorationoff = 852204,
        restorationon = 852203,
        resumebuild = 851999,
        resumeharvesting = 852017,
        resurrection = 852094,
        returnresources = 852020,
        revenge = 852241,
        revive = 852039,
        reveal = 852270,
        roar = 852164,
        robogoblin = 852656,
        root = 852165,
        sacrifice = 852205,
        sanctuary = 852569,
        scout = 852181,
        selfdestruct = 852040,
        selfdestructoff = 852042,
        selfdestructon = 852041,
        sentinel = 852182,
        setrally = 851980,
        shadowsight = 852570,
        shadowstrike = 852527,
        shockwave = 852125,
        silence = 852592,
        sleep = 852227,
        slow = 852075,
        slowoff = 852077,
        slowon = 852076,
        smart = 851971,
        soulburn = 852668,
        soulpreservation = 852242,
        spellshield = 852571,
        spellshieldaoe = 852572,
        spellsteal = 852483,
        spellstealoff = 852485,
        spellstealon = 852484,
        spies = 852235,
        spiritlink = 852499,
        spiritofvengeance = 852528,
        spirittroll = 852573,
        spiritwolf = 852126,
        stampede = 852593,
        standdown = 852113,
        starfall = 852183,
        stasistrap = 852114,
        steal = 852574,
        stomp = 852127,
        stoneform = 852206,
        stop = 851972,
        submerge = 852604,
        summonfactory = 852658,
        summongrizzly = 852594,
        summonphoenix = 852489,
        summonquillbeast = 852595,
        summonwareagle = 852596,
        tankdroppilot = 852079,
        tankloadpilot = 852080,
        tankpilot = 852081,
        taunt = 852520,
        thunderbolt = 852095,
        thunderclap = 852096,
        tornado = 852597,
        townbelloff = 852083,
        townbellon = 852082,
        tranquility = 852184,
        transmute = 852665,
        unavatar = 852087,
        unavengerform = 852532,
        unbearform = 852139,
        unburrow = 852534,
        uncoldarrows = 852245,
        uncorporealform = 852494,
        undeadbuild = 851998,
        undefend = 852056,
        undivineshield = 852091,
        unetherealform = 852497,
        unflamingarrows = 852175,
        unflamingattack = 852541,
        unholyfrenzy = 852209,
        unimmolation = 852178,
        unload = 852047,
        unloadall = 852048,
        unloadallcorpses = 852054,
        unloadallinstant = 852049,
        unpoisonarrows = 852256,
        unravenform = 852156,
        unrobogoblin = 852657,
        unroot = 852166,
        unstableconcoction = 852500,
        unstoneform = 852207,
        unsubmerge = 852605,
        unsummon = 852210,
        unwindwalk = 852130,
        vengeance = 852521,
        vengeanceinstant = 852524,
        vengeanceoff = 852523,
        vengeanceon = 852522,
        volcano = 852669,
        voodoo = 852503,
        ward = 852504,
        waterelemental = 852097,
        wateryminion = 852598,
        web = 852211,
        weboff = 852213,
        webon = 852212,
        whirlwind = 852128,
        windwalk = 852129,
        wispharvest = 852214,
        scrollofspeed = 852285,
        cancel = 851976,
        moveslot1 = 852002,
        moveslot2 = 852003,
        moveslot3 = 852004,
        moveslot4 = 852005,
        moveslot5 = 852006,
        moveslot6 = 852007,
        useslot1 = 852008,
        useslot2 = 852009,
        useslot3 = 852010,
        useslot4 = 852011,
        useslot5 = 852012,
        useslot6 = 852013,
        skillmenu = 852000,
        stunned = 851973,
        instant1 = 851991,
        instant2 = 851987,
        instant3 = 851975,
        instant4 = 852019
    }
    ordersIgnore = {
        waterelemental = oid.waterelemental,
        forkedlightning = oid.forkedlightning,
        frostarmor = oid.frostarmor,
        stomp = oid.stomp,
        faeriefire = oid.faeriefire,
        purge = oid.purge,
        rainoffire = oid.rainoffire,
        attack = oid.attack,
        stop = oid.stop,
        rejuvination = oid.rejuvination,
        bloodlust = oid.bloodlust,
        defend = oid.defend,
        undefend = oid.undefend,
        lightningshield = oid.lightningshield,
        spellsteal = oid.spellsteal,
        roar = oid.roar,
        slow = oid.slow,
        dispel = oid.dispel,
        bearform = oid.bearform,
        unbearform = oid.unbearform,
        polymorph = oid.polymorph,
        breathoffrost = oid.breathoffrost,
        curse = oid.curse,
        parasite = oid.parasite,
        innerfire = oid.innerfire,
        recharge = oid.recharge,
        carrionswarm = oid.carrionswarm,
        thunderclap = oid.thunderclap,
        holybolt = oid.holybolt,
        shockwave = oid.shockwave,
        berserk = oid.berserk,
        locustswarm = oid.locustswarm,
        chainlightning = oid.chainlightning,
        coldarrows = oid.coldarrows,
        ensnare = oid.ensnare,
        magicdefense = oid.magicdefense,
        magicundefense = oid.magicundefense,
        devourmagic = oid.devourmagic,
        summonwareagle = oid.summonwareagle,
        whirlwind = oid.whirlwind,
        flamingarrows = oid.flamingarrows,
        parasiteon = oid.parasiteon
    }
end

-- Spawn Set up
function spawnAddBases()
    -- addBase(baseName, alliedStart, alliedEnd, alliedCondition, fedStart, fedEnd, fedCondition, destination)

    spawn:addBase("arcane", "sArcaneLeft", "bottomRight", gg_unit_h003_0015, "sArcaneRight", "topLeft",
        gg_unit_h003_0007)
    spawn:addBase("arcaneCreep", "sArcaneLeft", "cStormLeft", gg_unit_h003_0015, "sArcaneRight", "cStormRight",
        gg_unit_h003_0007)
    spawn:addBase("arcaneHero", "sArcaneHeroLeft", "bottomRight", gg_unit_h014_0017, "sArcaneHeroRight", "topLeft",
        gg_unit_h014_0158)
    spawn:addBase("arcaneTop", "sElementalTopLeft", "bottomRight", gg_unit_hars_0355, "sElementalTopRight", "topLeft",
        gg_unit_hars_0293)
    spawn:addBase("arcaneBottom", "sElementalBottomLeft", "bottomRight", gg_unit_hars_0292, "sElementalBottomRight",
        "topLeft", gg_unit_hars_0303)
    spawn:addBase("blacksmith", "sCityBlacksmithLeft", "everythingRight", gg_unit_n00K_0802, "sCityBlacksmithRight",
        "everythingLeft", gg_unit_n00K_0477)
    spawn:addBase("blacksmithCreep", "sCityBlacksmithLeft", "cDeathMidLeft", gg_unit_n00K_0802, "sCityBlacksmithRight",
        "cDeathMidRight", gg_unit_n00K_0477)
    spawn:addBase("castle", "sHeroLeft", "everythingRight", gg_unit_h00E_0033, "sHeroRight", "everythingLeft",
        gg_unit_h00E_0081)
    spawn:addBase("cityElves", "sCityElfLeft", "everythingRight", gg_unit_hvlt_0207, "sCityElfRight", "everythingLeft",
        gg_unit_hvlt_0406)
    spawn:addBase("cityFront", "sCityFrontLeft", "middleRight", gg_unit_n00B_0364, "sCityFrontRight", "middleLeft",
        gg_unit_n00B_0399)
    spawn:addBase("citySide", "sCitySideLeft", "bottomRight", gg_unit_n00B_0102, "sCitySideRight", "topLeft",
        gg_unit_n00B_0038)
    spawn:addBase("kobold", "sKolboldLeft", "topRight", gg_unit_ngt2_0525, "sKolboldRight", "bottomLeft",
        gg_unit_ngt2_0455)
    spawn:addBase("highElves", "sElfLeft", "topRight", gg_unit_nheb_0109, "sElfRight", "bottomLeft", gg_unit_nheb_0036)
    spawn:addBase("highElvesCreep", "sElfLeft", "cForestLeft", gg_unit_nheb_0109, "sElfRight", "cForestRight",
        gg_unit_nheb_0036)
    spawn:addBase("merc", "sCampLeft", "bottomRight", gg_unit_n001_0048, "sCampRight", "topLeft", gg_unit_n001_0049)
    spawn:addBase("mine", "sWorkshopLeft", "bottomRight", gg_unit_h006_0074, "sWorkshopRight", "topLeft",
        gg_unit_h006_0055)
    spawn:addBase("naga", "sNagaLeft", "topRight", gg_unit_nntt_0135, "sNagaRight", "bottomLeft", gg_unit_nntt_0132)
    spawn:addBase("murloc", "sMurlocLeft", "topRight", gg_unit_nmh1_0735, "sMurlocRight", "bottomLeft",
        gg_unit_nmh1_0783)
    spawn:addBase("nagaCreep", "sNagaLeft", "cTidesLeft", gg_unit_nntt_0135, "sNagaRight", "cTidesRight",
        gg_unit_nntt_0132)
    spawn:addBase("nightElves", "sTreeLeft", "topRight", gg_unit_e003_0058, "sTreeRight", "bottomLeft",
        gg_unit_e003_0014)
    spawn:addBase("orc", "sOrcLeft", "topRight", gg_unit_o001_0075, "sOrcRight", "bottomLeft", gg_unit_o001_0078)
    spawn:addBase("shipyard", "sElfShipyardLeft", "sHumanShipyardRight", gg_unit_eshy_0120, "sElfShipyardRight",
        "sHumanShipyardLeft", gg_unit_eshy_0047)
    spawn:addBase("hshipyard", "sHumanShipyardLeft", "sHumanShipyardRight", gg_unit_hshy_0011, "sHumanShipyardRight",
        "sHumanShipyardLeft", gg_unit_hshy_0212, 3)
    spawn:addBase("town", "sTownLeft", "bottomRight", gg_unit_h00F_0029, "sTownRight", "topLeft", gg_unit_h00F_0066)
    spawn:addBase("undead", "sUndeadLeft", "middleRight", gg_unit_u001_0262, "sUndeadRight", "middleLeft",
        gg_unit_u001_0264)
end

function spawnAddUnits()
    -- addUnit(baseName, unitType, numOfUnits, {waves}, levelStart, levelEnd)

    -- Arcane Spawn
    spawn:addUnit("arcane", "h00C", 2, {5, 6, 7, 8, 9}, 3, 12) -- Sorcress
    spawn:addUnit("arcane", "hgry", 1, {2, 3, 4, 5, 6, 8, 10}, 10, 12) -- Gryphon Rider

    -- Arcane Creep Spawn
    spawn:addUnit("arcaneCreep", "narg", 2, {1, 2, 3, 4}, 2, 12) -- Battle Golem
    spawn:addUnit("arcaneCreep", "hwt2", 1, {1, 2, 3, 4}, 3, 12) -- Water Elemental (Level 2)
    spawn:addUnit("arcaneCreep", "hwt3", 1, {1, 2, 3, 4}, 4, 12) -- Water Elemental (Level 3)
    spawn:addUnit("arcaneCreep", "h00K", 1, {1, 2, 3, 4, 5, 10}, 6, 12) -- Magi Defender

    -- Arcane Hero Sapwn
    spawn:addUnit("arcaneHero", "n00A", 1, {5, 6}, 7, 12) -- Supreme Wizard
    spawn:addUnit("arcaneHero", "nsgg", 1, {4, 6}, 9, 12) -- Seige Golem

    -- Arcane Top Spawn
    spawn:addUnit("arcaneTop", "narg", 4, {4, 5, 6}, 2, 12) -- Battle Golem
    spawn:addUnit("arcaneTop", "hwt2", 1, {4, 5, 6}, 4, 12) -- Water Elemental (Level 2)
    spawn:addUnit("arcaneTop", "hwt3", 1, {5, 6}, 8, 12) -- Water Elemental (Level 3)

    -- Arcane Bottom Spawn
    spawn:addUnit("arcaneBottom", "narg", 4, {1, 2, 3}, 2, 12) -- Battle Golem
    spawn:addUnit("arcaneBottom", "hwt2", 1, {1, 2, 3}, 4, 12) -- Water Elemental (Level 2)
    spawn:addUnit("arcaneBottom", "hwt3", 1, {2, 3}, 8, 12) -- Water Elemental (Level 3)

    -- Blacksmith Spawn
    spawn:addUnit("blacksmith", "hfoo", 1, {1, 2, 3, 4, 5}, 3, 12) -- Footman 1
    spawn:addUnit("blacksmith", "h00L", 1, {1, 2, 3, 4}, 4, 12) -- Knight
    spawn:addUnit("blacksmith", "h00L", 1, {1, 2, 3, 4}, 5, 12) -- Knight
    spawn:addUnit("blacksmith", "h017", 1, {1, 2, 3}, 6, 12) -- Scarlet Commander
    spawn:addUnit("blacksmith", "hmtm", 1, {3, 8}, 7, 12) -- Catapult
    spawn:addUnit("blacksmith", "h00D", 1, {2}, 10, 12) -- Commander of the Guard

    -- Blacksmith Creep Spawn
    spawn:addUnit("blacksmithCreep", "h007", 4, {1, 2, 3, 4}, 1, 6) -- Militia
    spawn:addUnit("blacksmithCreep", "nhea", 1, {1, 2, 3, 4}, 3, 12) -- Archer
    spawn:addUnit("blacksmithCreep", "hspt", 1, {1, 2, 3, 4}, 5, 12) -- Tower Guard
    spawn:addUnit("blacksmithCreep", "h011", 2, {1, 2, 3, 4, 5}, 8, 12) -- Scarlet Commander
    spawn:addUnit("blacksmithCreep", "hcth", 2, {1, 2, 3, 4, 5}, 11, 12) -- Captian

    -- Castle Spawn
    spawn:addUnit("castle", "h018", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 8, 12) -- Commander

    -- City Elves
    spawn:addUnit("cityElves", "nhea", 1, {1, 2, 3, 4, 5, 6}, 1, 3) -- Archer
    spawn:addUnit("cityElves", "hspt", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 2, 3) -- Tower Guard
    spawn:addUnit("cityElves", "hspt", 2, {1, 2, 3, 4, 5, 6, 7}, 4, 5) -- Tower Guard
    spawn:addUnit("cityElves", "nchp", 1, {1, 2, 3, 4}, 3, 12) -- Mystic
    spawn:addUnit("cityElves", "hspt", 3, {1, 2, 3, 4, 5, 6}, 6, 12) -- Tower Guard
    spawn:addUnit("cityElves", "nhea", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 4, 12) -- Archer
    spawn:addUnit("cityElves", "nchp", 1, {1, 2, 3, 4, 5, 6, 7}, 7, 12) -- Mystic

    -- City Front Spawn
    spawn:addUnit("cityFront", "h007", 2, {2, 3, 4, 5, 6, 7}, 1, 2) -- Militia 1
    spawn:addUnit("cityFront", "h015", 3, {2, 3, 4, 5, 6, 7}, 1, 5) -- Militia 2
    spawn:addUnit("cityFront", "hfoo", 3, {2, 3, 4, 5, 6, 7}, 4, 12) -- Footman 1
    spawn:addUnit("cityFront", "hcth", 2, {2, 3, 4, 5, 6}, 6, 12) -- Captian

    -- City Side Spawn
    spawn:addUnit("citySide", "h015", 1, {6, 7, 8, 9, 10}, 1, 2) -- Militia 1
    spawn:addUnit("citySide", "hfoo", 2, {6, 7, 8, 9, 10}, 2, 12) -- Footman 1
    spawn:addUnit("citySide", "h015", 2, {1, 2, 3, 4, 6}, 3, 12) -- Militia 1

    -- Kobold Spawn
    spawn:addUnit("kobold", "nkob", 2, {1, 2, 3, 4, 5, 6, 7, 8, 9}, 1, 12) -- Kobold
    spawn:addUnit("kobold", "nkot", 1, {1, 2, 3, 5, 7, 9}, 3, 12) -- Kobold Tunneler
    spawn:addUnit("kobold", "nkog", 1, {1, 3, 5, 7, 9}, 4, 12) -- Kobold Geomancer
    spawn:addUnit("kobold", "nkol", 1, {4, 6, 8}, 5, 12) -- Kobold Taskmaster

    -- High Elves
    spawn:addUnit("highElves", "earc", 2, {1, 2, 3, 4, 5}, 1, 12) -- Ranger
    spawn:addUnit("highElves", "e000", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 2, 12) -- Elite Ranger
    spawn:addUnit("highElves", "hhes", 4, {1, 2, 3, 4}, 4, 12) -- Swordsman
    spawn:addUnit("highElves", "nemi", 1, {1, 2, 3, 4, 5, 6}, 5, 12) -- Emmisary

    -- High Elves Creep
    spawn:addUnit("highElvesCreep", "hhes", 2, {1, 2, 3, 4}, 1, 12) -- Swordsman
    spawn:addUnit("highElvesCreep", "nhea", 1, {1, 2, 3, 4, 5}, 2, 12) -- Archer
    spawn:addUnit("highElvesCreep", "nemi", 1, {1, 2, 3, 4}, 4, 12) -- Emmisary
    spawn:addUnit("highElvesCreep", "h010", 2, {1, 2, 3, 4, 5}, 5, 12) -- Elven Guardian

    -- Merc Spawn
    spawn:addUnit("merc", "n00L", 3, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 1, 12) -- Rogue
    spawn:addUnit("merc", "n003", 2, {4, 5, 6, 7, 8, 9, 10}, 2, 12) -- Merc Archer
    spawn:addUnit("merc", "n002", 3, {2, 3, 4, 7, 8, 9, 10}, 3, 12) -- Merc
    spawn:addUnit("merc", "n008", 1, {1, 2, 3, 4, 5, 6, 8, 9, 10}, 4, 12) -- Enforcer
    spawn:addUnit("merc", "nass", 1, {6, 7, 8, 9, 10}, 5, 12) -- Assasin
    spawn:addUnit("merc", "n004", 1, {7, 8, 9, 10}, 1, 12) -- Wizard Warrior
    spawn:addUnit("merc", "n005", 1, {7, 8, 9, 10}, 6, 12) -- Bandit Lord

    -- Mine Spawn
    spawn:addUnit("mine", "h001", 1, {2, 3, 4, 5, 6}, 2, 12) -- Morter Team
    spawn:addUnit("mine", "h008", 2, {1, 2, 3, 4, 5, 6, 7, 8}, 3, 12) -- Rifleman
    spawn:addUnit("mine", "h013", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 4, 12) -- Rifleman Long
    spawn:addUnit("mine", "ncg2", 2, {1, 2, 3, 4, 5, 6, 7}, 4, 12) -- Clockwerk Goblin
    spawn:addUnit("mine", "hmtt", 1, {1, 3, 5, 7}, 5, 12) -- Seige Engine
    spawn:addUnit("mine", "n00F", 1, {2, 3, 4, 5, 6, 7}, 6, 12) -- Automaton

    -- Murloc Spawn
    spawn:addUnit("murloc", "nmcf", 4, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 1, 12) -- Mur'gul Cliffrunner
    spawn:addUnit("murloc", "nnmg", 1, {2, 4, 6, 7, 8}, 2, 12) -- Mur'gul Reaver
    spawn:addUnit("murloc", "nmsn", 1, {1, 3, 4, 6, 9}, 3, 12) -- Mur'gul Snarecaster
    spawn:addUnit("murloc", "nmtw", 1, {1, 3, 6}, 6, 12) -- Mur'gul Tidewarrior

    -- Naga Spawn
    spawn:addUnit("naga", "nmyr", 2, {1, 3, 4, 6, 7, 9, 10}, 1, 12) -- Naga Myrmidon
    spawn:addUnit("naga", "nnsw", 1, {4, 5, 7, 9, 10}, 3, 12) -- Naga Siren
    spawn:addUnit("naga", "nnrg", 1, {5, 8, 9, 10}, 6, 12) -- Naga Royal Guard
    spawn:addUnit("naga", "nhyc", 1, {1, 3, 5, 8, 9}, 9, 12) -- Dragon Turtle

    -- Naga Creep Spawn
    spawn:addUnit("nagaCreep", "nmyr", 2, {1, 2, 3, 4}, 2, 12) -- Naga Myrmidon
    spawn:addUnit("nagaCreep", "nnsw", 1, {2, 3, 4, 5}, 3, 12) -- Naga Siren
    spawn:addUnit("nagaCreep", "nsnp", 2, {2, 3, 4, 5, 6}, 5, 12) -- Snap Dragon

    -- Night Elves Spawn
    spawn:addUnit("nightElves", "nwat", 1, {3, 4, 5, 6, 7, 8, 9}, 2, 12) -- Sentry
    spawn:addUnit("nightElves", "edry", 1, {1, 4, 5, 7, 9}, 3, 12) -- Dryad
    spawn:addUnit("nightElves", "edoc", 2, {1, 3, 5, 7, 9}, 4, 12) -- Druid of the Claw
    spawn:addUnit("nightElves", "e005", 1, {2, 4, 6, 8}, 5, 12) -- Mountain Giant
    spawn:addUnit("nightElves", "nwnr", 1, {5, 10}, 9, 12) -- Ent

    -- Orc Spawn
    spawn:addUnit("orc", "o002", 2, {1, 3, 4, 5, 6, 7, 8, 9, 10}, 1, 12) -- Grunt
    spawn:addUnit("orc", "o002", 2, {5, 6, 7, 8, 9}, 3, 12) -- Grunt
    spawn:addUnit("orc", "nftr", 1, {4, 5, 7, 8, 9, 10}, 2, 12) -- Spearman
    spawn:addUnit("orc", "nogo", 3, {2, 4, 6, 8, 10}, 4, 12) -- Ogre
    spawn:addUnit("orc", "nw2w", 1, {1, 3, 5, 7, 9}, 3, 12) -- Warlock
    spawn:addUnit("orc", "owad", 1, {1, 6, 9}, 6, 12) -- Orc Warchief
    -- spawn:addUnit("orc", "ocat", 1, {1,5}, 6, 12)  -- Demolisher

    -- Human Shipyard Spawn
    spawn:addUnit("hshipyard", "hdes", 1, {2, 4}, 1, 2) -- Human Frigate
    spawn:addUnit("hshipyard", "hdes", 1, {2, 4, 8}, 3, 4) -- Human Frigate
    spawn:addUnit("hshipyard", "hdes", 1, {2, 4, 6, 8}, 5, 12) -- Human Frigate
    spawn:addUnit("hshipyard", "hbsh", 1, {3, 8}, 6, 12) -- Human Battleship

    -- Night Elf Shipyard Spawn
    spawn:addUnit("shipyard", "edes", 1, {1, 6}, 2, 3) -- Night Elf Frigate
    spawn:addUnit("shipyard", "edes", 1, {1, 3, 6}, 4, 5) -- Night Elf Frigate
    spawn:addUnit("shipyard", "edes", 1, {1, 3, 6, 10}, 6, 12) -- Night Elf Frigate
    spawn:addUnit("shipyard", "ebsh", 1, {3, 7}, 7, 12) -- Night Elf Battleship

    -- Town Spawn
    spawn:addUnit("town", "h007", 3, {1, 2, 3, 4, 5}, 1, 5) -- Militia
    spawn:addUnit("town", "h007", 2, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 3, 12) -- Militia
    spawn:addUnit("town", "hcth", 1, {1, 2, 3, 4}, 2, 12) -- Captian
    spawn:addUnit("town", "n00X", 2, {1, 2, 3, 4, 6, 8}, 3, 12) -- Arbalist
    spawn:addUnit("town", "hfoo", 5, {1, 2, 5, 6, 8}, 5, 12) -- Footman
    spawn:addUnit("town", "h00L", 2, {1, 3, 7, 9}, 4, 12) -- Knight

    -- Undead Spawn
    spawn:addUnit("undead", "ugho", 4, {1, 2, 3, 4, 5, 6, 7, 8, 9}, 1, 12) -- Ghoul
    spawn:addUnit("undead", "uskm", 2, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 2, 12) -- Skeleton Mage
    spawn:addUnit("undead", "unec", 1, {1, 2, 3, 4, 5, 6, 7}, 3, 12) -- Necromancer
    spawn:addUnit("undead", "nerw", 1, {1, 6}, 4, 12) -- Warlock
    spawn:addUnit("undead", "nfgl", 1, {2, 5, 8}, 5, 12) -- Giant Skeleton
end
