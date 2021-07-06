function HERO_INIT()

	-- Create Class Definition
	HERO = {}
	HERO.HEROES = {}

	---Get Hero from Unit
	---@param u unit
	---@return HERO
	function HERO.GET(u)
		return HERO.HEROES["H" .. GetHandleId(u)]
	end

	---Create new Hero Instance
	---@param unit unit
	---@return HERO
	function HERO.NEW(unit)

		---@class HERO:UNIT
		local self = {}
		self = UNIT.NEW(unit)

		self.heroType = HEROTYPE.GET(unit)

		---Get Hero Level
		---@return integer
		function self:Level() return GetHeroLevel(self.unit) end

		---Level up Hero
		---@return boolean
		function self:LevelUp()

			AdjustPlayerStateBJ(50, self:Player(), PLAYER_STATE_RESOURCE_LUMBER)
			SetPlayerTechResearchedSwap(FourCC("R005"), self:Level() - 1, self:Player())

			if (ModuloInteger(self:Level(), 4) == 0) then
				SetPlayerTechResearchedSwap(FourCC("R006"), self:Level() / 4, self:Player())
			end

			-- Remove Ability Points
			if (self:Level() < 15 and ModuloInteger(self:Level(), 2) ~= 0) then
				ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SUB, 1)
			elseif (self:Level() < 25 and self:Level() >= 15 and ModuloInteger(self:Level(), 3) ~= 0) then
				ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SUB, 1)
			elseif (self:Level() >= 25 and ModuloInteger(self:Level(), 4) ~= 0) then
				ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SUB, 1)
			end

			print("Level Up, " .. self.unitTypeFour .. " Level: " .. self:Level())

			return true
		end

		---comment
		---@return string
		function self:NameProper() return GetHeroProperName(self.unit) end

		---Change Hero Proper Name
		---@param name string
		---@return boolean
		function self:NameProperChange(name)
			BlzSetHeroProperName(self.unit, name)
			return true
		end

		---Get Level of Spell for Hero
		---@param spellObj SPELL
		---@return integer
		function self:SpellLevel(spellObj) return GetUnitAbilityLevel(self.unit, spellObj.id) end

		---Get Spell Cooldown Remaining
		---@param spellObj SPELL
		---@return real
		function self:SpellCooldownRemaining(spellObj) return BlzGetUnitAbilityCooldownRemaining(self.unit, spellObj.id) end

		---Get Spell Mana Cost
		---@param spellObj SPELL
		---@return integer
		function self:SpellManaCost(spellObj)
			return BlzGetUnitAbilityManaCost(self.unit, spellObj.id, self:SpellLevel(spellObj))
		end

		---Get if spell is currently castable or not
		---@param spellObj SPELL
		---@return boolean
		function self:SpellIsCastable(spellObj)
			if self:SpellLevel(spellObj) > 0 and self:SpellCooldownRemaining(spellObj) == 0 and self.Mana() >= 0 then
				return true
			else
				return false
			end
		end

		---comment
		---@param spellObj SPELL
		---@param spellLevel integer
		---@return integer
		function self:SpellLevelSet(spellObj, spellLevel) return SetUnitAbilityLevel(self.unit, spellObj.id, spellLevel) end

		---comment
		---@param spellObj SPELL
		---@param amount number
		---@return integer
		function self:SpellLevelIncrement(spellObj, amount)
			amount = amount or 1

			local newLevel = self:SpellLevel(spellObj) + amount
			if newLevel < 0 then newLevel = 0 end

			return SetUnitAbilityLevel(self.unit, spellObj.id, newLevel)
		end

		---Have hero try to Learn a Spell (Only works if Hero has a skill Point)
		---@param spellObj SPELL
		---@return boolean
		function self:SpellHeroLearn(spellObj)
			SelectHeroSkill(self.unit, spellObj.id)
			return true
		end

		---Choose to make a spell Permanent or not
		---@param spellObj SPELL
		---@param permanent boolean @true makes it permanent, false makes it not permanent
		---@return boolean
		function self:SpellPermanent(spellObj, permanent) return UnitMakeAbilityPermanent(self.unit, permanent, spellObj.id) end

		---Give Hero an Item
		---@param itemObj ITEMTYPE
		---@return item
		function self:ItemAdd(itemObj) return UnitAddItemById(self.unit, itemObj.id) end

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

		---Increment Skill Points by amount
		---@param amount number
		---@return boolean
		function self:SkillPointsInc(amount)
			amount = self:SkillPoints() + amount
			if amount < 0 then amount = 0 end

			return ModifyHeroSkillPoints(self.unit, bj_MODIFYMETHOD_SET, amount)
		end

		---Set Skill Points to Value
		---@param value any
		---@return boolean
		function self:SkillPointsSet(value) return ModifyHeroSkillPoints(self.unit, bj_MODIFYMETHOD_SET, value) end

		---Get a table of Spell Names for Hero
		---@return table
		function self:SpellNames() return self.heroType.spells.names end

		---Get Spell Details
		---@param spellObj SPELL
		---@return table
		function self:SpellDetails(spellObj)
			local spellDetails = spellObj
			spellDetails.level = self:SpellLevel(spellObj)
			spellDetails.cooldown = self:SpellCooldownRemaining(spellObj)
			spellDetails.hasBuff = self:HasSpellBuff(spellObj)
			spellDetails.mana = self:SpellManaCost(spellObj)
			spellDetails.manaLeft = self:Mana() - spellDetails.mana
			spellDetails.castable = self:SpellIsCastable(spellObj)

			return spellDetails
		end


		local heroSpell, pickedSpell, u, x, y, newAlter
		local g = CreateGroup()

		-- Get home Base Location
		if self:PlayerNumber() < 7 then
			x = GetRectCenterX(gg_rct_Left_Castle)
			y = GetRectCenterY(gg_rct_Left_Castle)
		else
			x = GetRectCenterX(gg_rct_Right_Castle)
			y = GetRectCenterY(gg_rct_Right_Castle)
		end

		-- Move hero to home base
		SetUnitPosition(unit, x, y)

		-- Give the hero the required Skill points for the spells
		self:SkillPointsSet(self.heroType.spellsStartingCount + 1)

		for i = 1, self.heroType.spellsStartingCount do
			heroSpell = self.heroType.spellsStarting[i] ---@type HEROSPELL
			pickedSpell = spell[heroSpell.name] ---@type SPELL

			-- Have the hero learn the spell
			if heroSpell.starting then self:SpellHeroLearn(pickedSpell) end
		end

		-- Add the Permanent Spells for the Hero
		for i = 1, self.heroType.spellsPermanentCount do
			heroSpell = self.heroType.spellsPermanent[i] ---@type HEROSPELL
			pickedSpell = spell[heroSpell.name] ---@type SPELL

			-- Have the hero learn the spell
			if heroSpell.permanent then self:SpellPermanent(pickedSpell, true) end
		end

		-- Give the Hero starting Items
		for i = 1, self.heroType.itemCount do
			pickedItem = item[self.heroType.items[i]] ---@type ITEMTYPE

			UnitAddItemById(unit, pickedItem.id)
		end

		-- Set up Alter
		g = GetUnitsOfPlayerAndTypeId(self:Player(), FourCC("halt"))
		while true do
			u = FirstOfGroup(g)
			if u == nil then break end

			-- Replace Unit Alter
			newAlter = ReplaceUnitBJ(u, self.heroType.idAlter, bj_UNIT_STATE_METHOD_MAXIMUM)

			GroupRemoveUnit(g, u)
		end
		DestroyGroup(g)

		
		PLAYERS[self:PlayerNumber()] = {picked = true, cameraLock = false, alter = newAlter, hero = self}
		HEROTYPE.HEROES["H" .. self.handleId] = self

		return self
	end

end
