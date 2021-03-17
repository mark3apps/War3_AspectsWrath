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
            hero:levelUp(levelingUnit)
        end, "hero:levelUp")
    end)
end

-- Unit Casts Spell
function Init_UnitCastsSpell()
    trig_CastSpell = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(trig_CastSpell, EVENT_PLAYER_UNIT_SPELL_CAST)

    TriggerAddAction(trig_CastSpell, function()
        local triggerUnit = GetTriggerUnit()
        local order = OrderId2String(GetUnitCurrentOrder(triggerUnit))
        local spellCast = CC2Four(GetSpellAbilityId())

        debugfunc(function()
            CAST_aiHero(triggerUnit, spellCast)
        end, "CAST_aiHero")
    end)
end

-- Unit enters the Map
function Init_UnitEntersMap()

    TriggerRegisterEnterRectSimple(Trig_UnitEntersMap, GetPlayableMapRect())
    TriggerAddAction(Trig_UnitEntersMap, function()
        local triggerUnit = GetTriggerUnit()
        addUnitsToIndex(triggerUnit)
    end)
end

-- Unit Issued Target or no Target Order
function Init_IssuedOrder()

    TriggerRegisterAnyUnitEventBJ(Trig_IssuedOrder, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    TriggerRegisterAnyUnitEventBJ(Trig_IssuedOrder, EVENT_PLAYER_UNIT_ISSUED_ORDER)

    TriggerAddAction(Trig_IssuedOrder, function()
        local triggerUnit = GetTriggerUnit()
        local orderId = GetIssuedOrderId()
        local orderString = OrderId2String(orderId)

        if ordersIgnore[orderString] ~= nil and IsUnitType(triggerUnit, UNIT_TYPE_STRUCTURE) == false and
            IsUnitType(triggerUnit, UNIT_TYPE_HERO) == false and GetUnitTypeId(triggerUnit) ~= FourCC("uloc") and
            GetUnitTypeId(triggerUnit) ~= FourCC("h000") and GetUnitTypeId(triggerUnit) ~= FourCC("h00V") and
            GetUnitTypeId(triggerUnit) ~= FourCC("h00N") and GetUnitTypeId(triggerUnit) ~= FourCC("h00O") and
            GetUnitTypeId(triggerUnit) ~= FourCC("h00M") and GetUnitTypeId(triggerUnit) ~= FourCC("o006") and
            UnitHasBuffBJ(triggerUnit, FourCC("B006")) == false and --[[ Attack! Buff --]] GetOwningPlayer(triggerUnit) ~=
            Player(17) and GetOwningPlayer(triggerUnit) ~= Player(PLAYER_NEUTRAL_AGGRESSIVE) then

            PolledWait(3)
            indexer:order(triggerUnit)
        end
    end)

end

-- Unit finishes casting a spell
function Init_finishCasting()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_FINISH)
    TriggerAddAction(t, function()

        local triggerUnit = GetTriggerUnit()
        if not IsUnitType(triggerUnit, UNIT_TYPE_HERO) then
            unitKeepMoving(triggerUnit)
        end
    end)
end

-- Unit finishes Stops a spell
function Init_stopCasting()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    TriggerAddAction(t, function()
        local triggerUnit = GetTriggerUnit()

        if not IsUnitType(triggerUnit, UNIT_TYPE_HERO) then
            unitKeepMoving(triggerUnit)
        end
    end)
end

-- Unit Dies
function Init_UnitDies()
    TriggerRegisterAnyUnitEventBJ(Trig_UnitDies, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(Trig_UnitDies, function()

        local dieingUnit = GetTriggerUnit()

        if IsUnitInGroup(dieingUnit, base.all.g) then
            debugfunc(function()
                base.died(dieingUnit)
            end, "Building Die")
        end

        if not IsUnitType(dieingUnit, UNIT_TYPE_HERO) then
            indexer:remove(dieingUnit)
        end

    end)
end

-- Unit Enters region (Special)
function init_MoveToNext()
    TriggerAddAction(Trig_moveToNext, function()

        local triggerUnit = GetTriggerUnit()
        local player = GetOwningPlayer(triggerUnit)
        local isAllied = IsPlayerInForce(player, udg_PLAYERGRPallied)
        local isFed = IsPlayerInForce(player, udg_PLAYERGRPfederation)

        if not IsUnitType(triggerUnit, UNIT_TYPE_HERO) then
            if isAllied or isFed then
                local region = loc:getRegion(GetTriggeringRegion())

                if (isAllied and region.allied) or (isFed and region.fed) then
                    local x, y = loc:getRandomXY(region.next)
                    indexer:updateEnd(triggerUnit, x, y)
                    indexer:order(triggerUnit)
                end
            end
        end
    end)
end

-- Update Base Buildings
function init_BaseLoop()
    TriggerRegisterTimerEventPeriodic(Trig_baseLoop, 2.5)
    TriggerAddAction(Trig_baseLoop, function()

        local u, id
        local g = CreateGroup()

        GroupAddGroup(base.all.g, g)
        while true do
            u = FirstOfGroup(g)
            if u == nil then
                break
            end

            base.update(u)

            GroupRemoveUnit(g, u)
        end
        DestroyGroup(g)
    end)
end

do
    local real = MarkGameStarted
    function MarkGameStarted()
        real()
        local trigger = CreateTrigger()
        for i = 0, 11 do
            BlzTriggerRegisterPlayerKeyEvent(trigger, Player(i), OSKEY_G, 0, true)
        end
        TriggerAddAction(trigger, function()

            local player = GetTriggerPlayer()
            local playerDetails = hero.players[GetConvertedPlayerId(player)]
            SelectUnitForPlayerSingle(playerDetails.alter, player)
        end)

        local trigger = CreateTrigger()
        for i = 0, 11 do
            BlzTriggerRegisterPlayerKeyEvent(trigger, Player(i), OSKEY_D, 0, true)
        end
        TriggerAddAction(trigger, function()

            local player = GetTriggerPlayer()
            local pNumber = GetConvertedPlayerId(player)

            debugfunc(function()
                if hero.players[pNumber].cameraLock == true then
                    PanCameraToTimedForPlayer(player, GetUnitX(hero.players[pNumber].hero),
                        GetUnitY(hero.players[pNumber].hero), 0)

                    hero.players[pNumber].cameraLock = false
                    print("Camera Unlocked")
                else
                    SetCameraTargetControllerNoZForPlayer(player, hero.players[pNumber].hero, 0, 0, false)
                    hero.players[pNumber].cameraLock = true
                    print("Camera Locked")
                end
            end, "Camera Lock")
        end)

        local trigger = CreateTrigger()
        for i = 0, 11 do
            BlzTriggerRegisterPlayerKeyEvent(trigger, Player(i), OSKEY_F, 0, true)
        end

        TriggerAddAction(trigger, function()

            local player = GetTriggerPlayer()
            local playerDetails = hero.players[GetConvertedPlayerId(player)]
            SelectUnitForPlayerSingle(playerDetails.hero, player)

            if playerDetails.cameraLocked == true then
                PanCameraToTimedForPlayer(player, GetUnitX(playerDetails.hero), GetUnitY(playerDetails.hero), 0)
            end
        end)
    end
end

--
-- Trigger Functions
-----------------

-- Add unit to index then order to move if unit is computer controlled and a correct unit
function addUnitsToIndex(unit)

    if not IsUnitType(unit, UNIT_TYPE_HERO) then
        indexer:add(unit)

        if IsUnitType(unit, UNIT_TYPE_STRUCTURE) == false and
            (IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPallied) or
                IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPfederation)) then
            indexer:order(unit)
        end
    end
end

function CAST_aiHero(triggerUnit, spellCast)
    if IsUnitInGroup(triggerUnit, ai.heroGroup) then
        local heroName = indexer:getKey(triggerUnit, "heroName")
        local spellCastData = hero[hero[spellCast]]

        if spellCastData ~= nil then
            ai:castSpell(heroName, spellCastData)
            print("MANUAL CAST")
        end
    end
end

-- Order starting units to attack
function orderStartingUnits()
    local g = CreateGroup()
    local u, uId

    g = GetUnitsInRectAll(GetPlayableMapRect())
    while true do
        u = FirstOfGroup(g)
        if u == nil then
            break
        end

        debugfunc(function()

            indexer:add(u)

            uId = GetUnitTypeId(u)
            if not (IsUnitType(u, UNIT_TYPE_STRUCTURE)) and not (IsUnitType(u, UNIT_TYPE_HERO)) and uId ~=
                FourCC("hhdl") and uId ~= FourCC("hpea") and
                (IsPlayerInForce(GetOwningPlayer(u), udg_PLAYERGRPallied) or
                    IsPlayerInForce(GetOwningPlayer(u), udg_PLAYERGRPfederation)) then

                indexer:order(u)
            end
        end, "Index")

        GroupRemoveUnit(g, u)
    end
    DestroyGroup(g)
end

-- Tell unit to keep Attack-Moving to it's indexed destination
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

--
--  Ability Triggers
--

-- Shifter Switch

function ABTY_ShifterSwitch()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerAddAction(t, function()

        if GetSpellAbilityId() == hero.switch.id then

            local u

            local g = CreateGroup()
            local p = GetSpellTargetLoc()
            local castingUnit = GetTriggerUnit()
            local castingPlayer = GetOwningPlayer(castingUnit)

            g = GetUnitsInRangeOfLocAll(200, p)
            RemoveLocation(p)

            local xOrig = GetUnitX(castingUnit)
            local yOrig = GetUnitY(castingUnit)

            while true do
                u = GroupPickRandomUnit(g)
                if u == nil then
                    BlzEndUnitAbilityCooldown(castingUnit, hero.switch.id)
                    local abilitymana = BlzGetAbilityManaCost(hero.switch.id,
                                            GetUnitAbilityLevel(castingUnit, hero.switch.id))
                    SetUnitManaBJ(castingUnit, GetUnitState(castingUnit, UNIT_STATE_MANA) + abilitymana)
                    print("added ability and mana back")

                    break
                end

                if IsUnitIllusion(u) and GetOwningPlayer(u) == castingPlayer then

                    local xIll = GetUnitX(u)
                    local yIll = GetUnitY(u)

                    AddSpecialEffect("Abilities/Spells/Orc/MirrorImage/MirrorImageMissile.mdl", xIll, yIll)
                    DestroyEffect(GetLastCreatedEffectBJ())
                    AddSpecialEffect("Abilities/Spells/Orc/MirrorImage/MirrorImageMissile.mdl", xOrig, yOrig)
                    DestroyEffect(GetLastCreatedEffectBJ())

                    PolledWait(.1)

                    SetUnitX(castingUnit, xIll)
                    SetUnitX(u, xOrig)
                    SetUnitY(castingUnit, yIll)
                    SetUnitY(u, yOrig)

                    SelectUnitForPlayerSingle(castingUnit, castingPlayer)

                    break
                end

                GroupRemoveUnit(g, u)
            end
            DestroyGroup(g)

        end
    end)
end

function ABTY_ManaAddict_ManaExplosion()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerAddAction(t, function()

        if GetSpellAbilityId() == hero.manaOverload.id then
            local u, new, distance, angle, uX, uY, uNewX, uNewY
            local g = CreateGroup()
            local g2 = CreateGroup()

            local castingUnit = GetTriggerUnit()
            local castingPlayer = GetOwningPlayer(castingUnit)

            -- Get Spell Info
            local castX = GetUnitX(castingUnit)
            local castY = GetUnitY(castingUnit)
            local castL = GetUnitLoc(castingUnit)
            local spellLevel = GetUnitAbilityLevel(castingUnit, hero.manaOverload.id)
            local manaStart = GetUnitState(castingUnit, UNIT_STATE_MANA)
            local manaSpell = manaStart * 0.1
            local manaLeft = manaStart - manaSpell

            -- Set up Spell Variables
            local duration = 0.2
            local tick = 0.04
            local loopTimes = duration / tick
            local damageFull = manaSpell * (spellLevel * 0.2 + 0.8)
            local pushbackArea = 200 + (spellLevel * 35)

            local damageTick = damageFull / loopTimes

            print(spellLevel)
            print(damageTick)

            -- Prep Spell
            SetUnitManaBJ(castingUnit, manaLeft)
            GetUnitsInRangeOfLocAll(pushbackArea, castL)

            -- Filter Out all of the units that don't matter
            while true do
                u = FirstOfGroup(g)
                if u == nil then
                    break
                end

                if not IsUnitType(u, UNIT_TYPE_STRUCTURE) and not IsUnitType(u, UNIT_TYPE_FLYING) and
                    not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) and not IsUnitType(u, UNIT_TYPE_RESISTANT) and
                    IsUnitAliveBJ(u) and not IsUnitAlly(u, GetOwningPlayer(castingUnit)) then

                    print("Adding Unit")
                    GroupAddUnit(g2, u)
                    PauseUnit(u, true)

                    AddSpecialEffectTarget("Abilities/Spells/Undead/DarkRitual/DarkRitualTarget.mdl", u, "chest")
                    DestroyEffect(GetLastCreatedEffectBJ())
                end

                GroupRemoveUnit(g, u)
            end
            DestroyGroup(g)

            if CountUnitsInGroup(g2) > 0 then
                for i = 1, loopTimes do
                    print("looping")
                    ForGroup(g2, function()
                        u = GetEnumUnit()

                        if IsUnitAliveBJ(u) then
                            uX = GetUnitX(u)
                            uY = GetUnitY(u)
                            distance = distanceBetweenUnits(castingUnit, u)
                            angle = angleBetweenUnits(castingUnit, u)

                            uNewX, uNewY = PolarProjectionCoordinates(uX, uY, distance, angle)

                            SetUnitX(u, uNewX)
                            SetUnitY(u, uNewY)
                            UnitDamageTargetBJ(castingUnit, u, damageTick, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)

                            if i == loopTimes then
                                PauseUnit(u, false)
                            end
                        else
                            PauseUnit(u, false)
                            GroupRemoveUnit(g2, u)
                        end
                    end)

                    PolledWait(tick)
                end
            end
            DestroyGroup(g2)
        end

    end)

end
