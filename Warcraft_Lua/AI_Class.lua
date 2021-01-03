function init_aiClass()
	-- Create the table for the class definition
	ai_Class = {}

	-- Define the new() function
	ai_Class.new = function()
		local self = {}
		self.heroes = {}
		self.heroOptions = {
			"heroA",
			"heroB",
			"heroC",
			"heroD",
			"heroE",
			"heroF",
			"heroG",
			"heroH",
			"heroI",
			"heroJ",
			"heroK",
			"heroL"
		}
		self.count = 0
		self.loop = 1
		self.tick = 1

		function self:isAlive(i)
			return self[i].alive
		end

		function self:countOfHeroes()
			return self.count
		end

		function self:initHero(heroUnit)
			self.count = self.count + 1
			self.tick = (1.00 + (self.count * 0.1)) / self.count

			local i = self.heroOptions[self.count]
			print("Name: " .. i)

			table.insert(self.heroes, i)

			self[i] = {}

			self[i].unit = heroUnit
			GroupAddUnit(udg_AI_Heroes, self[i].unit)

			self[i].id = GetUnitTypeId(heroUnit)
			self[i].four = CC2Four(self[i].id)
			self[i].name = hero[self[i].four]

			self[i].player = GetOwningPlayer(heroUnit)
			self[i].playerNumber = GetConvertedPlayerId(GetOwningPlayer(heroUnit))

			if self[i].playerNumber > 6 then
				self[i].teamNumber = 2
			else
				self[i].teamNumber = 1
			end

			self[i].heroesFriend = CreateGroup()
			self[i].heroesEnemy = CreateGroup()
			self[i].lifeHistory = {0.00, 0.00, 0.00}
			SetUnitUserData(self[i].unit, self.count)

			self[i].alive = false
			self[i].fleeing = false
			self[i].casting = false
			self[i].castingDuration = -10.00
			self[i].castingDanger = false
			self[i].order = nil
			self[i].castingUlt = false
			self[i].chasing = false
			self[i].defending = false
			self[i].lowLife = false
			self[i].highDamage = false
			self[i].updateDest = false

			self[i].unitHealing = nil
			self[i].unitAttacking = nil
			self[i].unitChasing = nil

			if self[i].four == hero.brawler.four then -- Brawler
				self[i].healthFactor = 1.00
				self[i].manaFactor = 0.02

				self[i].lifeHighPercent = 65.00
				self[i].lifeLowPercent = 20.00
				self[i].lifeLowNumber = 450.00

				self[i].highDamageSingle = 17.00
				self[i].highDamageAverage = 25.00

				self[i].powerBase = 500.00
				self[i].powerLevel = 200.00

				self[i].clumpCheck = true
				self[i].clumpRange = 100.00
				self[i].intelRange = 1100.00
				self[i].closeRange = 500.00
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
			elseif self[i].four == hero.tactition.four then -- Tactition
				self[i].healthFactor = 1.00
				self[i].manaFactor = 0.20

				self[i].lifeHighPercent = 75.00
				self[i].lifeLowPercent = 20.00
				self[i].lifeLowNumber = 400.00

				self[i].highDamageSingle = 17.00
				self[i].highDamageAverage = 25.00

				self[i].powerBase = 500.00
				self[i].powerLevel = 200.00
				self[i].clumpCheck = true
				self[i].clumpRange = 250.00
				self[i].intelRange = 1000.00
				self[i].closeRange = 400.00
			elseif self[i].four == hero.timeMage.four then -- Time Mage
				self[i].healthFactor = 1.00
				self[i].manaFactor = 0.10

				self[i].lifeHighPercent = 85.00
				self[i].lifeLowPercent = 25.00
				self[i].lifeLowNumber = 400.00

				self[i].highDamageSingle = 8.00
				self[i].highDamageAverage = 17.00

				self[i].powerBase = 750.00
				self[i].powerLevel = 250.00

				self[i].clumpCheck = true
				self[i].clumpRange = 250.00
				self[i].intelRange = 1100.00
				self[i].closeRange = 700.00
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
			end
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
				self[i].clumpFriendPower = 0.00
				self[i].clumpEnemy = nil
				self[i].clumpEnemyPower = 0.00
				self[i].clumpBoth = nil
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
				local powerAllyTemp
				local powerEnemyTemp

				GroupEnumUnitsInRange(g, self[i].x, self[i].y, self[i].intelRange, nil)

				-- Enumerate through group

				while true do
					u = FirstOfGroup(g)
					if (u == nil) then
						break
					end

					-- Unit is alive and not the hero
					if (IsUnitAliveBJ(u) == true and u ~= self[i].unit) then
						self[i].countUnit = self[i].countUnit + 1

						-- Get Unit Details
						unitLife = GetUnitLifePercent(u)
						unitRange = BlzGetUnitWeaponRealField(u, UNIT_WEAPON_RF_ATTACK_RANGE, 0)

						unitX = GetUnitX(u)
						unitY = GetUnitY(u)
						unitDistance = distance(unitX, unitY, self[i].x, self[i].y)

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
							if unitDistance <= self[i].closeRange then
								self[i].countUnitFriendClose = self[i].countUnitFriendClose + 1
							end

							-- Check to see if unit is the most powerful friend
							if unitPower > self[i].powerFriend then
								self[i].unitPowerFriend = u
							end

							-- Relative Power
							self[i].powerFriend = self[i].powerFriend + (unitPower * (unitLife / 100.00) * unitPowerRangeMultiplier)
						else
							-- Update Count
							self[i].countUnitEnemy = self[i].countUnitEnemy + 1
							if unitDistance <= self[i].closeRange then
								self[i].countUnitEnemyClose = self[i].countUnitEnemyClose + 1
							end

							-- Check to see if unit is the most powerful Enemy
							if unitPower > self[i].powerEnemy then
								self[i].unitPowerEnemy = u
							end

							-- Relative Power
							self[i].powerEnemy = self[i].powerEnemy + (unitPower * (unitLife / 100.00) * unitPowerRangeMultiplier)
						end

						if self[i].clumpCheck == true then
							powerAllyTemp = 0
							powerEnemyTemp = 0
							clump = CreateGroup()

							GroupEnumUnitsInRange(clump, unitX, unitY, self[i].clumpRange, nil)

							while true do
								clumpUnit = FirstOfGroup(clump)
								if clumpUnit == nil then
									break
								end

								if IsUnitAliveBJ(clumpUnit) and IsUnitType(clumpUnit, UNIT_TYPE_STRUCTURE) == false then
									if IsUnitAlly(clumpUnit, self[i].player) then
										powerAllyTemp = powerAllyTemp + SquareRoot(I2R(GetUnitPointValue(clumpUnit)))
									else
										powerEnemyTemp = powerEnemyTemp + SquareRoot(I2R(GetUnitPointValue(clumpUnit)))
									end
								end

								GroupRemoveUnit(clump, clumpUnit)
							end
							DestroyGroup(clump)

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

				if #self[i].lifeHistory > 5 then
					table.remove(self[i].lifeHistory, 1)
				end

				self[i].percentLifeSingle =
					self[i].lifeHistory[#self[i].lifeHistory - 1] - self[i].lifeHistory[#self[i].lifeHistory]
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

				--print("Clump Enemy: " .. R2S(self[i].clumpEnemyPower))
				--print("Clump Both: " .. R2S(self[i].clumpBothPower))
				print("Enemies Nearby: " .. self[i].countUnitEnemy)
				print("Power Clump Enemy: " .. self[i].powerEnemy)
				--print("Hero Power: " .. R2S(self[i].powerHero))
				--print("Power Level: " .. R2S(self[i].powerCount))
			end
		end

		function self:CleanUp(i)
			if (self[i].currentOrder ~= "move" and (self[i].lowLife or self[i].fleeing)) then
				self:ACTIONtravelToHeal(i)
			end

			if
				(self[i].currentOrder ~= "attack" and self[i].currentOrder ~= "move" and self[i].lowLife == false and
					self[i].casting == false)
			 then
				self:ACTIONattackBase(i)
			end
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

		-- AI has Low Health
		function self:STATELowHealth(i)
			if
				(self[i].weightedLifePercent < self[i].lifeLowPercent or self[i].weightedLife < self[i].lifeLowNumber) and
					self[i].lowLife == false
			 then
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

				local rand = GetRandomInt(1, 3)
				if rand == 1 then
					self:ACTIONattackBase(i)
				else
					self:ACTIONtravelToDest(i)
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
				self[i].castingCounter = -10.00

				-- Punish the AI for screwing up
				self[i].lifeLowPercent = self[i].lifeLowPercent + 4.00
				self[i].powerBase = self[i].powerBase / 2

				if self[i].lifeHighPercent < 98.00 then
					self[i].lifeHighPercent = self[i].lifeHighPercent + 2.00
				end
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
			if
				(self[i].powerHero < self[i].powerCount or self[i].percentLifeSingle > self[i].highDamageSingle or
					self[i].percentLifeAverage > self[i].highDamageAverage) and
					self[i].lowLife == false and
					self[i].fleeing == false
			 then
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
			if
				self[i].powerHero > self[i].powerCount and self[i].percentLifeSingle <= 0.0 and
					self[i].percentLifeAverage <= self[i].highDamageAverage and
					self[i].lowLife == false and
					self[i].fleeing == true
			 then
				print("Stop Fleeing")
				self[i].fleeing = false

				self:ACTIONtravelToDest(i)
			end
		end

		-- AI Casting Spell
		function self:STATEcastingSpell(i)
			if self[i].casting == true then
				if self[i].castingDuration == -10.00 then
					if self[i].currentOrder ~= self[i].order then
						self[i].casting = false
						self[i].castingDanger = false
						--print("Stopped Casting")
						self:ACTIONtravelToDest(i)
						self[i].order = self[i].currentOrder
					else
						--print("Still Casting Spell")
					end
				elseif self[i].castingDuration > 0.00 then
					--print("Still Casting Spell")
					self[i].castingDuration = self[i].castingDuration - aiTick
				else
					--print("Stopped Casting (Count)")
					self[i].casting = false
					self[i].castingDuration = -10.00
					self[i].castingDanger = false
					self:ACTIONtravelToDest(i)
					self[i].order = self[i].currentOrder
				end
			end
		end

		--
		-- ACTIONS
		--

		function self:castSpell(i, castDuration, danger)
			danger = danger or false
			castDuration = castDuration or -10.00

			if (self[i].fleeing == true or self[i].lowhealth == true) and danger == false then
				self:ACTIONtravelToDest(i)
			else
				--print("Spell Cast")
				self[i].casting = true

				if danger then
					self[i].castingDanger = true
				end

				self[i].castingDuration = castDuration
				self[i].order = OrderId2String(GetUnitCurrentOrder(self[i].unit))
				print(self[i].order)
			end
		end

		function self:ACTIONtravelToHeal(i)
			local healDistance = 100000000.00
			local healDistanceNew = 0.00
			local unitX
			local unitY
			local u
			local g = CreateGroup()

			GroupAddGroup(udg_UNIT_Healing[self[i].teamNumber], g)
			while true do
				u = FirstOfGroup(g)
				if u == nil then
					break
				end

				unitX = GetUnitX(u)
				unitY = GetUnitY(u)
				healDistanceNew = distance(self[i].x, self[i].y, unitX, unitY)

				if healDistanceNew < healDistance then
					healDistance = healDistanceNew
					self[i].unitHealing = u
				end

				GroupRemoveUnit(g, u)
			end
			DestroyGroup(g)

			unitX = GetUnitX(self[i].unitHealing)
			unitY = GetUnitY(self[i].unitHealing)

			IssuePointOrder(self[i].unit, "move", unitX, unitY)
		end

		function self:ACTIONtravelToDest(i)
			if self[i].lowLife == true or self[i].fleeing == true then
				local unitX = GetUnitX(self[i].unitHealing)
				local unitY = GetUnitY(self[i].unitHealing)
				IssuePointOrder(self[i].unit, "move", unitX, unitY)
			else
				local unitX = GetUnitX(self[i].unitAttacking)
				local unitY = GetUnitY(self[i].unitAttacking)
				IssuePointOrder(self[i].unit, "attack", unitX, unitY)
			end
		end

		function self:ACTIONattackBase(i)
			self[i].unitAttacking = GroupPickRandomUnit(udg_UNIT_Bases[self[i].teamNumber])

			local unitX = GetUnitX(self[i].unitAttacking)
			local unitY = GetUnitY(self[i].unitAttacking)

			IssuePointOrder(self[i].unit, "attack", unitX, unitY)
		end

		-- Finders
		function self:getHeroName(unit)
			return self.heroOptions[S2I(GetUnitUserData(unit))]
		end

		function self:getHeroData(unit)
			return self[self:getHeroName(unit)]
		end

		-- Hero AI

		function self:manaAddictAI(i)
			local curSpell

			--  Always Cast
			-------

			-- Mana Shield
			curSpell = hero:spell(self[i], "manaShield")
			if curSpell.castable == true and curSpell.hasBuff == false then
				print(curSpell.name)
				IssueImmediateOrder(self[i].unit, curSpell.order)
				self:castSpell(i)
			end

			--  Cast available all the time
			-------
			if self[i].casting == false then

				-- Mana Drain
				curSpell = hero:spell(self[i], "manaOverload")
				if self[i].countUnitEnemyClose > 3 and self[i].manaPercent < 90.00 and curSpell.castable == true then
					print(curSpell.name)
					IssueImmediateOrder(self[i].unit, curSpell.order)
					self:castSpell(i)
				end

			end

			-- Normal Cast
			--------

			if self[i].casting == false and self[i].lowLife == false and self[i].fleeing == false then

				-- Frost Nova
				curSpell = hero:spell(self[i], "frostNova")
				if self[i].clumpEnemyPower >= 40 and curSpell.castable == true and curSpell.manaLeft > 80 then
					print(curSpell.name)
					IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].clumpEnemy), GetUnitY(self[i].clumpEnemy))
					self:castSpell(i)
				end

			end
		end

		function self:brawlerAI(i)
			local curSpell

			if self[i].casting == false then
			end
		end

		-- Shift Master Spell AI
		function self:shiftMasterAI(i)
			local curSpell


			-- Normal Cast Spells
			if self[i].casting == false and self[i].lowLife == false and self[i].fleeing == false then

				-- Custom Intel
				local g = CreateGroup()
				local u = nil
				local illusionsNearby = 0

				-- Find all Nearby Illusions
				GroupEnumUnitsInRange(g, self[i].x, self[i].y, 600.00, nil)
				while true do
					u = FirstOfGroup(g)
					if (u == nil) then
						break
					end

					if IsUnitIllusion(u) then
						illusionsNearby = illusionsNearby + 1
					end
					GroupRemoveUnit(g, u)
				end
				DestroyGroup(g)

				-- Shift Back
				local curSpell = hero:spell(self[i], "shiftBack")
				if self[i].countUnitEnemyClose >= 2 and curSpell.castable == true and curSpell.manaLeft > 45 then
					print(curSpell.name)
					IssueImmediateOrder(self[i].unit, curSpell.order)
					self:castSpell(i)
				end

				-- Shift Forward
				curSpell = hero:spell(self[i], "shiftForward")
				if self[i].countUnitEnemyClose >= 2 and curSpell.castable == true and curSpell.manaLeft > 45 then
					print(curSpell.name)
					IssueImmediateOrder(self[i].unit, curSpell.order)
					self:castSpell(i)
				end

				-- Falling Strike
				curSpell = hero:spell(self[i], "fallingStrike")
				if
					(self[i].powerEnemy > 250.00 or self[i].clumpEnemyPower > 80.00) and curSpell.castable == true and
						curSpell.manaLeft > 45
				 then
					print(curSpell.name)

					if self[i].powerEnemy > 250.00 then
						IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].unitPowerEnemy), GetUnitY(self[i].unitPowerEnemy))
					else
						IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].clumpEnemy), GetUnitY(self[i].clumpEnemy))
					end

					self:castSpell(i)
				end

				-- Shift Storm
				curSpell = hero:spell(self[i], "shiftStorm")
				if self[i].countUnitEnemy >= 6 and curSpell.castable == true and curSpell.manaLeft > 30 then
					print(curSpell.name)
					IssueImmediateOrder(self[i].unit, curSpell.order)
					self:castSpell(i)
				end
			end
		end


		function self:tactitionAI(i)
			if self[i].casting == false then
				-- Iron Defense
				if
					BlzGetUnitAbilityCooldownRemaining(self[i].unit, ironDefense.spell) == 0.00 and
						(self[i].mana) > I2R(BlzGetAbilityManaCost(ironDefense.spell, ironDefense.level)) and
						ironDefense.level > 0 and
						self[i].lifePercent < 85
				 then
					-- Bolster
					IssueImmediateOrder(self[i].unit, ironDefense.id)
					self:castSpell(i)
				elseif
					BlzGetUnitAbilityCooldownRemaining(self[i].unit, bolster.spell) == 0.00 and
						(self[i].mana + 20) > I2R(BlzGetAbilityManaCost(bolster.spell, bolster.level)) and
						bolster.level > 0 and
						self[i].countUnitFriend > 2 and
						self[i].countUnitEnemy > 2
				 then
					-- Attack
					IssueImmediateOrder(self[i].unit, bolster.id)
					self:castSpell(i, 2)
				elseif
					BlzGetUnitAbilityCooldownRemaining(self[i].unit, attack.spell) == 0.00 and
						(self[i].mana) > I2R(BlzGetAbilityManaCost(attack.spell, attack.level)) and
						attack.level > 0 and
						self[i].clumpEnemyPower > 250
				 then
					-- Inspire
					IssueTargetOrder(self[i].unit, attack.string, self[i].unitPowerEnemy)
					self:castSpell(i)
				elseif
					BlzGetUnitAbilityCooldownRemaining(self[i].unit, inspire.spell) == 0.00 and
						(self[i].mana) > I2R(BlzGetAbilityManaCost(inspire.spell, inspire.level)) and
						inspire.level > 0 and
						self[i].countUnitFriend > 5 and
						self[i].countUnitEnemy > 5
				 then
					IssueImmediateOrder(self[i].unit, inspire.string)
					self:castSpell(i)
				end
			end
		end

		function self:timeMageAI(i)
			if self[i].casting == false then
			end
		end

		return self
	end
end
