function init_baseClass()

	base = {}

	base.all = {g = CreateGroup(), unitsTotal = 0, unitsAlive = 0}

	base.allied = {
		unitsTotal = 0,
		unitsAlive = 0,
		advantage = 0,
		gTeleport = CreateGroup(),
		gDanger = CreateGroup(),
		gHealing = CreateGroup()
	}
	base.federation = {
		unitsTotal = 0,
		unitsAlive = 0,
		advantage = 0,
		gTeleport = CreateGroup(),
		gDanger = CreateGroup(),
		gHealing = CreateGroup()
	}

	base.top = {
		allied = {g = CreateGroup(), unitsTotal = 0, unitsAlive = 0, advantage = 0},
		federation = {g = CreateGroup(), unitsTotal = 0, unitsAlive = 0, advantage = 0}
	}
	base.middle = {
		allied = {g = CreateGroup(), unitsTotal = 0, unitsAlive = 0, advantage = 0},
		federation = {g = CreateGroup(), unitsTotal = 0, unitsAlive = 0, advantage = 0}
	}
	base.bottom = {
		allied = {g = CreateGroup(), unitsTotal = 0, unitsAlive = 0, advantage = 0},
		federation = {g = CreateGroup(), unitsTotal = 0, unitsAlive = 0, advantage = 0}
	}

	---Add a base to the map
	---@param unit unit
	---@param importance integer
	---@param mainBase unit
	---@param update boolean
	---@param teleport boolean
	---@param healing boolean
	function base.add(unit, importance, mainBase, update, teleport, healing)

		local teamNumber, regionName, teamName, allied, federation
		local handleId = GetHandleId(unit)
		local x = GetUnitX(unit)
		local y = GetUnitY(unit)
		local name = GetUnitName(unit)
		local player = GetOwningPlayer(unit)
		local lifePercent = GetUnitLifePercent(unit)
		local mana = GetUnitState(unit, UNIT_STATE_MANA)
		local idType = GetUnitTypeId(unit)
		local fourType = CC2Four(idType)

		if IsPlayerInForce(player, udg_PLAYERGRPallied) then
			teamNumber = 1
			teamName = "allied"
		else
			teamNumber = 2
			teamName = "federation"
		end

		-- Add to Region Specific Buildings
		if IsUnitInRegion(bottomRegion, unit) then
			regionName = "bottom"
		elseif IsUnitInRegion(middleRegion, unit) then
			regionName = "middle"
		elseif IsUnitInRegion(topRegion, unit) then
			regionName = "top"
		end

		if update then
			-- Add to ALL Unit Group
			GroupAddUnit(base.all.g, unit)

			-- Add to HEALING Unit Group
			-- if healing then
			GroupAddUnit(base[teamName].gHealing, unit)
			-- end

			-- Add to REGION Unit Group
			GroupAddUnit(base[regionName][teamName].g, unit)
		end

		-- Add to TELEPORT Unit Group
		if teleport then GroupAddUnit(base[teamName].gTeleport, unit) end

		-- Set Importance
		base[regionName][teamName].unitsTotal = base[regionName][teamName].unitsTotal + importance
		base[regionName][teamName].unitsAlive = base[regionName][teamName].unitsAlive + importance
		base[teamName].unitsTotal = base[teamName].unitsTotal + importance
		base[teamName].unitsAlive = base[teamName].unitsAlive + importance
		base.all.unitsTotal = base.all.unitsTotal + importance
		base.all.unitsAlive = base.all.unitsAlive + importance

		-- Get TEAM Advantage
		allied = base.allied.unitsAlive / base.allied.unitsTotal
		federation = base.federation.unitsAlive / base.federation.unitsTotal
		base.allied.advantage = allied - federation
		base.federation.advantage = federation - allied

		-- Get REGION Advantage
		allied = (base[regionName].allied.unitsAlive / base[regionName].allied.unitsTotal) * 100
		federation = (base[regionName].federation.unitsAlive / base[regionName].federation.unitsTotal) * 100

		base[regionName].allied.advantage = allied - federation
		base[regionName].federation.advantage = federation - allied

		-- Add Building to Table
		base[handleId] = {
			x = x,
			y = y,
			name = name,
			unit = unit,
			importance = importance,
			lifePercent = lifePercent,
			unitsFriendly = 0,
			unitsEnemy = 0,
			unitsCount = 0,
			danger = 0,
			update = update,
			idType = idType,
			fourType = fourType,
			handleId = handleId,
			mainBase = mainBase,
			regionName = regionName,
			teamName = teamName,
			mana = mana
		}
	end

	---Update the selected Base
	---@param unit unit
	---@return boolean
	function base.update(unit)
		local u, heroLevel

		local unitsFriendly = 0
		local unitsEnemy = 0
		local unitsCount = 0

		local handleId = GetHandleId(unit)

		if base[handleId].update == false then return true end

		local teamName = base[handleId].teamName

		local g = CreateGroup()
		GroupEnumUnitsInRange(g, base[handleId].x, base[handleId].y, 900, nil)
		while true do
			u = FirstOfGroup(g)
			if u == nil then break end

			-- Calculate Danger Levels
			if IsUnitAliveBJ(u) then
				if IsUnitAlly(u, GetOwningPlayer(unit)) then
					if IsUnitType(u, UNIT_TYPE_HERO) then
						unitsFriendly = unitsFriendly + 3 * GetHeroLevel(u)
					else
						unitsFriendly = unitsFriendly + GetUnitLevel(u)
					end
				else
					if IsUnitType(u, UNIT_TYPE_HERO) then
						unitsEnemy = unitsEnemy + 3 * GetHeroLevel(u)
					else
						unitsEnemy = unitsEnemy + GetUnitLevel(u)
					end
				end
			end

			GroupRemoveUnit(g, u)
		end
		DestroyGroup(g)

		-- Check if Unit is in Danger
		if IsUnitInGroup(unit, base[teamName].gDanger) then
			if unitsEnemy == 0 then
				GroupRemoveUnit(base[teamName].gDanger, unit)
				GroupAddUnit(base[teamName].gHealing, unit)
			end

			CreateCorpse()

		else
			if unitsEnemy > 0 then
				GroupAddUnit(base[teamName].gDanger, unit)
				GroupRemoveUnit(base[teamName].gHealing, unit)
			end
		end

		-- Heal Units as needed
		if unitsEnemy == 0 and unitsFriendly > 0 and base[handleId].mana > 50 then
			if IsUnitInGroup(unit, base[teamName].gHealing) and BlzGetUnitAbilityCooldownRemaining(unit, FourCC("A027")) == 0 then

				g = CreateGroup()
				GroupEnumUnitsInRange(g, base[handleId].x, base[handleId].y, 900, nil)

				while true do
					u = FirstOfGroup(g)
					if u == nil then break end

					if IsUnitType(u, UNIT_TYPE_HERO) and IsUnitAlly(u, GetOwningPlayer(unit)) then
						if not UnitHasBuffBJ(u, FourCC("Brej")) and (GetUnitLifePercent(u) < 95 or GetUnitManaPercent(u) < 95) then

							SetUnitAbilityLevel(unit, FourCC("A027"), spawn.creepLevel)
							IssueTargetOrder(unit, "rejuvination", u)
							break
						end
					end

					GroupRemoveUnit(g, u)
				end

				DestroyGroup(g)
			end
		end

		base[handleId].lifePercent = GetUnitLifePercent(unit)
		base[handleId].mana = GetUnitState(unit, UNIT_STATE_MANA)
		base[handleId].unitsFriendly = unitsFriendly
		base[handleId].unitsEnemy = unitsEnemy
		base[handleId].unitsCount = unitsEnemy - unitsFriendly
		base[handleId].danger = base[handleId].unitsCount * (((100 - base[handleId].lifePercent) / 10) + 1) *
						                        base[handleId].importance

		-- print(base[handleId].name .. " Allies:" .. base[handleId].unitsFriendly .. " Enemies: " .. base[handleId].unitsEnemy)
	end

	---Notify System that Base has died
	---@param unit unit
	function base.died(unit)
		local allied, federation, u
		local handleId = GetHandleId(unit)
		local regionName = base[handleId].regionName
		local teamName = base[handleId].teamName
		local teleport = base[handleId].teleport
		local importance = base[handleId].importance
		local x = base[handleId].x
		local y = base[handleId].y
		local name = base[handleId].name

		-- Remove Unit from ALL Group
		GroupRemoveUnit(base.all.g, unit)

		-- Remove Unit from REGION Group
		if IsUnitInGroup(unit, base[regionName][teamName].g) then GroupRemoveUnit(base[regionName][teamName].g, unit) end

		if IsUnitInGroup(unit, base[teamName].gDanger) then GroupRemoveUnit(base[teamName].gDanger, unit) end

		if IsUnitInGroup(unit, base[teamName].gHealing) then GroupRemoveUnit(base[teamName].gDanger, unit) end

		-- Remove Unit from TELEPORT Group
		if teleport then GroupRemoveUnit(base[teamName].gTeleport, unit) end

		-- Adjust Region importance
		base[regionName][teamName].unitsAlive = base[regionName][teamName].unitsAlive - importance
		base[teamName].unitsAlive = base[teamName].unitsAlive - importance
		base.all.unitsAlive = base.all.unitsAlive - importance

		-- Get TEAM Advantage
		allied = (base.allied.unitsAlive / base.allied.unitsTotal) * 100
		federation = (base.federation.unitsAlive / base.federation.unitsTotal) * 100
		base.allied.advantage = allied - federation
		base.federation.advantage = federation - allied

		-- Get REGION Advantage
		allied = (base[regionName].allied.unitsAlive / base[regionName].allied.unitsTotal) * 100
		federation = (base[regionName].federation.unitsAlive / base[regionName].federation.unitsTotal) * 100

		base[regionName].allied.advantage = allied - federation
		base[regionName].federation.advantage = federation - allied

		PlaySound("Sound/Interface/Warning.flac")

		if teamName == "federation" then

			for i = 6, 11 do SetPlayerHandicapXPBJ(Player(i), GetPlayerHandicapXPBJ(Player(i)) + 10) end

			print("FEDERATION Base has Fallen!")
			u = CreateUnit(Player(20), FourCC("h00W"), x, y, bj_UNIT_FACING)

		else
			for i = 0, 5 do SetPlayerHandicapXPBJ(Player(i), GetPlayerHandicapXPBJ(Player(i)) + 10) end

			print("ALLIED Base has Fallen!")

			u = CreateUnit(Player(23), FourCC("h00W"), x, y, bj_UNIT_FACING)
		end

		print(name .. " has been razed.")
		PingMinimap(x, y, 15)
		base.add(u, 0, false, false, true)

	end

end