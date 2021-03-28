
--
--  Shifter
--


-- Switch
function ABTY.shifter.switch()
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

--
-- Mana Addict
--

-- Mana Explosion
function ABTY.manaAddict.manaExplosion()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerAddAction(t, function()

        if GetSpellAbilityId() == hero.manaOverload.id then
            local u, new, distance, angle, uX, uY, uNewX, uNewY, newDistance
            local g = CreateGroup()

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
            local manaPercent = GetUnitManaPercent(castingUnit) / 100

            -- Set up Spell Variables
            local duration = (0.4 * manaPercent) + 0.2
            local factor = 1
            local tick = 0.04
            local damageFull = manaSpell * (spellLevel * 0.2 + 0.8)
            local aoe = (200 + (spellLevel * 40)) * manaPercent + 100

            -- Prep Spell
            SetUnitManaBJ(castingUnit, manaLeft)

            g = GetUnitsInRangeOfLocAll(aoe, castL)

            -- Filter Out all of the units that don't matter

            ForGroup(g, function()
                u = GetEnumUnit()

                if not IsUnitType(u, UNIT_TYPE_STRUCTURE) and not IsUnitType(u, UNIT_TYPE_FLYING) and
                    not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) and not IsUnitType(u, UNIT_TYPE_RESISTANT) and
                    IsUnitAliveBJ(u) and not IsUnitAlly(u, GetOwningPlayer(castingUnit)) then

                    AddSpecialEffectTarget("Abilities/Spells/Undead/DarkRitual/DarkRitualTarget.mdl", u, "chest")
                    DestroyEffect(GetLastCreatedEffectBJ())
                else
                    GroupRemoveUnit(g, u)
                end

            end)

            pushbackUnits(g, castingUnit, castX, castY, aoe, damageFull, tick, duration, factor)
            DestroyGroup(g)

        end

    end)

end


-- Mana Explosion
function ABTY.manaAddict.manaBomb()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerAddAction(t, function()

        if GetSpellAbilityId() == hero.frostNova.id then
            local distance, xNew, yNew, l, u
            local g = CreateGroup()

            -- Caster vars
            local castingUnit = GetTriggerUnit()
            local x = GetUnitX(castingUnit)
            local y = GetUnitY(castingUnit)
            local player = GetOwningPlayer(castingUnit)

            -- Ability Vars
            local xCast = GetOrderPointX()
            local yCast = GetOrderPointY()
            local lCast = Location(xCast, yCast)
            local xBomb = x
            local yBomb = y
            local level = GetUnitAbilityLevel(castingUnit, hero.frostNova.id)
            local mana = GetUnitState(castingUnit, UNIT_STATE_MANA)
            local distanceTotal = distanceBetweenCoordinates(x, y, xCast, yCast)
            local angle = angleBetweenCoordinates(x, y, xCast, yCast)
            
            -- Constants
            local bombSpeed = 35 + 5 * level
            local damage = (mana * (0.5 + 0.1 * level)) + 50 * level
            local duration = 0.3
            local aoe = 100
            local bombTick = 0.1
            local explosionTick = 0.04

            -- Move the Bomb Forward
            while distance <= distanceTotal do

                xBomb, yBomb = polarProjectionCoordinates(xBomb, yBomb, bombSpeed, angle)
                distance = distanceBetweenCoordinates(xBomb, yBomb, xCast, yCast)

                l = Location(xBomb, yBomb)
                AddSpecialEffectLoc("Abilities/Spells/Undead/DeathandDecay/DeathandDecayDamage.mdl", l)
                DestroyEffect(GetLastCreatedEffectBJ())
                RemoveLocation(l)

                PolledWait(bombTick)
            end

            -- Explode the Bomb
            AddSpecialEffectLoc("Units/NightElf/Wisp/WispExplode.mdl", lCast)
            DestroyEffect(GetLastCreatedEffectBJ())

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

            pushbackUnits(g, castingUnit, xCast, yCast, aoe, damage, explosionTick, duration, 1)
            DestroyGroup(g)

            

        end
    end)
end