function TalentStatChange( )
	ModifyHeroStat(udg_Talent__Choice.StatType, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, udg_Talent__Choice.StatPower )
end
function TalentStatChangeReset( )
	ModifyHeroStat(udg_Talent__Choice.StatType, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, udg_Talent__Choice.StatPower )
end
--Example for using Talent by Tasyen.
TalentAddUnitSheet(function()
	--Which HeroType is this; Custom Paladin

	local heroTypeId =  FourCC('H001')
    local choice

	TalentHeroCreate(heroTypeId)
	--HeroTypeId gains at Level 0: create a new Tier
	TalentHeroCreateTierEx(1)

	--Create a new Choice and add it to the last Created Tier
	choice = TalentHeroCreateChoiceEx()	--activade  TalentStr when Picking this Talent
	choice.OnLearn = function() ModifyHeroStat( bj_HEROSTAT_STR, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6 ) end
	choice.OnReset = function() ModifyHeroStat( bj_HEROSTAT_STR, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6 ) end
	choice.Text = "Gain 6 Str"
	choice.Head = "Handschuhe der Kraft"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNGauntletsOfOgrePower.blp"

	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = function() ModifyHeroStat( bj_HEROSTAT_AGI, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6 ) end
	choice.OnReset = function() ModifyHeroStat( bj_HEROSTAT_AGI, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6 ) end
	choice.Text = "Gain 6 Agi"
	choice.Head = "Schuhe der Beweglichkeit"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNSlippersOfAgility.blp"

	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = function() ModifyHeroStat( bj_HEROSTAT_INT, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6 ) end
	choice.OnReset = function() ModifyHeroStat( bj_HEROSTAT_INT, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6 ) end
	choice.Text = "Gain 6 Int"
	choice.Head = "Robe der Weißen"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNRobeOfTheMagi.blp"

	--Level 2
	TalentHeroCreateTierEx(2)
 
	choice = TalentHeroCreateChoiceEx()
	abilityId =  FourCC('Awfb')
	TalentChoiceAddAbility(choice, abilityId) --Skill gained when picking this choice
	choice.Text = BlzGetAbilityExtendedTooltip(abilityId,1)
	choice.Head = BlzGetAbilityTooltip(abilityId,1)
	choice.Icon = BlzGetAbilityIcon(abilityId)

	choice = TalentHeroCreateChoiceEx()
	abilityId =  FourCC('AHhb')
	TalentChoiceAddAbility(choice, abilityId)
	choice.Text = BlzGetAbilityExtendedTooltip(abilityId,1)
	choice.Head = BlzGetAbilityTooltip(abilityId,1)
	choice.Icon = BlzGetAbilityIcon(abilityId)


	--Level 4
	TalentHeroCreateTierEx(4)

	choice = TalentHeroCreateChoiceEx()
	abilityId =  FourCC('ACif')
	TalentChoiceAddAbility(choice, abilityId)
	choice.Text = BlzGetAbilityExtendedTooltip(abilityId,1)
	choice.Head = BlzGetAbilityTooltip(abilityId,1)
	choice.Icon = BlzGetAbilityIcon(abilityId)

	choice = TalentHeroCreateChoiceEx()
	abilityId =  FourCC('Afbt')
	TalentChoiceAddAbility(choice, abilityId)
	choice.Text = BlzGetAbilityExtendedTooltip(abilityId,1)
	choice.Head = BlzGetAbilityTooltip(abilityId,1)
	choice.Icon = BlzGetAbilityIcon(abilityId)

	--Create Own Variabes and attach them

	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = TalentStatChange
	choice.OnReset = TalentStatChangeReset
	choice.Text = "Gain 8 Str"
	choice.Head = "Gürtel der Gigantenkraft"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNBelt.blp"
	choice.StatType = bj_HEROSTAT_STR --save custom Data, one should not overwrite indexes expected with different data
	choice.StatPower = 8
	
	
	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = TalentStatChange
	choice.OnReset = TalentStatChangeReset
	choice.Text = "Gain 8 Int"
	choice.Head = "Robe der Weißen"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNRobeOfTheMagi.blp"
	choice.StatType = bj_HEROSTAT_INT
	choice.StatPower = 8

	--Level 6
	TalentHeroCreateTierEx(6)

	choice = TalentHeroCreateChoiceEx()
	abilityId =  FourCC('AHre')
	TalentChoiceAddAbilityEx(abilityId, 0)
	choice.Text = BlzGetAbilityExtendedTooltip(abilityId,1)
	choice.Head = BlzGetAbilityTooltip(abilityId,1)
	choice.Icon = BlzGetAbilityIcon(abilityId)

	choice = TalentHeroCreateChoiceEx()
	abilityId =  FourCC('AHav')
	TalentChoiceAddAbilityEx(abilityId, 0)
	choice.Text = BlzGetAbilityExtendedTooltip(abilityId,1)
	choice.Head = BlzGetAbilityTooltip(abilityId,1)
	choice.Icon = BlzGetAbilityIcon(abilityId)

	--Level 8
	TalentHeroCreateTierEx(8)

	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = function()
		ModifyHeroStat( bj_HEROSTAT_INT, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6 )
		ModifyHeroStat( bj_HEROSTAT_STR, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6 )
		ModifyHeroStat( bj_HEROSTAT_AGI, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6 )	
	end
	choice.OnReset = function()
		ModifyHeroStat( bj_HEROSTAT_INT, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6 )
		ModifyHeroStat( bj_HEROSTAT_STR, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6 )
		ModifyHeroStat( bj_HEROSTAT_AGI, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6 )	
	end
	choice.Text = "Gain + 6 to all stats"
	choice.Head = "Krone des Königs"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNHelmutPurple.blp"

	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = function() BlzSetUnitBaseDamage(udg_Talent__Unit, BlzGetUnitBaseDamage(udg_Talent__Unit, 0) + 20, 0) end
	choice.OnReset = function() BlzSetUnitBaseDamage(udg_Talent__Unit, BlzGetUnitBaseDamage(udg_Talent__Unit, 0) - 20, 0) end
	choice.Text = "Gain 20 ATK"
	choice.Head = "Mithril Blade"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp"
	
	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = function() BlzSetUnitArmor(udg_Talent__Unit, BlzGetUnitArmor(udg_Talent__Unit) + 10) end
	choice.OnReset = function() BlzSetUnitArmor(udg_Talent__Unit, BlzGetUnitArmor(udg_Talent__Unit) - 10) end
	choice.Text = "Gain 10 Armor"
	choice.Head = "Mithril Armor"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNHumanArmorUpThree.blp"
end)



