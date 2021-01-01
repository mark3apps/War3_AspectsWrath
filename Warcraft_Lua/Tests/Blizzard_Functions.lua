UNIT_STATE_MAX_LIFE = "UNIT_STATE_MAX_LIFE"
UNIT_STATE_MAX_MANA = "UNIT_STATE_MAX_MANA"
UNIT_STATE_MANA = "UNIT_STATE_MANA"


function FourCC(i)
    return i
end

function GetUnitAbilityLevel( a, b )
    return dummy.spellLevel
end

function BlzGetUnitAbilityCooldownRemaining( a, b )
    return dummy.spellCooldownRemaining
end

function BlzGetUnitAbilityCooldown(whichUnit, abilId, level)
    return dummy.spellCooldown
end

function BlzGetUnitAbilityManaCost( a, b, c )
    return dummy.spellMana
end

function GetUnitLifePercent(a)
    return dummy.unitLifePercent
end

function GetWidgetLife(whichWidget)
    return dummy.unitLife
end

function GetUnitState(whichUnit, whichUnitState)
    if whichUnitState == UNIT_STATE_MAX_LIFE then
        return dummy.unitLifeMax

    elseif whichUnitState == UNIT_STATE_MAX_MANA then
        return dummy.unitManaMax

    elseif whichUnitState == UNIT_STATE_MANA then
        return dummy.unitMana
    end
end

function GetUnitManaPercent(whichUnit)
    return dummy.unitManaPercent
end

function GetHeroLevel(whichHero)
    return dummy.heroLevel
end
