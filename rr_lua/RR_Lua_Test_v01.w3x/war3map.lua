udg_townVillageForce = nil
udg_TEMP_UnitGroup = nil
gg_rct_R01_01 = nil
gg_rct_R01_02 = nil
gg_rct_R01_03 = nil
gg_rct_R01_04 = nil
gg_rct_R01_01L = nil
gg_rct_R01_02L = nil
gg_rct_R01_03L = nil
gg_rct_R01_04L = nil
gg_trg_Testing = nil
gg_trg_Melee_Initialization = nil
gg_trg_Setup = nil
gg_trg_Send_Units = nil
function InitGlobals()
    udg_townVillageForce = CreateForce()
    udg_TEMP_UnitGroup = CreateGroup()
end

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

--
-- Functions
--
function dprint(message, level)
    level = level or 1

    if debugprint >= level then
        print("|cff00ff00[debug " .. level .. "]|r " .. tostring(message))
    end
end

function tableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function tableRemoveValue(table, value)

    return table.remove(table, tableFind(table, value))
end

function tableFind(tab, el)
    for index, value in pairs(tab) do
        if value == el then
            return index
        end
    end
end

function distanceBetweenCoordinates(x1, y1, x2, y2) -- Find Distance between points
    return SquareRoot(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)))
end

function distanceBetweenUnits(unitA, unitB)
    return distanceBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA), GetUnitX(unitB), GetUnitY(unitB))
end

function angleBetweenCoordinates(x1, y1, x2, y2)
    return bj_RADTODEG * Atan2(y2 - y1, x2 - x1)
end

function angleBetweenUnits(unitA, unitB)
    return angleBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA), GetUnitX(unitB), GetUnitY(unitB))
end

function polarProjectionCoordinates(x, y, dist, angle)
    local newX = x + dist * Cos(angle * bj_DEGTORAD)
    local newY = y + dist * Sin(angle * bj_DEGTORAD)
    return newX, newY
end

function debugfunc(func, name) -- Turn on runtime logging
    local passed, data = pcall(function()
        func()
        return "func " .. name .. " passed"
    end)
    if not passed then
        print("|cffff0000[ERROR]|r" .. name, passed, data)
    end
end

function CC2Four(num) -- Convert from Handle ID to Four Char
    return string.pack(">I4", num)
end

-- Timer Utils
do
    local data = {}
    function SetTimerData(whichTimer, dat)
        data[whichTimer] = dat
    end

    -- GetData functionality doesn't even require an argument.
    function GetTimerData(whichTimer)
        if not whichTimer then
            whichTimer = GetExpiredTimer()
        end
        return data[whichTimer]
    end

    -- NewTimer functionality includes optional parameter to pass data to timer.
    function NewTimer(dat)
        local t = CreateTimer()
        if dat then
            data[t] = dat
        end
        return t
    end

    -- Release functionality doesn't even need for you to pass the expired timer.
    -- as an arg. It also returns the user data passed.
    function ReleaseTimer(whichTimer)
        if not whichTimer then
            whichTimer = GetExpiredTimer()
        end
        local dat = data[whichTimer]
        data[whichTimer] = nil
        PauseTimer(whichTimer)
        DestroyTimer(whichTimer)
        return dat
    end
end

-- Requires https://www.hiveworkshop.com/threads/lua-timerutils.316957/

do
    local oldWait = PolledWait
    function PolledWait(duration)
        local thread = coroutine.running()
        if thread then
            TimerStart(NewTimer(thread), duration, false, function()
                coroutine.resume(ReleaseTimer())
            end)
            coroutine.yield(thread)
        else
            oldWait(duration)
        end
    end

    local oldTSA = TriggerSleepAction
    function TriggerSleepAction(duration)
        PolledWait(duration)
    end

    local thread
    local oldSync = SyncSelections
    function SyncSelectionsHelper()
        local t = thread
        oldSync()
        coroutine.resume(t)
    end
    function SyncSelections()
        thread = coroutine.running()
        if thread then
            ExecuteFunc("SyncSelectionsHelper")
            coroutine.yield(thread)
        else
            oldSync()
        end
    end

    if not EnableWaits then -- Added this check to ensure compatibilitys with Lua Fast Triggers
        local oldAction = TriggerAddAction
        function TriggerAddAction(whichTrig, userAction)
            oldAction(whichTrig, function()
                coroutine.resume(coroutine.create(function()
                    userAction()
                end))
            end)
        end
    end
end

function pushbackUnits(g, castingUnit, x, y, aoe, damage, tick, duration, factor)
    local u, uX, uY, distance, angle, newDistance, uNewX, uNewY

    local loopTimes = duration / tick
    local damageTick = damage / loopTimes

    if CountUnitsInGroup(g) > 0 then
        for i = 1, loopTimes do

            ForGroup(g, function()
                u = GetEnumUnit()

                if IsUnitAliveBJ(u) then

                    if i == 1 then
                        PauseUnit(u, true)
                    end

                    uX = GetUnitX(u)
                    uY = GetUnitY(u)

                    distance = distanceBetweenCoordinates(x, y, uX, uY)
                    angle = angleBetweenCoordinates(x, y, uX, uY)

                    newDistance = ((aoe + 80) - distance) * 0.13 * factor

                    uNewX, uNewY = polarProjectionCoordinates(uX, uY, newDistance, angle)

                    -- if IsTerrainPathable(uNewX, uNewY, PATHING_TYPE_WALKABILITY) then
                    SetUnitX(u, uNewX)
                    SetUnitY(u, uNewY)
                    -- end

                    if damage > 0 then
                        UnitDamageTargetBJ(castingUnit, u, damageTick, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC)
                    end

                    if i >= loopTimes - 1 then
                        PauseUnit(u, false)
                    end
                else
                    PauseUnit(u, false)
                    GroupRemoveUnit(g, u)
                end
            end)

            PolledWait(tick)
        end
    end
    DestroyGroup(g)
end

function valueFactor(level, base, previousFactor, levelFactor, constant)

    local value = base

    if level > 1 then
        for i = 2, level do
            value = (value * previousFactor) + (i * levelFactor) + (constant)
            print(value)
        end
    end

    print(value)
    return value
end


do
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
end

function INIT_ai()

    -- Set up basic Variables
    ai = {}
    ai.towns = {}
    ai.routes = {}
    ai.landmarks = {}
    ai.units = {}
    ai.unitGroup = CreateGroup()

    --------
    --  Add new things to the fold
    --------

    -- Adds a new town to the map.  (NEEDS to be extended with additional RECTs)
    function ai.addTown(name, hostileForce)

        -- Init the Town
        ai.towns[name] = {}
        ai.towns[name].name = name
        ai.towns[name].paused = false
        ai.towns[name].state = "auto"
        ai.towns[name].stateCurrent = "normal"
        ai.towns[name].states = {"auto", "normal", "danger", "pause", "abadon", "gather"}

        -- Set Up Unit Group
        ai.towns[name].units = CreateGroup()
        ai.towns[name].unitCount = 0

        -- Set up Landmarks
        ai.towns[name].residence = {}
        ai.towns[name].safehouse = {}
        ai.towns[name].barracks = {}
        ai.towns[name].patrol = {}
        ai.towns[name].gathering = {}

        -- Sets the Player group that the town will behave hostily towards
        ai.towns[name].hostileForce = hostileForce

        -- Set up the regions and rects to be extended
        ai.towns[name].region = CreateRegion()
        ai.towns[name].rects = {}

        return true
    end

    function ai.extendTown(name, rect)
        RegionAddRect(ai.towns[name].region, rect)

        return true
    end

    -- Add a new landmark
    function ai.addLandmark(town, name, rect, types, unit, radius, maxCapacity)
        unit = unit or nil
        radius = radius or 600
        maxCapacity = maxCapacity or 500

        local handleId = GetHandleId(rect)

        -- Add initial variables to the table
        ai.landmarks[name] = {}
        ai.landmarks[name] {
            id = handleId,
            alive = true,
            state = "normal",
            town = town,
            name = name,
            rect = rect,
            x = GetRectCenterX(rect),
            y = GetRectCenterY(rect),
            types = types,
            unit = unit,
            radius = radius,
            maxCapacity = maxCapacity
        }

        -- Add Landmark information to the town
        for i = 1, #ai.landmarks[name].types do
            ai.towns[town][ai.landmarks[name].type[i]] = name
        end

    end

    -- Adds a route that villagers can take when moving
    function ai.addRoute(name, type)

        -- Set up the route Vars
        ai.routes[name] = {}
        ai.routes[name].name = name
        ai.routes[name].type = type
        ai.routes[name].steps = {}
        ai.routes[name].stepCount = 0

        return true
    end

    -- Adds a unit that exists into the fold to be controlled by the AI. Defaults to Day shift.
    function ai.addUnit(town, type, unit, name, shift)

        shift = shift or "day"

        local handleId = GetHandleId(unit)

        -- Add to Unit groups
        GroupAddUnit(ai.towns[town].units, unit)
        GroupAddUnit(ai.unitGroup, unit)

        -- Update Unit Count
        ai.towns[town].unitCount = CountUnitsInGroup(ai.towns[town].units)
        ai.units.count = CountUnitsInGroup(ai.unitGroup)

        ai.units[handleId] = {}
        ai.units[handleId] = {
            id = handleId,
            unitType = GetUnitTypeId(unit),
            unitName = GetUnitName(unit),
            paused = false,
            town = town,
            name = name,
            shift = shift,
            state = "auto",
            type = type,
            route = nil,
            step = 1,
            routes = {},
            xHome = GetUnitX(unit),
            yHome = GetUnitY(unit),
            xDest = nil,
            yDest = nil
        }

        if type == "villager" then
            ai.units[handleId].states = {"relax", "move", "sleep"}
            ai.units[handleId].stateCurrent = "relax"

        end

        return true
    end

    --------
    --  TOWN ACTIONS
    --------

    function ai.townState(town, state)

        if tableContains(ai.towns[town].states, state) then
            ai.towns[town].state = state
            ai.towns[town].stateCurrent = state

            ai.updateTown(town, state)

            return true
        end

        return false
    end

    function ai.townHostileForce(town, force)

        ai.towns[town].force = force
        return true

    end

    function ai.townVulnerableUnits(town, flag)

        ForGroup(ai.towns[town].units, function()
            local unit = GetEnumUnit()

            SetUnitInvulnerable(unit, flag)
        end)

        return true

    end

    function ai.townUnitsHurt(town, low, high, kill)

        ForGroup(ai.towns[town].units, function()
            local unit = GetEnumUnit()
            local percentLife = GetUnitLifePercent(unit)
            local randInt = GetRandomInt(low, high)

            percentLife = percentLife - randInt
            if not kill and percentLife <= 0 then
                percentLife = 1
            end

            SetUnitLifePercentBJ(unit, percentLife)
        end)

        return true
    end

    function ai.townUnitsSetLife(town, low, high)

        ForGroup(ai.towns[town].units, function()
            local unit = GetEnumUnit()
            local percentLife = GetRandomInt(low, high)

            SetUnitLifePercentBJ(unit, percentLife)
        end)

        return true
    end

    --------
    --  ROUTE ACTIONS
    --------

    -- Adds at the end of the selected route, a new place for a unit to move to.
    function ai.routeAddStep(route, rect, time, lookAtRect, animation, speed)

        -- Set default values if one wasn't specified
        speed = speed or nil
        animation = animation or "stand 1"
        lookAtRect = lookAtRect or nil
        time = time or 0

        -- Add Event to Rect Entering Trigger
        TriggerRegisterEnterRectSimple(ai.unitEntersRegion, rect)

        -- Update the count of steps in the route
        local stepCount = ai.routes[route].stepCount + 1

        -- Add the step to the route
        ai.routes[route].stepCount = stepCount
        ai.routes[route].steps[stepCount] = {
            optionCount = 1,
            options = {}
        }

        ai.routes[route].steps[stepCount].optionCount = 1
        ai.routes[route].steps[stepCount].options[1] = {
            rect = rect,
            x = GetRectCenterX(rect),
            y = GetRectCenterY(rect),
            time = time,
            speed = speed,
            lookAtRect = lookAtRect,
            animation = animation
        }

        return true

    end

    -- Adds an additional option to the picked route step
    function ai.routeAddOption(route, step, rect, time, lookAtRect, animation, speed)

        -- Set default values if one wasn't specified
        speed = speed or nil
        animation = animation or "stand 1"
        lookAtRect = lookAtRect or nil
        time = time or 0

        -- Update the Option Count for the Route
        local stepCount = ai.routes[name].stepCount
        local optionCount = ai.routes[name].steps[stepCount].optionCount + 1

        -- Add the Option to the Step in the Route
        ai.routes[name].steps[stepCount].optionCount = optionCount
        ai.routes[name].steps[stepCount].options[optionCount] =
            {
                rect = rect,
                x = GetRectCenterX(rect),
                y = GetRectCenterY(rect),
                time = time,
                speed = speed,
                lookAtRect = lookAtRect,
                animation = animation
            }

        return true

    end

    function ai.routeGetStepCount(route)
        return ai.routes[route].stepCount
    end

    function ai.routeGetOptionCount(route, step)
        return ai.routes[route].steps[step].optionCount
    end

    --------
    --  UNIT ACTIONS
    --------

    function ai.unitAddRoute(unit, route)
        local handleId = GetHandleId(unit)

        if ai.routes[route] ~= nil then
            table.insert(ai.units[handleId].routes, route)
            return true
        end

        return false

    end

    function ai.unitRemoveRoute(unit, route)
        local handleId = GetHandleId(unit)
        local routes = ai.units[handleId].routes

        if tableContains(routes, route) then
            ai.units[handleId].routes = tableRemoveValue(routes, route)
            return true
        end

        return false
    end

    function ai.unitKill(unit)
        local handleId = GetHandleId(unit)
        local data = ai.units[handleId]
        ai.units[handleId] = nil
        GroupRemoveUnit(ai.unitGroup, unit)
        GroupRemoveUnit(ai.towns[data.town].units, unit)

        KillUnit(unit)

        return true
    end

    function ai.unitRemove(unit)
        local handleId = GetHandleId(unit)
        local data = ai.units[handleId]
        ai.units[handleId] = nil
        GroupRemoveUnit(ai.unitGroup, unit)
        GroupRemoveUnit(ai.towns[data.town].units, unit)

        RemoveUnit(unit)

        return true
    end

    function ai.unitPause(unit, flag)
        local handleId = GetHandleId(unit)

        PauseUnit(unit, flag)
        ai.units[handleId].paused = flag

        return true
    end

    function ai.unitPickRoute(unit, route, step)
        local data = ai.units[GetHandleId(unit)]

        if #data.routes == 0 and route == nil then
            return false
        end

        route = route or data.routes[GetRandomInt(1, #data.routes)]
        step = step or 1

        local optionNumber = GetRandomInt(1, ai.routes[route].steps[step].optionCount)
        local option = ai.routes[route].steps[step].options[optionNumber]

        ai.units[data.id].stateCurrent = "moving"
        ai.units[data.id].route = route
        ai.units[data.id].step = step
        ai.units[data.id].option = optionNumber
        ai.units[data.id].xDest = option.x
        ai.units[data.id].yDest = option.y
        ai.units[data.id].optionSpeed = option.speed
        ai.units[data.id].optionTime = option.time
        ai.units[data.id].optionLookAtRect = option.lookAtRect
        ai.units[data.id].optionAnimation = option.animation

        SetUnitMoveSpeed(unit, option.speed)
        IssuePointOrderById(unit, oid.move, option.x, option.y)

        return true

    end

    -- Set the Unit State
    function ai.unitSetState(unit, state)
        local data = ai.units[GetHandleId(unit)]

        if tableContains(ai.units[data.id].states, state) then
            ai.units[data.id].state = state

            ai.unitSTATE[state](unit)

            return true
        end

        return false
    end

    --------
    --  UNIT STATES
    --------

    ai.unitSTATE = {}

    --
    -- MOVE
    function ai.unitSTATE.move(unit)
        local data = ai.units[GetHandleId(unit)]

        if #data.routes == 0 and route == nil then
            return false
        end

        local route = data.routes[GetRandomInt(1, #data.routes)]

        ai.unitPickRoute(unit)

        return true
    end

    --
    -- RETURN HOME
    function ai.unitSTATE.returnHome(unit)
        local data = ai.units[GetHandleId(unit)]

        ai.units[data.id].stateCurrent = "returningHome"
        ai.units[data.id].route = nil
        ai.units[data.id].step = 0
        ai.units[data.id].option = 0
        ai.units[data.id].xDest = nil
        ai.units[data.id].yDest = nil
        ai.units[data.id].optionSpeed = nil
        ai.units[data.id].optionTime = nil
        ai.units[data.id].optionLookAtRect = nil
        ai.units[data.id].optionAnimation = nil

        IssuePointOrderById(unit, oid.move, data.xHome, data.yHome)

        return true
    end

    --------
    --  UNIT STATES TRANSIENT
    --------

    --
    -- MOVING
    function ai.unitSTATE.moving(unit)
        local data = ai.units[GetHandleId(unit)]

        if GetUnitCurrentOrder(unit) ~= oid.move then
            IssuePointOrderById(unit, oid.move, data.xDest, data.yDest)
        end
        local data = ai.units[GetHandleId(unit)]

        return true
    end

    --
    -- WAITING
    function ai.unitSTATE.waiting(unit)

        -- Do nothing, come on now, what did you think was going to be here??
        return true
    end

    --
    -- RETURNING HOME
    function ai.unitSTATE.returningHome(unit)
        local data = ai.units[GetHandleId(unit)]

        if GetUnitCurrentOrder(unit) ~= oid.move then
            IssuePointOrderById(unit, oid.move, data.xHome, data.yHome)
        end
        local data = ai.units[GetHandleId(unit)]

        return true
    end

    --------
    --  TRIGGERS
    --------

    function ai.INIT_triggers()

        --------
        --  UNIT LOOPS
        --------

        local t = CreateTrigger()
        TriggerRegisterTimerEventPeriodic(t, 2)
        TriggerAddAction(t, function()

            local u, data, handleId
            local g = CreateGroup()
            GroupAddGroup(ai.unitGroup, g)

            -- Loop through the Units and check to see if they need anything
            u = FirstOfGroup(g)
            while u ~= nil do
                handleId = GetHandleId(unit)
                data = ai.units[handleId]

                GroupRemoveUnit(g, u)
                u = FirstOfGroup(g)
            end
            DestroyGroup(g)

        end)

        -- Trigger Unit enters a Rect in a Route
        ai.unitEntersRegion = CreateTrigger()
        TriggerAddAction(ai.unitEntersRegion, function()
            local unit = GetEnteringUnit()

            debugfunc(function()
                print("Entering")

                if IsUnitInGroup(unit, ai.unitGroup) then
                    print("Yay!")

                    local handleId = GetHandleId(unit)
                    local data = ai.units[handleId]

                    PolledWait(0.5)

                    -- If the Rect isn't the targetted end rect, ignore any future actions
                    if not RectContainsUnit(ai.routes[data.route].steps[data.step].options[data.option].rect, unit) then
                        print("DOESN'T CONTAIN")
                        return false
                    end

                    local order = oid.move
                    local i = 1
                    while order == oid.move and i < 15 do
                        order = GetUnitCurrentOrder(unit)
                        PolledWait(0.1)
                        i = i + 1
                    end

                    -- If current State is moving
                    if data.stateCurrent == "moving" then

                        ai.units[data.id].stateCurrent = "waiting"

                        if data.optionLookAtRect ~= nil then
                            local x = GetUnitX(unit)
                            local y = GetUnitY(unit)

                            -- Get the angle to the rect and find a point 10 units in that direction
                            local facingAngle = angleBetweenCoordinates(x, y, GetRectCenterX(data.optionLookAtRect),
                                                    GetRectCenterY(data.optionLookAtRect))
                            local xNew, yNew = polarProjectionCoordinates(x, y, 10, facingAngle)
                            IssuePointOrderById(unit, oid.move, xNew, yNew)

                            order = oid.move
                            i = 1
                            while order == oid.move and i < 15 do
                                order = GetUnitCurrentOrder(unit)
                                PolledWait(0.1)
                                i = i + 1
                            end
                        end

                        if data.optionAnimation ~= nil then
                            print(data.optionAnimation)
                            SetUnitAnimation(unit, data.optionAnimation)
                        end

                        PolledWait(data.optionTime)

                        local routeSteps = ai.routes[data.route].stepCount

                        print(routeSteps .. ":" .. data.step)

                        if routeSteps == data.step then
                            ai.unitSetState(unit, "returnHome")
                        else
                            ai.unitPickRoute(unit, data.route, (data.step + 1))
                        end
                    end
                end
            end, "Entering")
        end)

    end

    --------
    --  INIT
    --------

    function ai.init()
        ai.INIT_triggers()

    end

    ai.init()
end

--------
--  Main -- This runs everything
--------
do
    debugfunc(function()
        INIT_ai()
        print("AI INIT")
    end, "Init")
end

function CreateUnitsForPlayer0()
    local p = Player(0)
    local u
    local unitID
    local t
    local life
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1724.3, -1058.5, 203.341, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1774.6, -779.5, 154.802, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1854.4, -224.2, 319.558, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1990.4, 279.6, 130.115, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2090.1, 510.0, 226.534, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2161.4, 562.0, 231.830, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2255.1, 544.6, 93.936, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2468.3, 394.7, 56.384, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2672.1, 212.2, 179.094, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2799.1, -21.6, 139.388, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2848.7, -288.2, 217.525, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2852.9, -670.8, 321.437, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2810.3, -927.8, 80.313, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2782.2, -1071.5, 259.879, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2767.7, -1154.5, 173.183, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2783.1, -1235.3, 108.405, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2719.0, -1315.9, 352.584, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2582.9, -1402.1, 318.108, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2390.5, -1559.5, 140.168, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2264.1, -1617.3, 79.697, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2126.9, -1679.0, 334.170, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2011.1, -1686.0, 112.031, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2046.8, -1411.7, 230.742, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2240.8, -896.0, 206.461, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2372.5, -504.5, 27.324, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2397.1, -653.6, 259.340, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2421.7, -914.2, 57.515, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1573.1, -1720.7, 141.783, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1553.1, -1904.0, 256.407, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1617.0, -2102.5, 16.491, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1839.2, -2142.6, 281.984, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2090.4, -2194.1, 119.766, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2316.3, -2221.1, 40.332, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2479.3, -2171.9, 359.341, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2535.8, -2135.7, 28.291, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2664.4, -2005.9, 159.043, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1208.4, -2403.2, 33.817, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1416.8, -2642.5, 63.854, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1721.6, -2764.6, 327.414, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2020.3, -2758.0, 298.661, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2302.3, -2651.1, 80.928, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2522.1, -2543.5, 211.285, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2624.5, -2507.2, 320.844, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2642.3, -2444.5, 300.002, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1119.3, -984.6, 289.169, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1160.4, -670.3, 180.972, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1280.6, -341.7, 191.783, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1307.4, -235.0, 8.877, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1271.9, 1071.0, 343.685, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1302.4, 1271.1, 214.515, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1375.4, 1386.9, 50.835, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1570.5, 1547.1, 318.536, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1808.2, 1615.9, 148.419, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1969.6, 1553.9, 176.050, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2233.5, 1550.5, 256.802, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2458.3, 1513.1, 91.145, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2534.2, 1436.2, 290.279, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2561.0, 1338.2, 289.510, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2495.8, 1186.6, 148.902, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2261.7, 881.6, 42.639, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2190.2, 881.6, 270.371, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2168.4, 964.9, 229.698, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2060.4, 1032.3, 243.541, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1876.1, 953.3, 75.676, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1730.5, 817.0, 155.967, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1608.9, 2326.1, 306.418, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1957.9, 2480.3, 254.682, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2451.0, 2597.5, 190.948, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2777.1, 2604.7, 10.811, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -3071.5, 1789.0, 249.793, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -3099.8, 1444.9, 332.929, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -3217.4, 874.2, 32.488, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -3218.5, 516.0, 215.833, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -3192.5, 421.3, 98.616, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -3028.7, -998.9, 200.485, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2988.6, -1410.3, 261.603, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2947.7, -1798.1, 84.542, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2935.5, -1905.8, 324.777, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2985.9, -1948.6, 356.034, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2962.3, -2082.2, 353.342, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -3181.9, -2967.3, 17.732, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2944.1, -3150.3, 246.310, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2643.8, -3345.1, 330.688, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2476.3, -3409.3, 168.502, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2344.7, -3412.8, 209.812, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2172.2, -3402.5, 95.881, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1912.3, -3397.3, 222.546, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1773.5, -3359.1, 262.340, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1726.0, -3273.9, 65.722, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1856.6, -3180.3, 43.705, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2278.9, -3073.8, 273.392, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2589.7, -3011.2, 278.688, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2757.2, -2977.3, 298.277, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -2823.0, -2945.0, 188.202, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -343.0, -2960.0, 245.739, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -56.4, -2881.5, 15.535, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 303.7, -2611.4, 349.782, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 616.2, -2316.0, 309.681, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 685.8, -2175.7, 222.634, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 639.7, -2016.5, 179.720, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 322.7, -1862.0, 275.084, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 61.6, -1775.3, 231.083, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -245.7, -1783.3, 59.317, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -331.8, -1843.8, 120.535, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -343.9, -2036.2, 152.835, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 953.2, -3095.0, 42.639, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1019.8, -2957.7, 166.569, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1282.7, -2676.0, 42.551, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1502.4, -2362.2, 13.030, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1607.8, -2094.0, 350.980, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1603.9, -1924.8, 274.667, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1593.2, -1847.6, 101.231, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1382.8, -1760.4, 240.125, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1167.9, -1687.8, 15.085, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 906.6, -1648.1, 167.613, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 852.3, -1718.7, 98.682, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 982.4, -1951.0, 91.552, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1161.9, -2121.4, 55.406, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1215.5, -2216.6, 295.431, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1155.1, -2257.2, 87.586, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 454.0, -3059.3, 199.803, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 250.0, -3212.3, 333.247, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 14.2, -3421.9, 255.209, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -204.9, -3529.6, 74.182, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -473.5, -3382.0, 2.461, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -584.1, -3315.2, 200.935, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -649.4, -3249.4, 314.955, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -783.3, -3154.5, 324.777, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -805.1, -3006.7, 286.686, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -622.9, -2876.9, 90.893, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1138.5, -938.3, 301.441, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1631.8, -873.9, 324.887, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 2096.1, -880.4, 327.018, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 2346.8, -982.7, 118.118, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 2431.3, -1172.9, 126.830, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 2438.1, -1481.6, 139.783, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 2401.9, -1890.1, 110.614, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 2404.6, -2167.1, 329.754, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 2384.2, -2394.5, 55.087, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 2348.8, -2502.9, 187.070, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 2291.2, -2573.0, 44.705, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 2241.3, -2635.8, 92.068, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 2130.0, -2750.0, 275.732, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 2019.4, -2773.4, 244.475, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1869.9, -2831.8, 219.821, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1779.8, -2873.6, 258.143, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 1694.2, -2882.2, 67.107, FourCC("hfoo"))
end

function CreatePlayerBuildings()
end

function CreatePlayerUnits()
    CreateUnitsForPlayer0()
end

function CreateAllUnits()
    CreatePlayerBuildings()
    CreatePlayerUnits()
end

function CreateRegions()
    local we
    gg_rct_R01_01 = Rect(1024.0, -480.0, 1568.0, 64.0)
    gg_rct_R01_02 = Rect(224.0, 544.0, 928.0, 1216.0)
    gg_rct_R01_03 = Rect(-960.0, 160.0, -384.0, 832.0)
    gg_rct_R01_04 = Rect(-1216.0, -2048.0, -384.0, -1152.0)
    gg_rct_R01_01L = Rect(576.0, -608.0, 704.0, -480.0)
    gg_rct_R01_02L = Rect(576.0, 160.0, 704.0, 288.0)
    gg_rct_R01_03L = Rect(-1472.0, 96.0, -1344.0, 224.0)
    gg_rct_R01_04L = Rect(-192.0, -416.0, -64.0, -288.0)
end

function Trig_Testing_Actions()
    SetUnitAnimation(GetEnumUnit(), "stand")
    TriggerSleepAction(2)
end

function InitTrig_Testing()
    gg_trg_Testing = CreateTrigger()
    DisableTrigger(gg_trg_Testing)
    TriggerRegisterEnterRectSimple(gg_trg_Testing, gg_rct_R01_01)
    TriggerAddAction(gg_trg_Testing, Trig_Testing_Actions)
end

function Trig_Melee_Initialization_Actions()
    MeleeStartingVisibility()
        INIT_Config()
end

function InitTrig_Melee_Initialization()
    gg_trg_Melee_Initialization = CreateTrigger()
    TriggerAddAction(gg_trg_Melee_Initialization, Trig_Melee_Initialization_Actions)
end

function InitCustomTriggers()
    InitTrig_Testing()
    InitTrig_Melee_Initialization()
end

function RunInitializationTriggers()
    ConditionalTriggerExecute(gg_trg_Melee_Initialization)
end

function InitCustomPlayerSlots()
    SetPlayerStartLocation(Player(0), 0)
    SetPlayerColor(Player(0), ConvertPlayerColor(0))
    SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    SetPlayerRaceSelectable(Player(0), true)
    SetPlayerController(Player(0), MAP_CONTROL_USER)
end

function InitCustomTeams()
    SetPlayerTeam(Player(0), 0)
end

function main()
    SetCameraBounds(-3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    NewSoundEnvironment("Default")
    SetAmbientDaySound("LordaeronSummerDay")
    SetAmbientNightSound("LordaeronSummerNight")
    SetMapMusic("Music", true, 0)
    CreateRegions()
    CreateAllUnits()
    InitBlizzard()
    InitGlobals()
    InitCustomTriggers()
    RunInitializationTriggers()
end

function config()
    SetMapName("TRIGSTR_001")
    SetMapDescription("TRIGSTR_003")
    SetPlayers(1)
    SetTeams(1)
    SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)
    DefineStartLocation(0, 1792.0, -2368.0)
    InitCustomPlayerSlots()
    SetPlayerSlotAvailable(Player(0), MAP_CONTROL_USER)
    InitGenericPlayerSlots()
end

