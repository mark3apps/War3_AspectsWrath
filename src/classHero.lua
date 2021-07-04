--
-- Hero Skills / Abilities Class
-----------------
hero = {}
spell = {}
item = {}

---@class itemATA
function item.Init()
	item.id = {}
	item.names = {}

	-- comment
	---@param name string
	---@param properName string
	---@param four string
	---@param abilityFour string
	---@param order integer
	---@param instant boolean
	---@param castTime table
	function item.New(name, properName, four, abilityFour, order, instant, castTime)
		item[name] = {
			name = name,
			properName = properName,
			four = four,
			id = FourCC(four),
			abilityFour = abilityFour,
			abilityId = FourCC(abilityFour),
			order = order,
			instant = instant,
			castTime = castTime
		}

		table.insert(item.names, name)
		item.id[four] = name

		return true
	end

end

function _SpellInit()

	_Spell = {}
	spell.id = {}
	spell.names = {}

	---Add a new Spell
	---@param name string
	---@param properName string
	---@param four string
	---@param buff integer
	---@param order string
	---@param instant boolean
	---@param castTime table
	function _Spell.new(name, properName, four, buff, order, instant, castTime)

		---@class spell
		local self = {}
		self.name = name
		self.properName = properName
		self.four = four
		self.id = FourCC(four)
		self.buff = buff
		self.order = order
		self.instant = instant
		self.castTime = castTime

		spell.id[four] = name
		table.insert(spell.names, name)
		spell[name] = self

		return true
	end

end

function _UnitInit()
	_Unit = {}

	---comment
	---@param unit unit
	---@return unitExtended
	function _Unit.Get(unit)
		if _Unit[GetHandleId(unit)] == nil then
			return _Unit.New(unit)
		else
			return _Unit[GetHandleId(unit)]
		end
	end

	---comment
	---@param unit unit
	function _Unit.Remove(unit)
		unit = _Unit.Get(unit)
		unit:SFXRemoveAll()
		_Unit[unit.handleId] = nil

		return true
	end

	---comment
	---@param unit unit
	---@param overwrite boolean
	---@return unitExtended
	function _Unit.New(unit, overwrite)
		overwrite = overwrite or false

		-- If unit is already in the index, skip adding it if overwrite is set to false
		if _Unit.Get(unit) ~= nil and not overwrite then return false end

		---@class unitExtended
		local self = {}

		self.data = {}
		self.unit = unit
		self.handleId = GetHandleId(unit)
		self.startX = GetUnitX(unit)
		self.startY = GetUnitY(unit)
		self.orderX = nil ---@type real
		self.orderY = nil ---@type real
		self.orderTarget = nil ---@type unit
		self.unitType = GetUnitTypeId(unit)
		self.order = GetUnitCurrentOrder(unit)
		self.orderType = "" ---@type string
		self.sfx = {}
		self.sfxAll = {}

		---comment
		---@param unitType unittype
		---@return boolean
		function self:IsType(unitType) return IsUnitType(self.unit, unitType) end

		---comment
		---@return integer
		function self:OrderCurrent() return GetUnitCurrentOrder(self.unit) end

		---comment
		---@return integer
		function self:OrderLast() return self.order end

		---comment
		---@return string
		function self:OrderLastType() return self.orderType end

		---comment
		---@param orderId any
		---@return boolean
		function self:OrderHome(orderId) return self:OrderPoint(orderId, self.startX, self.startY) end

		---Re Issue the last given order
		---@return boolean 
		function self:OrderAgain()
			if self.orderTarget == "Target" then
				return self:OrderTarget(self.order, self.orderTarget)
			elseif self.orderTarget == "Point" then
				return self:OrderPoint(self.order, self.orderX, self.orderY)
			elseif self.orderType == "Immediate" then
				return self:OrderImmediate(self.order)
			else
				self:OrderPick()
				self:OrderPoint(oid.attack, self.orderX, self.orderY)
				return true
			end

			return false
		end

		---comment
		---@param orderId integer
		---@param targetUnit unit
		---@return boolean
		function self:OrderTarget(orderId, targetUnit)
			self.order = orderId
			self.orderType = "Target"
			self.orderX = nil
			self.orderY = nil
			self.orderTarget = targetUnit
			return IssueTargetOrderById(self.unit, orderId, targetUnit)
		end

		---comment
		---@param orderId integer
		---@param x real
		---@param y real
		---@return boolean
		function self:OrderPoint(orderId, x, y)
			self.order = orderId
			self.orderType = "Point"
			self.orderX = x
			self.orderY = y
			self.orderTarget = nil
			return IssuePointOrderById(self.unit, orderId, x, y)
		end

		---comment
		---@param orderId integer
		---@return boolean
		function self:OrderImmediate(orderId)
			self.order = orderId
			self.orderType = "Immediate"
			self.orderX = nil
			self.orderY = nil
			self.orderTarget = nil
			return IssueImmediateOrderById(self.unit, orderId)
		end

		---comment
		---@return real
		function self:X() return GetUnitX(self.unit) end

		---comment
		---@return real
		function self:Y() return GetUnitY(self.unit) end

		---comment
		---@param timeScale real
		---@return boolean
		function self:SetTimeScale(timeScale) return SetUnitTimeScale(self.unit, timeScale) end

		---comment
		---@param g group
		---@return boolean
		function self:GroupAdd(g) return GroupAddUnit(g, self.unit) end

		---comment
		---@param g any
		---@return boolean
		function self:GroupRemove(g) return GroupRemoveUnit(g, self.unit) end

		---comment
		---@param g group
		---@return boolean
		function self:InGroup(g) return IsUnitInGroup(g, self.unit) end

		---comment
		---@param animationName string
		---@return boolean
		function self:SetAnimation(animationName) return SetUnitAnimation(self.unit, animationName) end

		---comment
		---@param animationName any
		---@return nil
		function self:QueueAnimation(animationName) return QueueUnitAnimation(self.unit, animationName) end

		---comment
		---@return string
		function self:Name() return GetUnitName(unit) end

		---comment
		---@return integer
		function self:LifePercentage() return math.floor(self:LifeMax() / self:Life() * 100) end

		---comment
		---@return player
		function self:Player() return GetOwningPlayer(self.unit) end

		---comment
		---@return integer
		function self:PlayerNumber() return GetConvertedPlayerId(GetOwningPlayer(self.unit)) end

		---comment
		---@return integer
		function self:ManaPercentage() return math.floor(self:ManaMax() / self:Mana() * 100) end

		---Get Unit Max Life
		---@return real
		function self:LifeMax() return GetUnitState(self.unit, UNIT_STATE_MAX_LIFE) end

		---Get Hero Max Mana
		---@return real
		function self:ManaMax() return GetUnitState(self.unit, UNIT_STATE_MAX_MANA) end

		---Get Hero Life
		---@return real
		function self:Life() return GetUnitState(self.unit, UNIT_STATE_LIFE) end

		---Get Hero Mana
		---@return real
		function self:Mana() return GetUnitState(self.unit, UNIT_STATE_MANA) end

		---comment
		---@return boolean
		function self:IsAlive() return IsUnitAliveBJ(self.unit) end

		--- Check if the hero currently has a buff giving it a spell
		---@param spellName string
		---@return boolean
		function self:HasSpellBuff(spellName)

			if spell[spellName].buff == 0 then
				return false
			else
				return UnitHasBuffBJ(self.unit, spell[spellName].buff)
			end
		end

		---comment
		---@param four string
		---@return boolean
		function self:HasBuff(four) return UnitHasBuffBJ(self.unit, FourCC(four)) end

		---comment
		---@param key string
		---@param value any
		---@return boolean
		function self:SetKey(key, value)
			self.data[key] = value

			return true
		end

		---comment
		---@param key string
		---@return any
		function self:GetKey(key) return self.data[key] end

		---Add SFX by Name
		---@param name string
		---@param sfx effect
		function self:SFXAdd(name, sfx)

			if self.sfx[name] ~= nil then DestroyEffect(self.sfx[name]) end

			self.sfx[name] = sfx
			table.insert(self.sfxAll, name)
			return true
		end

		---Remove SFX by Name
		---@param name string
		function self:SFXRemove(name)
			DestroyEffect(self.sfx[name])
			return true
		end

		---Remove All SFX
		---@return boolean
		function self:SFXRemoveAll()
			local sfxName

			for i = 1, #self.sfxAll, 1 do
				sfxName = self.sfxAll[i]
				self:SFXRemove(sfxName)
			end

			return true
		end

		---comment
		---@param playerForce force
		---@return boolean
		function self:InForce(playerForce) return IsUnitInForce(self.unit, playerForce) end

		function self:InRect(r) return RectContainsUnit(r, self.unit) end

		-- CUSTOM FOR PROJECT
		function self:OrderPick()

			local alliedForce = self:InForce(udg_PLAYERGRPallied)
			local x, y

			if self:InRect(gg_rct_Big_Top_Left) or self:InRect(gg_rct_Big_Top_Left_Center) or
							self:InRect(gg_rct_Big_Top_Right_Center) or self:InRect(gg_rct_Big_Top_Right) then

				if alliedForce then
					x, y = GetRandomCoordinatesInRect(gg_rct_Right_Start_Top)
				else
					x, y = GetRandomCoordinatesInRect(gg_rct_Left_Start_Top)
				end

			elseif self:InRect(gg_rct_Big_Middle_Left) or self:InRect(gg_rct_Big_Middle_Left_Center) or
			self:InRect(gg_rct_Big_Middle_Right_Center) or self:InRect(gg_rct_Big_Middle_Right) then

				if alliedForce then
					x, y = GetRandomCoordinatesInRect(gg_rct_Right_Start)
				else
					x, y = GetRandomCoordinatesInRect(gg_rct_Left_Start)
				end

			else

				if alliedForce then
					x, y = GetRandomCoordinatesInRect(gg_rct_Right_Start_Bottom)
				else
					x, y = GetRandomCoordinatesInRect(gg_rct_Left_Start_Bottom)
				end
			end

			self.orderX = x
			self.orderY = y
			self.order = oid.attack
			self.orderType = "Point"

			return true
		end

		---Kill the Unit
		---@return boolean
		function self:Kill()
			KillUnit(self.unit)
			return true
		end

		-- If unit Exists in Index remove it
		if _Unit[self.handleId] ~= nil then _Unit.Remove(self.unit) end

		-- Add Unit to Index
		_Unit[self.handleId] = self

		return self
	end

end

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

		function self:GetSpell(spellName) return self.heroType.spells[spellName] end

		---Get Level of Spell for Hero
		---@param spellName string
		---@return integer
		function self:SpellLevel(spellName) return GetUnitAbilityLevel(self.unit, self:GetSpell(spellName).id) end

		---Get Spell Cooldown Remaining
		---@param spellName string
		---@return real
		function self:SpellCooldownRemaining(spellName)
			return BlzGetUnitAbilityCooldownRemaining(self.unit, self:GetSpell(spellName).id)
		end

		---Get Spell Mana Cost
		---@param spellName string
		---@return integer
		function self:SpellManaCost(spellName)
			return BlzGetUnitAbilityManaCost(self.unit, self:GetSpell(spellName).id, self:SpellLevel(spellName))
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

		---Get a table of Spell Names for Hero
		---@return table
		function self:SpellNames() return self.heroType.spells.names end

		---Get Spell Details
		---@param spellName string
		---@return table
		function self:SpellDetails(spellName)
			local spellDetails = self:GetSpell(spellName)
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

function _HeroTypeInit()

	-- Create Class Definition
	_HeroType = {}

	-- Init Globals
	heroType = {id = {}, names = {}, players = {}}
	for i = 1, 12 do hero.players[i] = {picked = false} end

	_HeroType.new = function(name, four, fourAlter)

		---@class heroType
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
		---@param spellObj spell
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
		function self:AddItem(item)
			table.insert(self.items, item)

			return true
		end

		---Add a talent to Hero
		---@param talent any
		---@param level integer
		---@return boolean
		function self:TalentAdd(talent, level) return true end

		-- Register newly created hero
		hero.id[four] = name
		table.insert(hero.names, name)
		hero[name] = self
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
