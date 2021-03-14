function init_Lua()
    debugprint = 2
    -- Define Classes
    debugfunc(function()
        init_triggers()

        Init_luaGlobals()
        init_locationClass()
        init_indexerClass()
        init_heroClass()
        init_spawnClass()
        init_aiClass()
        init_baseClass()
        --init_gateClass()
    end, "Define Classes")
    --dprint("Classes Defined", 2)

    -- Start the Map init
    Init_Map()

    -- Init Classes
    debugfunc(function()
        loc = loc_Class.new()
        addRegions()
        addBases()

        indexer = indexer_Class.new()
        hero = hero_Class.new()
        ai = ai_Class.new()
        spawn = spawn_Class.new()

        

    end, "Init Classes")

    --dprint("Classes Initialized", 2)
    


    -- Init Trigger
    debugfunc(function()
        ConditionalTriggerExecute(gg_trg_baseAndHeals)

        init_AutoZoom()
        Init_HeroLevelsUp()
        Init_UnitCastsSpell()
        init_spawnTimers()
        Init_UnitEntersMap()
        Init_stopCasting()
        Init_finishCasting()
        Init_IssuedOrder()
        Init_UnitDies()
        init_MoveToNext()
        Init_PickingPhase()
        init_BaseLoop()

        -- Abilities
        ABTY_ShifterSwitch()
    end, "Init Triggers")

    --dprint("Triggers Initialized", 2)

    -- Spawn Base / Unit Setup
    -- Init Trigger
    debugfunc(function()
        spawnAddBases()
        spawnAddUnits()
    end, "Init Spawn")

    --dprint("Spawn Setup", 2)

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

            startHeroPicker()
        end, "Start Delayed Triggers")
        --dprint("AI Started", 2)

        orderStartingUnits()
        spawn:startSpawn()

        --dprint("Spawn Started", 2)

    end)
end

-- Init Delayed Functions 10 second after Map Init
function init_Delayed_10()
    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 10)
    TriggerAddAction(t, function()
        debugfunc(function()
            FogMaskEnableOn()
            FogEnableOn()

            -- Set up the Creep Event Timer
            StartTimerBJ(udg_EventTimer, false, 350.00)
        end, "Start Delayed Triggers")
    end)
end

function Init_Map()

    FogMaskEnableOff()
    FogEnableOff()
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

    for i = 0, 11 do
        if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING then
            ForceAddPlayer(udg_playersAll, Player(i))
        end
    end

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

function startHeroPicker()
    HeroSelector.initHeroes()

    for i = 1, 8 do
        HeroSelector.show(true, player(i))
    end
end

function init_aiLoopStates()
    if (ai.count > 0) then
        local t = CreateTrigger()
        TriggerRegisterTimerEventPeriodic(t, ai.tick)
        TriggerAddAction(t, function()
            --print(" -- ")
            if ai.loop >= ai.count then
                ai.loop = 1
            else
                ai.loop = ai.loop + 1
            end

            local i = ai.heroOptions[ai.loop]
            print(i)

            debugfunc(function()
                ai:updateIntel(i)

                if ai:isAlive(i) then
                    ai:STATEDead(i)
                    ai:STATELowHealth(i)
                    ai:STATEStopFleeing(i)
                    ai:STATEFleeing(i)
                    ai:STATEHighHealth(i)
                    ai:STATEcastingSpell(i)
                    ai:STATEDefend(i)
                    ai:STATEDefending(i)
                    ai:STATEAbilities(i)
                    ai:CleanUp(i)
                else
                    ai:STATERevived(i)
                end
                print(" --")
            end, "AI STATES")
        end)
    end
end

function init_spawnTimers()
    -- Create Spawn Loop Trigger

    TriggerAddAction(Trig_spawnLoop, function()
        debugfunc(function()
            spawn:loopSpawn()
        end, "spawn:loopSpawn")
    end)

    TriggerAddAction(Trig_upgradeCreeps, function()
        debugfunc(function()
            spawn:upgradeCreeps()
        end, "spawn:upgradeCreeps()")
    end)
end

--
-- Triggers
--

-- Camera Setup
function init_AutoZoom()

    -- DisableTrigger(Trig_AutoZoom)
    TriggerRegisterTimerEventPeriodic(Trig_AutoZoom, 3.00)
    TriggerAddAction(Trig_AutoZoom, function()
        local i = 1
        local ug = CreateGroup()

        while (i <= 12) do
            if GetLocalPlayer() == Player(i) then
                ug = GetUnitsInRangeOfLocAll(1350, GetCameraTargetPositionLoc())
                SetCameraFieldForPlayer(ConvertedPlayer(i), CAMERA_FIELD_TARGET_DISTANCE,
                    (1400.00 + (1.00 * I2R(CountUnitsInGroup(ug)))), 6.00)
                DestroyGroup(ug)
            end
            i = i + 1
        end
    end)
end

function Init_PickingPhase()
    local t = CreateTrigger()
    TriggerRegisterTimerEventPeriodic(t, 1.00)
    TriggerAddAction(t, function()
        -- debugfunc(function()
        local u, player
        local unitHero = false
        local g = CreateGroup()

        local count = (5 - GetTriggerExecCount(GetTriggeringTrigger()))

        HeroSelector.setTitleText(GetLocalizedString("DEFAULTTIMERDIALOGTEXT") .. ": " .. count)

        if count <= 5 then
            PlaySoundBJ(gg_snd_BattleNetTick)
        end

        if count <= 0 then

            ForForce(udg_playersAll, function()
                player = GetEnumPlayer()

                if not hero.players[GetConvertedPlayerId(player)].picked then
                    print("picking for player " .. GetConvertedPlayerId(player))
                    HeroSelector.forcePick(player)
                end

                local heroUnit = hero.players[GetConvertedPlayerId(player)].hero
                ShowUnitShow(heroUnit)
                SelectUnitForPlayerSingle(heroUnit, player)
                PanCameraToTimedForPlayer(player, GetUnitX(heroUnit), GetUnitY(heroUnit), 0)
            end)

            DisableTrigger(GetTriggeringTrigger())
            HeroSelector.destroy()
            init_aiLoopStates()
        end
        -- end, "Pick Hero")
    end)
end
