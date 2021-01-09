function getRectDetails(region)
    return {centerX = GetRectCenterX(region), centerY = GetRectCenterY(region), minX = GetRectMinX(region), maxX = GetRectMaxX(region), minY = GetRectMinY(region), maxY = GetRectMaxY(region)}
end

function Init_luaGlobals()
    loc = {}

    loc.arcaneLeft = getRectDetails(gg_rct_Left_Arcane)
    loc.arcaneRight.reg = getRectDetails(gg_rct_Right_Arcane)
    loc.castleLeft.reg = getRectDetails(gg_rct_Left_Castle)
    loc.castleRight.reg = getRectDetails(gg_rct_Right_Castle)
    loc.elfLeft.reg = getRectDetails(gg_rct_Elf_Base_Left)
    loc.elfRight.reg = getRectDetails(gg_rct_Elf_Base_Right)
    loc.arcaneLeft.reg = CreateRegion()
    loc.arcaneRight.reg = CreateRegion()
    loc.castleLeft.reg = CreateRegion()
    loc.castleRight.reg = CreateRegion()
    loc.elfLeft.reg = CreateRegion()
    loc.elfRight.reg = CreateRegion()
    RegionAddRect(loc.arcaneLeft.reg, gg_rct_Left_Arcane)
    RegionAddRect(loc.arcaneRight.reg, gg_rct_Right_Arcane)
    RegionAddRect(loc.castleLeft.reg, gg_rct_Left_Castle)
    RegionAddRect(loc.castleRight.reg, gg_rct_Right_Castle)
    RegionAddRect(loc.elfLeft.reg, gg_rct_Elf_Base_Left)
    RegionAddRect(loc.elfRight.reg, gg_rct_Elf_Base_Right)

    loc.everythingLeft.reg = getRectDetails(gg_rct_Left_Everything)
    loc.everythingRight.reg = getRectDetails(gg_rct_Right_Everything)
    loc.bottomLeft.reg = getRectDetails(gg_rct_Left_Start_Bottom)
    loc.bottomRight.reg = getRectDetails(gg_rct_Right_Start_Bottom)
    loc.middleLeft.reg = getRectDetails(gg_rct_Left_Start_Middle)
    loc.middleRight.reg = getRectDetails(gg_rct_Right_Start_Middle)
    loc.topLeft.reg = getRectDetails(gg_rct_Left_Start_Top)
    loc.topRight.reg = getRectDetails(gg_rct_Right_Start_Top)
    loc.everythingLeft.reg = CreateRegion()
    loc.everythingRight.reg = CreateRegion()
    loc.bottomLeft.reg = CreateRegion()
    loc.bottomRight.reg = CreateRegion()
    loc.middleLeft.reg = CreateRegion()
    loc.middleRight.reg = CreateRegion()
    loc.topLeft.reg = CreateRegion()
    loc.topRight.reg = CreateRegion()
    RegionAddRect(loc.everythingLeft.reg, gg_rct_Left_Everything)
    RegionAddRect(loc.everythingRight.reg, gg_rct_Right_Everything)
    RegionAddRect(loc.bottomLeft.reg, gg_rct_Left_Start_Bottom)
    RegionAddRect(loc.bottomRight.reg, gg_rct_Right_Start_Bottom)
    RegionAddRect(loc.middleLeft.reg, gg_rct_Left_Start_Middle)
    RegionAddRect(loc.middleRight.reg, gg_rct_Right_Start_Middle)
    RegionAddRect(loc.topLeft.reg, gg_rct_Left_Start_Top)
    RegionAddRect(loc.topRight.reg, gg_rct_Right_Start_Top)

    loc.spawnArcaneLeft.reg = getRectDetails(gg_rct_Left_Mage_Base)
    loc.spawnArcaneLeft.reg = getRectDetails(gg_rct_Right_Mage_Base)
    loc.spawnArcaneHeroLeft.reg = getRectDetails(gg_rct_Arcane_Hero_Left)
    loc.spawnArcaneHeroRight.reg = getRectDetails(gg_rct_Arcane_Hero_Right)
    loc.spawnElementalTopLeft.reg = getRectDetails(gg_rct_Arcane_Left_Top)
    loc.spawnElementalTopRight.reg = getRectDetails(gg_rct_Arcane_Right_Top)
    loc.spawnElementalBottomLeft.reg = getRectDetails(gg_rct_Arcane_Left_Bottom)
    loc.spawnElementalBottomRight.reg = getRectDetails(gg_rct_Arcane_Right_Bottom)
    loc.spawnHeroLeft.reg = getRectDetails(gg_rct_Left_Hero)
    loc.spawnHeroRight.reg = getRectDetails(gg_rct_Right_Hero)
    loc.spawnArcaneLeft.reg = CreateRegion()
    loc.spawnArcaneLeft.reg = CreateRegion()
    loc.spawnArcaneHeroLeft.reg = CreateRegion()
    loc.spawnArcaneHeroRight.reg = CreateRegion()
    loc.spawnElementalTopLeft.reg = CreateRegion()
    loc.spawnElementalTopRight.reg = CreateRegion()
    loc.spawnElementalBottomLeft.reg = CreateRegion()
    loc.spawnElementalBottomLeft.reg = CreateRegion()
    loc.spawnElementalBottomRight.reg = CreateRegion()
    loc.spawnHeroLeft.reg = CreateRegion()
    loc.spawnHeroRight.reg = CreateRegion()
    RegionAddRect(loc.spawnArcaneLeft.reg, gg_rct_Left_Mage_Base)
    RegionAddRect(loc.spawnArcaneLeft.reg, gg_rct_Right_Mage_Base)
    RegionAddRect(loc.spawnArcaneHeroLeft.reg, gg_rct_Arcane_Hero_Left)
    RegionAddRect(loc.spawnArcaneHeroRight.reg, gg_rct_Arcane_Hero_Right)
    RegionAddRect(loc.spawnElementalTopLeft.reg, gg_rct_Arcane_Left_Top)
    RegionAddRect(loc.spawnElementalTopRight.reg, gg_rct_Arcane_Right_Top)
    RegionAddRect(loc.spawnElementalBottomLeft.reg, gg_rct_Arcane_Left_Bottom)
    RegionAddRect(loc.spawnElementalBottomRight.reg, gg_rct_Arcane_Right_Bottom)
    RegionAddRect(loc.spawnHeroLeft.reg, gg_rct_Left_Hero)
    RegionAddRect(loc.spawnHeroRight.reg, gg_rct_Right_Hero)

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

function init_Lua()
    debugprint = 2

    -- Define Classes
    debugfunc(function()
        Init_LuaGlobals()
        init_indexerClass()
        init_heroClass()
        init_spawnClass()
        init_aiClass()
    end, "Define Classes")
    dprint("Classes Defined", 2)

    -- Start the Map init
    Init_Map()

    -- Init Classes
    debugfunc(function()
        indexer = indexer_Class.new()
        hero = hero_Class.new()
        ai = ai_Class.new()
        spawn = spawn_Class.new()

    end, "Init Classes")

    dprint("Classes Initialized", 2)

    -- Init Trigger
    debugfunc(function()

        init_AutoZoom()
        Init_HeroLevelsUp()
        Init_UnitCastsSpell()
        Init_PlayerBuysUnit()
        init_spawnTimers()
        Init_UnitEntersMap()
        Init_stopCasting()
        Init_finishCasting()
        Init_IssuedOrder()
        Init_UnitDies()
        Init_UnitEntersMap()
    end, "Init Triggers")

    dprint("Triggers Initialized", 2)

    -- Spawn Base / Unit Setup
    -- Init Trigger
    debugfunc(function()
        spawnAddBases()
        spawnAddUnits()
    end, "Init Spawn")

    dprint("Spawn Setup", 2)

    -- Setup Delayed Init Triggers
    init_Delayed_1()
    init_Delayed_10()

    dprint("Init Finished")
end

-- Init Delayed Functions 1 second after Map Init
function init_Delayed_1()
    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 1)
    TriggerAddAction(t, function()
        debugfunc(function()
            -- ai:pickHeroes()
            dprint("pick Heroes Successfull", 2)
            -- ai:init_loopStates()

            orderStartingUnits()
            dprint("AI Started", 2)
            spawn:startSpawn()
            dprint("Spawn Started", 2)
        end, "Start Delayed Triggers")
    end)
end

-- Init Delayed Functions 10 second after Map Init
function init_Delayed_10()
    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 10)
    TriggerAddAction(t, function()
        debugfunc(function()
            -- FogMaskEnableOn()
            -- FogEnableOn()

            -- Set up the Creep Event Timer
            StartTimerBJ(udg_EventTimer, false, 350.00)
        end, "Start Delayed Triggers")
    end)
end

--
-- Init Classes
--

function init_indexerClass()
    indexer_Class = {}

    indexer_Class.new = function()
        local self = {}

        self.data = {}

        function self:add(unit, order)
            order = order or "attack"
            local unitId = GetHandleId(unit)

            local x = GetUnitX(unit)
            local y = GetUnitY(unit)

            self.data[unitId] = {}
            self.data[unitId] = {
                xSpawn = x,
                ySpawn = y,
                order = order,
                unit = unit,
                sfx = {}
            }
        end

        function self:updateEnd(unit, x, y)
            local unitId = GetHandleId(unit)
            self.data[unitId].xEnd = x
            self.data[unitId].yEnd = y
        end

        function self:order(unit, order)

            local unitId = GetHandleId(unit)
            local alliedForce = IsUnitInForce(unit, udg_PLAYERGRPallied)
            local p, x, y
            local data = self.data[unitId]
            order = order or data.order

            if data.xEnd == nil or data.yEnd == nil then

                if RectContainsUnit(gg_rct_Big_Top_Left, unit) or RectContainsUnit(gg_rct_Big_Top_Left_Center, unit) or
                    RectContainsUnit(gg_rct_Big_Top_Right_Center, unit) or RectContainsUnit(gg_rct_Big_Top_Right, unit) then

                    if alliedForce then
                        p = GetRandomLocInRect(gg_rct_Right_Start_Top)
                    else
                        p = GetRandomLocInRect(gg_rct_Left_Start_Top)
                    end

                elseif RectContainsUnit(gg_rct_Big_Middle_Left, unit) or
                    RectContainsUnit(gg_rct_Big_Middle_Left_Center, unit) or
                    RectContainsUnit(gg_rct_Big_Middle_Right_Center, unit) or
                    RectContainsUnit(gg_rct_Big_Middle_Right, unit) then

                    if alliedForce then
                        p = GetRandomLocInRect(gg_rct_Right_Start)
                    else
                        p = GetRandomLocInRect(gg_rct_Left_Start)
                    end

                else

                    if alliedForce then
                        p = GetRandomLocInRect(gg_rct_Right_Start_Bottom)
                    else
                        p = GetRandomLocInRect(gg_rct_Left_Start_Bottom)
                    end
                end

                x = GetLocationX(p)
                y = GetLocationY(p)
                RemoveLocation(p)

                self.data[unitId].xEnd = x
                self.data[unitId].yEnd = y
            else
                x = data.xEnd
                y = data.yEnd
            end

            -- Issue Order
            IssuePointOrder(unit, order, x, y)
        end

        function self:addKey(unit, key, value)
            value = value or 0
            local unitId = GetHandleId(unit)
            self.data[unitId][key] = value
        end

        function self:get(unit)
            local unitId = GetHandleId(unit)
            return self.data[unitId]
        end

        function self:set(unit, data)
            local unitId = GetHandleId(unit)
            self.data[unitId] = data
        end

        function self:remove(unit)
            self.data[GetHandleId(unit)] = nil
            return true
        end

        return self
    end
end

-- Spawn Class
function init_spawnClass()
    -- Create the table for the class definition
    spawn_Class = {}

    -- Define the new() function
    spawn_Class.new = function()
        local self = {}

        self.bases = {}
        self.baseCount = 0
        self.timer = CreateTimer()
        self.cycleInterval = 5.00
        self.baseInterval = 0.4
        self.waveInterval = 20.00

        self.creepLevel = 1
        self.creepLevelTimer = CreateTimer()

        self.wave = 1
        self.base = ""
        self.baseI = 0
        self.indexer = ""
        self.alliedBaseAlive = false
        self.fedBaseAlive = false
        self.unitInWave = false
        self.unitInLevel = true
        self.numOfUnits = 0
        self.unitType = ""

        function self:addBase(baseName, alliedStart, alliedEnd, alliedCondition, fedStart, fedEnd, fedCondition)
            -- Add all of the info the base and add the base name to the base list
            self[baseName] = {
                allied = {
                    startPoint = alliedStart,
                    endPoint = alliedEnd,
                    condition = alliedCondition
                },
                fed = {
                    startPoint = fedStart,
                    endPoint = fedEnd,
                    condition = fedCondition
                },
                destination = destination,
                units = {}
            }
            table.insert(self.bases, baseName)
            self.baseCount = self.baseCount + 1
        end

        function self:addUnit(baseName, unitType, numOfUnits, waves, levelStart, levelEnd)
            table.insert(self[baseName].units, {
                unitType = unitType,
                numOfUnits = numOfUnits,
                waves = waves,
                level = {levelStart, levelEnd}
            })
        end

        function self:unitCount()
            return #self[self.base].units
        end

        function self:isUnitInWave()
            local waves = self[self.base].units[self.indexer].waves

            for index, value in ipairs(waves) do
                if value == self.wave then
                    self.unitInWave = true
                    return true
                end
            end

            self.unitInWave = false
            return true
        end

        function self:isUnitInLevel()
            local levelStart = self[self.base].units[self.indexer].level[1]
            local levelEnd = self[self.base].units[self.indexer].level[2]

            if (self.creepLevel >= levelStart and self.creepLevel <= levelEnd) then
                self.unitInLevel = true
            else
                self.unitInLevel = false
            end
        end

        function self:baseAlive()
            self.alliedBaseAlive = IsUnitAliveBJ(self[self.base].allied.condition)
            self.fedBaseAlive = IsUnitAliveBJ(self[self.base].fed.condition)
        end

        function self:checkSpawnUnit()
            self:baseAlive(self.base)
            self:isUnitInWave()
            self:isUnitInLevel()
            self.numOfUnits = self[self.base].units[self.indexer].numOfUnits
            self.unitType = self[self.base].units[self.indexer].unitType
        end

        function self:spawnUnits()
            local pStart, xStart, yStart, pDest, xDest, yDest, spawnedUnit

            for i = 1, self:unitCount(self.base) do
                self.indexer = i
                self:checkSpawnUnit()

                if self.unitInWave and self.unitInLevel then

                    if self.alliedBaseAlive then
                        for n = 1, self.numOfUnits do
                            pStart = GetRandomLocInRect(self[self.base].allied.startPoint)
                            xStart = GetLocationX(pStart)
                            yStart = GetLocationY(pStart)
                            RemoveLocation(pStart)

                            pDest = GetRandomLocInRect(self[self.base].allied.endPoint)
                            xDest = GetLocationX(pDest)
                            yDest = GetLocationY(pDest)
                            RemoveLocation(pDest)

                            spawnedUnit = CreateUnit(Player(GetRandomInt(18, 20)), FourCC(self.unitType), xStart,
                                              yStart, bj_UNIT_FACING)

                            indexer:add(spawnedUnit)
                            indexer:updateEnd(spawnedUnit, xDest, yDest)
                            indexer:order(spawnedUnit)

                        end
                    end

                    if self.fedBaseAlive then
                        for n = 1, self.numOfUnits do

                            pStart = GetRandomLocInRect(self[self.base].fed.startPoint)
                            xStart = GetLocationX(pStart)
                            yStart = GetLocationY(pStart)
                            RemoveLocation(pStart)

                            pDest = GetRandomLocInRect(self[self.base].fed.endPoint)
                            xDest = GetLocationX(pDest)
                            yDest = GetLocationY(pDest)
                            RemoveLocation(pDest)

                            spawnedUnit = CreateUnit(Player(GetRandomInt(21, 23)), FourCC(self.unitType), xStart,
                                              yStart, bj_UNIT_FACING)

                            indexer:add(spawnedUnit)
                            indexer:updateEnd(spawnedUnit, xDest, yDest)
                            indexer:order(spawnedUnit)
                        end
                    end
                end
            end
        end

        -- Run the Spawn Loop
        function self:loopSpawn()
            -- Iterate everything up
            self.baseI = self.baseI + 1

            if (self.baseI > self.baseCount) then
                self.baseI = 0
                self.wave = self.wave + 1

                if self.wave > 10 then
                    self.wave = 1
                    StartTimerBJ(self.timer, false, self.cycleInterval)
                else
                    StartTimerBJ(self.timer, false, self.waveInterval)
                end

                return true
            else
                StartTimerBJ(self.timer, false, self.baseInterval)
            end

            -- Find the Base to Spawn Next
            self.base = self.bases[self.baseI]

            -- Spawn the Units at the selected Base
            DisableTrigger(Trig_UnitEntersMap)
            self:spawnUnits()
            EnableTrigger(Trig_UnitEntersMap)
        end

        function self:upgradeCreeps()
            self.creepLevel = self.creepLevel + 1

            if self.creepLevel >= 12 then
                DisableTrigger(self.Trig_upgradeCreeps)
            else
                StartTimerBJ(self.creepLevelTimer, false, (70 + (15 * self.creepLevel)))
            end

            DisplayTimedTextToForce(GetPlayersAll(), 10, "Creeps Upgrade.  Level: " .. self.creepLevel)
        end

        -- Start the Spawn Loop
        function self:startSpawn()
            -- Start Spawn Timer
            StartTimerBJ(self.timer, false, 1)
            StartTimerBJ(self.creepLevelTimer, false, 90)

            TriggerRegisterTimerExpireEvent(Trig_spawnLoop, self.timer)
            TriggerRegisterTimerExpireEvent(Trig_upgradeCreeps, self.creepLevelTimer)
        end

        --
        -- Class Triggers
        --

        return self
    end
end

function init_spawnTimers()
    -- Create Spawn Loop Trigger
    Trig_spawnLoop = CreateTrigger()
    TriggerAddAction(Trig_spawnLoop, function()
        debugfunc(function()
            spawn:loopSpawn()
        end, "spawn:loopSpawn")
    end)

    Trig_upgradeCreeps = CreateTrigger()
    TriggerAddAction(Trig_upgradeCreeps, function()
        debugfunc(function()
            spawn:upgradeCreeps()
        end, "spawn:upgradeCreeps()")
    end)
end

-- AI Class
function init_aiClass()
    -- Create the table for the class definition
    ai_Class = {}

    -- Define the new() function
    ai_Class.new = function()
        local self = {}

        self.heroes = {}
        self.heroGroup = CreateGroup()
        self.heroOptions = {"heroA", "heroB", "heroC", "heroD", "heroE", "heroF", "heroG", "heroH", "heroI", "heroJ",
                            "heroK", "heroL"}
        self.count = 0
        self.loop = 1
        self.tick = 1

        function self:isAlive(i)
            return self[i].alive
        end

        function self:countOfHeroes()
            return self.count
        end

        function self:initHero(heroUnit)
            self.count = self.count + 1
            self.tick = (1.00 + (self.count * 0.1)) / self.count

            local i = self.heroOptions[self.count]
            print("Name: " .. i)

            table.insert(self.heroes, i)

            self[i] = {}

            self[i].unit = heroUnit
            GroupAddUnit(self.heroGroup, self[i].unit)

            self[i].id = GetUnitTypeId(heroUnit)
            self[i].four = CC2Four(self[i].id)
            self[i].name = hero[self[i].four]

            self[i].player = GetOwningPlayer(heroUnit)
            self[i].playerNumber = GetConvertedPlayerId(GetOwningPlayer(heroUnit))

            if self[i].playerNumber > 6 then
                self[i].teamNumber = 2
            else
                self[i].teamNumber = 1
            end

            self[i].heroesFriend = CreateGroup()
            self[i].heroesEnemy = CreateGroup()
            self[i].lifeHistory = {0.00, 0.00, 0.00}
            SetUnitUserData(self[i].unit, self.count)

            self[i].alive = false
            self[i].fleeing = false
            self[i].casting = false
            self[i].castingDuration = -10.00
            self[i].castingDanger = false
            self[i].order = nil
            self[i].castingUlt = false
            self[i].chasing = false
            self[i].defending = false
            self[i].lowLife = false
            self[i].highDamage = false
            self[i].updateDest = false

            self[i].unitHealing = nil
            self[i].unitAttacking = nil
            self[i].unitChasing = nil

            if self[i].four == hero.brawler.four then -- Brawler
                self[i].healthFactor = 1.00
                self[i].manaFactor = 0.02

                self[i].lifeHighPercent = 65.00
                self[i].lifeLowPercent = 20.00
                self[i].lifeLowNumber = 450.00

                self[i].highDamageSingle = 17.00
                self[i].highDamageAverage = 25.00

                self[i].powerBase = 500.00
                self[i].powerLevel = 200.00

                self[i].clumpCheck = true
                self[i].clumpRange = 100.00
                self[i].intelRange = 1100.00
                self[i].closeRange = 500.00
            elseif self[i].four == hero.manaAddict.four then -- Mana Addict
                self[i].healthFactor = 1.00
                self[i].manaFactor = 0.75

                self[i].lifeHighPercent = 85.00
                self[i].lifeLowPercent = 25.00
                self[i].lifeLowNumber = 300.00

                self[i].highDamageSingle = 3.00
                self[i].highDamageAverage = 18.00

                self[i].powerBase = 700.00
                self[i].powerLevel = 220.00

                self[i].clumpCheck = true
                self[i].clumpRange = 100.00
                self[i].intelRange = 1000.00
                self[i].closeRange = 400.00
            elseif self[i].four == hero.tactition.four then -- Tactition
                self[i].healthFactor = 1.00
                self[i].manaFactor = 0.20

                self[i].lifeHighPercent = 75.00
                self[i].lifeLowPercent = 20.00
                self[i].lifeLowNumber = 400.00

                self[i].highDamageSingle = 17.00
                self[i].highDamageAverage = 25.00

                self[i].powerBase = 500.00
                self[i].powerLevel = 200.00
                self[i].clumpCheck = true
                self[i].clumpRange = 250.00
                self[i].intelRange = 1000.00
                self[i].closeRange = 400.00
            elseif self[i].four == hero.timeMage.four then -- Time Mage
                self[i].healthFactor = 1.00
                self[i].manaFactor = 0.10

                self[i].lifeHighPercent = 85.00
                self[i].lifeLowPercent = 25.00
                self[i].lifeLowNumber = 400.00

                self[i].highDamageSingle = 8.00
                self[i].highDamageAverage = 17.00

                self[i].powerBase = 750.00
                self[i].powerLevel = 250.00

                self[i].clumpCheck = true
                self[i].clumpRange = 250.00
                self[i].intelRange = 1100.00
                self[i].closeRange = 700.00
            elseif self[i].four == hero.shiftMaster.four then -- Shifter
                self[i].healthFactor = 1.00
                self[i].manaFactor = 0.15

                self[i].lifeHighPercent = 70.00
                self[i].lifeLowPercent = 25.00
                self[i].lifeLowNumber = 350.00

                self[i].highDamageSingle = 17.00
                self[i].highDamageAverage = 25.00

                self[i].powerBase = 500.00
                self[i].powerLevel = 200.00

                self[i].clumpCheck = true
                self[i].clumpRange = 100.00
                self[i].intelRange = 1100.00
                self[i].closeRange = 400.00
            end
        end

        -- AI Picks Hero
        function self:pickHeroes()
            local i = 1
            local count = 12
            local x, y, u, selPlayer, lastCreatedHero, randInt, heroName

            while (i <= count) do
                selPlayer = ConvertedPlayer(i)
                if (GetPlayerController(selPlayer) == MAP_CONTROL_COMPUTER) then
                    if (i < 7) then
                        udg_INT_TeamNumber[i] = 1
                    else
                        udg_INT_TeamNumber[i] = 2
                    end

                    -- Pick random hero
                    randInt = GetRandomInt(3, 3)
                    heroName = hero.heroes[randInt]
                    lastCreatedHero = CreateUnit(selPlayer, hero[heroName].id, 0, 0, 0)

                    -- Add Starting Spells
                    debugfunc(function()
                        hero:setupHero(lastCreatedHero)
                        self:initHero(lastCreatedHero)
                    end, "Init Hero")

                end

                i = i + 1
            end
        end

        function self:loopStates() -- Start AI Loop
            if self.loop >= self.count then
                self.loop = 1
            else
                self.loop = self.loop + 1
            end

            print(" -- ")
            local i = self.heroOptions[self.loop]

            debugfunc(function()
                self:updateIntel(i)

                if self:isAlive(i) then
                    self:STATEDead(i)
                    self:STATELowHealth(i)
                    self:STATEStopFleeing(i)
                    self:STATEFleeing(i)
                    self:STATEHighHealth(i)
                    self:STATEcastingSpell(i)
                    self:STATEAbilities(i)
                    self:CleanUp(i)
                else
                    self:STATERevived(i)
                end
                print("Finished")
            end, "AI STATES")
        end

        function self:init_loopStates()
            if (self.count > 0) then
                self.trig_loopStates = CreateTrigger()
                TriggerRegisterTimerEvent(self.trig_loopStates, ai.tick, true)
                TriggerAddAction(self.trig_loopStates, ai:loopStates())
            end
        end

        -- Update Intel
        function self:updateIntel(i)
            -- Only run if the hero is alive
            if (self[i].alive == true) then
                -- Update info about the AI Hero

                self[i].x = GetUnitX(self[i].unit)
                self[i].y = GetUnitY(self[i].unit)
                self[i].life = GetWidgetLife(self[i].unit)
                self[i].lifePercent = GetUnitLifePercent(self[i].unit)
                self[i].lifeMax = GetUnitState(self[i].unit, UNIT_STATE_MAX_LIFE)
                self[i].mana = GetUnitState(self[i].unit, UNIT_STATE_MANA)
                self[i].manaPercent = GetUnitManaPercent(self[i].unit)
                self[i].manaMax = GetUnitState(self[i].unit, UNIT_STATE_MAX_MANA)
                self[i].level = GetHeroLevel(self[i].unit)
                self[i].currentOrder = OrderId2String(GetUnitCurrentOrder(self[i].unit))

                -- Reset Intel
                self[i].countUnit = 0
                self[i].countUnitFriend = 0
                self[i].countUnitFriendClose = 0
                self[i].countUnitEnemy = 0
                self[i].countUnitEnemyClose = 0
                self[i].powerFriend = 0.00
                self[i].powerEnemy = 0.00

                self[i].unitPowerFriend = nil
                self[i].unitPowerEnemy = nil

                self[i].clumpFriend = nil
                self[i].clumpFriendPower = 0.00
                self[i].clumpEnemy = nil
                self[i].clumpEnemyPower = 0.00
                self[i].clumpBoth = nil
                self[i].clumpBothPower = 0.00

                GroupClear(self[i].heroesFriend)
                GroupClear(self[i].heroesEnemy)

                -- Units around Hero
                local g = CreateGroup()
                local clump = CreateGroup()
                local unitPower = 0.00
                local unitPower = 0.00
                local unitLife = 0.00
                local unitX
                local unitY
                local unitDistance = 0.00
                local unitRange = 0.00
                local unitPowerRangeMultiplier = 0.00
                local u
                local clumpUnit
                local powerAllyTemp
                local powerEnemyTemp

                GroupEnumUnitsInRange(g, self[i].x, self[i].y, self[i].intelRange, nil)

                -- Enumerate through group

                while true do
                    u = FirstOfGroup(g)
                    if (u == nil) then
                        break
                    end

                    -- Unit is alive and not the hero
                    if (IsUnitAliveBJ(u) == true and u ~= self[i].unit) then
                        self[i].countUnit = self[i].countUnit + 1

                        -- Get Unit Details
                        unitLife = GetUnitLifePercent(u)
                        unitRange = BlzGetUnitWeaponRealField(u, UNIT_WEAPON_RF_ATTACK_RANGE, 0)

                        unitX = GetUnitX(u)
                        unitY = GetUnitY(u)
                        unitDistance = distance(unitX, unitY, self[i].x, self[i].y)

                        -- Get Unit Power
                        if (IsUnitType(u, UNIT_TYPE_HERO) == true) then -- is Hero
                            unitPower = I2R((GetHeroLevel(u) * 75))

                            if IsUnitAlly(u, self[i].player) then -- Add to hero Group
                                GroupAddUnit(self[i].heroesFriend, u)
                            else
                                GroupAddUnit(self[i].heroesEnemy, u)
                            end
                        else -- Unit is NOT a hero
                            unitPower = I2R(GetUnitPointValue(u))
                        end

                        -- Power range modifier
                        if unitDistance < unitRange then
                            unitPowerRangeMultiplier = 1.00
                        else
                            unitPowerRangeMultiplier = 300.00 / (unitDistance - unitRange + 300.00)
                        end

                        if IsUnitAlly(u, self[i].player) == true then
                            -- Update count
                            self[i].countUnitFriend = self[i].countUnitFriend + 1
                            if unitDistance <= self[i].closeRange then
                                self[i].countUnitFriendClose = self[i].countUnitFriendClose + 1
                            end

                            -- Check to see if unit is the most powerful friend
                            if unitPower > self[i].powerFriend then
                                self[i].unitPowerFriend = u
                            end

                            -- Relative Power
                            self[i].powerFriend = self[i].powerFriend +
                                                      (unitPower * (unitLife / 100.00) * unitPowerRangeMultiplier)
                        else
                            -- Update Count
                            self[i].countUnitEnemy = self[i].countUnitEnemy + 1
                            if unitDistance <= self[i].closeRange then
                                self[i].countUnitEnemyClose = self[i].countUnitEnemyClose + 1
                            end

                            -- Check to see if unit is the most powerful Enemy
                            if unitPower > self[i].powerEnemy then
                                self[i].unitPowerEnemy = u
                            end

                            -- Relative Power
                            self[i].powerEnemy = self[i].powerEnemy +
                                                     (unitPower * (unitLife / 100.00) * unitPowerRangeMultiplier)
                        end

                        if self[i].clumpCheck == true then
                            powerAllyTemp = 0
                            powerEnemyTemp = 0
                            clump = CreateGroup()

                            GroupEnumUnitsInRange(clump, unitX, unitY, self[i].clumpRange, nil)

                            while true do
                                clumpUnit = FirstOfGroup(clump)
                                if clumpUnit == nil then
                                    break
                                end

                                if IsUnitAliveBJ(clumpUnit) and IsUnitType(clumpUnit, UNIT_TYPE_STRUCTURE) == false then
                                    if IsUnitAlly(clumpUnit, self[i].player) then
                                        powerAllyTemp = powerAllyTemp + SquareRoot(I2R(GetUnitPointValue(clumpUnit)))
                                    else
                                        powerEnemyTemp = powerEnemyTemp + SquareRoot(I2R(GetUnitPointValue(clumpUnit)))
                                    end
                                end

                                GroupRemoveUnit(clump, clumpUnit)
                            end
                            DestroyGroup(clump)

                            if powerAllyTemp > self[i].clumpFriendPower then
                                self[i].clumpFriendPower = powerAllyTemp
                                self[i].clumpFriend = u
                            end

                            if powerEnemyTemp > self[i].clumpEnemyPower then
                                self[i].clumpEnemyPower = powerEnemyTemp
                                self[i].clumpEnemy = u
                            end

                            if (powerAllyTemp + powerEnemyTemp) > self[i].clumpBothPower then
                                self[i].clumpBothPower = powerAllyTemp + powerEnemyTemp
                                self[i].clumpBoth = u
                            end
                        end
                    end

                    GroupRemoveUnit(g, u)
                end
                DestroyGroup(g)

                -- Find how much damage the Hero is taking
                self[i].lifeHistory[#self[i].lifeHistory + 1] = self[i].lifePercent

                if #self[i].lifeHistory > 5 then
                    table.remove(self[i].lifeHistory, 1)
                end

                self[i].percentLifeSingle = self[i].lifeHistory[#self[i].lifeHistory - 1] -
                                                self[i].lifeHistory[#self[i].lifeHistory]
                self[i].percentLifeAverage = self[i].lifeHistory[1] - self[i].lifeHistory[#self[i].lifeHistory]

                -- Figure out the Heroes Weighted Life
                self[i].weightedLife = (self[i].life * self[i].healthFactor) + (self[i].mana * self[i].manaFactor)
                self[i].weightedLifeMax = (self[i].lifeMax * self[i].healthFactor) +
                                              (self[i].manaMax * self[i].manaFactor)
                self[i].weightedLifePercent = (self[i].weightedLife / self[i].weightedLifeMax) * 100.00

                -- Get the Power Level of the surrounding Units
                self[i].powerEnemy = (self[i].powerEnemy * (((100.00 - self[i].weightedLifePercent) / 20.00) + 0.50))
                self[i].powerCount = self[i].powerEnemy - self[i].powerFriend

                -- Raise Hero Confidence Level
                self[i].powerBase = self[i].powerBase + (0.25 * I2R(self[i].level))
                self[i].powerHero = self[i].powerBase + (self[i].powerLevel * I2R(self[i].level))

                -- print("Clump Enemy: " .. R2S(self[i].clumpEnemyPower))
                -- print("Clump Both: " .. R2S(self[i].clumpBothPower))
                print("Enemies Nearby: " .. self[i].countUnitEnemy)
                print("Power Clump Enemy: " .. self[i].powerEnemy)
                -- print("Hero Power: " .. R2S(self[i].powerHero))
                -- print("Power Level: " .. R2S(self[i].powerCount))
            end
        end

        function self:CleanUp(i)
            if (self[i].currentOrder ~= "move" and (self[i].lowLife or self[i].fleeing)) then
                self:ACTIONtravelToHeal(i)
            end

            if (self[i].currentOrder ~= "attack" and self[i].currentOrder ~= "move" and self[i].lowLife == false and
                self[i].casting == false) then
                self:ACTIONattackBase(i)
            end
        end

        -- AI Run Specifics
        function self:STATEAbilities(i)
            local heroName = self[i].name

            if self[i].name == "manaAddict" then
                self:manaAddictAI(i)
            elseif self[i].name == "brawler" then
                self:brawlerAI(i)
            elseif self[i].name == "shiftMaster" then
                self:shiftMasterAI(i)
            elseif self[i].name == "tactition" then
                self:tactitionAI(i)
            elseif self[i].name == "timeMage" then
                self:timeMageAI(i)
            end
        end

        -- AI has Low Health
        function self:STATELowHealth(i)
            if (self[i].weightedLifePercent < self[i].lifeLowPercent or self[i].weightedLife < self[i].lifeLowNumber) and
                self[i].lowLife == false then
                print("Low Health")
                self[i].lowLife = true
                self[i].fleeing = false
                self[i].chasing = false
                self[i].defending = false
                self[i].highdamage = false
                self[i].updateDest = false

                if self[i].castingDanger == false then
                    self[i].casting = false
                    self[i].castingCounter = -10.00
                    self:ACTIONtravelToHeal(i)
                end
            end
        end

        -- AI Has High Health
        function self:STATEHighHealth(i)
            if self[i].alive == true and self[i].lowLife == true and self[i].weightedLifePercent >
                self[i].lifeHighPercent then
                print("High Health")
                self[i].lowLife = false
                self[i].fleeing = false

                -- Reward the AI For doing good
                self[i].lifeLowPercent = self[i].lifeLowPercent - 1.00
                self[i].lifeHighPercent = self[i].lifeHighPercent - 1.00

                local rand = GetRandomInt(1, 3)
                if rand == 1 then
                    self:ACTIONattackBase(i)
                else
                    self:ACTIONtravelToDest(i)
                end
            end
        end

        -- AI is Dead
        function self:STATEDead(i)
            if self[i].alive == true and IsUnitAliveBJ(self[i].unit) == false then
                print("Dead")
                self[i].alive = false
                self[i].lowLife = false
                self[i].fleeing = false
                self[i].chasing = false
                self[i].defending = false
                self[i].highdamage = false
                self[i].updateDest = false
                self[i].casting = false
                self[i].castingUlt = false
                self[i].castingCounter = -10.00

                -- Punish the AI for screwing up
                self[i].lifeLowPercent = self[i].lifeLowPercent + 4.00
                self[i].powerBase = self[i].powerBase / 2

                if self[i].lifeHighPercent < 98.00 then
                    self[i].lifeHighPercent = self[i].lifeHighPercent + 2.00
                end
            end
        end

        -- AI has Revived
        function self:STATERevived(i)
            if self[i].alive == false and IsUnitAliveBJ(self[i].unit) == true then
                print("Revived")
                self[i].alive = true
                self:ACTIONattackBase(i)
            end
        end

        -- AI Fleeing
        function self:STATEFleeing(i)
            if (self[i].powerHero < self[i].powerCount or self[i].percentLifeSingle > self[i].highDamageSingle or
                self[i].percentLifeAverage > self[i].highDamageAverage) and self[i].lowLife == false and self[i].fleeing ==
                false then
                print("Flee")
                self[i].fleeing = true

                if self[i].castingDanger == false then
                    self[i].casting = false
                    self[i].castingCounter = -10.00
                    self:ACTIONtravelToHeal(i)
                end
            end
        end

        -- AI Stop Fleeing
        function self:STATEStopFleeing(i)
            if self[i].powerHero > self[i].powerCount and self[i].percentLifeSingle <= 0.0 and
                self[i].percentLifeAverage <= self[i].highDamageAverage and self[i].lowLife == false and self[i].fleeing ==
                true then
                print("Stop Fleeing")
                self[i].fleeing = false

                self:ACTIONtravelToDest(i)
            end
        end

        -- AI Casting Spell
        function self:STATEcastingSpell(i)
            if self[i].casting == true then
                if self[i].castingDuration == -10.00 then
                    if self[i].currentOrder ~= self[i].order then
                        self[i].casting = false
                        self[i].castingDanger = false
                        -- print("Stopped Casting")
                        self:ACTIONtravelToDest(i)
                        self[i].order = self[i].currentOrder
                    else
                        -- print("Still Casting Spell")
                    end
                elseif self[i].castingDuration > 0.00 then
                    -- print("Still Casting Spell")
                    self[i].castingDuration = self[i].castingDuration - aiTick
                else
                    -- print("Stopped Casting (Count)")
                    self[i].casting = false
                    self[i].castingDuration = -10.00
                    self[i].castingDanger = false
                    self:ACTIONtravelToDest(i)
                    self[i].order = self[i].currentOrder
                end
            end
        end

        --
        -- ACTIONS
        --

        function self:castSpell(i, castDuration, danger)
            danger = danger or false
            castDuration = castDuration or -10.00

            if (self[i].fleeing == true or self[i].lowhealth == true) and danger == false then
                self:ACTIONtravelToDest(i)
            else
                -- print("Spell Cast")
                self[i].casting = true

                if danger then
                    self[i].castingDanger = true
                end

                self[i].castingDuration = castDuration
                self[i].order = OrderId2String(GetUnitCurrentOrder(self[i].unit))
                print(self[i].order)
            end
        end

        function self:ACTIONtravelToHeal(i)
            local healDistance = 100000000.00
            local healDistanceNew = 0.00
            local unitX
            local unitY
            local u
            local g = CreateGroup()

            GroupAddGroup(udg_UNIT_Healing[self[i].teamNumber], g)
            while true do
                u = FirstOfGroup(g)
                if u == nil then
                    break
                end

                unitX = GetUnitX(u)
                unitY = GetUnitY(u)
                healDistanceNew = distance(self[i].x, self[i].y, unitX, unitY)

                if healDistanceNew < healDistance then
                    healDistance = healDistanceNew
                    self[i].unitHealing = u
                end

                GroupRemoveUnit(g, u)
            end
            DestroyGroup(g)

            unitX = GetUnitX(self[i].unitHealing)
            unitY = GetUnitY(self[i].unitHealing)

            IssuePointOrder(self[i].unit, "move", unitX, unitY)
        end

        function self:ACTIONtravelToDest(i)
            if self[i].lowLife == true or self[i].fleeing == true then
                local unitX = GetUnitX(self[i].unitHealing)
                local unitY = GetUnitY(self[i].unitHealing)
                IssuePointOrder(self[i].unit, "move", unitX, unitY)
            else
                local unitX = GetUnitX(self[i].unitAttacking)
                local unitY = GetUnitY(self[i].unitAttacking)
                IssuePointOrder(self[i].unit, "attack", unitX, unitY)
            end
        end

        function self:ACTIONattackBase(i)
            self[i].unitAttacking = GroupPickRandomUnit(udg_UNIT_Bases[self[i].teamNumber])

            local unitX = GetUnitX(self[i].unitAttacking)
            local unitY = GetUnitY(self[i].unitAttacking)

            IssuePointOrder(self[i].unit, "attack", unitX, unitY)
        end

        -- Finders
        function self:getHeroName(unit)
            return self.heroOptions[S2I(GetUnitUserData(unit))]
        end

        function self:getHeroData(unit)
            return self[self:getHeroName(unit)]
        end

        -- Hero AI

        function self:manaAddictAI(i)
            local curSpell

            --  Always Cast
            -------

            -- Mana Shield
            curSpell = hero:spell(self[i], "manaShield")
            if curSpell.castable == true and curSpell.hasBuff == false then
                print(curSpell.name)
                IssueImmediateOrder(self[i].unit, curSpell.order)
                self:castSpell(i)
            end

            --  Cast available all the time
            -------
            if self[i].casting == false then
                -- Mana Drain
                curSpell = hero:spell(self[i], "manaOverload")
                if self[i].countUnitEnemyClose > 3 and self[i].manaPercent < 90.00 and curSpell.castable == true then
                    print(curSpell.name)
                    IssueImmediateOrder(self[i].unit, curSpell.order)
                    self:castSpell(i)
                end
            end

            -- Normal Cast
            --------

            if self[i].casting == false and self[i].lowLife == false and self[i].fleeing == false then
                -- Frost Nova
                curSpell = hero:spell(self[i], "frostNova")
                if self[i].clumpEnemyPower >= 40 and curSpell.castable == true and curSpell.manaLeft > 80 then
                    print(curSpell.name)
                    IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].clumpEnemy),
                        GetUnitY(self[i].clumpEnemy))
                    self:castSpell(i)
                end
            end
        end

        function self:brawlerAI(i)
            local curSpell

            if self[i].casting == false then
            end
        end

        -- Shift Master Spell AI
        function self:shiftMasterAI(i)
            local curSpell

            -- Normal Cast Spells
            if self[i].casting == false and self[i].lowLife == false and self[i].fleeing == false then
                -- Custom Intel
                local g = CreateGroup()
                local u = nil
                local illusionsNearby = 0

                -- Find all Nearby Illusions
                GroupEnumUnitsInRange(g, self[i].x, self[i].y, 600.00, nil)
                while true do
                    u = FirstOfGroup(g)
                    if (u == nil) then
                        break
                    end

                    if IsUnitIllusion(u) then
                        illusionsNearby = illusionsNearby + 1
                    end
                    GroupRemoveUnit(g, u)
                end
                DestroyGroup(g)

                -- Shift Back
                local curSpell = hero:spell(self[i], "shiftBack")
                if self[i].countUnitEnemyClose >= 2 and curSpell.castable == true and curSpell.manaLeft > 45 then
                    print(curSpell.name)
                    IssueImmediateOrder(self[i].unit, curSpell.order)
                    self:castSpell(i)
                end

                -- Shift Forward
                curSpell = hero:spell(self[i], "shiftForward")
                if self[i].countUnitEnemyClose >= 2 and curSpell.castable == true and curSpell.manaLeft > 45 then
                    print(curSpell.name)
                    IssueImmediateOrder(self[i].unit, curSpell.order)
                    self:castSpell(i)
                end

                -- Falling Strike
                curSpell = hero:spell(self[i], "fallingStrike")
                if (self[i].powerEnemy > 250.00 or self[i].clumpEnemyPower > 80.00) and curSpell.castable == true and
                    curSpell.manaLeft > 45 then
                    print(curSpell.name)

                    if self[i].powerEnemy > 250.00 then
                        IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].unitPowerEnemy),
                            GetUnitY(self[i].unitPowerEnemy))
                    else
                        IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].clumpEnemy),
                            GetUnitY(self[i].clumpEnemy))
                    end

                    self:castSpell(i)
                end

                -- Shift Storm
                curSpell = hero:spell(self[i], "shiftStorm")
                if self[i].countUnitEnemy >= 6 and curSpell.castable == true and curSpell.manaLeft > 30 then
                    print(curSpell.name)
                    IssueImmediateOrder(self[i].unit, curSpell.order)
                    self:castSpell(i)
                end
            end
        end

        function self:tactitionAI(i)
            if self[i].casting == false then
                -- Iron Defense
                if BlzGetUnitAbilityCooldownRemaining(self[i].unit, ironDefense.spell) == 0.00 and (self[i].mana) >
                    I2R(BlzGetAbilityManaCost(ironDefense.spell, ironDefense.level)) and ironDefense.level > 0 and
                    self[i].lifePercent < 85 then
                    -- Bolster
                    IssueImmediateOrder(self[i].unit, ironDefense.id)
                    self:castSpell(i)
                elseif BlzGetUnitAbilityCooldownRemaining(self[i].unit, bolster.spell) == 0.00 and (self[i].mana + 20) >
                    I2R(BlzGetAbilityManaCost(bolster.spell, bolster.level)) and bolster.level > 0 and
                    self[i].countUnitFriend > 2 and self[i].countUnitEnemy > 2 then
                    -- Attack
                    IssueImmediateOrder(self[i].unit, bolster.id)
                    self:castSpell(i, 2)
                elseif BlzGetUnitAbilityCooldownRemaining(self[i].unit, attack.spell) == 0.00 and (self[i].mana) >
                    I2R(BlzGetAbilityManaCost(attack.spell, attack.level)) and attack.level > 0 and
                    self[i].clumpEnemyPower > 250 then
                    -- Inspire
                    IssueTargetOrder(self[i].unit, attack.string, self[i].unitPowerEnemy)
                    self:castSpell(i)
                elseif BlzGetUnitAbilityCooldownRemaining(self[i].unit, inspire.spell) == 0.00 and (self[i].mana) >
                    I2R(BlzGetAbilityManaCost(inspire.spell, inspire.level)) and inspire.level > 0 and
                    self[i].countUnitFriend > 5 and self[i].countUnitEnemy > 5 then
                    IssueImmediateOrder(self[i].unit, inspire.string)
                    self:castSpell(i)
                end
            end
        end

        function self:timeMageAI(i)
            if self[i].casting == false then
            end
        end

        return self
    end
end

-- Hero Class

function init_heroClass()
    -- Create Class Definition
    hero_Class = {}

    -- Define new() function
    hero_Class.new = function()
        local self = {}

        self.items = {"teleportation"}
        self.item = {}
        self.item.teleportation = {
            name = "Staff of Teleportation",
            four = "I000",
            id = FourCC("I000"),
            order = ""
        }

        self.heroes = {"brawler", "manaAddict", "shiftMaster", "tactition", "timeMage"}

        self.E001 = "brawler"
        self.brawler = {}
        self.brawler.four = "E001"
        self.brawler.fourAlter = "h00I"
        self.brawler.id = FourCC(self.brawler.four)
        self.brawler.idAlter = FourCC(self.brawler.fourAlter)
        self.brawler.spellLearnOrder = {"unleashRage", "drain", "warstomp", "bloodlust"}
        self.brawler.startingSpells = {}
        self.brawler.permanentSpells = {}
        self.brawler.startingItems = {"teleportation"}
        self.brawler.drain = {
            name = "Drain",
            four = "A01Y",
            id = FourCC("A01Y"),
            buff = 0,
            order = "stomp",
            ult = false
        }
        self.brawler.bloodlust = {
            name = "Bloodlust",
            four = "A007",
            id = FourCC("A007"),
            buff = 0,
            order = "stomp",
            ult = false
        }
        self.brawler.warstomp = {
            name = "War Stomp",
            four = "A002",
            id = FourCC("A002"),
            buff = 0,
            order = "stomp",
            ult = false
        }
        self.brawler.unleashRage = {
            name = "Unleassh Rage",
            four = "A029",
            id = FourCC("A029"),
            buff = 0,
            order = "stomp",
            ult = true
        }

        self.H009 = "tactition"
        self.tactition = {}
        self.tactition.four = "H009"
        self.tactition.fourAlter = "h00Y"
        self.tactition.id = FourCC(self.tactition.four)
        self.tactition.idAlter = FourCC(self.tactition.fourAlter)
        self.tactition.spellLearnOrder = {"inspire", "raiseBanner", "ironDefense", "bolster", "attack"}
        self.tactition.startingSpells = {"raiseBanner"}
        self.tactition.permanentSpells = {}
        self.tactition.startingItems = {"teleportation"}
        self.tactition.ironDefense = {
            name = "Iron Defense",
            four = "A019",
            id = FourCC("A019"),
            buff = 0,
            order = "roar",
            ult = false
        }
        self.tactition.raiseBanner = {
            name = "Raise Banner",
            four = "A01I",
            id = FourCC("A01I"),
            buff = 0,
            order = "healingward",
            ult = false
        }
        self.tactition.attack = {
            name = "Attack!",
            four = "A01B",
            id = FourCC("A01B"),
            buff = 0,
            order = "fingerofdeath",
            ult = false
        }
        self.tactition.bolster = {
            name = "Bolster",
            four = "A01Z",
            id = FourCC("A01Z"),
            buff = 0,
            order = "tranquility",
            ult = false
        }
        self.tactition.inspire = {
            name = "Inspire",
            four = "A042",
            id = FourCC("A042"),
            buff = 0,
            order = "channel",
            ult = true
        }

        self.E002 = "shiftMaster"
        self.shiftMaster = {}
        self.shiftMaster.four = "E002"
        self.shiftMaster.fourAlter = "h00Q"
        self.shiftMaster.id = FourCC(self.shiftMaster.four)
        self.shiftMaster.idAlter = FourCC(self.shiftMaster.fourAlter)
        self.shiftMaster.spellLearnOrder = {"shiftStorm", "felForm", "shiftBack", "fallingStrike", "shiftForward"}
        self.shiftMaster.startingSpells = {"felForm"}
        self.shiftMaster.permanentSpells = {"felForm", "attributeBonus", "shadeStrength", "swiftMoves"}
        self.shiftMaster.startingItems = {"teleportation"}
        self.shiftMaster.attributeBonus = {
            name = "Attribute Bonus",
            four = "A031",
            id = FourCC("A031"),
            buff = 0,
            order = "",
            ult = false
        }
        self.shiftMaster.shadeStrength = {
            name = "Shade Strength",
            four = "A037",
            id = FourCC("A037"),
            buff = 0,
            order = "",
            ult = false
        }
        self.shiftMaster.swiftMoves = {
            name = "Swift Moves",
            four = "A005",
            id = FourCC("A005"),
            buff = 0,
            order = "",
            ult = false
        }
        self.shiftMaster.shiftBack = {
            name = "Shift Back",
            four = "A03U",
            id = FourCC("A03U"),
            buff = 0,
            order = "stomp",
            ult = false
        }
        self.shiftMaster.shiftForward = {
            name = "Shift Forward",
            four = "A030",
            id = FourCC("A030"),
            buff = 0,
            order = "thunderclap",
            ult = false
        }
        self.shiftMaster.fallingStrike = {
            name = "Falling Strike",
            four = "A03T",
            id = FourCC("A03T"),
            buff = 0,
            order = "clusterrockets",
            ult = false
        }
        self.shiftMaster.shiftStorm = {
            name = "Shift Storm",
            four = "A03C",
            id = FourCC("A03C"),
            buff = 0,
            order = "channel",
            ult = true
        }
        self.shiftMaster.felForm = {
            name = "Fel Form",
            four = "A02Y",
            id = FourCC("A02Y"),
            buff = 0,
            order = "metamorphosis",
            ult = true
        }

        self.H00R = "manaAddict"
        self.manaAddict = {}
        self.manaAddict.four = "H00R"
        self.manaAddict.fourAlter = "h00B"
        self.manaAddict.id = FourCC(self.manaAddict.four)
        self.manaAddict.idAlter = FourCC(self.manaAddict.fourAlter)
        self.manaAddict.spellLearnOrder = {"starfall", "manaShield", "frostNova", "manaOverload", "manaBurst"}
        self.manaAddict.startingSpells = {"manaShield"}
        self.manaAddict.permanentSpells = {}
        self.manaAddict.startingItems = {"teleportation"}
        self.manaAddict.manaShield = {
            name = "Mana Shield",
            four = "A001",
            id = FourCC("A001"),
            buff = FourCC("BNms"),
            order = "manashieldon",
            ult = false
        }
        self.manaAddict.frostNova = {
            name = "Frost Nova",
            four = "A03S",
            id = FourCC("A03S"),
            buff = 0,
            order = "flamestrike",
            ult = false
        }
        self.manaAddict.manaOverload = {
            name = "Mana Overload",
            four = "A018",
            id = FourCC("A018"),
            buff = 0,
            order = "manashield",
            ult = false
        }
        self.manaAddict.manaBurst = {
            name = "Mana Burst",
            four = "A02B",
            id = FourCC("A02B"),
            buff = 0,
            order = "custerrockets",
            ult = false
        }
        self.manaAddict.starfall = {
            name = "Starfall",
            four = "A015",
            id = FourCC("A015"),
            buff = 0,
            order = "starfall",
            ult = true
        }

        self.H00J = "timeMage"
        self.timeMage = {}
        self.timeMage.four = "H00J"
        self.timeMage.fourAlter = "h00Z"
        self.timeMage.id = FourCC(self.timeMage.four)
        self.timeMage.idAlter = FourCC(self.timeMage.fourAlter)
        self.timeMage.spellLearnOrder = {"paradox", "timeTravel", "chronoAtrophy", "decay"}
        self.timeMage.startingSpells = {}
        self.timeMage.permanentSpells = {}
        self.timeMage.startingItems = {"teleportation"}
        self.timeMage.chronoAtrophy = {
            name = "Chrono Atrophy",
            four = "A04K",
            id = FourCC("A04K"),
            buff = 0,
            order = "flamestrike",
            ult = false
        }
        self.timeMage.decay = {
            name = "Decay",
            four = "A032",
            id = FourCC("A032"),
            buff = 0,
            order = "shadowstrike",
            ult = false
        }
        self.timeMage.timeTravel = {
            name = "Time Travel",
            four = "A04P",
            id = FourCC("A04P"),
            buff = 0,
            order = "clusterrockets",
            ult = false
        }
        self.timeMage.paradox = {
            name = "Paradox",
            four = "A04N",
            id = FourCC("A04N"),
            buff = 0,
            order = "tranquility",
            ult = true
        }

        function self:spell(heroUnit, spellName)
            local spellDetails = self[heroUnit.name][spellName]
            spellDetails.level = self:level(heroUnit, spellName)
            spellDetails.cooldown = self:cooldown(heroUnit, spellName)
            spellDetails.hasBuff = self:hasBuff(heroUnit, spellName)
            spellDetails.mana = self:mana(heroUnit, spellName, spellDetails.level)
            spellDetails.manaLeft = heroUnit.mana - spellDetails.mana

            if spellDetails.level > 0 and spellDetails.cooldown == 0 and spellDetails.manaLeft >= 0 then
                spellDetails.castable = true
            else
                spellDetails.castable = false
            end

            -- print(spellName .. " : " .. spellDetails.level)
            -- print("Castable: " .. tostring(spellDetails.castable))

            return spellDetails
        end

        function self:level(heroUnit, spellName)
            return GetUnitAbilityLevel(heroUnit.unit, self[heroUnit.name][spellName].id)
        end

        function self:cooldown(heroUnit, spellName)
            return BlzGetUnitAbilityCooldownRemaining(heroUnit.unit, self[heroUnit.name][spellName].id)
        end

        function self:mana(heroUnit, spellName, level)
            return BlzGetUnitAbilityManaCost(heroUnit.unit, self[heroUnit.name][spellName].id, level)
        end

        function self:hasBuff(heroUnit, spellName)
            if self[heroUnit.name][spellName].buff == 0 then
                return false
            else
                return UnitHasBuffBJ(heroUnit.unit, self[heroUnit.name][spellName].buff)
            end
        end

        function self.levelUp(unit)
            local heroFour = CC2Four(GetUnitTypeId(unit))
            local heroName = self[heroFour]
            local heroLevel = GetHeroLevel(unit)
            local spells = self[heroName]

            print(self[heroFour])

            -- Remove Ability Points
            if (heroLevel < 15 and ModuloInteger(heroLevel, 2) ~= 0) then
                ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SUB, 1)
            elseif (heroLevel < 25 and heroLevel >= 15 and ModuloInteger(heroLevel, 3) ~= 0) then
                ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SUB, 1)
            elseif (heroLevel >= 25 and ModuloInteger(heroLevel, 4) ~= 0) then
                ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SUB, 1)
            end

            print("Level Up, " .. heroFour .. " Level: " .. heroLevel)

            -- Learn Skill if the Hero is owned by a Computer
            if GetPlayerController(GetOwningPlayer(unit)) == MAP_CONTROL_COMPUTER then
                local unspentPoints = GetHeroSkillPoints(unit)

                print("Unspent Abilities: " .. unspentPoints)

                if unspentPoints > 0 then
                    for i = 1, #spells.spellLearnOrder do
                        print(spells.spellLearnOrder[i])
                        SelectHeroSkill(unit, spells[spells.spellLearnOrder[i]].id)

                        if GetHeroSkillPoints(unit) == 0 then
                            break
                        end
                    end
                end
            end
        end

        function self:setupHero(unit)
            local heroFour = CC2Four(GetUnitTypeId(unit))
            local heroName = self[heroFour]
            local player = GetOwningPlayer(unit)
            local playerNumber = GetConvertedPlayerId(player)
            local heroLevel = GetHeroLevel(unit)
            local spells = self[heroName]
            local picked, u, x, y
            local g = CreateGroup()

            -- Get home Base Location
            if playerNumber < 7 then
                x = GetRectCenterX(gg_rct_Left_Castle)
                y = GetRectCenterY(gg_rct_Left_Castle)
            else
                x = GetRectCenterX(gg_rct_Right_Castle)
                y = GetRectCenterY(gg_rct_Right_Castle)
            end

            -- Move hero to home base
            SetUnitPosition(unit, x, y)
            SelectUnitForPlayerSingle(unit, player)
            PanCameraToTimedForPlayer(player, x, y, 0)

            -- Give the hero the required Skill points for the spells
            ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SET, #spells.startingSpells + 1)
            for i = 1, #spells.startingSpells do
                picked = spells[spells.startingSpells[i]]

                -- Have the hero learn the spell
                SelectHeroSkill(unit, picked.id)
            end

            -- Add the Permanent Spells for the Hero
            for i = 1, #spells.permanentSpells do
                picked = spells[spells.permanentSpells[i]]

                -- Make the Spell Permanent
                UnitMakeAbilityPermanent(unit, true, picked.id)
            end

            -- Give the Hero starting Items
            for i = 1, #spells.startingItems do
                picked = self.item[spells.startingItems[i]]

                -- Make the Spell Permanent
                UnitAddItemById(unit, picked.id)
            end

            -- Set up Alter
            g = GetUnitsOfPlayerAndTypeId(player, FourCC("halt"))
            while true do
                u = FirstOfGroup(g)
                if u == nil then
                    break
                end

                -- Replace Unit Alter
                ReplaceUnitBJ(u, self[heroName].idAlter, bj_UNIT_STATE_METHOD_MAXIMUM)

                GroupRemoveUnit(g, u)
            end
            DestroyGroup(g)
        end

        return self
    end
end

--
-- Functions
--

function dprint(message, level)
    level = level or 1

    if debugprint >= level then
        print("|cff00ff00[debug " .. level .. "]|r " .. tostring(message))
    end
end

function distance(x1, y1, x2, y2) -- Find Distance between points
    return SquareRoot(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)))
end

function debugfunc(func, name) -- Turn on runtime logging
    local passed, data = pcall(function()
        func()
        return "func " .. name .. " passed"
    end)
    if not passed then
        print("|cffff0000[ERROR]|r" .. name, passed, data)
    end
    passed = nil
    data = nil
end

function CC2Four(num) -- Convert from Handle ID to Four Char
    return string.pack(">I4", num)
end

--
-- Triggers
--

-- AI Triggers

-- Spawn Set up
function spawnAddBases()
    -- addBase(baseName, alliedStart, alliedEnd, alliedCondition, fedStart, fedEnd, fedCondition, destination)

    spawn:addBase("arcane", gg_rct_Left_Arcane, gg_rct_Right_Start_Bottom, gg_unit_h003_0015, gg_rct_Right_Arcane,
        gg_rct_Left_Start_Top, gg_unit_h003_0007)
    spawn:addBase("arcaneCreep", gg_rct_Left_Arcane, gg_rct_Left_Elemental_Start, gg_unit_h003_0015,
        gg_rct_Right_Arcane, gg_rct_Right_Elemental_Start, gg_unit_h003_0007)
    spawn:addBase("arcaneHero", gg_rct_Arcane_Hero_Left, gg_rct_Right_Start_Bottom, gg_unit_h014_0241,
        gg_rct_Arcane_Hero_Right, gg_rct_Left_Start_Top, gg_unit_h014_0043)
    spawn:addBase("arcaneTop", gg_rct_Arcane_Left_Top, gg_rct_Right_Start_Bottom, gg_unit_hars_0355,
        gg_rct_Arcane_Right_Top, gg_rct_Left_Start_Top, gg_unit_hars_0293)
    spawn:addBase("arcaneBottom", gg_rct_Arcane_Left_Bottom, gg_rct_Right_Start_Bottom, gg_unit_hars_0292,
        gg_rct_Arcane_Right_Bottom, gg_rct_Left_Start_Top, gg_unit_hars_0303)
    spawn:addBase("blacksmith", gg_rct_Blacksmith_Left, gg_rct_Right_Everything, gg_unit_n00K_0802,
        gg_rct_Blacksmith_Right, gg_rct_Left_Everything, gg_unit_n00K_0477)
    spawn:addBase("blacksmithCreep", gg_rct_Blacksmith_Left, gg_rct_Zombie_End_Left, gg_unit_n00K_0802,
        gg_rct_Blacksmith_Right, gg_rct_Zombie_End_Right, gg_unit_n00K_0477)
    spawn:addBase("castle", gg_rct_Left_Hero, gg_rct_Right_Everything, gg_unit_h00E_0033, gg_rct_Right_Hero,
        gg_rct_Left_Everything, gg_unit_h00E_0081)
    spawn:addBase("cityElves", gg_rct_City_Elves_Left, gg_rct_Right_Everything, gg_unit_hvlt_0207,
        gg_rct_City_Elves_Right, gg_rct_Left_Everything, gg_unit_hvlt_0406)
    spawn:addBase("cityFront", gg_rct_Front_Town_Left, gg_rct_Right_Start, gg_unit_n00B_0364, gg_rct_Front_City_Right,
        gg_rct_Left_Start, gg_unit_n00B_0399)
    spawn:addBase("citySide", gg_rct_Left_City, gg_rct_Right_Start_Bottom, gg_unit_n00B_0102, gg_rct_Right_City,
        gg_rct_Left_Start_Top, gg_unit_n00B_0038)
    spawn:addBase("kobold", gg_rct_Furbolg_Left, gg_rct_Right_Start_Top, gg_unit_ngt2_0525, gg_rct_Furbolg_Right,
        gg_rct_Left_Start_Bottom, gg_unit_ngt2_0455)
    spawn:addBase("highElves", gg_rct_Left_High_Elves, gg_rct_Right_Start_Top, gg_unit_nheb_0109,
        gg_rct_Right_High_Elves, gg_rct_Left_Start_Bottom, gg_unit_nheb_0036)
    spawn:addBase("highElvesCreep", gg_rct_Left_High_Elves, gg_rct_Aspect_of_Forest_Left, gg_unit_nheb_0109,
        gg_rct_Right_High_Elves, gg_rct_Aspect_of_Forest_Right, gg_unit_nheb_0036)
    spawn:addBase("merc", gg_rct_Camp_Bottom, gg_rct_Right_Start_Bottom, gg_unit_n001_0048, gg_rct_Camp_Top,
        gg_rct_Left_Start_Top, gg_unit_n001_0049)
    spawn:addBase("mine", gg_rct_Left_Workshop, gg_rct_Right_Start_Bottom, gg_unit_h006_0074, gg_rct_Right_Workshop,
        gg_rct_Left_Start_Top, gg_unit_h006_0055)
    spawn:addBase("naga", gg_rct_Naga_Left, gg_rct_Right_Start_Top, gg_unit_nntt_0135, gg_rct_Naga_Right,
        gg_rct_Left_Start_Bottom, gg_unit_nntt_0132)
    spawn:addBase("murloc", gg_rct_Murloc_Spawn_Left, gg_rct_Right_Start_Top, gg_unit_nmh1_0735,
        gg_rct_Murloc_Spawn_Right, gg_rct_Left_Start_Bottom, gg_unit_nmh1_0783)
    spawn:addBase("nagaCreep", gg_rct_Naga_Left, gg_rct_Murloc_Left, gg_unit_nntt_0135, gg_rct_Naga_Right,
        gg_rct_Murloc_Right, gg_unit_nntt_0132)
    spawn:addBase("nightElves", gg_rct_Left_Tree, gg_rct_Right_Start_Top, gg_unit_e003_0058, gg_rct_Right_Tree,
        gg_rct_Left_Start_Bottom, gg_unit_e003_0014)
    spawn:addBase("orc", gg_rct_Left_Orc, gg_rct_Right_Start_Top, gg_unit_o001_0075, gg_rct_Right_Orc,
        gg_rct_Left_Start_Bottom, gg_unit_o001_0078)
    spawn:addBase("shipyard", gg_rct_Left_Shipyard, gg_rct_Shipyard_End, gg_unit_eshy_0120, gg_rct_Right_Shipyard,
        gg_rct_Shipyard_End, gg_unit_eshy_0047)
    spawn:addBase("hshipyard", gg_rct_Human_Shipyard_Left, gg_rct_Right_Shipyard, gg_unit_hshy_0011,
        gg_rct_Human_Shipyard_Right, gg_rct_Left_Shipyard, gg_unit_hshy_0212, 3)
    spawn:addBase("town", gg_rct_Left_Forward_Camp, gg_rct_Right_Start_Bottom, gg_unit_h00F_0029, gg_rct_Right_Forward,
        gg_rct_Left_Start_Top, gg_unit_h00F_0066)
    spawn:addBase("undead", gg_rct_Undead_Left, gg_rct_Right_Start, gg_unit_u001_0262, gg_rct_Undead_Right,
        gg_rct_Left_Start, gg_unit_u001_0264)
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

-- Camera Setup
function init_AutoZoom()
    Trig_AutoZoom = CreateTrigger()
    -- DisableTrigger(Trig_AutoZoom)
    TriggerRegisterTimerEventPeriodic(Trig_AutoZoom, 3.00)

    TriggerAddAction(Trig_AutoZoom, function()
        local i = 1
        local ug = CreateGroup()

        while (i <= 12) do
            ug = GetUnitsInRangeOfLocAll(1350, GetCameraTargetPositionLoc())
            SetCameraFieldForPlayer(ConvertedPlayer(i), CAMERA_FIELD_TARGET_DISTANCE,
                (1700.00 + (1.00 * I2R(CountUnitsInGroup(ug)))), 6.00)
            DestroyGroup(ug)
            i = i + 1
        end
    end)
end

--
-- Game Action Triggers
--

-- Hero Levels Up
function Init_HeroLevelsUp()
    local t = CreateTrigger()

    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_HERO_LEVEL)
    TriggerAddAction(t, function()
        -- Get Locals
        local levelingUnit = GetLevelingUnit()

        debugfunc(function()
            hero.levelUp(levelingUnit)
        end, "hero.levelUp")
    end)
end

-- Unit Casts Spell
function Init_UnitCastsSpell()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_CAST)

    TriggerAddAction(t, function()
        local triggerUnit = GetTriggerUnit()

        debugfunc(function()
            CAST_aiHero(triggerUnit)
        end, "CAST_aiHero")
    end)
end

function CAST_aiHero(triggerUnit)
    if IsUnitInGroup(triggerUnit, ai.heroGroup) then
        local pickedHero = ai.heroOptions[S2I(GetUnitUserData(triggerUnit))]
        ai:castSpell(pickedHero)
    end
end

function Init_PlayerBuysUnit()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SELL)
    TriggerAddAction(t, function()
        local sellingUnit = GetSellingUnit()
        local buyingUnit = GetBuyingUnit()
        local soldUnit = GetSoldUnit()
        local buyingPlayer = GetOwningPlayer(buyingUnit)
        local sellingPlayer = GetOwningPlayer(sellingUnit)

        debugfunc(function()

            -- Hero picked at beginning of game
            if sellingUnit == gg_unit_n00C_0082 then
                local g = CreateGroup()
                g = GetUnitsOfPlayerAndTypeId(buyingPlayer, FourCC("h00H"))
                if CountUnitsInGroup(g) == 1 then
                    RemoveUnit(buyingUnit)
                    hero:setupHero(soldUnit)
                else
                    RemoveUnit(soldUnit)
                end
                DestroyGroup(g)
            end
        end, "hero:setupHero")

    end)
end

function Init_Map()

    FogEnableOff()
    FogMaskEnableOff()
    MeleeStartingVisibility()
    udg_UserPlayers = GetPlayersByMapControl(MAP_CONTROL_USER)
    udg_ALL_PLAYERS = GetPlayersAll()

    -- Turn on Bounty
    ForForce(udg_ALL_PLAYERS, function()
        SetPlayerFlagBJ(PLAYER_STATE_GIVES_BOUNTY, true, GetEnumPlayer())
    end)

    -- Add Computers to their group
    udg_PLAYERcomputers[1] = Player(18)
    udg_PLAYERcomputers[2] = Player(19)
    udg_PLAYERcomputers[3] = Player(20)
    udg_PLAYERcomputers[4] = Player(21)
    udg_PLAYERcomputers[5] = Player(22)
    udg_PLAYERcomputers[6] = Player(23)

    -- Create the Allied Computers
    ForceAddPlayerSimple(udg_PLAYERcomputers[1], udg_PLAYERGRPallied)
    ForceAddPlayerSimple(udg_PLAYERcomputers[2], udg_PLAYERGRPallied)
    ForceAddPlayerSimple(udg_PLAYERcomputers[3], udg_PLAYERGRPallied)

    -- Create the Federation Computers
    ForceAddPlayerSimple(udg_PLAYERcomputers[4], udg_PLAYERGRPfederation)
    ForceAddPlayerSimple(udg_PLAYERcomputers[5], udg_PLAYERGRPfederation)
    ForceAddPlayerSimple(udg_PLAYERcomputers[6], udg_PLAYERGRPfederation)

    -- Create the Allied Users
    ForceAddPlayerSimple(Player(0), udg_PLAYERGRPalliedUsers)
    ForceAddPlayerSimple(Player(1), udg_PLAYERGRPalliedUsers)
    ForceAddPlayerSimple(Player(2), udg_PLAYERGRPalliedUsers)
    ForceAddPlayerSimple(Player(3), udg_PLAYERGRPalliedUsers)
    ForceAddPlayerSimple(Player(4), udg_PLAYERGRPalliedUsers)
    ForceAddPlayerSimple(Player(5), udg_PLAYERGRPalliedUsers)

    -- Create the Federation Users
    ForceAddPlayerSimple(Player(6), udg_PLAYERGRPfederationUsers)
    ForceAddPlayerSimple(Player(7), udg_PLAYERGRPfederationUsers)
    ForceAddPlayerSimple(Player(8), udg_PLAYERGRPfederationUsers)
    ForceAddPlayerSimple(Player(9), udg_PLAYERGRPfederationUsers)
    ForceAddPlayerSimple(Player(10), udg_PLAYERGRPfederationUsers)
    ForceAddPlayerSimple(Player(11), udg_PLAYERGRPfederationUsers)

    -- Change the color of Player 1 and Player 2
    SetPlayerColorBJ(Player(0), PLAYER_COLOR_COAL, true)
    SetPlayerColorBJ(Player(1), PLAYER_COLOR_EMERALD, true)

    -- Change the color of the computer players to all match
    ForForce(udg_PLAYERGRPallied, function()
        SetPlayerColorBJ(GetEnumPlayer(), PLAYER_COLOR_RED, true)
    end)
    ForForce(udg_PLAYERGRPfederation, function()
        SetPlayerColorBJ(GetEnumPlayer(), PLAYER_COLOR_BLUE, true)
    end)

end

function Init_UnitEntersMap()
    Trig_UnitEntersMap = CreateTrigger()
    TriggerRegisterEnterRectSimple(Trig_UnitEntersMap, GetPlayableMapRect())
    TriggerAddAction(Trig_UnitEntersMap, function()
        local triggerUnit = GetTriggerUnit()
        addUnitsToIndex(triggerUnit)
    end)
end

function addUnitsToIndex(unit)

    indexer:add(unit)

    if IsUnitType(unit, UNIT_TYPE_STRUCTURE) == false and IsUnitType(unit, UNIT_TYPE_HERO) == false and
        (IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPallied) or
            IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPfederation)) then
        indexer:order(unit)
    end

end

function Init_UnitDies()
    Trig_UnitDies = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(Trig_UnitDies, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(Trig_UnitDies, function()
        local dieingUnit = GetTriggerUnit()

        indexer:remove(dieingUnit)

    end)
end

function orderStartingUnits()
    local g = CreateGroup()
    local u

    g = GetUnitsInRectAll(GetPlayableMapRect())
    while true do
        u = FirstOfGroup(g)
        if u == nil then
            break
        end

        debugfunc(function()
            indexer:add(u)
            if not (IsUnitType(u, UNIT_TYPE_STRUCTURE)) and not (IsUnitType(u, UNIT_TYPE_HERO)) and
                (IsPlayerInForce(GetOwningPlayer(u), udg_PLAYERGRPallied) or
                    IsPlayerInForce(GetOwningPlayer(u), udg_PLAYERGRPfederation)) then
                print("Order this thing")
                indexer:updateEnd(u)
                indexer:order(u)
            end
        end, "Index")

        GroupRemoveUnit(g, u)
    end
    DestroyGroup(g)
end

-- Unit Issued Target or no Target Order
function Init_IssuedOrder()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_ORDER)

    local triggerUnit = GetTriggerUnit()
    local orderId = GetIssuedOrderId()
    local orderString = OrderId2String(orderId)

    if ordersIgnore[orderString] ~= nil and IsUnitType(unit, UNIT_TYPE_STRUCTURE) == false and
        IsUnitType(unit, UNIT_TYPE_HERO) == false and GetUnitTypeId(unit) ~= FourCC("uloc") and GetUnitTypeId(unit) ~=
        FourCC("h000") and GetUnitTypeId(unit) ~= FourCC("h00V") and GetUnitTypeId(unit) ~= FourCC("h00N") and
        GetUnitTypeId(unit) ~= FourCC("h00O") and GetUnitTypeId(unit) ~= FourCC("h00M") and GetUnitTypeId(unit) ~=
        FourCC("o006") and UnitHasBuffBJ(unit, FourCC("B006")) == false and --[[ Attack! Buff --]] GetOwningPlayer(unit) ~=
        Player(17) and GetOwningPlayer(unit) ~= Player(PLAYER_NEUTRAL_AGGRESSIVE) then

        PolledWait(0.5)
        indexer:order(unit, "attack")
    end
end

-- Unit finishes casting a spell
function Init_finishCasting()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_FINISH)
    TriggerAddAction(t, function()

        local triggerUnit = GetTriggerUnit()
        unitKeepMoving(triggerUnit)
    end)
end

-- Unit finishes Stops a spell
function Init_stopCasting()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    TriggerAddAction(t, function()

        local triggerUnit = GetTriggerUnit()
        unitKeepMoving(triggerUnit)
    end)
end

function unitKeepMoving(unit)
    if GetOwningPlayer(unit) ~= Player(PLAYER_NEUTRAL_AGGRESSIVE) and IsUnitType(unit, UNIT_TYPE_HERO) == false and
        UnitHasBuffBJ(unit, FourCC("B006")) == false and GetUnitTypeId(unit) ~= FourCC("h00M") and GetUnitTypeId(unit) ~=
        FourCC("h00M") and GetUnitTypeId(unit) ~= FourCC("h000") and GetUnitTypeId(unit) ~= FourCC("h00V") and
        GetUnitTypeId(unit) ~= FourCC("h00O") and
        (IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPallied) == true or
            IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPfederation) == true) then
        PolledWait(0.5)
        indexer:order(unit, "attack")
    end
end


function keepUnitsMoving()

    -- Unit Enters Left Start Bottom
    local t = CreateTrigger()
    TriggerRegisterEnterRegionSimple(t, loc.arcaneLeft)
    TriggerRegisterEnterRegionSimple(t, loc.arcaneRight)
    TriggerRegisterEnterRegionSimple(t, loc.castleLeft)
    TriggerRegisterEnterRegionSimple(t, loc.castleRight)
    TriggerRegisterEnterRegionSimple(t, loc.elfLeft)
    TriggerRegisterEnterRegionSimple(t, loc.elfRight)

    TriggerRegisterEnterRegionSimple(t, loc.bottomLeft)
    TriggerRegisterEnterRegionSimple(t, loc.bottomRight)
    TriggerRegisterEnterRegionSimple(t, loc.middleLeft)
    TriggerRegisterEnterRegionSimple(t, loc.middleRight)
    TriggerRegisterEnterRegionSimple(t, loc.topLeft)
    TriggerRegisterEnterRegionSimple(t, loc.topRight)

    TriggerAddAction(t, function()

        local unit = GetTriggerUnit()
        local region = GetTriggeringRegion()
        local player = GetOwningPlayer(unit)
        local isAllied = IsPlayerInForce(player, udg_PLAYERGRPallied)
        local isFed = IsPlayerInForce(player, udg_PLAYERGRPfederation)

        if isAllied or isFed then
            
        end
    end)

end

function getRandomPointInRegion(region)
    return GetRandomReal(region.minX, region.maxX), GetRandomReal(region.minY, region.maxY)
end
