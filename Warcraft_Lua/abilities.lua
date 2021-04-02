function init_Abilities()

    -- Init Vars
    ability = {}

    --
    --  Shifter
    --

    -- Switch
    function ability.switch()

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

    --
    -- Mana Addict
    --

    -- Mana Explosion
    function ability.manaExplosion()

        local u, new, distance, angle, uX, uY, uNewX, uNewY, newDistance, sfx
        local g = CreateGroup()

        local castingUnit = GetTriggerUnit()
        local castingPlayer = GetOwningPlayer(castingUnit)

        -- Get Spell Info
        local castX = GetUnitX(castingUnit)
        local castY = GetUnitY(castingUnit)
        local castL = GetUnitLoc(castingUnit)
        local spellLevel = GetUnitAbilityLevel(castingUnit, hero.manaExplosion.id)
        local manaStart = GetUnitState(castingUnit, UNIT_STATE_MANA)
        local manaSpell = manaStart * 0.1
        local manaLeft = manaStart - manaSpell
        local manaPercent = GetUnitManaPercent(castingUnit) / 100

        -- Set up Spell Variables
        local duration = (0.4 * manaPercent) + 0.2
        local factor = 1
        local tick = 0.04
        local damageFull = manaSpell * (spellLevel * 0.2 + 0.8)
        local aoe = (100 + (spellLevel * 40)) * manaPercent + 200

        -- Prep Spell
        SetUnitManaBJ(castingUnit, manaLeft)

        g = GetUnitsInRangeOfLocAll(aoe, castL)

        -- Filter Out all of the units that don't matter

        ForGroup(g, function()
            u = GetEnumUnit()

            if not IsUnitType(u, UNIT_TYPE_STRUCTURE) and not IsUnitType(u, UNIT_TYPE_FLYING) and
                not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) and not IsUnitType(u, UNIT_TYPE_RESISTANT) and
                IsUnitAliveBJ(u) and not IsUnitAlly(u, GetOwningPlayer(castingUnit)) then
                sfx = AddSpecialEffectTarget("Abilities/Spells/Undead/DarkRitual/DarkRitualTarget.mdl", u, "chest")
                DestroyEffect(sfx)
            else
                GroupRemoveUnit(g, u)
            end

        end)

        pushbackUnits(g, castingUnit, castX, castY, aoe, damageFull, tick, duration, factor)
        DestroyGroup(g)
    end

    -- Mana Explosion
    function ability.manaBomb()

        local xNew, yNew, l, u, sfx
        local g = CreateGroup()
        local distance = 0

        -- Caster vars
        local castingUnit = GetTriggerUnit()
        local x = GetUnitX(castingUnit)
        local y = GetUnitY(castingUnit)
        local player = GetOwningPlayer(castingUnit)

        -- Ability Vars
        local xCast = GetSpellTargetX()
        local yCast = GetSpellTargetY()
        local lCast = Location(xCast, yCast)
        local xBomb = x
        local yBomb = y
        local level = GetUnitAbilityLevel(castingUnit, hero.manaBomb.id)
        local mana = GetUnitState(castingUnit, UNIT_STATE_MANA)
        local distanceTotal = distanceBetweenCoordinates(x, y, xCast, yCast)
        local angle = angleBetweenCoordinates(x, y, xCast, yCast)

        -- Constants
        local bombSpeed = 35 + 5 * level
        local damage = (mana * (0.3 + 0.1 * level)) + 100 * level
        local damageAftershock = 25 + 25 * level
        local duration = 0.5
        local durationExplosion = 0.3
        local aoe = 200
        local aoeExplosion = 100
        local bombTick = 0.1
        local explosionTick = 0.04

        local loopTimes = durationExplosion / explosionTick
        local damageTick = damage / loopTimes

        -- Move the Bomb Forward
        while distance + 150 <= distanceTotal do

            xBomb, yBomb = polarProjectionCoordinates(xBomb, yBomb, bombSpeed, angle)
            distance = distanceBetweenCoordinates(x, y, xBomb, yBomb)

            l = Location(xBomb, yBomb)
            sfx = AddSpecialEffectLoc("Abilities/Spells/Undead/DeathandDecay/DeathandDecayDamage.mdl", l)
            DestroyEffect(sfx)
            RemoveLocation(l)

            PolledWait(bombTick)
        end

        PolledWait(0.3)

        -- Explode the Bomb
        sfx = AddSpecialEffectLoc("Flamestrike Mystic I/Flamestrike Mystic I.mdx", lCast)
        DestroyEffect(sfx)
        sfx = AddSpecialEffectLoc("Units/NightElf/Wisp/WispExplode.mdl", lCast)
        DestroyEffect(sfx)

        for i = 1, loopTimes do

            g = GetUnitsInRangeOfLocAll(aoe, lCast)
            while true do
                u = FirstOfGroup(g)
                if u == nil then
                    break
                end

                if not IsUnitType(u, UNIT_TYPE_STRUCTURE) and not IsUnitType(u, UNIT_TYPE_FLYING) and
                    not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) and not IsUnitType(u, UNIT_TYPE_RESISTANT) and
                    IsUnitAliveBJ(u) and not IsUnitAlly(u, GetOwningPlayer(castingUnit)) then

                    UnitDamageTargetBJ(castingUnit, u, damageTick, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC)

                    if i == 1 then
                        sfx = AddSpecialEffectTarget("Abilities/Spells/Undead/DarkRitual/DarkRitualTarget.mdl", u,
                                  "chest")
                        DestroyEffect(sfx)
                    end
                end

                GroupRemoveUnit(g, u)
            end
            DestroyGroup(g)

            PolledWait(explosionTick)
        end

        -- Start the Aftershock
        g = GetUnitsInRangeOfLocAll(aoe, lCast)
        RemoveLocation(lCast)

        ForGroup(g, function()
            u = GetEnumUnit()

            if not IsUnitType(u, UNIT_TYPE_STRUCTURE) and not IsUnitType(u, UNIT_TYPE_FLYING) and
                not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) and not IsUnitType(u, UNIT_TYPE_RESISTANT) and
                IsUnitAliveBJ(u) and not IsUnitAlly(u, GetOwningPlayer(castingUnit)) then

            else
                GroupRemoveUnit(g, u)
            end

        end)

        pushbackUnits(g, castingUnit, xCast, yCast, aoe, damageAftershock, explosionTick, duration, 0.2)
        DestroyGroup(g)

    end

    function ability.unleashMana()
        local u, uTarget, unitCount, sfx1
        local g = CreateGroup()
        local dummy = FourCC("h01H")
        local dummySpell = FourCC("A005")

        -- Caster vars
        local castingUnit = GetTriggerUnit()
        local x = GetUnitX(castingUnit)
        local y = GetUnitY(castingUnit)
        local l = Location(x, y)
        local player = GetOwningPlayer(castingUnit)

        -- Ability Vars
        local level = GetUnitAbilityLevel(castingUnit, hero.unleashMana.id)
        local mana = GetUnitState(castingUnit, UNIT_STATE_MANA)
        local damageMissles = 60 + (60 * level - 60)

        local aoeMissles = 800 + 100 * level

        local duration = 15
        local tick = 0.15

        currentOrder = OrderId2String(GetUnitCurrentOrder(castingUnit))

        sfx1 = AddSpecialEffectLoc("Mana Storm.mdx", l)
        BlzSetSpecialEffectScale(sfx1, 0.75)

        PolledWait(0.5)

        while duration > 0 and mana > 0 and currentOrder == hero.unleashMana.order do

            g = GetUnitsInRangeOfLocAll(aoeMissles, l)
            ForGroup(g, function()
                u = GetEnumUnit()

                if not IsUnitType(u, UNIT_TYPE_STRUCTURE) and not IsUnitType(u, UNIT_TYPE_FLYING) and
                    not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) and not IsUnitType(u, UNIT_TYPE_RESISTANT) and
                    IsUnitAliveBJ(u) and not IsUnitAlly(u, GetOwningPlayer(castingUnit)) then
                else
                    GroupRemoveUnit(g, u)
                end
            end)

            unitCount = CountUnitsInGroup(g)
            if unitCount > 3 then
                unitCount = 3
            end

            -- Shoot the Missles
            for i = 1, unitCount do
                SetUnitState(castingUnit, UNIT_STATE_MANA, mana - 2)
                mana = GetUnitState(castingUnit, UNIT_STATE_MANA)

                uTarget = GroupPickRandomUnit(g)
                u = CreateUnit(player, dummy, x, y, 0)
                UnitApplyTimedLife(u, FourCC("BTLF"), 0.4)
                BlzSetUnitBaseDamage(u, damageMissles, 0)
                BlzSetUnitBaseDamage(castingUnit, damageMissles, 0)
                IssueTargetOrder(u, "attack", uTarget)
            end
            DestroyGroup(g)

            currentOrder = OrderId2String(GetUnitCurrentOrder(castingUnit))

            duration = duration - tick
            PolledWait(tick)
        end

        DestroyEffect(sfx1)
        RemoveLocation(l)

        if currentOrder == hero.unleashMana.order then
            IssueImmediateOrder(castingUnit, "stop")
        end

    end

    function ability.soulBind()
        local u
        local g = CreateGroup()

        -- Caster vars
        local castingUnit = GetTriggerUnit()
        local player = GetOwningPlayer(castingUnit)

        -- Ability Vars
        local level = GetUnitAbilityLevel(castingUnit, hero.soulBind.id)
        local xCast = GetSpellTargetX()
        local yCast = GetSpellTargetY()
        local lCast = Location(xCast, yCast)

        local aoe = valueFactor(level, 150, 1, 20, 0)

        g = GetUnitsInRangeOfLocAll(aoe, lCast)
        RemoveLocation(lCast)

        while true do
            u = FirstOfGroup(g)
            if u == nil then
                break
            end

            if not IsUnitType(u, UNIT_TYPE_STRUCTURE) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) and IsUnitAliveBJ(u) then
                indexer:addKey(u, "soulBind", castingUnit)
                indexer:addKey(u, "soulBindLevel", level)
            end

            GroupRemoveUnit(g, u)
        end
        DestroyGroup(g)

    end

    function ability.DEATH_soulBind()

        local u, mana, sfx

        local dyingUnit = BlzGetEventDamageTarget()
        local lDyingUnit = GetUnitLoc(dyingUnit)

        local castingUnit = indexer:getKey(dyingUnit, "soulBind")
        local level = indexer:getKey(dyingUnit, "soulBindLevel")
        local player = GetOwningPlayer(castingUnit)

        local distance = distanceBetweenUnits(dyingUnit, castingUnit)

        if distance < 2000 then
            u = CreateUnitAtLoc(player, FourCC("e00D"), lDyingUnit, 0)

            while distance > 100 and IsUnitAliveBJ(castingUnit) do
                IssueTargetOrder(u, "attack", castingUnit)
                distance = distanceBetweenUnits(u, castingUnit)
                PolledWait(0.1)
            end

            KillUnit(u)

            mana = GetUnitState(castingUnit, UNIT_STATE_MANA)
            SetUnitState(castingUnit, UNIT_STATE_MANA, mana + valueFactor(level, 20, 1, 5, 0))

            sfx = AddSpecialEffectTarget("Abilities/Spells/Other/Charm/CharmTarget.mdl", castingUnit, "chest")
            DestroyEffect(sfx)

        end
        RemoveLocation(lDyingUnit)
    end

    --
    -- Init Triggers
    --

    -- EVENT Spell Effects Starts
    function ability.Init_SpellEffectTrig()

        -- Add Abilities
        ability.spellEffect = {}
        ability.spellEffect[hero.switch.id] = hero.switch.name
        ability.spellEffect[hero.manaExplosion.id] = hero.manaExplosion.name
        ability.spellEffect[hero.manaBomb.id] = hero.manaBomb.name
        ability.spellEffect[hero.unleashMana.id] = hero.unleashMana.name
        ability.spellEffect[hero.soulBind.id] = hero.soulBind.name

        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
        TriggerAddAction(t, function()
            local abilityId = GetSpellAbilityId()
            local abilityName = ability.spellEffect[abilityId]

            -- If the Ability ID is a match, find the function
            if not (abilityName == nil) then

                debugfunc(function()
                    ability[abilityName]()
                end, "Ability Cast")
            end

        end)
    end

    -- EVENT Unit Dies with Buff
    function ability.Init_SpellUnitDie()

        -- Add Buffs
        ability.buff = {}
        ability.buff[1] = {
            name = "DEATH_" .. hero.soulBind.name,
            id = hero.soulBind.buff
        }

        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DAMAGED)
        TriggerAddAction(t, function()

            if GetUnitState(BlzGetEventDamageTarget(), UNIT_STATE_LIFE) - GetEventDamage() < 0 then
                local dyingUnit = BlzGetEventDamageTarget()

                for i = 1, #ability.buff do

                    if UnitHasBuffBJ(dyingUnit, ability.buff[i].id) then
                        ability[ability.buff[i].name]()
                    end
                end
            end
        end)

    end

    ability.Init_SpellEffectTrig()
    ability.Init_SpellUnitDie()
end
