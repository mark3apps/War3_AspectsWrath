
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
            local duration = 0.6
            local factor = 1
            local tick = 0.04
            local damageFull = manaSpell * (spellLevel * 0.2 + 0.8)
            local aoe = (300 + (spellLevel * 40)) * manaPercent

            -- Prep Spell
            SetUnitManaBJ(castingUnit, manaLeft)

            g = GetUnitsInRangeOfLocAll(aoe, castL)

            -- Filter Out all of the units that don't matter

            ForGroup(g, function()
                u = GetEnumUnit()

                if not IsUnitType(u, UNIT_TYPE_STRUCTURE) and not IsUnitType(u, UNIT_TYPE_FLYING) and
                    not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) and not IsUnitType(u, UNIT_TYPE_RESISTANT) and
                    IsUnitAliveBJ(u) and not IsUnitAlly(u, GetOwningPlayer(castingUnit)) then

                    PauseUnit(u, true)

                    AddSpecialEffectTarget("Abilities/Spells/Undead/DarkRitual/DarkRitualTarget.mdl", u, "chest")
                    DestroyEffect(GetLastCreatedEffectBJ())
                else
                    GroupRemoveUnit(g, u)
                end

            end)

            debugfunc(function()
                pushbackUnits(g, castingUnit, castX, castY, aoe, damageFull, tick, duration, factor)
            end, "ManaBurst")
            DestroyGroup(g)

        end

    end)

end
