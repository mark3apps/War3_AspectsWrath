function HEROTYPE_INIT()

	-- Create Class Definition
	HEROTYPE = {}

	-- Init Globals
	HEROTYPE = {id = {}, names = {}, players = {}}
	for i = 1, 12 do hero.players[i] = {picked = false} end

    ---comment
    ---@param u unit
    ---@return HEROTYPE
	function HEROTYPE.GET(u)
        local unit = UNIT.GET(u)

        return heroType[HEROTYPE.id[unit.unitTypeFour]]
    end

	function HEROTYPE.NEW(name, four, fourAlter)

		---@class HEROTYPE
		local self = {}

		self.name = name
		self.four = four
		self.id = FourCC(four)
		self.fourAlter = fourAlter
		self.idAlter = FourCC(fourAlter)
		self.spellsPermanent = {}
		self.spellsAll = {}
		self.spellsStarting = {}
		self.spellsUlt = {}
		self.spells = {}
		self.items = {}
		self.talents = {}

		---Add a spell to Hero
		---@param spellObj SPELL
		---@param ult boolean
		---@param starting boolean
		---@param permanent boolean
		---@return boolean
		function self:SpellAdd(spellObj, ult, starting, permanent)
			ult = ult or false
			starting = starting or false
			permanent = permanent or false

			self.spells[spellObj.name] = spellObj
			self.spells[spellObj.name].ult = ult
			self.spells[spellObj.name].starting = starting
			self.spells[spellObj.name].permanent = permanent

			if starting then table.insert(self.spellsStarting, spellObj.name) end
			if permanent then table.insert(self.spellsPermanent, spellObj.name) end
			if ult then table.insert(self.spellsUlt, spellObj.name) end

			table.insert(self.spellsAll, spellObj.name)
			return true
		end

		---Add an item to Hero
		---@param item itemATA
		---@return boolean
		function self:ItemAdd(item)
			table.insert(self.items, item)

			return true
		end

		---Add a talent to Hero
		---@param talent any
		---@param level integer
		---@return boolean
		function self:TalentAdd(talent, level) return true end

		-- Register newly created hero
		HEROTYPE.id[four] = name
		table.insert(HEROTYPE.names, name)

		return self
	end

	---comment
	---@param unit unit
	function hero.LevelUp(unit)
		local heroFour = CC2Four(GetUnitTypeId(unit))
		local heroName = hero.unit.id[heroFour]
		local heroLevel = GetHeroLevel(unit)
		local heroPlayer = GetOwningPlayer(unit)
		local spells = hero.unit[heroName]

		AdjustPlayerStateBJ(50, heroPlayer, PLAYER_STATE_RESOURCE_LUMBER)
		SetPlayerTechResearchedSwap(FourCC("R005"), heroLevel - 1, heroPlayer)

		if (ModuloInteger(heroLevel, 4) == 0) then SetPlayerTechResearchedSwap(FourCC("R006"), heroLevel / 4, heroPlayer) end

		-- Remove Ability Points
		if (heroLevel < 15 and ModuloInteger(heroLevel, 2) ~= 0) then
			ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SUB, 1)
		elseif (heroLevel < 25 and heroLevel >= 15 and ModuloInteger(heroLevel, 3) ~= 0) then
			ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SUB, 1)
		elseif (heroLevel >= 25 and ModuloInteger(heroLevel, 4) ~= 0) then
			ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SUB, 1)
		end

		print("Level Up, " .. heroFour .. " Level: " .. heroLevel)

		-- Learn Skill if the Hero is owned by a Computer
		if GetPlayerController(heroPlayer) == MAP_CONTROL_COMPUTER then
			local unspentPoints = GetHeroSkillPoints(unit)

			print("Unspent Abilities: " .. unspentPoints)

			if unspentPoints > 0 then
				for i = 1, #spells.spellLearnOrder do
					SelectHeroSkill(unit, hero[spells.spellLearnOrder[i]].id)

					if GetHeroSkillPoints(unit) == 0 then return end
				end
			end
		end
	end

	function hero.Upgrade(unit) IssueUpgradeOrderByIdBJ(udg_AI_PursueHero[0], FourCC("R00D")) end

	---comment
	---@param unit unit
	function hero.SetupHero(unit)
		local heroFour = CC2Four(GetUnitTypeId(unit))
		local heroName = hero.unit.id[heroFour]
		local player = GetOwningPlayer(unit)
		local playerNumber = GetConvertedPlayerId(player)
		local heroLevel = GetHeroLevel(unit)
		local spells = hero.unit[heroName]
		local picked, u, x, y, newAlter
		local g = CreateGroup()

		hero.players[playerNumber] = {}

		-- Get home Base Location
		if playerNumber < 7 then
			x = GetRectCenterX(gg_rct_Left_Castle)
			y = GetRectCenterY(gg_rct_Left_Castle)
		else
			x = GetRectCenterX(gg_rct_Right_Castle)
			y = GetRectCenterY(gg_rct_Right_Castle)
		end

		-- Move hero to home base
		SetUnitPosition(unit, x, y)

		-- Give the hero the required Skill points for the spells
		ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SET, #spells.startingSpells + 1)
		for i = 1, #spells.startingSpells do
			picked = spell[spells.startingSpells[i]]

			-- Have the hero learn the spell
			SelectHeroSkill(unit, picked.id)
		end

		-- Add the Permanent Spells for the Hero
		for i = 1, #spells.permanentSpells do
			picked = spells[spells.permanentSpells[i]]

			-- Make the Spell Permanent
			UnitMakeAbilityPermanent(unit, true, picked.id)
		end

		-- Give the Hero starting Items
		for i = 1, #spells.startingItems do
			picked = item[spells.startingItems[i]]

			-- Make the Spell Permanent
			UnitAddItemById(unit, picked.id)
		end

		-- Set up Alter
		g = GetUnitsOfPlayerAndTypeId(player, FourCC("halt"))
		while true do
			u = FirstOfGroup(g)
			if u == nil then break end

			-- Replace Unit Alter
			ReplaceUnitBJ(u, hero.unit[heroName].idAlter, bj_UNIT_STATE_METHOD_MAXIMUM)
			newAlter = GetLastReplacedUnitBJ()
			GroupRemoveUnit(g, u)
		end
		DestroyGroup(g)

		hero.players[playerNumber].picked = true
		hero.players[playerNumber].cameraLock = false
		hero.players[playerNumber].alter = newAlter
		hero.players[playerNumber].hero = unit
	end

end
