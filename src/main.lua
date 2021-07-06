function init_Lua()

	shieldTowers = {allied = 7, fed = 7}

	-- Define Classes
	Init_luaGlobals()
	cine.Init()

	HEROTYPE_INIT()
	SPELL_INIT()
	HERO_INIT()
	ITEMTYPE_INIT()
	UNIT_INIT()

	init_locationClass()
	init_indexerClass()
	init_spawnClass()
	-- init_aiClass()
	init_baseClass()
	init_gateClass()

	init_triggers()

	-- Start the Map init
	Init_Map()

	-- Init Classes
	loc = loc_Class.new()
	addRegions()

	indexer = indexer_Class.new()
	-- ai = ai_Class.new()
	spawn = spawn_Class.new()

	-- Init Trigger
	ConditionalTriggerExecute(gg_trg_baseAndHeals)

	-- init_AutoZoom()
	Init_HeroLevelsUp()
	--Init_UnitCastsSpell()
	init_spawnTimers()
	Init_UnitEntersMap()
	-- Init_finishCasting()
	Init_IssuedOrder()
	Init_UnitDies()
	init_MoveToNext()
	Init_PickingPhase()
	init_BaseLoop()
	init_Moonwell_cast()

	-- Abilities
	init_Abilities()

	-- Setup Delayed Init Triggers
	init_Delayed_0()
	init_Delayed_1()
	init_Delayed_10()

	-- dprint("Init Finished")
end

function init_Delayed_0()
	local t = CreateTrigger()
	TriggerRegisterTimerEventSingle(t, 0)
	TriggerAddAction(t, function() cine.mapStart() end)
end

-- Init Delayed Functions 1 second after Map Init
function init_Delayed_1()
	local t = CreateTrigger()
	TriggerRegisterTimerEventSingle(t, 1)
	TriggerAddAction(t, function()
		-- dprint("AI Started", 2)

		gate.main()
		orderStartingUnits()
		spawn:startSpawn()

		-- dprint("Spawn Started", 2)

	end)
end

-- Init Delayed Functions 10 second after Map Init
function init_Delayed_10()
	local t = CreateTrigger()
	TriggerRegisterTimerEventSingle(t, 10)
	TriggerAddAction(t, function()
		try(function()

			-- Set up the Creep Event Timer
			StartTimerBJ(udg_EventTimer, false, 350.00)
		end)
	end)
end

function Init_Map()

	FogMaskEnableOff()
	FogEnableOff()
	MeleeStartingVisibility()
	udg_UserPlayers = GetPlayersByMapControl(MAP_CONTROL_USER)
	udg_ALL_PLAYERS = GetPlayersAll()

	-- Turn on Bounty
	ForForce(udg_ALL_PLAYERS, function() SetPlayerFlagBJ(PLAYER_STATE_GIVES_BOUNTY, true, GetEnumPlayer()) end)

	-- Add Computers to their group
	for i = 1, 6 do udg_PLAYERcomputers[i] = Player(i + 17) end

	-- Create the Allied Computers and set color
	for i = 1, 3 do
		ForceAddPlayerSimple(udg_PLAYERcomputers[i], udg_PLAYERGRPallied)
		SetPlayerColorBJ(udg_PLAYERcomputers[i], PLAYER_COLOR_RED, true)
	end

	-- Create the Federation Computers and set color
	for i = 4, 6 do
		ForceAddPlayerSimple(udg_PLAYERcomputers[i], udg_PLAYERGRPfederation)
		SetPlayerColorBJ(udg_PLAYERcomputers[i], PLAYER_COLOR_BLUE, true)
	end

	for i = 0, 11 do
		if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING then ForceAddPlayer(udg_playersAll, Player(i)) end
	end

	-- Create the Allied / Federation Users
	for i = 0, 5 do ForceAddPlayerSimple(Player(i), udg_PLAYERGRPalliedUsers) end
	for i = 6, 11 do ForceAddPlayerSimple(Player(i), udg_PLAYERGRPfederationUsers) end

	-- Change the color of Player 1 and Player 2
	SetPlayerColorBJ(Player(0), PLAYER_COLOR_COAL, true)
	SetPlayerColorBJ(Player(1), PLAYER_COLOR_EMERALD, true)
end

function init_spawnTimers()
	-- Create Spawn Loop Trigger

	TriggerAddAction(Trig_spawnLoop, function() try(function() spawn:loopSpawn() end) end)

	TriggerAddAction(Trig_upgradeCreeps, function() try(function() spawn:upgradeCreeps() end) end)
end

--
-- Triggers
--

function Init_PickingPhase()
	local t = CreateTrigger()
	TriggerRegisterTimerEventPeriodic(t, 1.00)
	TriggerAddAction(t, function()

		local u, player
		local unitHero = false
		local g = CreateGroup()

		local count = (15 - GetTriggerExecCount(GetTriggeringTrigger()))

		HeroSelector.setTitleText(GetLocalizedString("DEFAULTTIMERDIALOGTEXT") .. ": " .. count)

		if count <= 5 then PlaySoundBJ(gg_snd_BattleNetTick) end

		if count <= 0 then

			ForForce(udg_playersAll, function()
				player = GetEnumPlayer()

				if not PLAYERS[GetConvertedPlayerId(player)].picked then
					print("picking for player " .. GetConvertedPlayerId(player))
					HeroSelector.forcePick(player)
				end

				local heroUnit = PLAYERS[GetConvertedPlayerId(player)].hero.unit
				ShowUnitShow(heroUnit)
				SelectUnitForPlayerSingle(heroUnit, player)

			end)

			DisableTrigger(GetTriggeringTrigger())
			HeroSelector.destroy()

			cine.finish()

			--init_aiLoopStates()
		end
	end)
end
