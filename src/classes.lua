--
-- Location Class
-----------------
function init_locationClass()

	loc_Class = {}

	loc_Class.new = function()
		local self = {}
		self.regions = {}

		---Add a new location
		---@param name string
		---@param rect rect
		---@param nextRect rect
		---@param allied boolean
		function self:add(name, rect, nextRect, allied)
			nextRect = nextRect or ""
			allied = allied or false
			self[name] = {
				centerX = GetRectCenterX(rect),
				centerY = GetRectCenterY(rect),
				minX = GetRectMinX(rect),
				maxX = GetRectMaxX(rect),
				minY = GetRectMinY(rect),
				maxY = GetRectMaxY(rect)
			}
			self[name].reg = CreateRegion()
			RegionAddRect(self[name].reg, rect)

			self[name].rect = rect
			self[name].name = name

			self.regions[GetHandleId(self[name].rect)] = name
			self.regions[GetHandleId(self[name].reg)] = name

			if nextRect ~= "" then
				TriggerRegisterEnterRegionSimple(Trig_moveToNext, self[name].reg)
				self[name].next = nextRect
				self[name].allied = allied
				self[name].fed = not allied
			end
		end

		function self:getRandomXY(name)
			local region = self[name]
			return GetRandomReal(region.minX, region.maxX), GetRandomReal(region.minY, region.maxY)
		end

		function self:getRegion(region)
			local regionName = self.regions[GetHandleId(region)]
			return self[regionName]
		end

		return self
	end

end

--
-- AI Classes
-----------------
function init_aiClass()
	-- Create the table for the class definition
	ai_Class = {}

	-- Define the new() function
	ai_Class.new = function()
		local self = {}

		self.heroes = {}
		self.heroGroup = CreateGroup()
		self.heroOptions = {
			"heroA", "heroB", "heroC", "heroD", "heroE", "heroF", "heroG", "heroH", "heroI", "heroJ", "heroK", "heroL"
		}
		self.count = 0
		self.loop = 1
		self.tick = 1

		function self:isAlive(i) return self[i].alive end

		function self:countOfHeroes() return self.count end

		function self:initHero(heroUnit)
			self.count = self.count + 1
			self.tick = (1.00 + (self.count * 0.1)) / self.count

			local i = self.heroOptions[self.count]
			print("Name: " .. i)

			table.insert(self.heroes, i)

			self[i] = {}

			self[i].unit = heroUnit
			GroupAddUnit(self.heroGroup, self[i].unit)

			self[i].id = GetUnitTypeId(heroUnit)
			self[i].four = CC2Four(self[i].id)
			self[i].name = hero[self[i].four]

			self[i].player = GetOwningPlayer(heroUnit)
			self[i].playerNumber = GetConvertedPlayerId(GetOwningPlayer(heroUnit))

			if self[i].playerNumber > 6 then
				self[i].teamNumber = 2
				self[i].teamName = "federation"
				self[i].teamNameEnemy = "allied"
			else
				self[i].teamNumber = 1
				self[i].teamName = "allied"
				self[i].teamNameEnemy = "federation"
			end

			print("Team Number: " .. self[i].teamNumber)

			self[i].heroesFriend = CreateGroup()
			self[i].heroesEnemy = CreateGroup()
			self[i].lifeHistory = {0.00, 0.00, 0.00}

			indexer:add(self[i].unit)
			indexer:addKey(self[i].unit, "heroName", i)
			indexer:addKey(self[i].unit, "heroNumber", self.count)

			self[i].alive = false
			self[i].fleeing = false
			self[i].casting = false
			self[i].castingDuration = -10.00
			self[i].castingDanger = false
			self[i].order = nil
			self[i].castingUlt = false
			self[i].chasing = false
			self[i].defending = false
			self[i].defendingFast = false
			self[i].lowLife = false
			self[i].highDamage = false
			self[i].updateDest = false

			self[i].regionAttacking = nil

			self[i].unitHealing = nil
			self[i].unitAttacking = nil
			self[i].unitDefending = nil
			self[i].unitChasing = nil

			if self[i].four == hero.brawler.four then -- Brawler
				self[i].healthFactor = 1.00
				self[i].manaFactor = 0.02

				self[i].lifeHighPercent = 65.00
				self[i].lifeLowPercent = 20.00
				self[i].lifeLowNumber = 400.00

				self[i].highDamageSingle = 17.00
				self[i].highDamageAverage = 25.00

				self[i].powerBase = 500.00
				self[i].powerLevel = 200.00

				self[i].clumpCheck = true
				self[i].clumpRange = 100.00
				self[i].intelRange = 1100.00
				self[i].closeRange = 500.00

				self[i].strats = {"aggressive", "defensive", "passive"}

			elseif self[i].four == hero.manaAddict.four then -- Mana Addict
				self[i].healthFactor = 1.00
				self[i].manaFactor = 0.75

				self[i].lifeHighPercent = 85.00
				self[i].lifeLowPercent = 25.00
				self[i].lifeLowNumber = 300.00

				self[i].highDamageSingle = 3.00
				self[i].highDamageAverage = 18.00

				self[i].powerBase = 700.00
				self[i].powerLevel = 220.00

				self[i].clumpCheck = true
				self[i].clumpRange = 100.00
				self[i].intelRange = 1000.00
				self[i].closeRange = 400.00

				self[i].strats = {"aggressive", "defensive", "passive"}

			elseif self[i].four == hero.tactition.four then -- Tactition
				self[i].healthFactor = 1.00
				self[i].manaFactor = 0.20

				self[i].lifeHighPercent = 75.00
				self[i].lifeLowPercent = 20.00
				self[i].lifeLowNumber = 350.00

				self[i].highDamageSingle = 17.00
				self[i].highDamageAverage = 25.00

				self[i].powerBase = 500.00
				self[i].powerLevel = 200.00
				self[i].clumpCheck = true
				self[i].clumpRange = 250.00
				self[i].intelRange = 1000.00
				self[i].closeRange = 400.00

				self[i].strats = {"aggressive", "defensive", "passive"}

			elseif self[i].four == hero.timeMage.four then -- Time Mage
				self[i].healthFactor = 1.00
				self[i].manaFactor = 0.10

				self[i].lifeHighPercent = 85.00
				self[i].lifeLowPercent = 25.00
				self[i].lifeLowNumber = 350.00

				self[i].highDamageSingle = 8.00
				self[i].highDamageAverage = 17.00

				self[i].powerBase = 750.00
				self[i].powerLevel = 250.00

				self[i].clumpCheck = true
				self[i].clumpRange = 250.00
				self[i].intelRange = 1100.00
				self[i].closeRange = 700.00

				self[i].strats = {"aggressive", "defensive", "passive"}

			elseif self[i].four == hero.shiftMaster.four then -- Shifter
				self[i].healthFactor = 1.00
				self[i].manaFactor = 0.15

				self[i].lifeHighPercent = 70.00
				self[i].lifeLowPercent = 25.00
				self[i].lifeLowNumber = 350.00

				self[i].highDamageSingle = 17.00
				self[i].highDamageAverage = 25.00

				self[i].powerBase = 500.00
				self[i].powerLevel = 200.00

				self[i].clumpCheck = true
				self[i].clumpRange = 100.00
				self[i].intelRange = 1100.00
				self[i].closeRange = 400.00

				self[i].strats = {"aggressive", "defensive", "passive"}
			end

			local randI = GetRandomInt(1, #self[i].strats)
			self[i].strat = self[i].strats[randI]

			-- TESTING
			-- self[i].strat = "aggressive"
			-- TESTING

			print(self[i].strat)
		end

		-- Update Intel
		function self:updateIntel(i)
			-- Only run if the hero is alive
			if (self[i].alive == true) then
				-- Update info about the AI Hero
				self[i].x = GetUnitX(self[i].unit)
				self[i].y = GetUnitY(self[i].unit)
				self[i].life = GetWidgetLife(self[i].unit)
				self[i].lifePercent = GetUnitLifePercent(self[i].unit)
				self[i].lifeMax = GetUnitState(self[i].unit, UNIT_STATE_MAX_LIFE)
				self[i].mana = GetUnitState(self[i].unit, UNIT_STATE_MANA)
				self[i].manaPercent = GetUnitManaPercent(self[i].unit)
				self[i].manaMax = GetUnitState(self[i].unit, UNIT_STATE_MAX_MANA)
				self[i].level = GetHeroLevel(self[i].unit)
				self[i].currentOrder = OrderId2String(GetUnitCurrentOrder(self[i].unit))

				-- Reset Intel
				self[i].countUnit = 0
				self[i].countUnitFriend = 0
				self[i].countUnitFriendClose = 0
				self[i].countUnitEnemy = 0
				self[i].countUnitEnemyClose = 0
				self[i].powerFriend = 0.00
				self[i].powerEnemy = 0.00

				self[i].unitPowerFriend = nil
				self[i].unitPowerEnemy = nil

				self[i].clumpFriend = nil
				self[i].clumpFriendNumber = 0
				self[i].clumpFriendPower = 0.00
				self[i].clumpEnemy = nil
				self[i].clumpEnemyNumber = 0
				self[i].clumpEnemyPower = 0.00
				self[i].clumpBoth = nil
				self[i].clumpBothNumber = 0
				self[i].clumpBothPower = 0.00

				GroupClear(self[i].heroesFriend)
				GroupClear(self[i].heroesEnemy)

				-- Units around Hero
				local g = CreateGroup()
				local clump = CreateGroup()
				local unitPower = 0.00
				local unitPower = 0.00
				local unitLife = 0.00
				local unitX
				local unitY
				local unitDistance = 0.00
				local unitRange = 0.00
				local unitPowerRangeMultiplier = 0.00
				local u
				local clumpUnit
				local powerAllyTemp, powerAllyNumTemp, powerEnemyTemp, powerEnemyNumTemp

				GroupEnumUnitsInRange(g, self[i].x, self[i].y, self[i].intelRange, nil)

				-- Enumerate through group

				while true do
					u = FirstOfGroup(g)
					if (u == nil) then break end

					-- Unit is alive and not the hero
					if (IsUnitAliveBJ(u) == true and u ~= self[i].unit) then
						self[i].countUnit = self[i].countUnit + 1

						-- Get Unit Details
						unitLife = GetUnitLifePercent(u)
						unitRange = BlzGetUnitWeaponRealField(u, UNIT_WEAPON_RF_ATTACK_RANGE, 0)

						unitX = GetUnitX(u)
						unitY = GetUnitY(u)
						unitDistance = distanceBetweenCoordinates(unitX, unitY, self[i].x, self[i].y)

						-- Get Unit Power
						if (IsUnitType(u, UNIT_TYPE_HERO) == true) then -- is Hero
							unitPower = I2R((GetHeroLevel(u) * 75))

							if IsUnitAlly(u, self[i].player) then -- Add to hero Group
								GroupAddUnit(self[i].heroesFriend, u)
							else
								GroupAddUnit(self[i].heroesEnemy, u)
							end
						else -- Unit is NOT a hero
							unitPower = I2R(GetUnitPointValue(u))
						end

						-- Power range modifier
						if unitDistance < unitRange then
							unitPowerRangeMultiplier = 1.00
						else
							unitPowerRangeMultiplier = 300.00 / (unitDistance - unitRange + 300.00)
						end

						if IsUnitAlly(u, self[i].player) == true then
							-- Update count
							self[i].countUnitFriend = self[i].countUnitFriend + 1
							if unitDistance <= self[i].closeRange then self[i].countUnitFriendClose = self[i].countUnitFriendClose + 1 end

							-- Check to see if unit is the most powerful friend
							if unitPower > self[i].powerFriend then self[i].unitPowerFriend = u end

							-- Relative Power
							self[i].powerFriend = self[i].powerFriend + (unitPower * (unitLife / 100.00) * unitPowerRangeMultiplier)
						else
							-- Update Count
							self[i].countUnitEnemy = self[i].countUnitEnemy + 1
							if unitDistance <= self[i].closeRange then self[i].countUnitEnemyClose = self[i].countUnitEnemyClose + 1 end

							-- Check to see if unit is the most powerful Enemy
							if unitPower > self[i].powerEnemy then self[i].unitPowerEnemy = u end

							-- Relative Power
							self[i].powerEnemy = self[i].powerEnemy + (unitPower * (unitLife / 100.00) * unitPowerRangeMultiplier)
						end

						if self[i].clumpCheck == true then
							powerAllyTemp = 0
							powerEnemyTemp = 0
							powerAllyNumTemp = 0
							powerEnemyNumTemp = 0
							clump = CreateGroup()

							GroupEnumUnitsInRange(clump, unitX, unitY, self[i].clumpRange, nil)

							while true do
								clumpUnit = FirstOfGroup(clump)
								if clumpUnit == nil then break end

								if IsUnitAliveBJ(clumpUnit) and IsUnitType(clumpUnit, UNIT_TYPE_STRUCTURE) == false then
									if IsUnitAlly(clumpUnit, self[i].player) then
										powerAllyTemp = powerAllyTemp + SquareRoot(I2R(GetUnitPointValue(clumpUnit)))
										powerAllyNumTemp = powerAllyNumTemp + 1
									else
										powerEnemyTemp = powerEnemyTemp + SquareRoot(I2R(GetUnitPointValue(clumpUnit)))
										powerEnemyNumTemp = powerEnemyNumTemp + 1
									end
								end

								GroupRemoveUnit(clump, clumpUnit)
							end
							DestroyGroup(clump)

							if powerAllyNumTemp > self[i].clumpFriendNumber then self[i].clumpFriendNumber = powerAllyNumTemp end

							if powerEnemyNumTemp > self[i].clumpEnemyNumber then self[i].clumpEnemyNumber = powerEnemyNumTemp end

							if powerAllyTemp > self[i].clumpFriendPower then
								self[i].clumpFriendPower = powerAllyTemp
								self[i].clumpFriend = u
							end

							if powerEnemyTemp > self[i].clumpEnemyPower then
								self[i].clumpEnemyPower = powerEnemyTemp
								self[i].clumpEnemy = u
							end

							if (powerAllyTemp + powerEnemyTemp) > self[i].clumpBothPower then
								self[i].clumpBothPower = powerAllyTemp + powerEnemyTemp
								self[i].clumpBoth = u
							end
						end
					end

					GroupRemoveUnit(g, u)
				end
				DestroyGroup(g)

				-- Find how much damage the Hero is taking
				self[i].lifeHistory[#self[i].lifeHistory + 1] = self[i].lifePercent

				if #self[i].lifeHistory > 5 then table.remove(self[i].lifeHistory, 1) end

				self[i].clumpBothNumber = self[i].clumpFriendNumber + self[i].clumpEnemyNumber
				self[i].percentLifeSingle = self[i].lifeHistory[#self[i].lifeHistory - 1] -
								                            self[i].lifeHistory[#self[i].lifeHistory]
				self[i].percentLifeAverage = self[i].lifeHistory[1] - self[i].lifeHistory[#self[i].lifeHistory]

				-- Figure out the Heroes Weighted Life
				self[i].weightedLife = (self[i].life * self[i].healthFactor) + (self[i].mana * self[i].manaFactor)
				self[i].weightedLifeMax = (self[i].lifeMax * self[i].healthFactor) + (self[i].manaMax * self[i].manaFactor)
				self[i].weightedLifePercent = (self[i].weightedLife / self[i].weightedLifeMax) * 100.00

				-- Get the Power Level of the surrounding Units
				self[i].powerEnemy = (self[i].powerEnemy * (((100.00 - self[i].weightedLifePercent) / 20.00) + 0.50))
				self[i].powerCount = self[i].powerEnemy - self[i].powerFriend

				-- Raise Hero Confidence Level
				self[i].powerBase = self[i].powerBase + (0.25 * I2R(self[i].level))
				self[i].powerHero = self[i].powerBase + (self[i].powerLevel * I2R(self[i].level))

				-- print(self[i].currentOrder)
				-- print("Clump Enemy: " .. R2S(self[i].clumpEnemyPower))
				-- print("Clump Both: " .. R2S(self[i].clumpBothPower))
				-- print("Clump: " .. GetUnitName(self[i].clumpBoth))
				-- print("Enemies Nearby: " .. self[i].countUnitEnemy)
				-- print("Power Clump Enemy: " .. self[i].powerEnemy)
				-- print("Hero Power: " .. R2S(self[i].powerHero))
				-- print("Power Level: " .. R2S(self[i].powerCount))
			end
		end

		function self:CleanUp(i)
			if (self[i].currentOrder ~= "move" and (self[i].lowLife or self[i].fleeing)) then self:ACTIONtravelToHeal(i) end

			if (self[i].currentOrder ~= "attack" and self[i].currentOrder ~= "move" and self[i].lowLife == false and
							self[i].casting == false) then self:ACTIONtravelToDest(i) end
		end

		-- AI Run Specifics
		function self:STATEAbilities(i)

			if self[i].name == "manaAddict" then
				self:manaAddictAI(i)
			elseif self[i].name == "brawler" then
				self:brawlerAI(i)
			elseif self[i].name == "shiftMaster" then
				self:shiftMasterAI(i)
			elseif self[i].name == "tactition" then
				self:tactitionAI(i)
			elseif self[i].name == "timeMage" then
				self:timeMageAI(i)
			end
		end

		-- Check to see if Hero should try to upgrade
		function self:STATEUpgrade(i)
			local randInt = GetRandomInt(1, 40)

			if randInt == 10 then hero.upgrade(i) end
		end

		function self:STATEDefend(i)
			if self[i].alive and not self[i].lowLife and not self[i].fleeing and not self[i].casting and not self[i].defending then
				local baseCountDanger = CountUnitsInGroup(base[self[i].teamName].gDanger)
				if baseCountDanger > 0 then
					local u, id, defend, unitCount, danger, selectedId, distanceToBase
					local g = CreateGroup()

					GroupAddGroup(base[self[i].teamName].gDanger, g)
					local danger = 0
					local selectedId = nil
					while true do
						u = FirstOfGroup(g)
						if u == nil then break end

						id = GetHandleId(u)
						if base[id].danger > danger then
							danger = base[id].danger
							selectedId = id
						end

						GroupRemoveUnit(g, u)
					end
					DestroyGroup(g)

					id = selectedId

					if self[i].strat == "defensive" and danger > 40 then
						self[i].defending = true
					elseif self[i].strat == "passive" and danger > 120 then
						self[i].defending = true
					elseif self[i].strat == "aggressive" and danger > 400 then
						self[i].defending = true
					end

					if self[i].defending then
						self[i].unitDefending = base[id].unit
						distanceToBase = distanceBetweenCoordinates(self[i].x, self[i].y, base[id].x, base[id].y)

						if distanceToBase > 3500 then self[i].defendingFast = true end

						self:ACTIONtravelToDest(i)
						print("Defending: " .. GetUnitName(self[i].unitDefending))
					end
				end
			end
		end

		function self:STATEDefending(i)
			if self[i].defending then

				local id = GetHandleId(self[i].unitDefending)
				if base[id].danger <= 0 or not IsUnitAliveBJ(self[i].unitDefending) then
					self[i].defending = false
					self[i].defendingFast = false
					self[i].unitDefending = nil
					self:ACTIONattackBase(i)
					print("Stop Defending")

				else
					local distanceToBase = distanceBetweenCoordinates(self[i].x, self[i].y, base[id].x, base[id].y)
					local teleportCooldown = BlzGetUnitAbilityCooldownRemaining(self[i].unit, hero.item.teleportation.abilityId)

					if distanceToBase < 2500 and self[i].defendingFast then
						self[i].defendingFast = false
						self:ACTIONtravelToDest(i)

					elseif distanceToBase > 4000 and teleportCooldown == 0 then
						self:ACTIONtravelToDest(i)
					end
				end
			end
		end

		-- AI has Low Health
		function self:STATELowHealth(i)
			if (self[i].weightedLifePercent < self[i].lifeLowPercent or self[i].weightedLife < self[i].lifeLowNumber) and
							self[i].lowLife == false then
				print("Low Health")
				self[i].lowLife = true
				self[i].fleeing = false
				self[i].chasing = false
				self[i].defending = false
				self[i].highdamage = false
				self[i].updateDest = false

				if self[i].castingDanger == false then
					self[i].casting = false
					self[i].castingCounter = -10.00
					self:ACTIONtravelToHeal(i)
				end
			end
		end

		-- AI Has High Health
		function self:STATEHighHealth(i)
			if self[i].alive == true and self[i].lowLife == true and self[i].weightedLifePercent > self[i].lifeHighPercent then
				print("High Health")
				self[i].lowLife = false
				self[i].fleeing = false

				-- Reward the AI For doing good
				self[i].lifeLowPercent = self[i].lifeLowPercent - 1.00
				self[i].lifeHighPercent = self[i].lifeHighPercent - 1.00

				if self[i].defending then
					self:ACTIONtravelToDest(i)
				else
					local rand = GetRandomInt(1, 3)
					if rand == 1 then
						self:ACTIONattackBase(i)
					else
						self:ACTIONtravelToDest(i)
					end
				end
			end
		end

		-- AI is Dead
		function self:STATEDead(i)
			if self[i].alive == true and IsUnitAliveBJ(self[i].unit) == false then
				print("Dead")
				self[i].alive = false
				self[i].lowLife = false
				self[i].fleeing = false
				self[i].chasing = false
				self[i].defending = false
				self[i].highdamage = false
				self[i].updateDest = false
				self[i].casting = false
				self[i].castingUlt = false
				self[i].defending = false
				self[i].defendingFast = false
				self[i].castingCounter = -10.00

				-- Punish the AI for screwing up.  IT WILL FEAR DEATH!!!
				self[i].lifeLowPercent = self[i].lifeLowPercent + 4.00
				self[i].powerBase = self[i].powerBase / 2

				if self[i].lifeHighPercent < 98.00 then self[i].lifeHighPercent = self[i].lifeHighPercent + 2.00 end
			end
		end

		-- AI has Revived
		function self:STATERevived(i)
			if self[i].alive == false and IsUnitAliveBJ(self[i].unit) == true then
				print("Revived")
				self[i].alive = true
				self:ACTIONattackBase(i)
			end
		end

		-- AI Fleeing
		function self:STATEFleeing(i)
			if (self[i].powerHero < self[i].powerCount or self[i].percentLifeSingle > self[i].highDamageSingle or
							self[i].percentLifeAverage > self[i].highDamageAverage) and self[i].lowLife == false and self[i].fleeing == false then
				print("Flee")
				self[i].fleeing = true

				if self[i].castingDanger == false then
					self[i].casting = false
					self[i].castingCounter = -10.00
					self:ACTIONtravelToHeal(i)
				end
			end
		end

		-- AI Stop Fleeing
		function self:STATEStopFleeing(i)
			if self[i].powerHero > self[i].powerCount and self[i].percentLifeSingle <= 0.0 and self[i].percentLifeAverage <=
							self[i].highDamageAverage and self[i].lowLife == false and self[i].fleeing == true then
				print("Stop Fleeing")
				self[i].fleeing = false

				self:ACTIONtravelToDest(i)
			end
		end

		-- AI Casting Spell
		function self:STATEcastingSpell(i)
			if self[i].casting == true then

				if self[i].castingDuration > 0.00 then
					print("Casting Spell: " .. self[i].spellCast.name .. " - " .. self[i].castingDuration)

					self[i].castingDuration = self[i].castingDuration - (self.tick * self.count)
				else
					print("Stopped Cast")
					self[i].casting = false
					self[i].castingDuration = 0
					self[i].spellCast = {}
					self[i].castingDanger = false
					self:ACTIONtravelToDest(i)
				end
			end
		end

		--
		-- ACTIONS
		--

		function self:castSpell(i, spellCast, danger)

			if not self[i].casting then
				danger = danger or false
				if spellCast ~= nil then
					if (self[i].fleeing == true or self[i].lowhealth == true) and danger == false then
						self:ACTIONtravelToDest(i)
					else
						print("Spell Cast")
						self[i].casting = true

						if danger then self[i].castingDanger = true end

						self[i].spellCast = spellCast

						if self[i].spellCast.instant then
							self[i].castingDuration = 1
						else
							self[i].castingDuration = self[i].spellCast.castTime[1]
						end

					end
				end
			end
		end

		function self:ACTIONtravelToHeal(i)
			local healDistance = 100000000.00
			local healDistanceNew = 0.00
			local unitX, unitY, u
			local g = CreateGroup()

			GroupAddGroup(base[self[i].teamName].gHealing, g)
			while true do
				u = FirstOfGroup(g)
				if u == nil then break end

				unitX = GetUnitX(u)
				unitY = GetUnitY(u)
				healDistanceNew = distanceBetweenCoordinates(self[i].x, self[i].y, unitX, unitY)

				if healDistanceNew < healDistance then
					healDistance = healDistanceNew
					self[i].unitHealing = u
				end

				GroupRemoveUnit(g, u)
			end
			DestroyGroup(g)

			unitX = GetUnitX(self[i].unitHealing)
			unitY = GetUnitY(self[i].unitHealing)

			-- print("x:" .. unitX .. "y:" .. unitY)

			IssuePointOrder(self[i].unit, "move", unitX, unitY)
		end

		function self:ACTIONtravelToDest(i)
			local unitX, unitY

			if not self[i].casting then
				if self[i].lowLife == true or self[i].fleeing == true then
					unitX = GetUnitX(self[i].unitHealing)
					unitY = GetUnitY(self[i].unitHealing)
					IssuePointOrder(self[i].unit, "move", unitX, unitY)

				elseif self[i].defending then
					unitX = GetUnitX(self[i].unitDefending)
					unitY = GetUnitY(self[i].unitDefending)

					if not self:teleportCheck(i, unitX, unitY) then
						if self[i].defendingFast == true then
							IssuePointOrder(self[i].unit, "move", unitX, unitY)
						else
							IssuePointOrder(self[i].unit, "attack", unitX, unitY)
						end
					end

				else
					if not IsUnitAliveBJ(self[i].unitAttacking) then
						self:ACTIONattackBase(i)
						return
					end
					unitX = GetUnitX(self[i].unitAttacking)
					unitY = GetUnitY(self[i].unitAttacking)
					if not self:teleportCheck(i, unitX, unitY) then IssuePointOrder(self[i].unit, "attack", unitX, unitY) end
				end
			end

		end

		function self:ACTIONattackBase(i)

			if not self[i].casting then
				local regionAdvantage = 0
				local regions = {"top", "middle", "bottom"}
				local regionsPick = {}
				local baseAdvantage

				if self[i].strat == "aggressive" then
					baseAdvantage = self[i].teamName
				elseif self[i].strat == "defensive" then
					baseAdvantage = self[i].teamNameEnemy
				end

				if self[i].strat == "passive" then
					self[i].regionAttacking = regions[GetRandomInt(1, #regions)]
				else
					for a = 1, 3 do
						if regionAdvantage < base[regions[a]][baseAdvantage].advantage then
							regionAdvantage = base[regions[a]][baseAdvantage].advantage
							self[i].regionAttacking = regions[a]

							regionsPick = {}
							table.insert(regionsPick, regions[a])

						elseif regionAdvantage == base[regions[a]][baseAdvantage].advantage then

							table.insert(regionsPick, regions[a])

						end
					end

					if #regionsPick > 1 then self[i].regionAttacking = regionsPick[GetRandomInt(1, #regionsPick)] end

				end

				self[i].unitAttacking = GroupPickRandomUnit(base[self[i].regionAttacking][self[i].teamNameEnemy].g)

				local unitX = GetUnitX(self[i].unitAttacking)
				local unitY = GetUnitY(self[i].unitAttacking)
				print("Attacking: " .. self[i].regionAttacking .. " Base: " .. GetUnitName(self[i].unitAttacking))

				if not self:teleportCheck(i, unitX, unitY) then IssuePointOrder(self[i].unit, "attack", unitX, unitY) end
			end
		end

		function self:getHeroData(unit) return self[indexer:get(unit).heroName] end

		-- Teleport Stuff
		function self:teleportCheck(i, destX, destY)
			local destDistance = 100000000.00
			local destDistanceNew = 0.00
			local unitX, unitY, u
			local teleportUnit
			local g = CreateGroup()
			local heroUnit = self[i].unit

			local distanceOrig = distanceBetweenCoordinates(self[i].x, self[i].y, destX, destY)
			local teleportCooldown = BlzGetUnitAbilityCooldownRemaining(heroUnit, hero.item.teleportation.abilityId)

			if teleportCooldown == 0 and UnitHasItemOfTypeBJ(heroUnit, hero.item.teleportation.id) then

				GroupAddGroup(base[self[i].teamName].gTeleport, g)
				while true do
					u = FirstOfGroup(g)
					if u == nil then break end

					unitX = GetUnitX(u)
					unitY = GetUnitY(u)
					destDistanceNew = distanceBetweenCoordinates(destX, destY, unitX, unitY)

					if destDistanceNew < destDistance then
						destDistance = destDistanceNew
						teleportUnit = u
					end

					GroupRemoveUnit(g, u)
				end
				DestroyGroup(g)

				if distanceOrig - 2000 > destDistanceNew then

					print("Teleporting")

					-- PingMinimap(unitX, unitY, 15)

					UnitUseItemTarget(heroUnit, GetItemOfTypeFromUnitBJ(heroUnit, hero.item.teleportation.id), teleportUnit)

					self:castSpell(i, hero.item.teleportation)

					return true
				else
					return false
				end
			else
				return false
			end

		end

		-- Hero AI

		function self:manaAddictAI(i)
			local curSpell ---@type table

			--  Always Cast
			-------

			-- Mana Shield
			if self[i].casting then return false end

			curSpell = hero.spell(self[i], "manaShield")
			if curSpell.castable == true and curSpell.hasBuff == false then
				print(curSpell.name)
				IssueImmediateOrder(self[i].unit, curSpell.order)
				self:castSpell(i, curSpell)
				return true
			end

			--  Cast available all the time
			-------
			-- Mana Drain
			curSpell = hero.spell(self[i], "manaExplosion")
			if self[i].countUnitEnemyClose > 3 and self[i].manaPercent < 90.00 and curSpell.castable == true then
				print(curSpell.name)
				IssueImmediateOrder(self[i].unit, curSpell.order)
				self:castSpell(i, curSpell)
				return true
			end

			-- Normal Cast
			--------

			if self[i].lowLife == false and self[i].fleeing == false then
				-- Frost Nova
				curSpell = hero.spell(self[i], "manaBomb")
				if self[i].clumpEnemyPower >= 40 and curSpell.castable == true and curSpell.manaLeft > 80 then
					print(curSpell.name)
					IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].clumpEnemy), GetUnitY(self[i].clumpEnemy))
					self:castSpell(i, curSpell)
					return true
				end
			end
		end

		function self:brawlerAI(i)
			local curSpell ---@type table

			if self[i].casting == false then end
		end

		-- Shift Master Spell AI
		function self:shiftMasterAI(i)
			local curSpell ---@type table

			if not self[i].casting then

				-- Custom Intel
				local g = CreateGroup()
				local gUnits = CreateGroup()
				local gIllusions = CreateGroup()
				local u, uTemp, unitsNearby
				local illusionsNearby = 0

				-- Find all Nearby Illusions
				GroupEnumUnitsInRange(g, self[i].x, self[i].y, 600.00, nil)

				GroupAddGroup(g, gIllusions)
				while true do
					u = FirstOfGroup(g)
					if (u == nil) then break end

					if IsUnitIllusion(u) then illusionsNearby = illusionsNearby + 1 end
					GroupRemoveUnit(g, u)
				end
				DestroyGroup(g)

				if self[i].fleeing or self[i].lowLife then

					-- Check if there are illusions Nearby
					if illusionsNearby > 0 then
						curSpell = hero.spell(self[i], "switch")
						if curSpell.castable and curSpell.manaLeft > 0 and not self[i].casting then
							print(curSpell.name)

							u = GroupPickRandomUnit(gIllusions)
							GroupEnumUnitsInRange(gUnits, GetUnitX(u), GetUnitY(u), 350, nil)
							unitsNearby = 0
							while true do
								uTemp = FirstOfGroup(g)
								if (uTemp == nil) then break end

								if not IsUnitAlly(uTemp, GetOwningPlayer(self[i].unit)) then unitsNearby = unitsNearby + 1 end

								GroupRemoveUnit(g, uTemp)
							end
							DestroyGroup(g)

							if unitsNearby < self[i].countUnitEnemyClose then
								IssuePointOrderById(self[i].unit, oid.reveal, GetUnitX(u), GetUnitY(u))
							end
						end
					end

					curSpell = hero.spell(self[i], "shift")
					if curSpell.castable == true and curSpell.manaLeft > 0 then
						print(curSpell.name)
						IssueImmediateOrder(self[i].unit, curSpell.order)
						self:castSpell(i, curSpell)
					end
				end

				-- Normal Cast Spells
				if self[i].casting == false and self[i].lowLife == false and self[i].fleeing == false then

					-- Shift
					curSpell = hero.spell(self[i], "shift")
					if self[i].countUnitEnemyClose >= 2 and curSpell.castable == true and curSpell.manaLeft > 45 then
						print(curSpell.name)

						IssueImmediateOrder(self[i].unit, curSpell.order)
						self:castSpell(i, curSpell)
					end

					-- Falling Strike
					curSpell = hero.spell(self[i], "fallingStrike")
					if (self[i].powerEnemy > 250.00 or self[i].clumpEnemyPower > 80.00) and curSpell.castable == true and
									curSpell.manaLeft > 45 then
						print(curSpell.name)

						if self[i].powerEnemy > 250.00 then
							IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].unitPowerEnemy), GetUnitY(self[i].unitPowerEnemy))
						else
							IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].clumpEnemy), GetUnitY(self[i].clumpEnemy))
						end

						self:castSpell(i, curSpell)
					end

					-- Shift Storm
					curSpell = hero.spell(self[i], "shiftStorm")
					if self[i].countUnitEnemy >= 6 and curSpell.castable == true and curSpell.manaLeft > 30 then
						print(curSpell.name)
						IssueImmediateOrder(self[i].unit, curSpell.order)
						self:castSpell(i, curSpell)
					end
				end

				-- Clean up custom Intel
				DestroyGroup(gIllusions)
			end
		end

		function self:tactitionAI(i)
			local curSpell ---@type table
			local u

			-- Iron Defense
			curSpell = hero.spell(self[i], "ironDefense")
			if self[i].countUnitEnemy >= 2 and curSpell.castable == true and curSpell.manaLeft > 20 and self[i].lifePercent < 80 and
							not self[i].casting then
				print(curSpell.name)
				IssueImmediateOrder(self[i].unit, curSpell.order)
				self:castSpell(i, curSpell)
			end

			if not self[i].fleeing and not self[i].lowLife then
				-- Bolster
				curSpell = hero.spell(self[i], "bolster")
				if self[i].countUnitFriendClose >= 1 and curSpell.castable == true and curSpell.manaLeft > 50 and
								not self[i].casting then
					print(curSpell.name)
					IssueImmediateOrder(self[i].unit, curSpell.order)
					self:castSpell(i, curSpell)
				end

				-- Attack!
				curSpell = hero.spell(self[i], "attack")
				if CountUnitsInGroup(self[i].heroesEnemy) > 0 and curSpell.castable == true and curSpell.manaLeft > 40 and
								not self[i].casting then

					print(curSpell.name)
					u = GroupPickRandomUnit(self[i].heroesEnemy)
					IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(u), GetUnitY(u))
					IssueImmediateOrder(self[i].unit, curSpell.order)
					self:castSpell(i, curSpell)
				end
			end
		end

		function self:timeMageAI(i)
			if self[i].casting then return end

			local curSpell ---@type table
			local x, y, u

			if not self[i].fleeing and not self[i].lowLife then

				-- chrono Atrophy
				curSpell = hero.spell(self[i], "chronoAtrophy")
				if self[i].clumpBothNumber >= 7 and curSpell.castable and curSpell.manaLeft > 30 then
					print(curSpell.name)

					x = GetUnitX(self[i].clumpBoth)
					y = GetUnitY(self[i].clumpBoth)
					IssuePointOrder(self[i].unit, curSpell.order, x, y)
					self:castSpell(i, curSpell)
					return
				end

				-- Decay
				curSpell = hero.spell(self[i], "decay")
				if CountUnitsInGroup(self[i].heroesEnemies) > 0 and curSpell.castable == true and curSpell.manaLeft > 20 then
					print(curSpell.name)

					u = GroupPickRandomUnit(self[i].heroesEnemies)
					IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(u), GetUnitY(u))
					self:castSpell(i, curSpell)
					return
				end

				-- Time Travel
				curSpell = hero.spell(self[i], "timeTravel")
				if self[i].clumpBothNumber >= 4 and curSpell.castable and curSpell.manaLeft > 30 then
					print(curSpell.name)

					x = GetUnitX(self[i].clumpBoth)
					y = GetUnitY(self[i].clumpBoth)
					IssuePointOrder(self[i].unit, curSpell.order, x, y)
					self:castSpell(i, curSpell)
					return
				end
			end
		end

		return self
	end
end



--
-- Unit Indexer Class
-----------------
function init_indexerClass()
	indexer_Class = {}

	indexer_Class.new = function()
		local self = {}

		self.data = {}

		function self:add(unit, order)
			order = order or "attack"
			local unitId = GetHandleId(unit)

			if self.data[unitId] == nil then
				local x = GetUnitX(unit)
				local y = GetUnitY(unit)

				self.data[unitId] = {}
				self.data[unitId] = {xSpawn = x, ySpawn = y, order = order, unit = unit, sfx = {}}
			end
		end

		function self:updateEnd(unit, x, y)
			local unitId = GetHandleId(unit)
			self.data[unitId].xEnd = x
			self.data[unitId].yEnd = y
		end

		function self:order(unit, order)

			local unitId = GetHandleId(unit)
			local alliedForce = IsUnitInForce(unit, udg_PLAYERGRPallied)
			local p
			local x = self.data[unitId].xEnd
			local y = self.data[unitId].yEnd
			order = order or self.data[unitId].order

			if self.data[unitId].xEnd == nil or self.data[unitId].yEnd == nil then

				if RectContainsUnit(gg_rct_Big_Top_Left, unit) or RectContainsUnit(gg_rct_Big_Top_Left_Center, unit) or
								RectContainsUnit(gg_rct_Big_Top_Right_Center, unit) or RectContainsUnit(gg_rct_Big_Top_Right, unit) then

					if alliedForce then
						p = GetRandomLocInRect(gg_rct_Right_Start_Top)
					else
						p = GetRandomLocInRect(gg_rct_Left_Start_Top)
					end

				elseif RectContainsUnit(gg_rct_Big_Middle_Left, unit) or RectContainsUnit(gg_rct_Big_Middle_Left_Center, unit) or
								RectContainsUnit(gg_rct_Big_Middle_Right_Center, unit) or RectContainsUnit(gg_rct_Big_Middle_Right, unit) then

					if alliedForce then
						p = GetRandomLocInRect(gg_rct_Right_Start)
					else
						p = GetRandomLocInRect(gg_rct_Left_Start)
					end

				else

					if alliedForce then
						p = GetRandomLocInRect(gg_rct_Right_Start_Bottom)
					else
						p = GetRandomLocInRect(gg_rct_Left_Start_Bottom)
					end
				end

				x = GetLocationX(p)
				y = GetLocationY(p)
				RemoveLocation(p)

				self.data[unitId].xEnd = x
				self.data[unitId].yEnd = y
			end

			-- Issue Order
			IssuePointOrder(unit, order, x, y)
			QueuedTriggerClearBJ()
		end

		function self:addKey(unit, key, value)
			value = value or 0
			local unitId = GetHandleId(unit)
			self.data[unitId][key] = value
		end

		function self:getKey(unit, key)
			local unitId = GetHandleId(unit)
			return self.data[unitId][key]
		end

		function self:get(unit)
			local unitId = GetHandleId(unit)
			return self.data[unitId]
		end

		function self:set(unit, data)
			local unitId = GetHandleId(unit)
			self.data[unitId] = data
		end

		function self:remove(unit)
			self.data[GetHandleId(unit)] = nil
			return true
		end

		return self
	end
end

--
-- Spawn Class
-----------------
function init_spawnClass()
	-- Create the table for the class definition
	spawn_Class = {}

	-- Define the new() function
	spawn_Class.new = function()
		local self = {}

		self.bases = {}
		self.baseCount = 0
		self.timer = CreateTimer()
		self.cycleInterval = 1.00
		self.baseInterval = 0.5
		self.waveInterval = 10.00

		self.creepLevel = 1
		self.creepLevelTimer = CreateTimer()

		self.wave = 1
		self.base = ""
		self.baseI = 0
		self.indexer = ""
		self.alliedBaseAlive = false
		self.fedBaseAlive = false
		self.unitInWave = false
		self.unitInLevel = true
		self.numOfUnits = 0
		self.unitType = ""

		---Add a new Base
		---@param baseName string
		---@param alliedStart rect
		---@param alliedEnd rect
		---@param alliedCondition unit
		---@param fedStart rect
		---@param fedEnd rect
		---@param fedCondition unit
		function self:addBase(baseName, alliedStart, alliedEnd, alliedCondition, fedStart, fedEnd, fedCondition)
			-- Add all of the info the base and add the base name to the base list
			self[baseName] = {
				allied = {startPoint = alliedStart, endPoint = alliedEnd, condition = alliedCondition},
				fed = {startPoint = fedStart, endPoint = fedEnd, condition = fedCondition},
				units = {}
			}
			table.insert(self.bases, baseName)
			self.baseCount = self.baseCount + 1
		end

		---comment
		---@param baseName string
		---@param unitType unittype
		---@param numOfUnits integer
		---@param waves table
		---@param levelStart integer
		---@param levelEnd integer
		function self:addUnit(baseName, unitType, numOfUnits, waves, levelStart, levelEnd)
			table.insert(self[baseName].units,
			             {unitType = unitType, numOfUnits = numOfUnits, waves = waves, level = {levelStart, levelEnd}})
		end

		function self:unitCount() return #self[self.base].units end

		function self:isUnitInWave()
		
			local waves = self[self.base].units[self.indexer].waves

			for index, value in ipairs(waves) do
				if value == self.wave then
					self.unitInWave = true
					return true
				end
			end

			self.unitInWave = false
			return true
		end

		function self:isUnitInLevel()
			local levelStart = self[self.base].units[self.indexer].level[1]
			local levelEnd = self[self.base].units[self.indexer].level[2]

			if (self.creepLevel >= levelStart and self.creepLevel <= levelEnd) then
				self.unitInLevel = true
			else
				self.unitInLevel = false
			end
		end

		function self:baseAlive()
			self.alliedBaseAlive = IsUnitAliveBJ(self[self.base].allied.condition)
			self.fedBaseAlive = IsUnitAliveBJ(self[self.base].fed.condition)
		end

		function self:checkSpawnUnit()
			self:baseAlive(self.base)
			self:isUnitInWave()
			self:isUnitInLevel()
			self.numOfUnits = self[self.base].units[self.indexer].numOfUnits
			self.unitType = self[self.base].units[self.indexer].unitType
		end

		function self:spawnUnits()
			local pStart, xStart, yStart, pDest, xDest, yDest, spawnedUnit

			for i = 1, self:unitCount(self.base) do
				self.indexer = i
				self:checkSpawnUnit()

				if self.unitInWave and self.unitInLevel then

					for n = 1, self.numOfUnits do

						--DisableTrigger(Trig_UnitEntersMap)

						

						if self.alliedBaseAlive then
							xStart, yStart = loc:getRandomXY(self[self.base].allied.startPoint)
							xDest, yDest = loc:getRandomXY(self[self.base].allied.endPoint)

							spawnedUnit = CreateUnit(Player(GetRandomInt(18, 20)), FourCC(self.unitType), xStart, yStart, bj_UNIT_FACING)
							--QueuedTriggerClearInactiveBJ()
							--print(GetUnitName(spawnedUnit) .. " Created")
							indexer:add(spawnedUnit)
							indexer:updateEnd(spawnedUnit, xDest, yDest)
							--indexer:order(spawnedUnit)
						end

						if self.fedBaseAlive then
							xStart, yStart = loc:getRandomXY(self[self.base].fed.startPoint)
							xDest, yDest = loc:getRandomXY(self[self.base].fed.endPoint)

							spawnedUnit = CreateUnit(Player(GetRandomInt(21, 23)), FourCC(self.unitType), xStart, yStart, bj_UNIT_FACING)
							--QueuedTriggerClearInactiveBJ()
							--print(GetUnitName(spawnedUnit) .. " Created")
							indexer:add(spawnedUnit)
							indexer:updateEnd(spawnedUnit, xDest, yDest)
							--indexer:order(spawnedUnit)
						end

						
						--EnableTrigger(Trig_UnitEntersMap)
						

						--PolledWait(0.1)
					end
				end
			end
		end

		-- Run the Spawn Loop
		function self:loopSpawn()
			-- Iterate everything up
			self.baseI = self.baseI + 1

			if (self.baseI > self.baseCount) then
				self.baseI = 0
				self.wave = self.wave + 1

				if self.wave > 10 then
					self.wave = 1
					StartTimerBJ(self.timer, false, self.cycleInterval)
				else
					StartTimerBJ(self.timer, false, self.waveInterval)
				end

				return true
			else
				StartTimerBJ(self.timer, false, self.baseInterval)
			end

			-- Find the Base to Spawn Next
			self.base = self.bases[self.baseI]

			-- Spawn the Units at the selected Base
			DisableTrigger(Trig_UnitEntersMap)
			self:spawnUnits()
			EnableTrigger(Trig_UnitEntersMap)
		end

		function self:upgradeCreeps()
			self.creepLevel = self.creepLevel + 1

			if self.creepLevel >= 12 then
				DisableTrigger(self.Trig_upgradeCreeps)
			else
				StartTimerBJ(self.creepLevelTimer, false, (50 + (10 * self.creepLevel)))
			end

			DisplayTimedTextToForce(GetPlayersAll(), 10, "Creeps Upgrade.  Level: " .. self.creepLevel)
		end

		-- Start the Spawn Loop
		function self:startSpawn()
			-- Start Spawn Timer
			StartTimerBJ(self.timer, false, 1)
			StartTimerBJ(self.creepLevelTimer, false, 90)

			TriggerRegisterTimerExpireEvent(Trig_spawnLoop, self.timer)
			TriggerRegisterTimerExpireEvent(Trig_upgradeCreeps, self.creepLevelTimer)
		end

		--
		-- Class Triggers
		--

		return self
	end
end

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

function init_gateClass()

	gate = {}
	gate.types = {}
	gate.typeIds = {}
	gate.g = CreateGroup()
	gate.gClosed = CreateGroup()
	gate.gOpen = CreateGroup()

	---Add a new Gate Type
	---@param unitTypeClosed unittype
	---@param unitTypeOpen unittype
	---@param rotation real
	---@return boolean
	function gate.addType(unitTypeClosed, unitTypeOpen, rotation)

		local data = {unitTypeClosed = FourCC(unitTypeClosed), unitTypeOpen = FourCC(unitTypeOpen), rotation = rotation}

		gate.types[FourCC(unitTypeOpen)] = data
		gate.types[FourCC(unitTypeClosed)] = data

		table.insert(gate.typeIds, unitTypeOpen)
		table.insert(gate.typeIds, unitTypeClosed)

		return true
	end

	---Add a new Gate to be monitored
	---@param unit unit
	---@param owningPlayer player
	function gate.add(unit, owningPlayer)

		local playerForce, facingAngle
		local unitTypeClosed ---@type unittype
		local unitTypeOpen ---@type unittype
		local unitType = GetUnitTypeId(unit)
		local x = GetUnitX(unit)
		local y = GetUnitY(unit)

		-- Find if unit is Allied or Fed
		if IsPlayerInForce(owningPlayer, udg_PLAYERGRPallied) then
			playerForce = "allied"
		else
			playerForce = "federation"
		end

		facingAngle = gate.types[unitType].rotation
		unitTypeOpen = gate.types[unitType].unitTypeOpen
		unitTypeClosed = gate.types[unitType].unitTypeClosed

		if playerForce == "federation" then
			facingAngle = facingAngle + 180

			if facingAngle >= 360 then facingAngle = facingAngle - 360 end
		end

		RemoveUnit(unit)
		unit = CreateUnit(owningPlayer, unitTypeOpen, x, y, facingAngle)

		-- Play animation
		SetUnitAnimation(unit, "Death Alternate 1")

		GroupAddUnit(gate.g, unit)
		GroupAddUnit(gate.gOpen, unit)

		local unitId = GetHandleId(unit)
		gate[unitId] = {}
		gate[unitId].force = playerForce
		gate[unitId].unitTypeClosed = unitTypeClosed
		gate[unitId].unitTypeOpen = unitTypeOpen
		gate[unitId].x = x
		gate[unitId].y = y
		gate[unitId].facing = facingAngle

	end

	---Update all Gates
	function gate.update()

		local gGates = CreateGroup()
		GroupAddGroup(gate.g, gGates)

		local pickedUnit = _Unit.Get(FirstOfGroup(gGates))
		while pickedUnit ~= nil do
			local u
			local heroes = 0
			local enemies = 0
			local unit = pickedUnit
			local info = gate[GetHandleId(unit.unit)] ---@type table
			local g = CreateGroup()


			GroupEnumUnitsInRange(g, unit:X(), unit:Y(), 700, nil)


			while true do
				u = FirstOfGroup(g)
				if u == nil then break end

				if not IsUnitAlly(u, unit:Player()) and IsUnitAliveBJ(u) then enemies = enemies + 1 end

				if IsUnitType(u, UNIT_TYPE_HERO) and IsUnitAlly(u, unit:Player()) then heroes = heroes + 1 end

				GroupRemoveUnit(g, u)
			end
			DestroyGroup(g)

			-- print("Enemies:" .. enemies .. " Heroes: " .. heroes)

			if enemies > 0 and heroes == 0 and IsUnitInGroup(unit.unit, gate.gOpen) then

				unit:GroupRemove(gate.gOpen)
				unit:GroupRemove(gate.g)

				gate[unit.handleId] = {}

				unit:SetTimeScale(-1)

				PolledWait(0.667)

				-- Replace Gate with Closed Gate
				DisableTrigger(gate.Trig_gateDies)
				ReplaceUnitBJ(unit.unit, info.unitTypeClosed, bj_UNIT_STATE_METHOD_RELATIVE)
				EnableTrigger(gate.Trig_gateDies)

				unit = _Unit.New(GetLastReplacedUnitBJ())
				gate[unit.handleId] = info
				unit:GroupAdd(gate.gClosed)
				unit:GroupAdd(gate.g)

			elseif (enemies == 0 or heroes > 0) and unit:InGroup(gate.gClosed) then
				unit:GroupRemove(gate.gClosed)
				unit:GroupRemove(gate.g)

				gate[unit.handleId] = {}

				-- Replace Gate with Opened Gate
				DisableTrigger(gate.Trig_gateDies)
				ReplaceUnitBJ(unit.unit, info.unitTypeOpen, bj_UNIT_STATE_METHOD_RELATIVE)
				EnableTrigger(gate.Trig_gateDies)

				unit = _Unit.New(GetLastReplacedUnitBJ())
				gate[unit.handleId] = info
				unit:GroupAdd(gate.gOpen)
				unit:GroupAdd(gate.g)

				-- Play animation
				unit:SetAnimation("Death Alternate 1")

			end

			pickedUnit:GroupRemove(gGates)
			pickedUnit = _Unit.Get(FirstOfGroup(gGates))
		end
		DestroyGroup(gGates)

		-- print("--")
	end

	--
	--  TRIGGERS
	--

	function gate.InitTrig_update()
		local t = CreateTrigger()
		TriggerRegisterTimerEventPeriodic(t, 2.5)
		TriggerAddAction(t, function() try(function() gate.update() end, "Update") end)
	end

	function gate.InitTrig_hitAnim()
		local t = CreateTrigger()
		TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ATTACKED)
		TriggerAddAction(t, function()

			local triggerUnit = _Unit.Get(GetAttackedUnitBJ())
			local unitId = triggerUnit.handleId

			if gate.types[unitId] ~= nil then
				PolledWait(0.2)
				triggerUnit:QueueAnimation("Stand Hit")
			end

		end)
	end

	function gate.InitTrig_dies()
		gate.Trig_gateDies = CreateTrigger()
		TriggerRegisterAnyUnitEventBJ(gate.Trig_gateDies, EVENT_PLAYER_UNIT_DEATH)
		TriggerAddAction(gate.Trig_gateDies, function()

			try(function()
				local dyingUnit = GetDyingUnit()

				if IsUnitInGroup(dyingUnit, gate.g) then
					local x = GetUnitX(dyingUnit)
					local y = GetUnitY(dyingUnit)
					local unitType = GetUnitTypeId(dyingUnit)
					local owningPlayer = GetOwningPlayer(dyingUnit)

					local facingAngle = gate.types[unitType].rotation
					local unitTypeOpen = gate.types[unitType].unitTypeOpen

					-- Remove Traces of Unit
					GroupRemoveUnit(gate.g, dyingUnit)
					RemoveUnit(dyingUnit)

					if not IsPlayerInForce(owningPlayer, udg_PLAYERGRPallied) then
						facingAngle = facingAngle + 180

						if facingAngle >= 360 then facingAngle = facingAngle - 360 end
					end

					unit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), unitTypeOpen, x, y, facingAngle)

					-- Play Death animation
					SetUnitAnimation(unit, "Death 1")
				end
			end, "Start Delayed Triggers")
		end)
	end

	--
	-- MAIN
	--

	function gate.main()
		local unitId ---@type unittype
		local u
		local g = CreateGroup()

		try(function()
			gate.addType("h021", "h020", 0) -- Castle Gate Vertical Right
			gate.addType("h023", "h022", 90) -- Castle Gate Horizontal Botoom
			gate.addType("h01G", "h01C", 0) -- City Gate Verical Right
			gate.addType("h01B", "h01D", 180) -- City Gate Vertical Left
			gate.addType("h01S", "h01T", 90) -- City Gate Horizontal Top

			for i = 1, #gate.typeIds do
				unitId = gate.typeIds[i]

				g = GetUnitsOfTypeIdAll(FourCC(unitId))

				while true do
					u = FirstOfGroup(g)
					if u == nil then break end

					gate.add(u, GetOwningPlayer(u))

					GroupRemoveUnit(g, u)
				end
				DestroyGroup(g)
			end
		end, "add Types")

		-- Init Triggers
		gate.InitTrig_update()
		gate.InitTrig_dies()
		gate.InitTrig_hitAnim()
	end
end
