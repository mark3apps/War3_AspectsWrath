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
	loc:add("sTreeLeft", gg_rct_Left_Tree)
	loc:add("sTreeRight", gg_rct_Right_Tree)
	loc:add("sWorkshopLeft", gg_rct_Left_Workshop)
	loc:add("sWorkshopRight", gg_rct_Right_Workshop)
	loc:add("sUndeadLeft", gg_rct_Undead_Left)
	loc:add("sUndeadRight", gg_rct_Undead_Right)

	-- Creep Rects
	loc:add("cForestMidLeft", gg_rct_Aspect_of_Forest_Left_Mid, "cForestLeft", true)
	loc:add("cForestLeft", gg_rct_Aspect_of_Forest_Left, "topRight", true)
	loc:add("cForestMidRight", gg_rct_Aspect_of_Forest_Right_Mid, "cForestRight", false)
	loc:add("cForestRight", gg_rct_Aspect_of_Forest_Right, "bottomLeft", false)
	loc:add("cTidesLeft", gg_rct_Murloc_Left, "topRight", true)
	loc:add("cTidesRight", gg_rct_Murloc_Right, "bottomLeft", false)
	loc:add("cDeathMidLeft", gg_rct_Zombie_Mid_Left, "cDeathLeft", true)
	loc:add("cDeathLeft", gg_rct_Zombie_End_Left, "middleRight", true)
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
		instant4 = 852019,
		unknown = 851974
	}

	typeIdTable = {}
	typeIdTable[FourCC("uloc")] = true
	typeIdTable[FourCC("h000")] = true
	typeIdTable[FourCC("h00V")] = true
	typeIdTable[FourCC("h00N")] = true
	typeIdTable[FourCC("h00O")] = true
	typeIdTable[FourCC("h00M")] = true
	typeIdTable[FourCC("o006")] = true
	typeIdTable[FourCC("h01Z")] = true
	typeIdTable[FourCC("hhdl")] = true
	typeIdTable[FourCC("hpea")] = true

	ordersIgnore = {}
	ordersIgnore[oid.defend] = true
	ordersIgnore[oid.undefend] = true
	ordersIgnore[oid.frenzy] = true
	ordersIgnore[oid.berserk] = true
	ordersIgnore[oid.attack] = true
	ordersIgnore[oid.magicdefense] = true
	ordersIgnore[oid.magicundefense] = true
	ordersIgnore[oid.unknown] = true
	ordersIgnore[oid.bloodluston] = true
	ordersIgnore[oid.bloodlustoff] = true
	ordersIgnore[oid.parasiteon] = true
	ordersIgnore[oid.parasiteoff] = true
	ordersIgnore[oid.slowon] = true
	ordersIgnore[oid.slowoff] = true
	ordersIgnore[oid.flamingarrows] = true
	ordersIgnore[oid.bearform] = true

	-- Spells
	ordersIgnore[FourCC("A016")] = true -- Defend Dwarf
	ordersIgnore[FourCC("A04U")] = true -- Defend Magic
	ordersIgnore[FourCC("A041")] = true -- Defend
	ordersIgnore[FourCC("Afzy")] = true -- Footmen Charge
	ordersIgnore[FourCC("A05J")] = true -- Berserk Dwarf
	ordersIgnore[FourCC("A00J")] = true -- Charge

	mask = {
		black = "ReplaceableTextures\\CameraMasks\\Black_mask.blp",
		white = "ReplaceableTextures\\CameraMasks\\White_mask.blp"
	}

	frame = {
		hero = {
			bar = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BAR, 0),
			hp = {
				BlzGetOriginFrame(ORIGIN_FRAME_HERO_HP_BAR, 0), BlzGetOriginFrame(ORIGIN_FRAME_HERO_HP_BAR, 1),
    BlzGetOriginFrame(ORIGIN_FRAME_HERO_HP_BAR, 2), BlzGetOriginFrame(ORIGIN_FRAME_HERO_HP_BAR, 3),
    BlzGetOriginFrame(ORIGIN_FRAME_HERO_HP_BAR, 4), BlzGetOriginFrame(ORIGIN_FRAME_HERO_HP_BAR, 5)
			},
			mana = {
				BlzGetOriginFrame(ORIGIN_FRAME_HERO_MANA_BAR, 0), BlzGetOriginFrame(ORIGIN_FRAME_HERO_MANA_BAR, 1),
    BlzGetOriginFrame(ORIGIN_FRAME_HERO_MANA_BAR, 2), BlzGetOriginFrame(ORIGIN_FRAME_HERO_MANA_BAR, 3),
    BlzGetOriginFrame(ORIGIN_FRAME_HERO_MANA_BAR, 4), BlzGetOriginFrame(ORIGIN_FRAME_HERO_MANA_BAR, 5)
			},
			button = {
				BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, 0), BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, 1),
    BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, 2), BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, 3),
    BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, 4), BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, 5)
			}
		},

		portrait = BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT, 0),
		consoleUI = BlzGetFrameByName("ConsoleUI", 0),

		upperButtonBar = {
			frame = BlzGetFrameByName("UpperButtonBarFrame", 0),
			questsButton = BlzGetFrameByName("UpperButtonBarQuestsButton", 0),
			menuButton = BlzGetFrameByName("UpperButtonBarMenuButton", 0),
			alliesButton = BlzGetFrameByName("UpperButtonBarAlliesButton", 0),
			chatButton = BlzGetFrameByName("UpperButtonBarChatButton", 0)
		},

		resource = {
			frame = BlzGetFrameByName("ResourceBarFrame", 0),
			goldText = BlzGetFrameByName("ResourceBarGoldText", 0),
			lumberText = BlzGetFrameByName("ResourceBarLumberText", 0),
			supplyText = BlzGetFrameByName("ResourceBarSupplyText", 0),
			upkeepText = BlzGetFrameByName("ResourceBarUpkeepText", 0)
		}
	}

	sky = {blizzardSky = "Environment\\Sky\\BlizzardSky\\BlizzardSky.mdl"}

end

init = {}

function init.Globals()

	--
	-- Set up Bases
	--

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

	base.add(gg_unit_ndh2_0359, 1, false, true, true, true) -- Allied Draenei
	base.add(gg_unit_ndh2_0876, 1, false, true, true, true) -- Federation

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

	base.add(gg_unit_u001_0097, 2, false, true, true, true) -- Federation Undead
	base.add(gg_unit_u001_0098, 2, false, true, true, true) -- Federation

	--
	-- Set up Spawn
	--

	spawn:addBase("arcane", "sArcaneLeft", "bottomRight", gg_unit_h003_0015, "sArcaneRight", "topLeft", gg_unit_h003_0007)
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
	spawn:addBase("draenei", "sKolboldLeft", "topRight", gg_unit_ndh2_0359, "sKolboldRight", "bottomLeft",
	              gg_unit_ndh2_0876)
	spawn:addBase("highElves", "sElfLeft", "topRight", gg_unit_nheb_0109, "sElfRight", "bottomLeft", gg_unit_nheb_0036)
	spawn:addBase("highElvesCreep", "sElfLeft", "cForestMidLeft", gg_unit_nheb_0109, "sElfRight", "cForestMidRight",
	              gg_unit_nheb_0036)
	spawn:addBase("merc", "sCampLeft", "bottomRight", gg_unit_n001_0048, "sCampRight", "topLeft", gg_unit_n001_0049)
	spawn:addBase("mine", "sWorkshopLeft", "bottomRight", gg_unit_h006_0074, "sWorkshopRight", "topLeft", gg_unit_h006_0055)
	spawn:addBase("naga", "sNagaLeft", "topRight", gg_unit_nntt_0135, "sNagaRight", "bottomLeft", gg_unit_nntt_0132)
	spawn:addBase("murloc", "sMurlocLeft", "topRight", gg_unit_nmh1_0735, "sMurlocRight", "bottomLeft", gg_unit_nmh1_0783)
	spawn:addBase("nagaCreep", "sNagaLeft", "cTidesLeft", gg_unit_nntt_0135, "sNagaRight", "cTidesRight", gg_unit_nntt_0132)
	spawn:addBase("nightElves", "sTreeLeft", "topRight", gg_unit_e003_0058, "sTreeRight", "bottomLeft", gg_unit_e003_0014)
	spawn:addBase("orc", "sOrcLeft", "topRight", gg_unit_o001_0075, "sOrcRight", "bottomLeft", gg_unit_o001_0078)
	spawn:addBase("shipyard", "sElfShipyardLeft", "sHumanShipyardRight", gg_unit_eshy_0120, "sElfShipyardRight",
	              "sHumanShipyardLeft", gg_unit_eshy_0047)
	spawn:addBase("hshipyard", "sHumanShipyardLeft", "sHumanShipyardRight", gg_unit_hshy_0011, "sHumanShipyardRight",
	              "sHumanShipyardLeft", gg_unit_hshy_0212, 3)
	spawn:addBase("undead", "sUndeadLeft", "middleRight", gg_unit_u001_0097, "sUndeadRight", "middleLeft",
	              gg_unit_u001_0098)

	-- Arcane Spawn
	spawn:addUnit("arcane", "h00C", 1, {6, 7, 8, 9, 10}, 3, 12) -- Sorcress
	spawn:addUnit("arcane", "nchp", 1, {6, 7, 8, 9, 10}, 5, 12) -- Storm Summonor

	-- Arcane Creep Spawn
	spawn:addUnit("arcaneCreep", "narg", 1, {1, 2, 3, 4}, 2, 12) -- Battle Golem
	spawn:addUnit("arcaneCreep", "hwt2", 1, {1, 3}, 3, 12) -- Water Elemental (Level 2)
	spawn:addUnit("arcaneCreep", "hwt3", 1, {2, 3}, 4, 12) -- Water Elemental (Level 3)
	spawn:addUnit("arcaneCreep", "h00K", 1, {1, 2, 3, 5}, 6, 12) -- Magi Defender

	-- Arcane Hero Sapwn
	spawn:addUnit("arcaneHero", "n00A", 1, {5}, 7, 12) -- Supreme Wizard
	spawn:addUnit("arcaneHero", "nsgg", 1, {4}, 9, 12) -- Seige Golem

	-- Arcane Top Spawn
	spawn:addUnit("arcaneTop", "narg", 2, {4, 5, 6}, 1, 12) -- Battle Golem
	spawn:addUnit("arcaneTop", "hwt2", 1, {4, 6}, 4, 12) -- Water Elemental (Level 2)
	spawn:addUnit("arcaneTop", "n018", 1, {4}, 8, 12) -- Summonor

	-- Arcane Bottom Spawn
	spawn:addUnit("arcaneBottom", "narg", 2, {1, 2, 3}, 2, 12) -- Battle Golem
	spawn:addUnit("arcaneBottom", "hwt2", 1, {1, 3}, 4, 12) -- Water Elemental (Level 2)
	spawn:addUnit("arcaneBottom", "n018", 1, {1}, 8, 12) -- Summonor

	-- Blacksmith Creep Spawn
	spawn:addUnit("blacksmithCreep", "h007", 2, {1, 2, 3, 4}, 1, 6) -- Militia
	spawn:addUnit("blacksmithCreep", "nhea", 1, {1, 2}, 3, 12) -- Archer
	spawn:addUnit("blacksmithCreep", "hspt", 1, {3, 4}, 5, 12) -- Tower Guard
	spawn:addUnit("blacksmithCreep", "h017", 1, {1, 2, 3, 4, 5}, 8, 12) -- Scarlet Commander
	spawn:addUnit("blacksmithCreep", "hcth", 1, {1, 2, 3, 4, 5}, 11, 12) -- Captian

	-- Castle Spawn
	spawn:addUnit("castle", "h00S", 1, {1, 2, 3}, 8, 12) -- Commander

	-- City Elves
	spawn:addUnit("cityElves", "n00C", 1, {1, 3, 5}, 1, 3) -- Blood Elf Archer
	spawn:addUnit("cityElves", "n00C", 1, {1, 2, 3, 4, 5, 6}, 4, 12) -- Blood Elf Archer
	spawn:addUnit("cityElves", "hspt", 1, {1, 3, 4, 5, 6}, 2, 3) -- Blood Elf Breaker
	spawn:addUnit("cityElves", "hspt", 1, {1, 2, 3, 4, 5, 6, 7}, 4, 5) -- Blood Elf Breaker
	spawn:addUnit("cityElves", "hspt", 2, {1, 2, 3, 4, 5}, 6, 12) -- Blood Elf Breaker
	spawn:addUnit("cityElves", "hmpr", 1, {1, 4}, 3, 6) -- Mystic
	spawn:addUnit("cityElves", "hmpr", 1, {1, 2, 3, 4, 5, 7}, 7, 12) -- Mystic

	-- City Front Spawn
	spawn:addUnit("cityFront", "h007", 3, {1, 2, 3, 4, 5, 6}, 1, 2) -- Militia 1
	spawn:addUnit("cityFront", "h015", 2, {1, 2, 3, 4, 5, 6}, 3, 4) -- Militia 2
	spawn:addUnit("cityFront", "hfoo", 3, {1, 2, 3, 4, 5, 6}, 5, 12) -- Footman 1
	spawn:addUnit("cityFront", "hcth", 2, {3, 4, 6}, 5, 12) -- Captian
	spawn:addUnit("cityFront", "h00L", 1, {1, 3, 5}, 6, 12) -- Knight
	spawn:addUnit("cityFront", "hmtm", 1, {1, 4}, 8, 12) -- Catapult
	spawn:addUnit("cityFront", "h00D", 1, {2}, 10, 12) -- Commander of the Guard

	-- City Side Spawn
	spawn:addUnit("citySide", "h015", 1, {6, 7, 8, 9, 10}, 1, 2) -- Militia 1
	spawn:addUnit("citySide", "hfoo", 2, {5, 6, 8, 9}, 2, 3) -- Footman 1
	spawn:addUnit("citySide", "hfoo", 3, {5, 6, 8, 9}, 4, 12) -- Footman 1
	spawn:addUnit("citySide", "h00L", 1, {6, 8}, 3, 4) -- Knight
	spawn:addUnit("citySide", "h00L", 1, {6, 7, 8, 9}, 5, 12) -- Knight
	spawn:addUnit("citySide", "h017", 1, {8, 10}, 6, 12) -- Hardend Footman
	spawn:addUnit("citySide", "n00X", 1, {4, 5, 6, 7, 8, 9}, 3, 12) -- Arbalist

	-- Draenei Spawn
	spawn:addUnit("draenei", "ndrf", 2, {5, 6, 7, 8, 9, 10}, 1, 12) -- Draenei Guardian
	spawn:addUnit("draenei", "ndrf", 1, {7, 8, 9}, 5, 12) -- Draenei Guardian
	spawn:addUnit("draenei", "ndrd", 1, {6, 7, 8, 9, 10}, 3, 12) -- Draenei Darkslayer
	spawn:addUnit("draenei", "ndrs", 1, {7, 10}, 4, 12) -- Draenei Seer
	spawn:addUnit("draenei", "n00I", 1, {5, 6, 8}, 7, 12) -- Draenei Vindicator
	spawn:addUnit("draenei", "ncat", 1, {6, 8, 10}, 6, 12) -- Draenei Demolisher

	-- -- High Elves
	spawn:addUnit("highElves", "h00T", 1, {1, 2, 3, 5}, 1, 3) -- Apprentice
	spawn:addUnit("highElves", "h00T", 1, {1, 3}, 4, 12) -- Apprentice
	spawn:addUnit("highElves", "nhea", 1, {1, 3, 5}, 2, 12) -- Archer
	spawn:addUnit("highElves", "hhes", 2, {1, 2, 3, 4}, 4, 12) -- Swordsman
	spawn:addUnit("highElves", "nemi", 1, {1, 3, 5}, 5, 12) -- Mystic
	spawn:addUnit("highElves", "nws1", 1, {1, 2, 3, 5}, 6, 12) -- Dragon Hawk
	spawn:addUnit("highElves", "h005", 1, {1, 3, 5}, 7, 12) -- High Elf Knight

	-- -- High Elves Creep
	spawn:addUnit("highElvesCreep", "h00T", 1, {1, 2, 3, 4}, 1, 2) -- Swordsman
	spawn:addUnit("highElvesCreep", "hhes", 1, {1, 2, 3, 4}, 3, 12) -- Swordsman
	spawn:addUnit("highElvesCreep", "nhea", 1, {1, 3, 5}, 2, 12) -- Archer
	spawn:addUnit("highElvesCreep", "nemi", 1, {1, 3}, 4, 12) -- Mystic
	spawn:addUnit("highElvesCreep", "h010", 2, {1, 3, 5}, 5, 12) -- Elven Guardian

	-- Merc Spawn
	spawn:addUnit("merc", "n00L", 2, {1, 2, 3, 4, 5, 6}, 1, 12) -- Rogue
	spawn:addUnit("merc", "n003", 1, {2, 3, 4, 5, 6, 7, 8}, 2, 12) -- Merc Archer
	spawn:addUnit("merc", "n002", 2, {1, 2, 3, 5, 6}, 3, 12) -- Merc
	spawn:addUnit("merc", "n008", 1, {2, 5}, 4, 12) -- Enforcer
	spawn:addUnit("merc", "nass", 1, {3, 5, 7}, 5, 12) -- Assasin
	spawn:addUnit("merc", "n005", 1, {1, 5}, 6, 12) -- Bandit Lord

	-- Mine Spawn
	spawn:addUnit("mine", "h01O", 2, {1, 2, 3, 5, 6}, 1, 1) -- Dwarven Soldiers
	spawn:addUnit("mine", "h01O", 3, {1, 2, 3, 4, 5, 6, 7}, 2, 12) -- Dwarven Soldiers
	spawn:addUnit("mine", "h001", 1, {2, 4, 6}, 2, 12) -- Morter Team
	spawn:addUnit("mine", "h008", 1, {1, 2, 3, 4, 5, 6}, 3, 12) -- Rifleman
	spawn:addUnit("mine", "h01P", 1, {1, 2, 3, 4}, 5, 12) -- Dwarven Armored Captians
	spawn:addUnit("mine", "h01E", 1, {1, 2, 3, 4}, 6, 12) -- Magi
	spawn:addUnit("mine", "hgry", 1, {1, 2, 3, 4}, 8, 12) -- Gryphon Rider
	spawn:addUnit("mine", "hmtt", 1, {2, 5}, 6, 12) -- Seige Engine
	spawn:addUnit("mine", "n00F", 1, {1, 3, 6}, 7, 12) -- Automaton

	-- Murloc Spawn
	spawn:addUnit("murloc", "nmcf", 3, {5, 6, 7, 9, 10}, 1, 12) -- Mur'gul Cliffrunner
	spawn:addUnit("murloc", "nnmg", 1, {5, 7}, 2, 12) -- Mur'gul Reaver
	spawn:addUnit("murloc", "nmsn", 1, {6, 8, 10}, 3, 12) -- Mur'gul Snarecaster
	spawn:addUnit("murloc", "nmtw", 1, {4, 8}, 6, 12) -- Mur'gul Tidewarrior

	-- Naga Spawn
	spawn:addUnit("naga", "nmyr", 1, {1, 3}, 1, 3) -- Naga Myrmidon
	spawn:addUnit("naga", "nmyr", 1, {1, 2, 3, 4}, 4, 5) -- Naga Myrmidon
	spawn:addUnit("naga", "nmyr", 1, {1, 2, 3, 4, 5, 6}, 6, 12) -- Naga Myrmidon
	spawn:addUnit("naga", "nnsw", 1, {2, 4, 6}, 3, 12) -- Naga Siren
	spawn:addUnit("naga", "nnrg", 1, {2, 5}, 6, 12) -- Naga Royal Guard
	spawn:addUnit("naga", "nhyc", 1, {1, 4}, 9, 12) -- Dragon Turtle

	-- Naga Creep Spawn
	spawn:addUnit("nagaCreep", "nmyr", 1, {1, 2, 3, 4}, 2, 12) -- Naga Myrmidon
	spawn:addUnit("nagaCreep", "nnsw", 1, {2, 4}, 3, 12) -- Naga Siren
	spawn:addUnit("nagaCreep", "nsnp", 1, {2, 3, 4, 5, 6}, 5, 12) -- Snap Dragon

	-- Night Elves Spawn
	spawn:addUnit("nightElves", "earc", 1, {1, 2, 3, 4, 5}, 1, 12) -- Ranger
	spawn:addUnit("nightElves", "e000", 1, {1, 2, 3, 4, 5}, 2, 12) -- Elite Ranger
	spawn:addUnit("nightElves", "nwat", 1, {7, 8, 9, 10}, 2, 12) -- Sentry
	spawn:addUnit("nightElves", "edry", 1, {7, 9, 10}, 3, 12) -- Dryad
	spawn:addUnit("nightElves", "edoc", 1, {6, 7, 8, 9, 10}, 4, 12) -- Druid of the Claw
	spawn:addUnit("nightElves", "e005", 1, {5, 9}, 5, 12) -- Mountain Giant
	spawn:addUnit("nightElves", "nwnr", 1, {5}, 10, 12) -- Ent

	-- Orc Spawn
	spawn:addUnit("orc", "o002", 2, {1, 3, 5, 6}, 1, 12) -- Grunt
	spawn:addUnit("orc", "o002", 1, {2, 4, 6, 7}, 3, 12) -- Grunt
	spawn:addUnit("orc", "nftr", 1, {2, 4, 6, 7}, 2, 12) -- Troll
	spawn:addUnit("orc", "nogo", 2, {2, 4, 6, 7}, 4, 12) -- Ogre
	spawn:addUnit("orc", "nw2w", 1, {3, 5, 7}, 3, 12) -- Warlock
	spawn:addUnit("orc", "owad", 1, {1, 7}, 6, 12) -- Orc Warchief

	-- Human Shipyard Spawn
	spawn:addUnit("hshipyard", "hdes", 1, {2}, 1, 2) -- Human Frigate
	spawn:addUnit("hshipyard", "hdes", 1, {2, 4}, 3, 4) -- Human Frigate
	spawn:addUnit("hshipyard", "hdes", 1, {2, 4, 6}, 5, 12) -- Human Frigate
	spawn:addUnit("hshipyard", "hbsh", 1, {3}, 6, 12) -- Human Battleship

	-- Night Elf Shipyard Spawn
	spawn:addUnit("shipyard", "edes", 1, {1}, 2, 3) -- Night Elf Frigate
	spawn:addUnit("shipyard", "edes", 1, {1, 3}, 4, 5) -- Night Elf Frigate
	spawn:addUnit("shipyard", "edes", 1, {1, 3, 6}, 6, 12) -- Night Elf Frigate
	spawn:addUnit("shipyard", "ebsh", 1, {3}, 7, 12) -- Night Elf Battleship

	-- Undead Spawn
	spawn:addUnit("undead", "ugho", 4, {6, 7, 8, 9, 10}, 1, 12) -- Ghoul
	spawn:addUnit("undead", "uskm", 1, {6, 7, 8, 9, 10}, 2, 12) -- Skeleton Mage
	spawn:addUnit("undead", "unec", 1, {5, 7, 9}, 4, 12) -- Necromancer
	spawn:addUnit("undead", "nerw", 1, {7}, 6, 12) -- Warlock
	spawn:addUnit("undead", "nfgl", 1, {6, 9}, 8, 12) -- Giant Skeleton
	spawn:addUnit("undead", "ninc", 1, {5, 7}, 3, 5) -- Infernal Contraption (Level 1)
	spawn:addUnit("undead", "ninm", 1, {5, 7}, 6, 9) -- Infernal Contraption (Level 2)
	spawn:addUnit("undead", "nina", 1, {5, 7}, 10, 12) -- Infernal Contraption (Level 3)

	----------------
	-- Set up Spells
	--

	spell = {}

	-- Bonus Spells
	spell.bonusArmor = SPELL.NEW("bonusArmor", "Z001")
	spell.bonusAttackSpeed = SPELL.NEW("bonusAttackSpeed", "Z002")
	spell.bonusCriticalStrike = SPELL.NEW("bonusCriticalStrike", "Z003")
	spell.bonusDamage = SPELL.NEW("bonusDamage", "Z004")
	spell.bonusEvasion = SPELL.NEW("bonusEvasion", "Z005")
	spell.bonusHealthRegen = SPELL.NEW("bonusHealthRegen", "Z006")
	spell.bonusLifeSteal = SPELL.NEW("bonusLifeSteal", "Z007")
	spell.bonusMagicResistance = SPELL.NEW("bonusMagicResistance", "Z008")
	spell.bonusMovementSpeed = SPELL.NEW("bonusMovementSpeed", "Z009")
	spell.bonusStats = SPELL.NEW("bonusStats", "Z010")
	spell.bonusManaRegen = SPELL.NEW("bonusManaRegen", "Z011")

	-- Brawler
	spell.drain = SPELL.NEW("drain", "A01Y", "", oid.stomp, false, {6, 6, 6, 6, 6, 6})
	spell.bloodlust = SPELL.NEW("bloodlust", "A007", "", oid.stomp, true)
	spell.warstomp = SPELL.NEW("warstomp", "A002", "", oid.stomp, true)
	spell.unleashRage = SPELL.NEW("unleashRage", "A029", "", oid.stomp, false, {6, 6, 6})

	-- Tactition
	spell.inspire = SPELL.NEW("inspire", "A042", 0, oid.channel, true)
	spell.ironDefense = SPELL.NEW("ironDefense", "A019", "", oid.roar, true)
	spell.raiseBanner = SPELL.NEW("raiseBanner", "A01I", "", oid.healingward, true)
	spell.attack = SPELL.NEW("attack", "A01B", "", oid.fingerofdeath, true)
	spell.bolster = SPELL.NEW("bolster", "A01Z", "", oid.tranquility, true)

	-- Shift Master
	spell.shadeStrength = SPELL.NEW("shadeStrength", "A037")
	spell.swiftMoves = SPELL.NEW("swiftMoves", "A056")
	spell.swiftAttacks = SPELL.NEW("swiftAttacks", "A030")
	spell.switch = SPELL.NEW("switch", "A03U", "", oid.reveal, true)
	spell.shift = SPELL.NEW("shift", "A03T", "", oid.berserk, true)
	spell.fallingStrike = SPELL.NEW("fallingStrike", "A059", "", oid.thunderbolt, false, {1.5, 1.5, 1.5, 1.5, 1.5, 1.5})
	spell.shiftStorm = SPELL.NEW("shiftStorm", "A03C", "", oid.channel, true)
	spell.felForm = SPELL.NEW("felForm", "A02Y", "", oid.metamorphosis, true)

	-- Mana Addict
	spell.manaShield = SPELL.NEW("manaShield", "A001", "BNms", oid.manashieldon, true)
	spell.manaBomb = SPELL.NEW("manaBomb", "A03P", "", oid.flamestrike, true)
	spell.manaExplosion = SPELL.NEW("manaExplosion", "A018", "", oid.thunderclap, true)
	spell.soulBind = SPELL.NEW("soulBind", "A015", "B00F", oid.custerrockets, true)
	spell.unleashMana = SPELL.NEW("unleashMana", "A03S", "", oid.starfall, false, {15, 15, 15})

	-- Time Mage
	spell.chronoAtrophy = SPELL.NEW("chronoAtrophy", "A04K", "", oid.flamestrike, true)
	spell.decay = SPELL.NEW("decay", "A032", "", oid.shadowstrike, true)
	spell.timeTravel = SPELL.NEW("timeTravel", "A04P", "", oid.clusterrockets, true)
	spell.paradox = SPELL.NEW("paradox", "A04N", "", oid.tranquility, false, {10, 10, 10})

	----------------
	-- Set Up Items
	--
	item = {}
	item.teleport = ITEM.NEW("teleportation", "Teleport", "I000", "A01M", "", false, {6})
	item.tank = ITEM.NEW("tank", "Tank", "I005", "", "", true, {})
	item.mage = ITEM.NEW("mage", "Mage", "I006", "", "", true, {})

	----------------
	-- Set up Heroes
	--
	heroType = {}

	heroType.brawler = HEROTYPE.NEW("brawler", "E001", "h00I")
	heroType.brawler:SpellAdd(spell.bloodlust, false, false, true)
	heroType.brawler:SpellAdd(spell.drain, false, false, true)
	heroType.brawler:SpellAdd(spell.warstomp, false, false, true)
	heroType.brawler:SpellAdd(spell.unleashRage, true, false, true)
	heroType.brawler:ItemAdd(item.teleport)
	heroType.brawler:ItemAdd(item.tank)

	heroType.tactition = HEROTYPE.NEW("tactition", "H009", "h00Y")
	heroType.tactition:SpellAdd(spell.raiseBanner, false, true, true)
	heroType.tactition:SpellAdd(spell.attack, false, false, true)
	heroType.tactition:SpellAdd(spell.bolster, false, false, true)
	heroType.tactition:SpellAdd(spell.ironDefense, false, false, true)
	heroType.tactition:SpellAdd(spell.inspire, true, false, true)
	heroType.tactition:ItemAdd(item.teleport)
	heroType.tactition:ItemAdd(item.tank)

	heroType.shiftMaster = HEROTYPE.NEW("shiftMaster", "E002", "h00Q")
	heroType.shiftMaster:SpellAdd(spell.shift, false, true, true)
	heroType.shiftMaster:SpellAdd(spell.switch, false, false, true)
	heroType.shiftMaster:SpellAdd(spell.felForm, false, false, true)
	heroType.shiftMaster:SpellAdd(spell.fallingStrike, false, false, true)
	heroType.shiftMaster:SpellAdd(spell.shiftStorm, true, false, true)
	heroType.shiftMaster:SpellAdd(spell.shadeStrength, false, false, true)
	heroType.shiftMaster:ItemAdd(item.teleport)
	heroType.shiftMaster:ItemAdd(item.tank)

	heroType.manaAddict = HEROTYPE.NEW("manaAddict", "H00R", "h00B")
	heroType.manaAddict:SpellAdd(spell.manaShield, false, true, false)
	heroType.manaAddict:SpellAdd(spell.manaBomb, false, false , true)
	heroType.manaAddict:SpellAdd(spell.manaExplosion, false, false, true)
	heroType.manaAddict:SpellAdd(spell.soulBind, false, false, true)
	heroType.manaAddict:SpellAdd(spell.unleashMana, true, false, true)
	heroType.manaAddict:ItemAdd(item.teleport)
	heroType.manaAddict:ItemAdd(item.mage)
	-- hero.New("Mana Addict", "H00R", "h00B", {"paradox", "timeTravel", "chronoAtrophy", "decay"}, {"manaShield"}, {}, {"teleportation", "mage"})

	heroType.timeMage = HEROTYPE.NEW("timeMage", "H00J", "h00Z")
	heroType.timeMage:SpellAdd(spell.chronoAtrophy, false, false, true)
	heroType.timeMage:SpellAdd(spell.decay, false, false, true)
	heroType.timeMage:SpellAdd(spell.timeTravel, false, false, true)
	heroType.timeMage:SpellAdd(spell.paradox, true, false, true)
	heroType.timeMage:ItemAdd(item.teleport)
	heroType.timeMage:ItemAdd(item.mage)
	-- hero.New("timeMage", "H00J", "h00Z", {"paradox", "timeTravel", "chronoAtrophy", "decay"}, {}, {}, {"teleportation", "mage"})

end
