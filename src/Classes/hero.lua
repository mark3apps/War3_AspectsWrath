function _HeroInit()

	-- Create Class Definition
	_Hero = {}
	hero = {}

	---Create new Hero Instance
	---@param unit unit
	---@param heroType heroType
	---@return boolean
	function _Hero.new(unit, heroType)

		---@class hero:unitExtended
		local self = _Unit.new(unit)

		self.heroType = heroType

		---Get Hero Level
		---@return integer
		function self:Level() return GetHeroLevel(self.unit) end

		---comment
		---@return string
		function self:NameProper() return GetHeroProperName(self.unit) end

		---comment
		---@param spellName string
		---@return spell
		function self:Spell(spellName) return self.heroType.spells[spellName] end

		---Get Level of Spell for Hero
		---@param spellName string
		---@return integer
		function self:SpellLevel(spellName) return GetUnitAbilityLevel(self.unit, self:Spell(spellName).id) end

		---Get Spell Cooldown Remaining
		---@param spellName string
		---@return real
		function self:SpellCooldownRemaining(spellName)
			return BlzGetUnitAbilityCooldownRemaining(self.unit, self:Spell(spellName).id)
		end

		---Get Spell Mana Cost
		---@param spellName string
		---@return integer
		function self:SpellManaCost(spellName)
			return BlzGetUnitAbilityManaCost(self.unit, self:Spell(spellName).id, self:SpellLevel(spellName))
		end

		---Get if spell is currently castable or not
		---@param spellName string
		---@return boolean
		function self:SpellIsCastable(spellName)
			if self:SpellLevel(spellName) > 0 and self:SpellCooldownRemaining(spellName) == 0 and self.Mana() >= 0 then
				return true
			else
				return false
			end
		end

		---comment
		---@param spellName string
		---@param spellLevel integer
		---@return integer
		function self:SpellLevelSet(spellName, spellLevel)
			return SetUnitAbilityLevel(self.unit, self:Spell(spellName).id, spellLevel)
		end

		---comment
		---@param spellName string
		---@param amount number
		---@return integer
		function self:SpellLevelIncrement(spellName, amount)
			amount = amount or 1

			local newLevel = self:SpellLevel(spellName) + amount
			if newLevel < 0 then newLevel = 0 end

			return SetUnitAbilityLevel(self.unit, self:Spell(spellName).id, newLevel)
		end

		---comment
		---@return integer
		function self:Strength() return BlzGetUnitIntegerField(self.unit, UNIT_IF_STRENGTH) end
		---comment
		---@return integer
		function self:Agility() return BlzGetUnitIntegerField(self.unit, UNIT_IF_AGILITY) end
		---comment
		---@return integer
		function self:Intelligence() return BlzGetUnitIntegerField(self.unit, UNIT_IF_INTELLIGENCE) end

		---comment
		---@return integer
		function self:StrengthBonus()
			return GetAbilityInteger(self.unit, spell.bonusStats, true, ABILITY_ILF_STRENGTH_BONUS_ISTR, 0)
		end
		---comment
		---@return integer
		function self:AgilityBonus()
			return GetAbilityInteger(self.unit, spell.bonusStats, true, ABILITY_ILF_AGILITY_BONUS, 0)
		end
		---comment
		---@return integer
		function self:IntelligenceBonus()
			return GetAbilityInteger(self.unit, spell.bonusStats, true, ABILITY_ILF_INTELLIGENCE_BONUS, 0)
		end

		---comment
		---@param amount integer
		---@return boolean
		function self:StrengthIncrement(amount)
			return BlzSetUnitIntegerField(self.unit, UNIT_IF_STRENGTH, self:Strength() + amount)
		end
		---comment
		---@param amount number
		---@return boolean
		function self:AgilityIncrement(amount)
			return BlzSetUnitIntegerField(self.unit, UNIT_IF_AGILITY, self:Agility() + amount)
		end
		---comment
		---@param amount number 
		---@return boolean
		function self:IntelligenceIncrement(amount)
			return BlzSetUnitIntegerField(self.unit, UNIT_IF_INTELLIGENCE, self:Intelligence() + amount)
		end

		---comment
		---@param amount integer
		---@return boolean
		function self:StrengthBonusIncrement(amount)
			return SetAbilityInteger(self.unit, spell.bonusStats, true, ABILITY_ILF_STRENGTH_BONUS_ISTR, 0, amount)
		end
		---comment
		---@param amount integer
		---@return boolean
		function self:AgilityBonusIncrement(amount)
			return IncAbilityInteger(self.unit, spell.bonusStats, true, ABILITY_ILF_AGILITY_BONUS, 0, amount)
		end
		---comment
		---@param amount integer
		---@return boolean
		function self:IntelligenceBonusIncrement(amount)
			return SetAbilityInteger(self.unit, spell.bonusStats, true, ABILITY_ILF_INTELLIGENCE_BONUS, 0, amount)
		end

		---comment
		---@return boolean
		function self:StrengthBonusReset()
			return SetAbilityInteger(self.unit, spell.bonusStats, true, ABILITY_ILF_STRENGTH_BONUS_ISTR, 0, 0)
		end
		---comment
		---@return boolean
		function self:AgilityBonusReset()
			return SetAbilityInteger(self.unit, spell.bonusStats, true, ABILITY_ILF_AGILITY_BONUS, 0, 0)
		end
		---comment
		---@return boolean
		function self:IntelligenceBonusReset()
			return SetAbilityInteger(self.unit, spell.bonusStats, true, ABILITY_ILF_INTELLIGENCE_BONUS, 0, 0)
		end

		---comment
		---@return integer
		function self:SkillPoints() return GetHeroSkillPoints(self.unit) end

		---Get a table of Spell Names for Hero
		---@return table
		function self:SpellNames() return self.heroType.spells.names end

		---Get Spell Details
		---@param spellName string
		---@return table
		function self:SpellDetails(spellName)
			local spellDetails = self:Spell(spellName)
			spellDetails.level = self:SpellLevel(spellName)
			spellDetails.cooldown = self:SpellCooldownRemaining(spellName)
			spellDetails.hasBuff = self:HasSpellBuff(spellName)
			spellDetails.mana = self:SpellManaCost(spellName)
			spellDetails.manaLeft = self:Mana() - spellDetails.mana
			spellDetails.castable = self:SpellIsCastable(spellName)

			return spellDetails
		end

		return self
	end

end
