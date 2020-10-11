function init_AIClass()

	-- Create the table for the class definition
	ai = {}

	-- Define the new() function
	ai.new = function()
		local self = {}
		self.heroes = {}
		self.heroGroup = CreateGroup()
		self.heroOptions = {"heroA", "heroB", "heroC", "heroD", "heroE", "heroF", "heroG", "heroH", "heroI", "heroJ", "heroK", "heroL"}
		self.count = 0


		function self.isAlive(i)
			return self[i].alive
		end

		function self.initHero(heroUnit)

			self.count = self.count + 1

			local pickedName = self.heroOptions[self.count]
			BJDebugMsg("Name: " .. pickedName)

			table.insert( self.heroes, pickedName)
			


			self[pickedName] = {}
			local hero = self[pickedName]
			
			hero.unit = heroUnit
			GroupAddUnit(self.heroGroup, hero.unit)

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
			hero.castingCounter = -10.00
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

				hero.clumpAllyCheck = false
				hero.clumbEnemyCheck = false
				hero.clumbBothCheck = false
				hero.clumpRange = 100.00
				hero.intelRange = 1100.00
				hero.closeRange = 500.00
			
			elseif hero.unitType == FourCC("H00R") then  -- Mana Addict
					
				hero.name = "Mana Addict"
				hero.healthFactor = 1.00
				hero.manaFactor = 0.75

				hero.lifeHighPercent = 85.00
				hero.lifeLowPercent = 25.00
				hero.lifeLowNumber = 400.00

				hero.highDamageSingle = 4.00
				hero.highDamageAverage = 12.00

				hero.powerBase = 700.00
				hero.powerLevel = 220.00

				hero.clumpAllyCheck = false
				hero.clumbEnemyCheck = false
				hero.clumbBothCheck = false
				hero.clumpRange = 100.00
				hero.intelRange = 1000.00
				hero.closeRange = 500.00

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

				hero.clumpAllyCheck = false
				hero.clumbEnemyCheck = false
				hero.clumbBothCheck = false
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

				hero.highDamageSingle = 10.00
				hero.highDamageAverage = 17.00

				hero.powerBase = 750.00
				hero.powerLevel = 250.00

				hero.clumpAllyCheck = false
				hero.clumbEnemyCheck = false
				hero.clumbBothCheck = false
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

				hero.clumpAllyCheck = false
				hero.clumbEnemyCheck = false
				hero.clumbBothCheck = false
				hero.clumpRange = 150.00
				hero.intelRange = 1100.00
				hero.closeRange = 400.00

			end	
		end



		-- Update Intel
		function self.updateIntel(i)
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

						IsUnitAlly(whichUnit, whichPlayer)
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

							-- Check to see if unit is the most powerful friend
							if unitPower > hero.powerEnemy then
								hero.unitPowerEnemy = u
							end

							-- Relative Power
							hero.powerEnemy = hero.powerEnemy + (unitPower * (unitLife / 100.00) * unitPowerRangeMultiplier )
						end

						if hero.clumpAllyCheck == true or hero.clumpEnemyCheck == true or hero.clumpBothCheck == true then

							powerAllyTemp = 0
							powerEnemyTemp = 0

							GroupEnumUnitsInRange(clump, unitX, unitY, hero.clumpRange, nil)
							while true do
								clumpUnit = FirstOfGroup(clump)
								if clumpUnit == nil then break end

								if IsUnitAlly(clumpUnit, hero.player) and (hero.clumpAlly == true or hero.clumpBoth == true) then
									powerAllyTemp = powerAllyTemp + SquareRoot(I2R(GetUnitPointValue(clumpUnit)))
								end

								if not IsUnitAlly(clumpUnit, hero.player) and (hero.clumpEnemy == true or hero.clumpBoth == true) then
									powerEnemyTemp = powerEnemyTemp + SquareRoot(I2R(GetUnitPointValue(clumpUnit)))
								end

								GroupRemoveUnit(clump, clumpUnit)
							end
							DestroyGroup(clump)

							if hero.clumpAllyCheck == true and powerAllyTemp > hero.clumpFriendPower then
								hero.clumpFriendPower = powerAllyTemp
								hero.clumpFriend = u
							end

							if hero.clumpEnemyCheckCheck == true and powerEnemyTemp > hero.clumpEnemyPower then
								hero.clumpEnemyPower = powerEnemyTemp
								hero.clumpEnemy = u
							end

							if hero.clumpBothCheck == true and (powerAllyTemp + powerEnemyTemp) > hero.clumpBothPower then
								hero.clumpBothPower = powerAllyTemp + powerEnemyTemp
								hero.clumpBoth = u
							end

						end
						
					end

					GroupRemoveUnit(g, u)
				end
				DestroyGroup(g)

				-- Find how much damage the Hero is taking
				hero.lifeHistory[#hero.lifeHistory + 1] = hero.life
				
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

				--print("Hero Power: " .. R2S(hero.powerHero))
				--print("Power Level: " .. R2S(hero.powerCount))
			end

			
		end
		
		-- AI has Low Health
		function self.STATELowHealth(i)
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
				hero.casting = false
				hero.castingCounter = -10.00

				self.ACTIONtravelToHeal(i)
			end
		end		

		-- AI Has High Health
		function self.STATEHighHealth(i)
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
					self.ACTIONattackBase(i)
				else
					self.ACTIONtravelToDest(i)
				end
			end
		
		end

		-- AI is Dead
		function self.STATEDead(i)
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
		function self.STATERevived(i)
			local hero = self[i]

			if hero.alive == false and IsUnitAliveBJ(hero.unit) == true then

				print("Revived")
				hero.alive = true
				self.ACTIONattackBase(i)
			end
		end

		-- AI Fleeing
		function self.STATEFleeing(i)
			local hero = self[i]

			if hero.powerHero < hero.powerCount and
					hero.lowLife == false and hero.fleeing == false then
					
				print("Flee")
				hero.fleeing = true

				self.ACTIONtravelToHeal(i)
			end
		end	

		-- AI Stop Fleeing
		function self.STATEStopFleeing(i)
			local hero = self[i]

			if hero.powerHero > hero.powerCount and hero.lowLife == false and hero.fleeing == true then
					
				print("Stop Fleeing")
				hero.fleeing = false

				self.ACTIONtravelToDest(i)
			end
		end	

		-- AI Casting Spell
		function self.STATEcastingSpell(i)
			local hero = self[i]

			if hero.casting == true then
				print("Casting Spell")

				if hero.castingCounter == -10.00 then
					if GetUnitCurrentOrder(hero.unit) ~= hero.order then
						hero.casting = false
						self.ACTIONtravelToDest()
						hero.order = OrderId2String(GetUnitCurrentOrder(hero.unit))
					end

				elseif hero.castingCounter > 0.00 then
					hero.castingCounter = hero.castingCounter - 1.50

				else
					hero.casting = false
					hero.castingCounter = -10.00
					self.ACTIONtravelToDest()
					hero.order = OrderId2String(GetUnitCurrentOrder(hero.unit))
				end
			end	
		end

		--
		-- ACTIONS
		--

		function self.ACTIONtravelToHeal(i)
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

		function self.ACTIONtravelToDest(i)
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

		function self.ACTIONattackBase(i)
			local hero = self[i]

			hero.unitAttacking = GroupPickRandomUnit(udg_UNIT_Bases[hero.teamNumber])

			local unitX = GetUnitX(hero.unitAttacking)
			local unitY = GetUnitY(hero.unitAttacking)

			IssuePointOrder(hero.unit, "attack", unitX, unitY)

		end
		
		return self
	end

end


function InitTrig_AI_Spell_Start()
	local t = CreateTrigger()
	TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_CAST)

	print(CountUnitsInGroup(mapAI.heroGroup))

	TriggerAddCondition(t, Condition( function()
		IsUnitInGroup(GetTriggerUnit(), mapAI.heroGroup)
	end))
	
	TriggerAddAction(t, function()
		local hero = self[GetUnitUserData(GetTriggerUnit())]
		hero.casting = true
		hero.order = OrderId2String(GetUnitCurrentOrder(hero.unit))
		print("Spell Cast")
	end)
end


function InitTrig_Hero_Level_Up()
	local t = CreateTrigger()
	
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_HERO_LEVEL)
	TriggerAddAction(t, function()

		-- Get Locals
		local heroLevel = GetHeroLevel(GetLevelingUnit())
		local u = GetLevelingUnit()
		local uType = GetUnitTypeId(u)

		-- Remove Ability Points
		if (heroLevel < 15 and ModuloInteger(heroLevel, 2) ~= 0) then
			ModifyHeroSkillPoints(GetLevelingUnit(), bj_MODIFYMETHOD_SUB, 1)
		elseif (heroLevel < 25 and heroLevel >= 15 and ModuloInteger(heroLevel, 3) ~= 0) then
			ModifyHeroSkillPoints(GetLevelingUnit(), bj_MODIFYMETHOD_SUB, 1)
		elseif (heroLevel >= 25 and ModuloInteger(heroLevel, 4) ~= 0) then
			ModifyHeroSkillPoints(GetLevelingUnit(), bj_MODIFYMETHOD_SUB, 1)
		end


		-- If Computer, Learn Abilities
		if GetPlayerController( GetOwningPlayer(u) ) == MAP_CONTROL_COMPUTER then

			if uType == FourCC("H00R") then      -- Mana Addict
				SelectHeroSkill(u, FourCC("A015"))  -- Starfall
				SelectHeroSkill(u, FourCC("A001"))  -- Mana Shield
				SelectHeroSkill(u, FourCC("A03S"))  -- Frost Nova
				SelectHeroSkill(u, FourCC("A018"))  -- Mana Overload
				SelectHeroSkill(u, FourCC("A02B"))  -- Mana Burst
				
			elseif uType == FourCC("E001") then  -- Brawler
				SelectHeroSkill(u, FourCC("A029"))  -- Unleash Rage
				SelectHeroSkill(u, FourCC("A01Y"))  -- Drain
				SelectHeroSkill(u, FourCC("A007"))  -- Bloodlust
				SelectHeroSkill(u, FourCC("A002"))  -- War Stomp
				
			elseif uType == FourCC("E002") then  -- Shifter
				SelectHeroSkill(u, FourCC("A03C"))  -- Shifting Bladestorm
				SelectHeroSkill(u, FourCC("A02Y"))  -- Fel Form
				SelectHeroSkill(u, FourCC("A03U"))  -- Shift Back
				SelectHeroSkill(u, FourCC("A030"))  -- Shift Forwards
				SelectHeroSkill(u, FourCC("A03T"))  -- Falling Strike
				
			elseif uType == FourCC("H009") then  -- Tactition
				SelectHeroSkill(u, FourCC("A042"))  -- Inspire
				SelectHeroSkill(u, FourCC("A01I"))  -- Raise Banner
				SelectHeroSkill(u, FourCC("A01B"))  -- Attack
				SelectHeroSkill(u, FourCC("A01Z"))  -- Bolster
				SelectHeroSkill(u, FourCC("A019"))  -- Iron Defense
				
			elseif uType == FourCC("H00J") then  -- Time Mage
				SelectHeroSkill(u, FourCC("A04N"))  -- Paradox
				SelectHeroSkill(u, FourCC("A04I"))  -- Dimensional Phase
				SelectHeroSkill(u, FourCC("A04P"))  -- Time Travel
				SelectHeroSkill(u, FourCC("A04K"))  -- Chrono Atrophy
				SelectHeroSkill(u, FourCC("A032"))  -- Decay
			end
		end
	end )
end