--
-- Functions
--
-- **Credit** KickKing
-- Returns true if the value is found in the table
function TableContains(table, element)
    for _, value in pairs(table) do if value == element then return true end end
    return false
end

-- **Credit** KickKing
-- Remove a value from a table
function TableRemoveValue(table, value)
    return table.remove(table, TableFind(table, value))
end

-- **Credit** KickKing
-- Find the indext of a value in a table
function TableFind(tab, el)
    for index, value in pairs(tab) do if value == el then return index end end
end

-- **Credit** KickKing
-- get distance without locations
function DistanceBetweenCoordinates(x1, y1, x2, y2)
    return SquareRoot(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)))
end

-- **Credit** KickKing
-- get distance without locations
function DistanceBetweenUnits(unitA, unitB)
    return DistanceBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA),
                                      GetUnitX(unitB), GetUnitY(unitB))
end

--- **Credit** KickKing
---get angle without locations
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number @angle between 0 and 360
function AngleBetweenCoordinates(x1, y1, x2, y2)
    return bj_RADTODEG * Atan2(y2 - y1, x2 - x1)
end

-- **Credit** KickKing
---get angle without locations
---@param unitA handle @Unit 1
---@param unitB handle @Unit 2
---@return number @angle between 0 and 360
function AngleBetweenUnits(unitA, unitB)
    return AngleBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA),
                                   GetUnitX(unitB), GetUnitY(unitB))
end

-- **Credit** KickKing
-- Polar projection with Locations
function PolarProjectionCoordinates(x, y, dist, angle)
    local newX = x + dist * Cos(angle * bj_DEGTORAD)
    local newY = y + dist * Sin(angle * bj_DEGTORAD)
    return newX, newY
end

-- ** Credit** Planetary
-- Wraps your code in a "Try" loop so you can see errors printed in the log at runtime
function Debugfunc(func, name) -- Turn on runtime logging
    local passed, data = pcall(function()
        func()
        return "func " .. name .. " passed"
    end)
    if not passed then print("|cffff0000[ERROR]|r" .. name, passed, data) end
end

-- **CREDIT** Taysen
-- Converts integer formated types into the 4 digit strings (Opposite of FourCC())
function CC2Four(num) -- Convert from Handle ID to Four Char
    return string.pack(">I4", num)
end

-- **CREDIT** Bribe
-- Timer Utils
do
    local data = {}
    function SetTimerData(whichTimer, dat) data[whichTimer] = dat end

    -- GetData functionality doesn't even require an argument.
    function GetTimerData(whichTimer)
        if not whichTimer then whichTimer = GetExpiredTimer() end
        return data[whichTimer]
    end

    -- NewTimer functionality includes optional parameter to pass data to timer.
    function NewTimer(dat)
        local t = CreateTimer()
        if dat then data[t] = dat end
        return t
    end

    -- Release functionality doesn't even need for you to pass the expired timer.
    -- as an arg. It also returns the user data passed.
    function ReleaseTimer(whichTimer)
        if not whichTimer then whichTimer = GetExpiredTimer() end
        local dat = data[whichTimer]
        data[whichTimer] = nil
        PauseTimer(whichTimer)
        DestroyTimer(whichTimer)
        return dat
    end
end

--- Get a random xy in the specified rect
---@param rect any
---@return any
---@return any
function GetRandomCoordinatesInRect(rect)
    return GetRandomReal(GetRectMinX(rect), GetRectMaxX(rect)), GetRandomReal(GetRectMinY(rect), GetRectMaxY(rect))
end

---Get a random xy in the specified datapoints
---@param xMin number
---@param xMax number
---@param yMin number
---@param yMax number
---@return number
---@return number
function GetRandomCoordinatesInPoints(xMin, xMax, yMin, yMax)
    return GetRandomReal(xMin, xMax), GetRandomReal(yMin, yMax)
end

--- Wait until Order ends or until the amount of time specified
function WaitWhileOrder(unit, time, order, tick)

    -- Set Defaults
    time = time or 2
    order = order or oid.move
    tick = tick or 0.1

    -- Set Local Variables
    local i = 1
    local unitOrder = GetUnitCurrentOrder(unit)

    -- Loop
    while unitOrder == oid.move and i < time do
        unitOrder = GetUnitCurrentOrder(unit)
        PolledWait(tick)
        i = i + tick
    end

    return true
end

---Credit KickKing -A system that allow you to duplicate the functionality of auto-filling in the Object Editor
---@param level             number @How many Levels or iterations to use for this
---@param base              number @The number to start with
---@param previousFactor    number @Multiply the previous level by this value
---@param levelFactor       number @This value exponential adds to itself every level
---@param constant          number @This gets added every level
---@return                  number @The calculated Value
function ValueFactor(level, base, previousFactor, levelFactor, constant)

    local value = base

    if level > 1 then
        for i = 2, level do
            value = (value * previousFactor) + (i * levelFactor) + (constant)
        end
    end

    return value
end

-- **Credit** Nestharus (Converted to Lua and turned into object by KickKing)
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

