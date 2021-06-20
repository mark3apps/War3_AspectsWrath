--Buggy Has to be fixxed. Disallows Starting the map


--[[
TalentPreMadeChoice 1.2a
by Tasyen

Contains Predefined ChoiceCreations

API
=========
TalentChoiceCreateStats( strAdd,  agiAdd,  intAdd )
Create a new Choice which adds Str, agi and int.
The Choice is added to the last created Tier.
This also generates Main-Text showing the stats gained.
If you wana add pre Text do it as shown below
choice.Text = "your Text" .. choice.Text

TalentChoiceCreateStr( add )
TalentChoiceCreateAgi( add )
TalentChoiceCreateInt( add )

TalentChoiceCreateSustain(lifeAdd, lifeRegAdd, manaAdd, manaRegAdd, armorAdd)

TalentChoiceCreateImproveWeapon( weaponIndex,  damageAdd,  cooldownAdd )

TalentChoiceCreateImproveSpell(spell, manaCostAdd, cooldownAdd, rangeAdd, unitDurAdd, heroDurAdd, missileSpeedAdd, radiusAdd, castTimeAdd)

TalentChoiceCreateAddSpells( spell1,  spell2,  spell3 )
creates a new choice add it to the last created Tier and pushes spell1, spell2, and spell3 onto the choice.
spell2 and spell3 are only added if they are not 0.

TalentChoiceCreateAddSpell( spell,  useButtonInfos )
this choice will add 1 , if useButtonInfos is used then text, HeadLine and Icon are taken from the spell

TalentChoiceCreateReplaceSpell( oldSpell,  newSpell )

=======================
--]]
function TalentPreMadeChoiceStrings()
    Talent.Strings.AddSpellFirst = "Learn:"
    Talent.Strings.AddSpellFirstSeperator = " "
    Talent.Strings.AddSpellSeperator = ", "

    Talent.Strings.ImproveSpellFirst = ""
    Talent.Strings.ImproveSpellSeperatorFirst = ""
    Talent.Strings.ImproveSpellSeperator = ", "
    Talent.Strings.ImproveSpellManaCost = "Manacost-Change"
    Talent.Strings.ImproveSpellCoolDown = "Cooldown-Change"
    Talent.Strings.ImproveSpellRange = "Range-Change"
    Talent.Strings.ImproveSpellRadius = "Radius-Change"
    Talent.Strings.ImproveSpellDurHero = "Hero-Duration-Change"
    Talent.Strings.ImproveSpellDurUnit = "Unit-Duration-Change"
    Talent.Strings.ImproveSpellMissile = "MissleSpeed-Change"
    Talent.Strings.ImproveSpellCastTime = "CastTime-Change"

    Talent.Strings.ImproveWeaponFirst = "Weapon: "
    Talent.Strings.ImproveWeaponSeperatorFirst = ""
    Talent.Strings.ImproveWeaponSeperator = ", "
    Talent.Strings.ImproveWeaponDamage = GetLocalizedString("COLON_DAMAGE")
    Talent.Strings.ImproveWeaponCooldown = GetLocalizedString("COLON_SPEED")

    Talent.Strings.SustainFirst = ""
    Talent.Strings.SustainSeperatorFirst = ""
    Talent.Strings.SustainSeperator = ", "
    Talent.Strings.SustainLife = "Life-Bonus "
    Talent.Strings.SustainLifeReg = "LifeReg-Bonus "
    Talent.Strings.SustainMana = "Mana-Bonus "
    Talent.Strings.SustainManaReg = "ManaReg-Bonus "
    Talent.Strings.SustainArmor = GetLocalizedString("COLON_ARMOR")
    
    Talent.Strings.HeroStatsFirst = ""
    Talent.Strings.HeroStatsSeperator = ", "
    Talent.Strings.HeroStatsSeperatorFirst = ""
    Talent.Strings.HeroStatsStr = GetLocalizedString("COLON_STRENGTH")
    Talent.Strings.HeroStatsAgi = GetLocalizedString("COLON_AGILITY")
    Talent.Strings.HeroStatsInt = GetLocalizedString("COLON_INTELLECT")
end
function TalentChoiceStatsLearn()
	SetHeroStr(udg_Talent__Unit, GetHeroStr(udg_Talent__Unit,false) + udg_Talent__Choice.Str,true)
	SetHeroAgi(udg_Talent__Unit, GetHeroAgi(udg_Talent__Unit,false) + udg_Talent__Choice.Agi,true)
	SetHeroInt(udg_Talent__Unit, GetHeroInt(udg_Talent__Unit,false) + udg_Talent__Choice.Int,true)
end
function TalentChoiceStatsReset()
	SetHeroStr(udg_Talent__Unit, GetHeroStr(udg_Talent__Unit,false) - udg_Talent__Choice.Str,true)
	SetHeroAgi(udg_Talent__Unit, GetHeroAgi(udg_Talent__Unit,false) - udg_Talent__Choice.Agi,true)
	SetHeroInt(udg_Talent__Unit, GetHeroInt(udg_Talent__Unit,false) - udg_Talent__Choice.Int,true)
end
function TalentChoiceSustainLearn()
	BlzSetUnitMaxHP(udg_Talent__Unit, BlzGetUnitMaxHP(udg_Talent__Unit) + udg_Talent__Choice.BonusLife)
	BlzSetUnitMaxMana(udg_Talent__Unit, BlzGetUnitMaxMana(udg_Talent__Unit) + udg_Talent__Choice.BonusMana)
	BlzSetUnitArmor(udg_Talent__Unit, BlzGetUnitArmor(udg_Talent__Unit) + udg_Talent__Choice.BonusArmor)
	BlzSetUnitRealField(udg_Talent__Unit, UNIT_RF_HIT_POINTS_REGENERATION_RATE, BlzGetUnitRealField(udg_Talent__Unit, UNIT_RF_HIT_POINTS_REGENERATION_RATE) + udg_Talent__Choice.BonusLifeReg)
	BlzSetUnitRealField(udg_Talent__Unit, UNIT_RF_MANA_REGENERATION, BlzGetUnitRealField(udg_Talent__Unit, UNIT_RF_MANA_REGENERATION) + udg_Talent__Choice.BonusManaReg)
	SetUnitState(udg_Talent__Unit, UNIT_STATE_LIFE, GetUnitState(udg_Talent__Unit,UNIT_STATE_LIFE) + udg_Talent__Choice.BonusLife)
	SetUnitState(udg_Talent__Unit, UNIT_STATE_MANA, GetUnitState(udg_Talent__Unit,UNIT_STATE_MANA) + udg_Talent__Choice.BonusMana)
end
function TalentChoiceSustainReset()
	BlzSetUnitMaxHP(udg_Talent__Unit, BlzGetUnitMaxHP(udg_Talent__Unit) - udg_Talent__Choice.BonusLife)
	BlzSetUnitMaxMana(udg_Talent__Unit, BlzGetUnitMaxMana(udg_Talent__Unit) - udg_Talent__Choice.BonusMana)
	BlzSetUnitArmor(udg_Talent__Unit, BlzGetUnitArmor(udg_Talent__Unit) - udg_Talent__Choice.BonusArmor)
	BlzSetUnitRealField(udg_Talent__Unit, UNIT_RF_HIT_POINTS_REGENERATION_RATE, BlzGetUnitRealField(udg_Talent__Unit, UNIT_RF_HIT_POINTS_REGENERATION_RATE) - udg_Talent__Choice.BonusLifeReg)
	BlzSetUnitRealField(udg_Talent__Unit, UNIT_RF_MANA_REGENERATION, BlzGetUnitRealField(udg_Talent__Unit, UNIT_RF_MANA_REGENERATION) - udg_Talent__Choice.BonusManaReg)
end

function TalentChoiceImproveWeaponLearn()
	BlzSetUnitAttackCooldown(udg_Talent__Unit, BlzGetUnitAttackCooldown(udg_Talent__Unit, udg_Talent__Choice.WeaponIndex) + udg_Talent__Choice.BonusCooldown, udg_Talent__Choice.WeaponIndex)
	BlzSetUnitBaseDamage(udg_Talent__Unit, BlzGetUnitBaseDamage(udg_Talent__Unit, udg_Talent__Choice.WeaponIndex) + udg_Talent__Choice.BonusDamage, udg_Talent__Choice.WeaponIndex)
end
function TalentChoiceImproveWeaponReset()
	BlzSetUnitAttackCooldown(udg_Talent__Unit, BlzGetUnitAttackCooldown(udg_Talent__Unit, udg_Talent__Choice.WeaponIndex) - udg_Talent__Choice.BonusCooldown, udg_Talent__Choice.WeaponIndex)
	BlzSetUnitBaseDamage(udg_Talent__Unit, BlzGetUnitBaseDamage(udg_Talent__Unit, udg_Talent__Choice.WeaponIndex) - udg_Talent__Choice.BonusDamage, udg_Talent__Choice.WeaponIndex)
end
function TalentChoiceCreateStats(strAdd, agiAdd, intAdd)
    local choice = TalentHeroCreateChoiceEx()
    
	choice.OnLearn = TalentChoiceStatsLearn
	choice.OnReset = TalentChoiceStatsReset
	choice.Str = strAdd
	choice.Agi = agiAdd
	choice.Int = intAdd
	
    choice.Text = Talent.Strings.HeroStatsFirst
    local seperator = Talent.Strings.HeroStatsSeperatorFirst
    local seperator2 = Talent.Strings.HeroStatsSeperator
    if strAdd ~= 0 then	choice.Text = choice.Text.. seperator .. Talent.Strings.HeroStatsStr .. strAdd seperator = seperator2 end
	if agiAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.HeroStatsAgi .. agiAdd seperator = seperator2 end
	if intAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.HeroStatsInt .. intAdd seperator = seperator2 end
	return choice
end
function TalentChoiceCreateStr( add )
	return TalentChoiceCreateStats(add,0,0)
end
function TalentChoiceCreateAgi( add )
	return TalentChoiceCreateStats(0,add,0)
end
function TalentChoiceCreateInt( add )
	return TalentChoiceCreateStats(0,0,add)
end
function TalentChoiceCreateSustain(lifeAdd, lifeRegAdd, manaAdd, manaRegAdd, armorAdd)
	local choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = TalentChoiceSustainLearn
	choice.OnReset = TalentChoiceSustainReset
	choice.BonusLife = lifeAdd
	choice.BonusLifeReg = lifeRegAdd
	choice.BonusMana = manaAdd
	choice.BonusManaReg = manaRegAdd
	choice.BonusArmor = armorAdd

    choice.Text = Talent.Strings.SustainFirst
    local seperator = Talent.Strings.SustainSeperatorFirst
    local seperator2 = Talent.Strings.SustainSeperator
    if armorAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.SustainArmor .. armorAdd seperator = seperator2 end
	if lifeAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.SustainLife .. lifeAdd seperator = seperator2 end
    if lifeRegAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.SustainLifeReg .. lifeRegAdd seperator = seperator2 end
    if manaAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.SustainMana .. manaAdd seperator = seperator2 end
    if manaRegAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.SustainManaReg .. manaRegAdd seperator = seperator2 end

	return choice
end
function TalentChoiceCreateImproveWeapon( weaponIndex,  damageAdd,  cooldownAdd )
	local choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = TalentChoiceImproveWeaponLearn
	choice.OnReset = TalentChoiceImproveWeaponReset
	choice.WeaponIndex = weaponIndex
	choice.BonusDamage = damageAdd
	choice.BonusCooldown = cooldownAdd

    choice.Text = Talent.Strings.ImproveWeaponFirst
    local seperator = Talent.Strings.ImproveWeaponSeperatorFirst
    if damageAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.ImproveWeaponDamage .. damageAdd seperator = Talent.Strings.ImproveWeaponSeperator end
    if cooldownAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.ImproveWeaponCooldown .. cooldownAdd end
	return choice
end

function TalentChoiceImproveSpellLearn()
    local spell = BlzGetUnitAbility(udg_Talent__Unit, udg_Talent__Choice.Spell)
    
    BlzSetAbilityIntegerField(spell, ABILITY_IF_MISSILE_SPEED, BlzGetAbilityIntegerField(spell, ABILITY_IF_MISSILE_SPEED) + udg_Talent__Choice.Speed)
    for level = 0, BlzGetAbilityIntegerField(spell,ABILITY_IF_LEVELS), 1 do
        BlzSetAbilityIntegerLevelField(spell, ABILITY_ILF_MANA_COST, level, BlzGetAbilityIntegerLevelField(spell, ABILITY_ILF_MANA_COST, level) + udg_Talent__Choice.Mana)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_NORMAL, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_NORMAL, level) + udg_Talent__Choice.DurUnit)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_HERO, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_HERO, level) + udg_Talent__Choice.DurHero)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_COOLDOWN, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_COOLDOWN, level) + udg_Talent__Choice.Cool)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_AREA_OF_EFFECT, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_AREA_OF_EFFECT, level) + udg_Talent__Choice.Area)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_CAST_RANGE, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_CAST_RANGE, level) + udg_Talent__Choice.Range)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_CASTING_TIME, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_CASTING_TIME, level) + udg_Talent__Choice.CastTime)
    end
end
function TalentChoiceImproveSpellReset()
    local spell = BlzGetUnitAbility(udg_Talent__Unit, udg_Talent__Choice.Spell)
    
    BlzSetAbilityIntegerField(spell, ABILITY_IF_MISSILE_SPEED, BlzGetAbilityIntegerField(spell, ABILITY_IF_MISSILE_SPEED) - udg_Talent__Choice.Speed)
    for level = 0, BlzGetAbilityIntegerField(spell,ABILITY_IF_LEVELS), 1 do
        BlzSetAbilityIntegerLevelField(spell, ABILITY_ILF_MANA_COST, level, BlzGetAbilityIntegerLevelField(spell, ABILITY_ILF_MANA_COST, level) - udg_Talent__Choice.Mana)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_NORMAL, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_NORMAL, level) - udg_Talent__Choice.DurUnit)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_HERO, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_HERO, level) - udg_Talent__Choice.DurHero)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_COOLDOWN, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_COOLDOWN, level) - udg_Talent__Choice.Cool)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_AREA_OF_EFFECT, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_AREA_OF_EFFECT, level) - udg_Talent__Choice.Area)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_CAST_RANGE, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_CAST_RANGE, level) - udg_Talent__Choice.Range)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_CASTING_TIME, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_CASTING_TIME, level) - udg_Talent__Choice.CastTime)
    end
end
function TalentChoiceCreateImproveSpell(spell, manaCostAdd, cooldownAdd, rangeAdd, unitDurAdd, heroDurAdd, missileSpeedAdd, radiusAdd, castTimeAdd)
	local choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = TalentChoiceImproveSpellLearn
	choice.OnReset = TalentChoiceImproveSpellReset
	choice.Spell = spell
	choice.Mana = manaCostAdd
    choice.Cool = cooldownAdd
    choice.Range = rangeAdd
    choice.DurUnit = unitDurAdd
    choice.DurHero = heroDurAdd
    choice.Speed = missileSpeedAdd
    choice.Area = radiusAdd
    choice.CastTime = castTimeAdd

    choice.Text = Talent.Strings.ImproveSpellFirst
    local seperator = Talent.Strings.ImproveSpellSeperatorFirst
    local seperator2 = Talent.Strings.ImproveSpellSeperator
    if manaCostAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellManaCost .. manaCostAdd seperator = seperator2 end
    if cooldownAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellCoolDown .. cooldownAdd seperator = seperator2 end
    if rangeAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellRange .. rangeAdd seperator = seperator2 end
    if unitDurAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellDurUnit .. unitDurAdd seperator = seperator2 end
    if heroDurAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellDurHero .. heroDurAdd seperator = seperator2 end
    if missileSpeedAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellMissile .. missileSpeedAdd seperator = seperator2 end
    if radiusAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellRadius .. radiusAdd seperator = seperator2 end
    if castTimeAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellCastTime .. castTimeAdd seperator = seperator2 end
	return choice
end
function TalentChoiceCreateAddSpell( spell,  useButtonInfos )
	local choice = TalentHeroCreateChoiceEx()
	TalentChoiceAddAbilityEx(spell, 0)
	
	if useButtonInfos then
		choice.Text = BlzGetAbilityExtendedTooltip(spell,0)
		choice.Head = BlzGetAbilityTooltip(spell,0)
		choice.Icon = BlzGetAbilityIcon(spell)
	end
	return choice
end
function TalentChoiceCreateReplaceSpell( oldSpell,  newSpell )
	local choice = TalentHeroCreateChoiceEx()
	TalentChoiceAddAbilityEx(newSpell, oldSpell)
	return choice
end
function TalentChoiceCreateAddSpells(...)
    local arg = {...} -- get the variable arguments, for some reason it adds an addtional entry at the end.
    local choice = TalentHeroCreateChoiceEx()
    choice.Text = Talent.Strings.AddSpellFirst

    for i = 1, #arg - 1, 1 do
        TalentChoiceAddAbilityEx(arg[i], 0)
        if i == 1 then
			choice.Text = choice.Text .. Talent.Strings.AddSpellFirstSeperator .. GetObjectName(arg[i]).."|r"
        else
			choice.Text = choice.Text .. Talent.Strings.AddSpellSeperator .. GetObjectName(arg[i]).."|r"
		end
	end
	return choice
end
