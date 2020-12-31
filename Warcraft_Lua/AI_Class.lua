function init_AIClass()

	-- Create the table for the class definition
	ai = {}

	-- Define the new() function
	ai.new = function()
		local self = {}
		self.heroes = {}
		self.heroOptions = {"heroA", "heroB", "heroC", "heroD", "heroE", "heroF", "heroG", "heroH", "heroI", "heroJ", "heroK", "heroL"}
		self.count = 0


		function self:isAlive(i)
			return self[i].alive
		end

		function self:countOfHeroes()
			return self.count
		end

		function self:initHero(heroUnit)

			self.count = self.count + 1

			local pickedName = self.heroOptions[self.count]
			BJDebugMsg("Name: " .. pickedName)

			table.insert( self.heroes, pickedName)
			


			self[pickedName] = {}
			local hero = self[pickedName]
			
			hero.unit = heroUnit
			GroupAddUnit(udg_AI_Heroes, hero.unit)

			hero.unitType = GetUnitTypeId(heroUnit)
			hero.player = GetOwningPlayer(heroUnit)
			hero.playerNumber = GetConvertedPlayerId(GetOwningPlayer(heroUnit))


			if hero.playerNumber > 6 then
				hero.teamNumber = 2
			else
				hero.teamNumber = 1
			end

			hero.heroesFriend = CreateGroup()
			hero.heroesEnemy = CreateGroup()
			hero.lifeHistory = {0.00,0.00,0.00}
			SetUnitUserData(hero.unit, self.count)
			
			hero.alive = false
			hero.fleeing = false
			hero.casting = false
			hero.castingDuration = -10.00
			hero.castingDanger = false
			hero.order = nil
			hero.castingUlt = false
			hero.chasing = false
			hero.defending = false
			hero.lowLife = false
			hero.highDamage = false
			hero.updateDest = false

			hero.unitHealing = nil
			hero.unitAttacking = nil
			hero.unitChasing = nil

			
			if hero.unitType == FourCC("E001") then      -- Brawler
				hero.name = "Brawler"
				hero.healthFactor = 1.00
				hero.manaFactor = 0.02

				hero.lifeHighPercent = 65.00
				hero.lifeLowPercent = 20.00
				hero.lifeLowNumber = 450.00

				hero.highDamageSingle = 17.00
				hero.highDamageAverage = 25.00

				hero.powerBase = 500.00
				hero.powerLevel = 200.00

				hero.clumpCheck = true
				hero.clumpRange = 100.00
				hero.intelRange = 1100.00
				hero.closeRange = 500.00
			
			elseif hero.unitType == FourCC("H00R") then  -- Mana Addict
					
				hero.name = "Mana Addict"
				hero.healthFactor = 1.00
				hero.manaFactor = 0.75

				hero.lifeHighPercent = 85.00
				hero.lifeLowPercent = 25.00
				hero.lifeLowNumber = 300.00

				hero.highDamageSingle = 3.00
				hero.highDamageAverage = 18.00

				hero.powerBase = 700.00
				hero.powerLevel = 220.00

				hero.clumpCheck = true
				hero.clumpRange = 100.00
				hero.intelRange = 1000.00
				hero.closeRange = 400.00

			elseif hero.unitType == FourCC("H009") then  -- Tactition
						
				hero.name = "Tactition"
				hero.healthFactor = 1.00
				hero.manaFactor = 0.20

				hero.lifeHighPercent = 75.00
				hero.lifeLowPercent = 20.00
				hero.lifeLowNumber = 400.00

				hero.highDamageSingle = 17.00
				hero.highDamageAverage = 25.00

				hero.powerBase = 500.00
				hero.powerLevel = 200.00
				hero.clumpCheck = true
				hero.clumpRange = 250.00
				hero.intelRange = 1000.00
				hero.closeRange = 400.00

			elseif hero.unitType == FourCC("H00J") then  -- Time Mage
							
				hero.name = "Time Mage"
				hero.healthFactor = 1.00
				hero.manaFactor = 0.10

				hero.lifeHighPercent = 85.00
				hero.lifeLowPercent = 25.00
				hero.lifeLowNumber = 400.00

				hero.highDamageSingle = 8.00
				hero.highDamageAverage = 17.00

				hero.powerBase = 750.00
				hero.powerLevel = 250.00

				hero.clumpCheck = true
				hero.clumpRange = 250.00
				hero.intelRange = 1100.00
				hero.closeRange = 700.00

			elseif hero.unitType == FourCC("E002") then  -- Shifter
							
				hero.name = "Shifter"
				hero.healthFactor = 1.00
				hero.manaFactor = 0.15

				hero.lifeHighPercent = 70.00
				hero.lifeLowPercent = 25.00
				hero.lifeLowNumber = 350.00

				hero.highDamageSingle = 17.00
				hero.highDamageAverage = 25.00

				hero.powerBase = 500.00
				hero.powerLevel = 200.00

				hero.clumpCheck = true
				hero.clumpRange = 100.00
				hero.intelRange = 1100.00
				hero.closeRange = 400.00

			end	
		end



		-- Update Intel
		function self:updateIntel(i)
			local hero = self[i]

			-- Only run if the hero is alive
			if (hero.alive == true) then

				-- Update info about the AI Hero
				
				hero.x = GetUnitX(hero.unit)
				hero.y = GetUnitY(hero.unit)
				hero.life = GetWidgetLife(hero.unit)
				hero.lifePercent = GetUnitLifePercent(hero.unit)
				hero.lifeMax = GetUnitState(hero.unit, UNIT_STATE_MAX_LIFE)
				hero.mana = GetUnitState(hero.unit, UNIT_STATE_MANA)
				hero.manaPercent = GetUnitManaPercent(hero.unit)
				hero.manaMax = GetUnitState(hero.unit, UNIT_STATE_MAX_MANA)
				hero.level = GetHeroLevel(hero.unit)
				hero.currentOrder = OrderId2String(GetUnitCurrentOrder(hero.unit))
				
				-- Reset Intel
				hero.countUnit = 0
				hero.countUnitFriend = 0
				hero.countUnitFriendClose = 0
				hero.countUnitEnemy = 0
				hero.countUnitEnemyClose = 0
				hero.powerFriend = 0.00
				hero.powerEnemy = 0.00

				hero.unitPowerFriend = nil
				hero.unitPowerEnemy = nil

				hero.clumpFriend = nil
				hero.clumpFriendPower = 0.00
				hero.clumpEnemy = nil
				hero.clumpEnemyPower = 0.00
				hero.clumpBoth = nil
				hero.clumpBothPower = 0.00

				GroupClear(hero.heroesFriend)
				GroupClear(hero.heroesEnemy)

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


				GroupEnumUnitsInRange(g, hero.x, hero.y, hero.intelRange, nil)

				-- Enumerate through group
				
				while true do
					u = FirstOfGroup(g)	
					if ((u == nil)) then break end
					
					-- Unit is alive and not the hero
					if (IsUnitAliveBJ(u) == true and u ~= hero.unit) then
						hero.countUnit = hero.countUnit + 1


						-- Get Unit Details
						unitLife = GetUnitLifePercent(u)
						unitRange = BlzGetUnitWeaponRealField(u, UNIT_WEAPON_RF_ATTACK_RANGE, 0)

						unitX = GetUnitX(u)
						unitY = GetUnitY(u)
						unitDistance = distance(unitX, unitY, hero.x, hero.y)

						-- Get Unit Power
						if (IsUnitType(u, UNIT_TYPE_HERO) == true) then -- is Hero
							unitPower = I2R((GetHeroLevel(u) * 75))

							if IsUnitAlly(u, hero.player) then  -- Add to hero Group
								GroupAddUnit(hero.heroesFriend, u)
							else
								GroupAddUnit(hero.heroesEnemy, u)
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

						
						if IsUnitAlly(u, hero.player) == true then

							-- Update count
							hero.countUnitFriend = hero.countUnitFriend + 1
							if unitDistance <= hero.closeRange then
								hero.countUnitFriendClose = hero.countUnitFriendClose + 1
							end

							-- Check to see if unit is the most powerful friend
							if unitPower > hero.powerFriend then
								hero.unitPowerFriend = u
							end

							-- Relative Power
							hero.powerFriend = hero.powerFriend + (unitPower * (unitLife / 100.00) * unitPowerRangeMultiplier )

						else
							-- Update Count
							hero.countUnitEnemy = hero.countUnitEnemy + 1
							if unitDistance <= hero.closeRange then
								hero.countUnitEnemyClose = hero.countUnitEnemyClose + 1
							end

							-- Check to see if unit is the most powerful Enemy
							if unitPower > hero.powerEnemy then
								hero.unitPowerEnemy = u
							end

							-- Relative Power
							hero.powerEnemy = hero.powerEnemy + (unitPower * (unitLife / 100.00) * unitPowerRangeMultiplier )
						end

						if hero.clumpCheck == true then

							powerAllyTemp = 0
							powerEnemyTemp = 0
							clump = CreateGroup()

							GroupEnumUnitsInRange(clump, unitX, unitY, hero.clumpRange, nil)

							while true do
								clumpUnit = FirstOfGroup(clump)
								if clumpUnit == nil then break end

								if  IsUnitAliveBJ(clumpUnit) and IsUnitType(clumpUnit, UNIT_TYPE_STRUCTURE) == false then
									if IsUnitAlly(clumpUnit, hero.player) then 
										powerAllyTemp = powerAllyTemp + SquareRoot(I2R(GetUnitPointValue(clumpUnit)))
									else
										powerEnemyTemp = powerEnemyTemp + SquareRoot(I2R(GetUnitPointValue(clumpUnit)))
									end
								end


								GroupRemoveUnit(clump, clumpUnit)
							end
							DestroyGroup(clump)

							if powerAllyTemp > hero.clumpFriendPower then
								hero.clumpFriendPower = powerAllyTemp
								hero.clumpFriend = u
							end

							if powerEnemyTemp > hero.clumpEnemyPower then
								hero.clumpEnemyPower = powerEnemyTemp
								hero.clumpEnemy = u
							end

							if (powerAllyTemp + powerEnemyTemp) > hero.clumpBothPower then
								hero.clumpBothPower = powerAllyTemp + powerEnemyTemp
								hero.clumpBoth = u
							end

						end
						
					end

					GroupRemoveUnit(g, u)
				end
				DestroyGroup(g)

				-- Find how much damage the Hero is taking
				hero.lifeHistory[#hero.lifeHistory + 1] = hero.lifePercent
				
				if #hero.lifeHistory > 5 then
					table.remove(hero.lifeHistory, 1)
				end
				
				hero.percentLifeSingle = hero.lifeHistory[#hero.lifeHistory -1] - hero.lifeHistory[#hero.lifeHistory]
				hero.percentLifeAverage = hero.lifeHistory[1] - hero.lifeHistory[#hero.lifeHistory]

				-- Figure out the Heroes Weighted Life
				hero.weightedLife = (hero.life * hero.healthFactor) + (hero.mana * hero.manaFactor)
				hero.weightedLifeMax = (hero.lifeMax * hero.healthFactor) + (hero.manaMax * hero.manaFactor)
				hero.weightedLifePercent = (hero.weightedLife / hero.weightedLifeMax) * 100.00

				-- Get the Power Level of the surrounding Units
				hero.powerEnemy = (hero.powerEnemy * (((100.00 - hero.weightedLifePercent) / 20.00) + 0.50))
				hero.powerCount = hero.powerEnemy - hero.powerFriend

				-- Raise Hero Confidence Level
				hero.powerBase = hero.powerBase + (0.25 * I2R(hero.level))
				hero.powerHero = hero.powerBase + (hero.powerLevel * I2R(hero.level) )

				--print("Clump Enemy: " .. R2S(hero.clumpEnemyPower))
				--print("Clump Both: " .. R2S(hero.clumpBothPower))
				--print("Hero Power: " .. R2S(hero.powerHero))
				--print("Power Level: " .. R2S(hero.powerCount))
			end

			
		end
		
		function self:CleanUp(i)
			local hero = self[i]

			if (hero.currentOrder ~= "move" and (hero.lowLife or hero.fleeing)) then
				self:ACTIONtravelToHeal(i)
			end

			if (hero.currentOrder ~= "attack" and hero.currentOrder ~= "move" and hero.lowLife == false and hero.casting == false ) then
				self:ACTIONattackBase(i)
			end
		end

		-- AI Run Specifics
		function self:STATEAbilities(i)
			local hero = self[i]

			if hero.name == "Mana Addict" then
				self:manaAddictAI(i)
			elseif hero.name == "Brawler" then
				self:brawlerAI(i)
			elseif hero.name == "Shifter" then
				self:shifterAI(i)
			elseif hero.name == "Tactition" then
				self:tactitionAI(i)
			elseif hero.name == "Time Mage" then
				self:timeMageAI(i)
			end
			
		end

		-- AI has Low Health
		function self:STATELowHealth(i)
			local hero = self[i]

			
			if (hero.weightedLifePercent < hero.lifeLowPercent or 
					hero.weightedLife < hero.lifeLowNumber) and 
					hero.lowLife == false then
					
				print("Low Health")
				hero.lowLife = true
				hero.fleeing = false
				hero.chasing = false
				hero.defending = false
				hero.highdamage = false
				hero.updateDest = false

				if hero.castingDanger == false then
					hero.casting = false
					hero.castingCounter = -10.00
					self:ACTIONtravelToHeal(i)
				end
			end
		end		

		-- AI Has High Health
		function self:STATEHighHealth(i)
			local hero = self[i]

			
			if hero.alive == true and
					hero.lowLife == true and
					hero.weightedLifePercent > hero.lifeHighPercent then
				
				print("High Health")
				hero.lowLife = false
				hero.fleeing = false
				

				-- Reward the AI For doing good
				hero.lifeLowPercent = hero.lifeLowPercent - 1.00
				hero.lifeHighPercent = hero.lifeHighPercent - 1.00
				
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
			local hero = self[i]

			if hero.alive == true and IsUnitAliveBJ(hero.unit) == false then
				
				print("Dead")
				hero.alive = false
				hero.lowLife = false
				hero.fleeing = false
				hero.chasing = false
				hero.defending = false
				hero.highdamage = false
				hero.updateDest = false
				hero.casting = false
				hero.castingUlt = false
				hero.castingCounter = -10.00
				
				-- Punish the AI for screwing up
				hero.lifeLowPercent = hero.lifeLowPercent + 4.00
				hero.powerBase = hero.powerBase / 2

				if hero.lifeHighPercent < 98.00 then
					hero.lifeHighPercent = hero.lifeHighPercent + 2.00
				end
				
			end
		end

		-- AI has Revived
		function self:STATERevived(i)
			local hero = self[i]

			if hero.alive == false and IsUnitAliveBJ(hero.unit) == true then

				print("Revived")
				hero.alive = true
				self:ACTIONattackBase(i)
			end
		end

		-- AI Fleeing
		function self:STATEFleeing(i)
			local hero = self[i]

			if (hero.powerHero < hero.powerCount or hero.percentLifeSingle > hero.highDamageSingle or hero.percentLifeAverage > hero.highDamageAverage ) and
					hero.lowLife == false and hero.fleeing == false then
					
				print("Flee")
				hero.fleeing = true

				if hero.castingDanger == false then
					hero.casting = false
					hero.castingCounter = -10.00
					self:ACTIONtravelToHeal(i)
				end
			end
		end	

		-- AI Stop Fleeing
		function self:STATEStopFleeing(i)
			local hero = self[i]

			if  hero.powerHero > hero.powerCount and hero.percentLifeSingle <= 0.0 and hero.percentLifeAverage <= hero.highDamageAverage and hero.lowLife == false and hero.fleeing == true then
					
				print("Stop Fleeing")
				hero.fleeing = false

				self:ACTIONtravelToDest(i)
			end
		end	

		-- AI Casting Spell
		function self:STATEcastingSpell(i)
			local hero = self[i]

			if hero.casting == true then
				if hero.castingDuration == -10.00 then
					if hero.currentOrder ~= hero.order then
						hero.casting = false
						hero.castingDanger = false
						--print("Stopped Casting")
						self:ACTIONtravelToDest(i)
						hero.order = hero.currentOrder
					else
						--print("Still Casting Spell")
					end

				elseif hero.castingDuration > 0.00 then
					hero.castingDuration = hero.castingDuration - aiTick
					--print("Still Casting Spell")

				else
					--print("Stopped Casting (Count)")
					hero.casting = false
					hero.castingDuration = -10.00
					hero.castingDanger = false
					self:ACTIONtravelToDest(i)
					hero.order = hero.currentOrder
				end
			end	
		end

		--
		-- ACTIONS
		--

		function self:castSpell(i, castDuration, danger)
			danger = danger or false
			castDuration = castDuration or -10.00

			local hero = self[i]

			if (hero.fleeing == true or hero.lowhealth == true) and danger == false then
				self:ACTIONtravelToDest(i)
			else
				hero.casting = true

				if danger then
					hero.castingDanger = true
				end

				hero.castingDuration = castDuration
				hero.order = OrderId2String(GetUnitCurrentOrder(hero.unit))
				print(hero.order)
				--print("Spell Cast")
			end
		end


		function self:ACTIONtravelToHeal(i)
			local hero = self[i]

			local healDistance = 100000000.00
			local healDistanceNew = 0.00
			local unitX
			local unitY
			local u
			local g = CreateGroup()


			GroupAddGroup(udg_UNIT_Healing[hero.teamNumber], g)
			while true do
				u = FirstOfGroup(g)
				if u == nil then break end

				unitX = GetUnitX(u)
				unitY = GetUnitY(u)
				healDistanceNew = distance(hero.x, hero.y, unitX, unitY)

				if healDistanceNew < healDistance then
					healDistance = healDistanceNew
					hero.unitHealing = u
				end

				GroupRemoveUnit(g, u)
			end
			DestroyGroup(g)

			unitX = GetUnitX(hero.unitHealing)
			unitY = GetUnitY(hero.unitHealing)

			IssuePointOrder(hero.unit, "move", unitX, unitY)

		end

		function self:ACTIONtravelToDest(i)
			local hero = self[i]

			if hero.lowLife == true or hero.fleeing == true then
				local unitX = GetUnitX(hero.unitHealing)
				local unitY = GetUnitY(hero.unitHealing)
				IssuePointOrder(hero.unit, "move", unitX, unitY)
			else
				local unitX = GetUnitX(hero.unitAttacking)
				local unitY = GetUnitY(hero.unitAttacking)
				IssuePointOrder(hero.unit, "attack", unitX, unitY)
			end
		end

		function self:ACTIONattackBase(i)
			local hero = self[i]

			hero.unitAttacking = GroupPickRandomUnit(udg_UNIT_Bases[hero.teamNumber])

			local unitX = GetUnitX(hero.unitAttacking)
			local unitY = GetUnitY(hero.unitAttacking)

			IssuePointOrder(hero.unit, "attack", unitX, unitY)

		end


		function self:manaAddictAI(i)
			local hero = self[i]

			local manaShieldSpell = FourCC("A001")
			local manaShieldBuff = FourCC("BNms")
			local frostNovaSpell = FourCC("A03S")
			local manaOverloadSpell = FourCC("A018")

		--  Always Cast
		-------

			-- Mana Shield
			if	BlzGetUnitAbilityCooldownRemaining(hero.unit, manaShieldSpell) == 0.00 and
					UnitHasBuffBJ(hero.unit, manaShieldBuff) == false  then

				--print("Casting Mana Shield")
				IssueImmediateOrder(hero.unit, "manashieldon")
				self:castSpell(i)
			end


		--  Cast when Health is low
		-------

			if hero.casting == false then
				-- Mana Drain
				if	hero.countUnitEnemyClose > 3 and
					hero.manaPercent < 90.00 and
					GetUnitAbilityLevel(hero.unit, manaOverloadSpell) > 0 and
					BlzGetUnitAbilityCooldownRemaining(hero.unit, manaOverloadSpell) == 0.00 then
					
					--print("Casting Mana Overload")
					IssueImmediateOrder(hero.unit, "thunderclap")
					self:castSpell(i)
				end
			end

		-- Normal Cast
		--------			

			if hero.casting == false and hero.lowLife == false and hero.fleeing == false then

				-- Frost Nova
				if	hero.clumpEnemyPower >= 40 and
					BlzGetUnitAbilityCooldownRemaining(hero.unit, frostNovaSpell) == 0.00 and
					(hero.mana + 50.00) >= I2R(BlzGetAbilityManaCost(frostNovaSpell, GetUnitAbilityLevel(hero.unit,frostNovaSpell))) then
					
					--print("Frost Nova")
					IssuePointOrder(hero.unit, "flamestrike", GetUnitX(hero.clumpEnemy), GetUnitY(hero.clumpEnemy))
					self:castSpell(i)
				end
				
			end
		end

		function self:brawlerAI(i)
			local hero = self[i]

			if hero.casting == false then
				
			end
		end

		function self:shifterAI(i)
			local hero = self[i]

			local shiftBackSpell = FourCC("A03U")
			local shiftBackLevel = GetUnitAbilityLevel(hero.unit, shiftBackSpell)
			local shiftForwardSpell = FourCC("A030")
			local shiftForwardLevel = GetUnitAbilityLevel(hero.unit, shiftForwardSpell)
			local fallingStrikeSpell = FourCC("A03T")
			local fallingStrikeLevel = GetUnitAbilityLevel(hero.unit, fallingStrikeSpell)
			local shiftStormSpell = FourCC("A03C")
			local shiftStormLevel = GetUnitAbilityLevel(hero.unit, shiftStormSpell)
			local felFormSpell = FourCC("A02Y")
			local felFormLevel = GetUnitAbilityLevel(hero.unit, felFormSpell)

		--  Cast when Health is low
		-------
			if (hero.lowLife == true or hero.fleeing == true ) and hero.casting == false then

				-- Fel Form
				if	BlzGetUnitAbilityCooldownRemaining(hero.unit, felFormSpell) == 0.00 and
						(hero.mana) > I2R(BlzGetAbilityManaCost(felFormSpell, felFormLevel)) and
						felFormLevel > 0 and
						hero.casting == false then

					--print("Fel Form Danger")
					IssueImmediateOrder(hero.unit, "metamorphosis")
					self:castSpell(i, true)

				-- Shift Back
				elseif	BlzGetUnitAbilityCooldownRemaining(hero.unit, shiftBackSpell) == 0.00 and
						(hero.mana) > I2R(BlzGetAbilityManaCost(shiftBackSpell, shiftBackLevel)) and
						shiftBackLevel > 0 and
						hero.casting == false then

					--print("Shift Back Danger")
					IssueImmediateOrder(hero.unit, "stomp")
					self:castSpell(i, 1, true)
				end

			end


		--  Normal Cast Spells
		-------
			if hero.casting == false then


				-- Custom Intel
				local g = CreateGroup()
				local u = nil
				local illusionsNearby = 0

				-- Find all Nearby Illusions
				GroupEnumUnitsInRange(g, hero.x, hero.y, 600.00, nil)
				while true do
					u = FirstOfGroup(g)
					if (u == nil) then break end
						
					if IsUnitIllusion(u) then
						illusionsNearby = illusionsNearby + 1
					end
					GroupRemoveUnit(g, u)
				end
				DestroyGroup(g)


				-- Shift Back
				if	BlzGetUnitAbilityCooldownRemaining(hero.unit, shiftBackSpell) == 0.00 and
						(hero.mana + 40) > I2R(BlzGetAbilityManaCost(shiftBackSpell, shiftBackLevel)) and
						shiftBackLevel > 0 and
						hero.countUnitEnemyClose > 4 then
					
					--print("Shift Back")
					IssueImmediateOrder(hero.unit, "stomp")
					self:castSpell(i, 1)
				
				
				-- Shift Forward
				elseif	BlzGetUnitAbilityCooldownRemaining(hero.unit, shiftForwardSpell) == 0.00 and
						shiftForwardLevel > 0 and
						(((hero.mana + 40) > I2R(BlzGetAbilityManaCost(shiftForwardSpell, shiftForwardLevel)) and hero.countUnitEnemyClose > 4) or
						(hero.manaPercent > 70 and hero.countUnitEnemyClose > 2 )) then

					--print("Shift Forward")
					IssueImmediateOrder(hero.unit, "thunderclap")
					self:castSpell(i, 1)


				-- Falling Stike
				elseif BlzGetUnitAbilityCooldownRemaining(hero.unit, fallingStrikeSpell) == 0.00 and
					(hero.mana + 40) > I2R(BlzGetAbilityManaCost(fallingStrikeSpell, fallingStrikeLevel)) and 
					fallingStrikeLevel > 0 and
					(hero.powerEnemy > 250.00 or hero.clumpEnemyPower > 80.00) then
					
					if hero.powerEnemy > 250.00 then
						IssuePointOrder(hero.unit, "clusterrockets", GetUnitX(hero.unitPowerEnemy), GetUnitY(hero.unitPowerEnemy))
					else
						IssuePointOrder(hero.unit, "clusterrockets", GetUnitX(hero.clumpEnemy), GetUnitY(hero.clumpEnemy))
					end

					--print("Falling Strike")
					self:castSpell(i, 1)

				-- ShiftStorm
				elseif	BlzGetUnitAbilityCooldownRemaining(hero.unit, shiftStormSpell) == 0.00 and
					(hero.mana + 40) > I2R(BlzGetAbilityManaCost(shiftStormSpell, shiftStormLevel)) and
					shiftStormLevel > 0 and
					hero.countUnitEnemyClose > 6 and
					illusionsNearby >= 2 then

					--print("Shift Storm")
					IssueImmediateOrder(hero.unit, "channel")
					self:castSpell(i)

				
				-- Fel Form
				elseif BlzGetUnitAbilityCooldownRemaining(hero.unit, felFormSpell) == 0.00 and
						(hero.mana + 50) > I2R(BlzGetAbilityManaCost(felFormSpell, felFormLevel)) and
						felFormLevel > 0 and
						hero.countUnitEnemy > 5 then

					--print("Fel Form")
					IssueImmediateOrder(hero.unit, "metamorphosis")
					self:castSpell(i)
				end
			end
		end

		function self:tactitionAI(i)
			local hero = self[i]

			local ironDefenseSpell = FourCC("A019")
			local ironDefenseLevel = GetUnitAbilityLevel(hero.unit, ironDefenseSpell)
			local raiseBannerSpell = FourCC("A01I")
			local raiseBannerLevel = GetUnitAbilityLevel(hero.unit, raiseBannerSpell)
			local attackSpell = FourCC("A01B")
			local attackLevel = GetUnitAbilityLevel(hero.unit, attackSpell)
			local bolsterSpell = FourCC("A01Z")
			local bolsterLevel = GetUnitAbilityLevel(hero.unit, bolsterSpell)
			local inspireSpell = FourCC("A042")
			local inspireLevel = GetUnitAbilityLevel(hero.unit, inspireSpell)



			if hero.casting == false then

				-- Iron Defense
				if BlzGetUnitAbilityCooldownRemaining(hero.unit, ironDefenseSpell) == 0.00 and
						(hero.mana) > I2R(BlzGetAbilityManaCost(ironDefenseSpell, ironDefenseLevel)) and
						ironDefenseLevel > 0 and
						hero.lifePercent < 85 then

					IssueImmediateOrder(hero.unit, "battleroar")
					self:castSpell(i)

				-- Bolster
				elseif BlzGetUnitAbilityCooldownRemaining(hero.unit, bolsterSpell) == 0.00 and
						(hero.mana + 20) > I2R(BlzGetAbilityManaCost(bolsterSpell, bolsterLevel)) and
						bolsterLevel > 0 and
						hero.countUnitFriend > 2 and
						hero.countUnitEnemy > 2 then

					IssueImmediateOrder(hero.unit, "tranquility")
					self:castSpell(i, 2)
				

				-- Attack
				elseif BlzGetUnitAbilityCooldownRemaining(hero.unit, attackSpell) == 0.00 and
						(hero.mana) > I2R(BlzGetAbilityManaCost(attackSpell, attackLevel)) and
						attackLevel > 0 and
						hero.clumpEnemyPower > 250 then

					IssueTargetOrder(hero.unit, "fingerofdeath", hero.unitPowerEnemy)
					self:castSpell(i)
				

				-- Inspire
				elseif BlzGetUnitAbilityCooldownRemaining(hero.unit, inspireSpell) == 0.00 and
						(hero.mana) > I2R(BlzGetAbilityManaCost(inspireSpell, inspireLevel)) and
						inspireLevel > 0 and
						hero.countUnitFriend > 5 and
						hero.countUnitEnemy > 5 then

					IssueImmediateOrder(hero.unit, "roar")
					self:castSpell(i)
				end
			end
		end

		function self:timeMageAI(i)
			local hero = self[i]

			if hero.casting == false then
				
			end
		end

		return self
	end
end