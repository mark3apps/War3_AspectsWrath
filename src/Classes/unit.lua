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

		---Set the Units Max Life
		---@param amount integer
		---@return boolean
		function self:LifeMaxIncrement(amount)
			local percentLife = GetUnitLifePercent(self.unit)

			BlzSetUnitMaxHP(self.unit, self:LifeMax() + amount)
			SetUnitLifePercentBJ(self.unit, percentLife)

			return true
		end

		---Get Hero Max Mana
		---@return real
		function self:ManaMax() return GetUnitState(self.unit, UNIT_STATE_MAX_MANA) end

        ---Increment Max Mana
        ---@param amount integer
        ---@return boolean
        function self:ManaMaxIncrement(amount)
			local percentMana = GetUnitManaPercent(self.unit)

			BlzSetUnitMaxMana(self.unit, self:ManaMax() + amount)
			SetUnitManaPercentBJ(self.unit, percentMana)

			return true
        end

		---Get Hero Life
		---@return real
		function self:Life() return GetUnitState(self.unit, UNIT_STATE_LIFE) end

		---Get Hero Mana
		---@return real
		function self:Mana() return GetUnitState(self.unit, UNIT_STATE_MANA) end

		---Is Unit Alive
		---@return boolean
		function self:IsAlive() return IsUnitAliveBJ(self.unit) end

		---Get Unit Damage Bonus
		---@return integer
		function self:DamageBonus() return GetAbilityInteger(self.unit, spell.bonusDamage, true, ABILITY_ILF_ATTACK_BONUS, 0) end

		---Increment Damage Bonus by amount
		---@param amount integer
		---@return boolean
		function self:DamageBonusIncrement(amount)
			return IncAbilityInteger(self.unit, spell.bonusDamage, true, ABILITY_ILF_ATTACK_BONUS, 0, amount)
		end

		---Reset Damage Bonus
		---@return boolean
		function self:DamageBonusReset()
			return SetAbilityInteger(self.unit, spell.bonusDamage, true, ABILITY_ILF_ATTACK_BONUS, 0, 0)
		end

        ---Get Unit Armor Bonus
        ---@return integer
        function self:ArmorBonus() return GetAbilityInteger(self.unit, spell.bonusArmor, true, ABILITY_ILF_DEFENSE_BONUS_IDEF, 0) end

        ---Reset Unit Armor Bonus
        ---@param amount integer
        ---@return boolean
        function self:ArmorBonusIncrement(amount)
            return IncAbilityInteger(self.unit, spell.bonusArmor, true, ABILITY_ILF_DEFENSE_BONUS_IDEF, 0, amount)
        end

        ---Reset Unit Armor Bonus
        ---@return boolean
        function self:ArmorBonusReset()
            return SetAbilityInteger(self.unit, spell.bonusArmor, true, ABILITY_ILF_DEFENSE_BONUS_IDEF, 0, 0)
        end

        ---Get Life Regen Rate Bonus
        ---@return real
        function self:LifeRegenBonus()
            return GetAbilityReal(self.unit, spell.bonusHealthRegen, true, ABILITY_RLF_AMOUNT_OF_HIT_POINTS_REGENERATED, 0)
        end

        ---Increment Life Regen Bonus
        ---@param amount real
        ---@return boolean
        function self:LifeRegenBonusIncrement(amount)
            return IncAbilityReal(self.unit, spell.bonusHealthRegen, true, ABILITY_RLF_AMOUNT_OF_HIT_POINTS_REGENERATED, 0, amount)
        end

        ---Reset Life Regen Bonus
        ---@return boolean
        function self:LifeRegenBonusReset()
            return SetAbilityReal(self.unit, spell.bonusHealthRegen, true, ABILITY_RLF_AMOUNT_OF_HIT_POINTS_REGENERATED, 0, 0)
        end

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

		---Is Unit in Force
		---@param playerForce force
		---@return boolean
		function self:InForce(playerForce) return IsUnitInForce(self.unit, playerForce) end

		---Is Unit in Rect
		---@param r region
		---@return boolean
		function self:InRect(r) return RectContainsUnit(r, self.unit) end

        ---Is Unit in Region
        ---@param reg region
        ---@return boolean
        function self:InRegion(reg) return IsUnitInRegion(reg, self.unit) end

		---CUSTOM FOR PROJECT
		---Pick a new order for unit
		---@return boolean
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
