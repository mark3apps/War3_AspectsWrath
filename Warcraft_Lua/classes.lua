--
-- Location Class
-----------------
function init_locationClass()

    loc_Class = {}

    loc_Class.new = function()
        local self = {}
        self.regions = {}

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

            self[name].direction = direction
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
        self.heroOptions = {"heroA", "heroB", "heroC", "heroD", "heroE", "heroF", "heroG", "heroH", "heroI", "heroJ",
                            "heroK", "heroL"}
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
            self[i].strat = "defensive"
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
                            self[i].powerFriend = self[i].powerFriend +
                                                      (unitPower * (unitLife / 100.00) * unitPowerRangeMultiplier)
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
                            self[i].powerEnemy = self[i].powerEnemy +
                                                     (unitPower * (unitLife / 100.00) * unitPowerRangeMultiplier)
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
                                if clumpUnit == nil then
                                    break
                                end

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

                            if powerAllyNumTemp > self[i].clumpFriendNumber then
                                self[i].clumpFriendNumber = powerAllyNumTemp
                            end

                            if powerEnemyNumTemp > self[i].clumpEnemyNumber then
                                self[i].clumpEnemyNumber = powerEnemyNumTemp
                            end

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

                self[i].clumpBothNumber = self[i].clumpFriendNumber + self[i].clumpEnemyNumber
                self[i].percentLifeSingle = self[i].lifeHistory[#self[i].lifeHistory - 1] -
                                                self[i].lifeHistory[#self[i].lifeHistory]
                self[i].percentLifeAverage = self[i].lifeHistory[1] - self[i].lifeHistory[#self[i].lifeHistory]

                -- Figure out the Heroes Weighted Life
                self[i].weightedLife = (self[i].life * self[i].healthFactor) + (self[i].mana * self[i].manaFactor)
                self[i].weightedLifeMax = (self[i].lifeMax * self[i].healthFactor) +
                                              (self[i].manaMax * self[i].manaFactor)
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
            if (self[i].currentOrder ~= "move" and (self[i].lowLife or self[i].fleeing)) then
                self:ACTIONtravelToHeal(i)
            end

            if (self[i].currentOrder ~= "attack" and self[i].currentOrder ~= "move" and self[i].lowLife == false and
                self[i].casting == false) then

                self:ACTIONtravelToDest(i)
            end
        end

        -- AI Run Specifics
        function self:STATEAbilities(i)
            local heroName = self[i].name

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

        function self:STATEDefend(i)
            if self[i].alive and not self[i].lowLife and not self[i].fleeing and not self[i].casting and
                not self[i].defending then
                local baseCountDanger = CountUnitsInGroup(base[self[i].teamName].gDanger)
                if baseCountDanger > 0 then
                    local u, id, defend, unitCount, danger, selectedId, distanceToBase
                    local g = CreateGroup()

                    GroupAddGroup(base[self[i].teamName].gDanger, g)
                    local danger = 0
                    local selectedId = nil
                    while true do
                        u = FirstOfGroup(g)
                        if u == nil then
                            break
                        end

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
                        distanceToBase = distance(self[i].x, self[i].y, base[id].x, base[id].y)

                        if distanceToBase > 3500 then
                            self[i].defendingFast = true
                        end

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
                    local distanceToBase = distance(self[i].x, self[i].y, base[id].x, base[id].y)
                    local teleportCooldown = BlzGetUnitAbilityCooldownRemaining(self[i].unit,
                                                 hero.item.teleportation.abilityId)

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
            if self[i].alive == true and self[i].lowLife == true and self[i].weightedLifePercent >
                self[i].lifeHighPercent then
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
            if (self[i].powerHero < self[i].powerCount or self[i].percentLifeSingle > self[i].highDamageSingle or
                self[i].percentLifeAverage > self[i].highDamageAverage) and self[i].lowLife == false and self[i].fleeing ==
                false then
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
            if self[i].powerHero > self[i].powerCount and self[i].percentLifeSingle <= 0.0 and
                self[i].percentLifeAverage <= self[i].highDamageAverage and self[i].lowLife == false and self[i].fleeing ==
                true then
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

                        if danger then
                            self[i].castingDanger = true
                        end

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
                    if not self:teleportCheck(i, unitX, unitY) then
                        IssuePointOrder(self[i].unit, "attack", unitX, unitY)
                    end
                end
            end

        end

        function self:ACTIONattackBase(i)

            if not self[i].casting then
                local regionAdvantage = 0
                local regions = {"top", "middle", "bottom"}
                local regionsPick = {}
                local baseAdvantage

                if self[i].strat == "agressive" then
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

                    if #regionsPick > 1 then
                        self[i].regionAttacking = regionsPick[GetRandomInt(1, #regionsPick)]
                    end

                end

                self[i].unitAttacking = GroupPickRandomUnit(base[self[i].regionAttacking][self[i].teamNameEnemy].g)

                local unitX = GetUnitX(self[i].unitAttacking)
                local unitY = GetUnitY(self[i].unitAttacking)
                print("Attacking: " .. self[i].regionAttacking .. " Base: " .. GetUnitName(self[i].unitAttacking))

                if not self:teleportCheck(i, unitX, unitY) then
                    IssuePointOrder(self[i].unit, "attack", unitX, unitY)
                end
            end
        end

        function self:getHeroData(unit)
            return self[indexer:get(unit).heroName]
        end

        -- Teleport Stuff
        function self:teleportCheck(i, destX, destY)
            local destDistance = 100000000.00
            local destDistanceNew = 0.00
            local unitX, unitY, u
            local teleportUnit
            local g = CreateGroup()
            local heroUnit = self[i].unit

            local distanceOrig = distance(self[i].x, self[i].y, destX, destY)
            local teleportCooldown = BlzGetUnitAbilityCooldownRemaining(heroUnit, hero.item.teleportation.abilityId)

            if teleportCooldown == 0 and UnitHasItemOfTypeBJ(heroUnit, hero.item.teleportation.id) then

                
                GroupAddGroup(base[self[i].teamName].gTeleport, g)
                while true do
                    u = FirstOfGroup(g)
                    if u == nil then
                        break
                    end

                    unitX = GetUnitX(u)
                    unitY = GetUnitY(u)
                    destDistanceNew = distance(destX, destY, unitX, unitY)

                    if destDistanceNew < destDistance then
                        destDistance = destDistanceNew
                        teleportUnit = u
                    end

                    GroupRemoveUnit(g, u)
                end
                DestroyGroup(g)

                if distanceOrig - 2000 > destDistanceNew then

                    print("Teleporting")

                    PingMinimap(unitX, unitY, 15)
                    
                    UnitUseItemTarget(heroUnit, GetItemOfTypeFromUnitBJ(heroUnit, hero.item.teleportation.id),
                        teleportUnit)

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
            local curSpell

            --  Always Cast
            -------

            -- Mana Shield
            if self[i].casting then
                return false
            end

            curSpell = hero:spell(self[i], "manaShield")
            if curSpell.castable == true and curSpell.hasBuff == false then
                print(curSpell.name)
                IssueImmediateOrder(self[i].unit, curSpell.order)
                self:castSpell(i, curSpell)
                return true
            end

            --  Cast available all the time
            -------
            -- Mana Drain
            curSpell = hero:spell(self[i], "manaOverload")
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
                curSpell = hero:spell(self[i], "frostNova")
                if self[i].clumpEnemyPower >= 40 and curSpell.castable == true and curSpell.manaLeft > 80 then
                    print(curSpell.name)
                    IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].clumpEnemy),
                        GetUnitY(self[i].clumpEnemy))
                    self:castSpell(i, curSpell)
                    return true
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

            if not self[i].casting then

                -- Custom Intel
                local g = CreateGroup()
                local gIllusions = CreateGroup()
                local u, uTemp, unitsNearby
                local illusionsNearby = 0

                -- Find all Nearby Illusions
                GroupEnumUnitsInRange(g, self[i].x, self[i].y, 600.00, nil)

                GroupAddGroup(g, gIllusions)
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

                if self[i].fleeing or self[i].lowLife then

                    -- Check if there are illusions Nearby
                    if illusionsNearby > 0 then
                        curSpell = hero:spell(self[i], "switch")
                        if curSpell.castable and curSpell.manaLeft > 0 and not self[i].casting then
                            print(curSpell.name)

                            u = GroupPickRandomUnit(gIllusions)
                            GroupEnumUnitsInRange(gUnits, GetUnitX(u), GetUnitY(u), 350, nil)
                            unitsNearby = 0
                            while true do
                                uTemp = FirstOfGroup(g)
                                if (uTemp == nil) then
                                    break
                                end

                                if not IsUnitAlly(uTemp, GetOwningPlayer(self[i].unit)) then
                                    unitsNearby = unitsNearby + 1
                                end

                                GroupRemoveUnit(g, uTemp)
                            end
                            DestroyGroup(g)

                            if unitsNearby < self[i].countUnitEnemyClose then
                                IssuePointOrderById(self[i].unit, oid.reveal, GetUnitX(u), GetUnitY(u))
                            end
                        end
                    end

                    curSpell = hero:spell(self[i], "shift")
                    if curSpell.castable == true and curSpell.manaLeft > 0 then
                        print(curSpell.name)
                        IssueImmediateOrder(self[i].unit, curSpell.order)
                        self:castSpell(i, curSpell)
                    end
                end

                -- Normal Cast Spells
                if self[i].casting == false and self[i].lowLife == false and self[i].fleeing == false then

                    -- Shift
                    curSpell = hero:spell(self[i], "shift")
                    if self[i].countUnitEnemyClose >= 2 and curSpell.castable == true and curSpell.manaLeft > 45 then
                        print(curSpell.name)
                       
                        IssueImmediateOrder(self[i].unit, curSpell.order)
                        self:castSpell(i, curSpell)
                    end

                    -- Falling Strike
                    curSpell = hero:spell(self[i], "fallingStrike")
                    if (self[i].powerEnemy > 250.00 or self[i].clumpEnemyPower > 80.00) and curSpell.castable == true and
                        curSpell.manaLeft > 45 then
                        print(curSpell.name)

                        if self[i].powerEnemy > 250.00 then
                            IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].unitPowerEnemy),
                                GetUnitY(self[i].unitPowerEnemy))
                        else
                            IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].clumpEnemy),
                                GetUnitY(self[i].clumpEnemy))
                        end

                        self:castSpell(i, curSpell)
                    end

                    -- Shift Storm
                    curSpell = hero:spell(self[i], "shiftStorm")
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
            local curSpell, u

            -- Iron Defense
            curSpell = hero:spell(self[i], "ironDefense")
            if self[i].countUnitEnemy >= 2 and curSpell.castable == true and curSpell.manaLeft > 20 and
                self[i].lifePercent < 80 and not self[i].casting then
                print(curSpell.name)
                IssueImmediateOrder(self[i].unit, curSpell.order)
                self:castSpell(i, curSpell)
            end

            if not self[i].fleeing and not self[i].lowLife then
                -- Bolster
                curSpell = hero:spell(self[i], "bolster")
                if self[i].countUnitFriendClose >= 1 and curSpell.castable == true and curSpell.manaLeft > 50 and
                    not self[i].casting then
                    print(curSpell.name)
                    IssueImmediateOrder(self[i].unit, curSpell.order)
                    self:castSpell(i, curSpell)
                end

                -- Attack!
                curSpell = hero:spell(self[i], "attack")
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
            if self[i].casting then
                return
            end

            local curSpell, x, y, u

            if not self[i].fleeing and not self[i].lowLife then

                -- chrono Atrophy
                curSpell = hero:spell(self[i], "chronoAtrophy")
                if self[i].clumpBothNumber >= 7 and curSpell.castable and curSpell.manaLeft > 30 then
                    print(curSpell.name)

                    x = GetUnitX(self[i].clumpBoth)
                    y = GetUnitY(self[i].clumpBoth)
                    IssuePointOrder(self[i].unit, curSpell.order, x, y)
                    self:castSpell(i, curSpell)
                    return
                end

                -- Decay
                curSpell = hero:spell(self[i], "decay")
                if CountUnitsInGroup(self[i].heroesEnemies) > 0 and curSpell.castable == true and curSpell.manaLeft > 20 then
                    print(curSpell.name)

                    u = GroupPickRandomUnit(self[i].heroesEnemies)
                    IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(u), GetUnitY(u))
                    self:castSpell(i, curSpell)
                    return
                end

                -- Time Travel
                curSpell = hero:spell(self[i], "timeTravel")
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
-- Hero Skills / Abilities Class
-----------------
function init_heroClass()
    -- Create Class Definition
    hero_Class = {}

    -- Define new() function
    hero_Class.new = function()
        local self = {}

        self.players = {}
        for i = 1, 12 do
            self.players[i] = {
                picked = false
            }
        end

        self.items = {"teleportation", "tank"}
        self.item = {}

        self.item.teleportation = {
            name = "teleportation",
            properName = "Teleport",
            four = "I000",
            id = FourCC("I000"),
            abilityFour = "A01M",
            abilityId = FourCC("A01M"),
            order = "",
            instant = false,
            castTime = {6}
        }

        self.item.tank = {
            name = "tank",
            properName = "Tank",
            four = "I005",
            id = FourCC("I005"),
            order = "",
            instant = true
        }

        self.item.mage = {
            name = "mage",
            properName = "Mage",
            four = "I006",
            id = FourCC("I006"),
            order = "",
            instant = true
        }

        self.item[self.item.teleportation.id] = self.item[self.item.teleportation.name]
        self.item[self.item.tank.id] = self.item[self.item.tank.name]
        self.item[self.item.mage.id] = self.item[self.item.mage.name]

        self.heroes = {"brawler", "manaAddict", "shiftMaster", "tactition", "timeMage"}

        self.E001 = "brawler"
        self.brawler = {}
        self.brawler.four = "E001"
        self.brawler.fourAlter = "h00I"
        self.brawler.id = FourCC(self.brawler.four)
        self.brawler.idAlter = FourCC(self.brawler.fourAlter)
        self.brawler.spellLearnOrder = {"unleashRage", "drain", "warstomp", "bloodlust"}
        self.brawler.startingSpells = {}
        self.brawler.permanentSpells = {}
        self.brawler.startingItems = {"teleportation", "tank"}
        self.drain = {
            name = "drain",
            properName = "Drain",
            four = "A01Y",
            id = FourCC("A01Y"),
            buff = 0,
            order = "stomp",
            ult = false,
            instant = false,
            castTime = {6, 6, 6, 6, 6, 6}
        }
        self.bloodlust = {
            name = "bloodlust",
            properName = "Bloodlust",
            four = "A007",
            id = FourCC("A007"),
            buff = 0,
            order = "stomp",
            ult = false,
            instant = true
        }
        self.warstomp = {
            name = "warstomp",
            properName = "War Stomp",
            four = "A002",
            id = FourCC("A002"),
            buff = 0,
            order = "stomp",
            ult = false,
            instant = true
        }
        self.unleashRage = {
            name = "unleashRage",
            properName = "Unleassh Rage",
            four = "A029",
            id = FourCC("A029"),
            buff = 0,
            order = "stomp",
            ult = true,
            instant = false,
            castTime = {6, 6, 6, 6, 6, 6}
        }

        self[self.drain.four] = self.drain.name
        self[self.bloodlust.four] = self.bloodlust.name
        self[self.warstomp.four] = self.warstomp.name
        self[self.unleashRage.four] = self.unleashRage.name

        self.H009 = "tactition"
        self.tactition = {}
        self.tactition.four = "H009"
        self.tactition.fourAlter = "h00Y"
        self.tactition.id = FourCC(self.tactition.four)
        self.tactition.idAlter = FourCC(self.tactition.fourAlter)
        self.tactition.spellLearnOrder = {"inspire", "raiseBanner", "ironDefense", "bolster", "attack"}
        self.tactition.startingSpells = {"raiseBanner"}
        self.tactition.permanentSpells = {}
        self.tactition.startingItems = {"teleportation", "tank"}
        self.ironDefense = {
            name = "ironDefense",
            properName = "Iron Defense",
            four = "A019",
            id = FourCC("A019"),
            buff = 0,
            order = "roar",
            ult = false,
            instant = true
        }
        self.raiseBanner = {
            name = "raiseBanner",
            properName = "Raise Banner",
            four = "A01I",
            id = FourCC("A01I"),
            buff = 0,
            order = "healingward",
            ult = false,
            instant = true
        }
        self.attack = {
            name = "attack",
            properName = "Attack!",
            four = "A01B",
            id = FourCC("A01B"),
            buff = 0,
            order = "fingerofdeath",
            ult = false,
            instant = true
        }
        self.bolster = {
            name = "bolster",
            properName = "Bolster",
            four = "A01Z",
            id = FourCC("A01Z"),
            buff = 0,
            order = "tranquility",
            ult = false,
            instant = true
        }
        self.inspire = {
            name = "inspire",
            properName = "Inspire",
            four = "A042",
            id = FourCC("A042"),
            buff = 0,
            order = "channel",
            ult = true,
            instant = true
        }

        self[self.ironDefense.four] = self.ironDefense.name
        self[self.raiseBanner.four] = self.raiseBanner.name
        self[self.attack.four] = self.attack.name
        self[self.bolster.four] = self.bolster.name
        self[self.inspire.four] = self.inspire.name

        self.E002 = "shiftMaster"
        self.shiftMaster = {}
        self.shiftMaster.four = "E002"
        self.shiftMaster.fourAlter = "h00Q"
        self.shiftMaster.id = FourCC(self.shiftMaster.four)
        self.shiftMaster.idAlter = FourCC(self.shiftMaster.fourAlter)
        self.shiftMaster.spellLearnOrder = {"shiftStorm", "felForm", "switch", "fallingStrike", "shift"}
        self.shiftMaster.startingSpells = {"shift"}
        self.shiftMaster.permanentSpells = {"felForm", "fallingStrike", "shadeStrength", "swiftMoves", "swiftAttacks",
                                            "attributeStiftMaster"}
        self.shiftMaster.startingItems = {"teleportation", "tank"}
        self.attributeStiftMaster = {
            name = "attributeStiftMaster",
            properName = "Attribute Bonus",
            four = "A031",
            id = FourCC("A031"),
            buff = 0,
            order = "",
            ult = false
        }
        self.shadeStrength = {
            name = "shadeStrength",
            properName = "Shade Strength",
            four = "A037",
            id = FourCC("A037"),
            buff = 0,
            order = "",
            ult = false
        }
        self.swiftMoves = {
            name = "swiftMoves",
            properName = "Swift Moves",
            four = "A056",
            id = FourCC("A056"),
            buff = 0,
            order = "",
            ult = false
        }
        self.swiftAttacks = {
            name = "swiftAttacks",
            properName = "Swift Attacks",
            four = "A030",
            id = FourCC("A030"),
            buff = 0,
            order = "",
            ult = false
        }

        self.switch = {
            name = "switch",
            properName = "Switch",
            four = "A03U",
            id = FourCC("A03U"),
            buff = 0,
            order = "reveal",
            ult = false,
            instant = true
        }

        self.shift = {
            name = "shift",
            properName = "Shift",
            four = "A03T",
            id = FourCC("A03T"),
            buff = 0,
            order = "berserk",
            ult = false,
            instant = true
        }

        self.fallingStrike = {
            name = "fallingStrike",
            properName = "Falling Strike",
            four = "A059",
            id = FourCC("A059"),
            buff = 0,
            order = "thunderbolt",
            ult = false,
            instant = false,
            castTime = {1.5, 1.5, 1.5, 1.5, 1.5, 1.5}
        }

        self.shiftStorm = {
            name = "shiftStorm",
            properName = "Shift Storm",
            four = "A03C",
            id = FourCC("A03C"),
            buff = 0,
            order = "channel",
            ult = true,
            instant = true
        }

        self.felForm = {
            name = "felForm",
            properName = "Fel Form",
            four = "A02Y",
            id = FourCC("A02Y"),
            buff = 0,
            order = "metamorphosis",
            ult = true,
            instant = true
        }

        self[self.switch.four] = self.switch.name
        self[self.shift.four] = self.shift.name
        self[self.fallingStrike.four] = self.fallingStrike.name
        self[self.shiftStorm.four] = self.shiftStorm.name
        self[self.felForm.four] = self.felForm.name

        self.H00R = "manaAddict"
        self.manaAddict = {}
        self.manaAddict.four = "H00R"
        self.manaAddict.fourAlter = "h00B"
        self.manaAddict.id = FourCC(self.manaAddict.four)
        self.manaAddict.idAlter = FourCC(self.manaAddict.fourAlter)
        self.manaAddict.spellLearnOrder = {"starfall", "manaShield", "frostNova", "manaOverload", "manaBurst"}
        self.manaAddict.startingSpells = {"manaShield"}
        self.manaAddict.permanentSpells = {}
        self.manaAddict.startingItems = {"teleportation", "mage"}
        self.manaShield = {
            name = "manaShield",
            properName = "Mana Shield",
            four = "A001",
            id = FourCC("A001"),
            buff = FourCC("BNms"),
            order = "manashieldon",
            ult = false,
            instant = true
        }
        self.frostNova = {
            name = "frostNova",
            properName = "Frost Nova",
            four = "A03S",
            id = FourCC("A03S"),
            buff = 0,
            order = "flamestrike",
            ult = false,
            instant = true
        }
        self.manaOverload = {
            name = "manaOverload",
            properName = "Mana Overload",
            four = "A018",
            id = FourCC("A018"),
            buff = 0,
            order = "manashield",
            ult = false,
            instant = true
        }
        self.manaBurst = {
            name = "manaBurst",
            properName = "Mana Burst",
            four = "A02B",
            id = FourCC("A02B"),
            buff = 0,
            order = "custerrockets",
            ult = false,
            instant = false,
            castTime = {4, 4, 4, 4, 4, 4}
        }
        self.starfall = {
            name = "starfall",
            properName = "Starfall",
            four = "A015",
            id = FourCC("A015"),
            buff = 0,
            order = "starfall",
            ult = true,
            instant = false,
            castTime = {15, 15, 15, 15, 15, 15}
        }

        self[self.manaShield.four] = self.manaShield.name
        self[self.frostNova.four] = self.frostNova.name
        self[self.manaOverload.four] = self.manaOverload.name
        self[self.manaBurst.four] = self.manaBurst.name
        self[self.starfall.four] = self.starfall.name

        self.H00J = "timeMage"
        self.timeMage = {}
        self.timeMage.four = "H00J"
        self.timeMage.fourAlter = "h00Z"
        self.timeMage.id = FourCC(self.timeMage.four)
        self.timeMage.idAlter = FourCC(self.timeMage.fourAlter)
        self.timeMage.spellLearnOrder = {"paradox", "timeTravel", "chronoAtrophy", "decay"}
        self.timeMage.startingSpells = {}
        self.timeMage.permanentSpells = {}
        self.timeMage.startingItems = {"teleportation", "mage"}
        self.chronoAtrophy = {
            name = "chronoAtrophy",
            properName = "Chrono Atrophy",
            four = "A04K",
            id = FourCC("A04K"),
            buff = 0,
            order = "flamestrike",
            ult = false,
            instant = true
        }
        self.decay = {
            name = "decay",
            properName = "Decay",
            four = "A032",
            id = FourCC("A032"),
            buff = 0,
            order = "shadowstrike",
            ult = false,
            instant = true
        }
        self.timeTravel = {
            name = "timeTravel",
            properName = "Time Travel",
            four = "A04P",
            id = FourCC("A04P"),
            buff = 0,
            order = "clusterrockets",
            ult = false,
            instant = true
        }
        self.paradox = {
            name = "paradox",
            properName = "Paradox",
            four = "A04N",
            id = FourCC("A04N"),
            buff = 0,
            order = "tranquility",
            ult = true,
            instant = false,
            castTime = {10, 10, 10}
        }

        self[self.chronoAtrophy.four] = self.chronoAtrophy.name
        self[self.decay.four] = self.decay.name
        self[self.timeTravel.four] = self.timeTravel.name
        self[self.paradox.four] = self.paradox.name

        function self:spell(heroUnit, spellName)
            local spellDetails = self[spellName]
            spellDetails.level = self:level(heroUnit, spellName)
            spellDetails.cooldown = self:cooldown(heroUnit, spellName)
            spellDetails.hasBuff = self:hasBuff(heroUnit, spellName)
            spellDetails.mana = self:mana(heroUnit, spellName, spellDetails.level)
            spellDetails.manaLeft = heroUnit.mana - spellDetails.mana

            if spellDetails.level > 0 and spellDetails.cooldown == 0 and spellDetails.manaLeft >= 0 then
                spellDetails.castable = true
            else
                spellDetails.castable = false
            end

            -- print(spellName .. " : " .. spellDetails.level)
            -- print("Castable: " .. tostring(spellDetails.castable))

            return spellDetails
        end

        function self:level(heroUnit, spellName)
            return GetUnitAbilityLevel(heroUnit.unit, self[spellName].id)
        end

        function self:cooldown(heroUnit, spellName)
            return BlzGetUnitAbilityCooldownRemaining(heroUnit.unit, self[spellName].id)
        end

        function self:mana(heroUnit, spellName, level)
            return BlzGetUnitAbilityManaCost(heroUnit.unit, self[spellName].id, level)
        end

        function self:hasBuff(heroUnit, spellName)
            if self[spellName].buff == 0 then
                return false
            else
                return UnitHasBuffBJ(heroUnit.unit, self[spellName].buff)
            end
        end

        function self:levelUp(unit)
            local heroFour = CC2Four(GetUnitTypeId(unit))
            local heroName = self[heroFour]
            local heroLevel = GetHeroLevel(unit)
            local heroPlayer = GetOwningPlayer(unit)
            local spells = self[heroName]

            AdjustPlayerStateBJ(50, heroPlayer, PLAYER_STATE_RESOURCE_LUMBER)

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
                        SelectHeroSkill(unit, self[spells.spellLearnOrder[i]].id)

                        if GetHeroSkillPoints(unit) == 0 then
                            return
                        end
                    end
                end
            end
        end

        function self:setupHero(unit)
            local heroFour = CC2Four(GetUnitTypeId(unit))
            local heroName = self[heroFour]
            local player = GetOwningPlayer(unit)
            local playerNumber = GetConvertedPlayerId(player)
            local heroLevel = GetHeroLevel(unit)
            local spells = self[heroName]
            local picked, u, x, y, newAlter
            local g = CreateGroup()

            self.players[playerNumber] = {}

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
                picked = self[spells.startingSpells[i]]

                -- Have the hero learn the spell
                SelectHeroSkill(unit, picked.id)
            end

            -- Add the Permanent Spells for the Hero
            for i = 1, #spells.permanentSpells do
                picked = self[spells.permanentSpells[i]]

                -- Make the Spell Permanent
                UnitMakeAbilityPermanent(unit, true, picked.id)
            end

            -- Give the Hero starting Items
            for i = 1, #spells.startingItems do
                picked = self.item[spells.startingItems[i]]

                -- Make the Spell Permanent
                UnitAddItemById(unit, picked.id)
            end

            -- Set up Alter
            g = GetUnitsOfPlayerAndTypeId(player, FourCC("halt"))
            while true do
                u = FirstOfGroup(g)
                if u == nil then
                    break
                end

                -- Replace Unit Alter
                ReplaceUnitBJ(u, self[heroName].idAlter, bj_UNIT_STATE_METHOD_MAXIMUM)
                newAlter = GetLastReplacedUnitBJ()
                GroupRemoveUnit(g, u)
            end
            DestroyGroup(g)

            self.players[playerNumber].picked = true
            self.players[playerNumber].cameraLock = false
            self.players[playerNumber].alter = newAlter
            self.players[playerNumber].hero = unit
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
                self.data[unitId] = {
                    xSpawn = x,
                    ySpawn = y,
                    order = order,
                    unit = unit,
                    sfx = {}
                }
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

                elseif RectContainsUnit(gg_rct_Big_Middle_Left, unit) or
                    RectContainsUnit(gg_rct_Big_Middle_Left_Center, unit) or
                    RectContainsUnit(gg_rct_Big_Middle_Right_Center, unit) or
                    RectContainsUnit(gg_rct_Big_Middle_Right, unit) then

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
        self.cycleInterval = 5.00
        self.baseInterval = 0.4
        self.waveInterval = 28.00

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

        function self:addBase(baseName, alliedStart, alliedEnd, alliedCondition, fedStart, fedEnd, fedCondition)
            -- Add all of the info the base and add the base name to the base list
            self[baseName] = {
                allied = {
                    startPoint = alliedStart,
                    endPoint = alliedEnd,
                    condition = alliedCondition
                },
                fed = {
                    startPoint = fedStart,
                    endPoint = fedEnd,
                    condition = fedCondition
                },
                destination = destination,
                units = {}
            }
            table.insert(self.bases, baseName)
            self.baseCount = self.baseCount + 1
        end

        function self:addUnit(baseName, unitType, numOfUnits, waves, levelStart, levelEnd)
            table.insert(self[baseName].units, {
                unitType = unitType,
                numOfUnits = numOfUnits,
                waves = waves,
                level = {levelStart, levelEnd}
            })
        end

        function self:unitCount()
            return #self[self.base].units
        end

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

                    if self.alliedBaseAlive then
                        for n = 1, self.numOfUnits do

                            xStart, yStart = loc:getRandomXY(self[self.base].allied.startPoint)
                            xDest, yDest = loc:getRandomXY(self[self.base].allied.endPoint)

                            spawnedUnit = CreateUnit(Player(GetRandomInt(18, 20)), FourCC(self.unitType), xStart,
                                              yStart, bj_UNIT_FACING)

                            indexer:add(spawnedUnit)
                            indexer:updateEnd(spawnedUnit, xDest, yDest)
                            indexer:order(spawnedUnit)

                        end
                    end

                    if self.fedBaseAlive then
                        for n = 1, self.numOfUnits do
                            xStart, yStart = loc:getRandomXY(self[self.base].fed.startPoint)
                            xDest, yDest = loc:getRandomXY(self[self.base].fed.endPoint)

                            spawnedUnit = CreateUnit(Player(GetRandomInt(21, 23)), FourCC(self.unitType), xStart,
                                              yStart, bj_UNIT_FACING)

                            indexer:add(spawnedUnit)
                            indexer:updateEnd(spawnedUnit, xDest, yDest)
                            indexer:order(spawnedUnit)
                        end
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

    base.all = {
        g = CreateGroup(),
        unitsTotal = 0,
        unitsAlive = 0
    }

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
        allied = {
            g = CreateGroup(),
            unitsTotal = 0,
            unitsAlive = 0,
            advantage = 0
        },
        federation = {
            g = CreateGroup(),
            unitsTotal = 0,
            unitsAlive = 0,
            advantage = 0
        }
    }
    base.middle = {
        allied = {
            g = CreateGroup(),
            unitsTotal = 0,
            unitsAlive = 0,
            advantage = 0
        },
        federation = {
            g = CreateGroup(),
            unitsTotal = 0,
            unitsAlive = 0,
            advantage = 0
        }
    }
    base.bottom = {
        allied = {
            g = CreateGroup(),
            unitsTotal = 0,
            unitsAlive = 0,
            advantage = 0
        },
        federation = {
            g = CreateGroup(),
            unitsTotal = 0,
            unitsAlive = 0,
            advantage = 0
        }
    }

    function base.add(unit, importance, mainBase, update, teleport)

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
            GroupAddUnit(base[teamName].gHealing, unit)

             -- Add to REGION Unit Group
            GroupAddUnit(base[regionName][teamName].g, unit)
        end

        -- Add to TELEPORT Unit Group
        if teleport then
            GroupAddUnit(base[teamName].gTeleport, unit)
        end

       
        

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

    function base.update(unit)
        local u, heroLevel

        local unitsFriendly = 0
        local unitsEnemy = 0
        local unitsCount = 0

        local handleId = GetHandleId(unit)

        if base[handleId].update == false then
            return true
        end

        local l = Location(base[handleId].x, base[handleId].y)
        local teamName = base[handleId].teamName

        local g = CreateGroup()
        g = GetUnitsInRangeOfLocAll(900, l)
        while true do
            u = FirstOfGroup(g)
            if u == nil then
                break
            end

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

        else
            if unitsEnemy > 0 then
                GroupAddUnit(base[teamName].gDanger, unit)
                GroupRemoveUnit(base[teamName].gHealing, unit)
            end
        end

        -- Heal Units as needed
        if unitsEnemy == 0 and unitsFriendly > 0 and base[handleId].mana > 50 then
            if IsUnitInGroup(unit, base[teamName].gHealing) and BlzGetUnitAbilityCooldownRemaining(unit, FourCC("A027")) ==
                0 then

                g = GetUnitsInRangeOfLocAll(500, l)

                while true do
                    u = FirstOfGroup(g)
                    if u == nil then
                        break
                    end

                    if IsUnitType(u, UNIT_TYPE_HERO) and IsUnitAlly(u, GetOwningPlayer(unit)) then
                        if not UnitHasBuffBJ(u, FourCC("Brej")) and
                            (GetUnitLifePercent(u) < 95 or GetUnitManaPercent(u) < 95) then
                            IssueTargetOrder(unit, "rejuvination", u)
                            break
                        end
                    end

                    GroupRemoveUnit(g, u)
                end

                DestroyGroup(g)
            end
        end
        RemoveLocation(l)

        base[handleId].lifePercent = GetUnitLifePercent(unit)
        base[handleId].mana = GetUnitState(unit, UNIT_STATE_MANA)
        base[handleId].unitsFriendly = unitsFriendly
        base[handleId].unitsEnemy = unitsEnemy
        base[handleId].unitsCount = unitsEnemy - unitsFriendly
        base[handleId].danger = base[handleId].unitsCount * (((100 - base[handleId].lifePercent) / 10) + 1) *
                                    base[handleId].importance

        -- print(base[handleId].name .. " Allies:" .. base[handleId].unitsFriendly .. " Enemies: " .. base[handleId].unitsEnemy)
    end

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
        if IsUnitInGroup(unit, base[regionName][teamName].g) then
        GroupRemoveUnit(base[regionName][teamName].g, unit)
        end

        if IsUnitInGroup(unit, base[teamName].gDanger) then
            GroupRemoveUnit(base[teamName].gDanger, unit)
        end

        if IsUnitInGroup(unit, base[teamName].gHealing) then
            GroupRemoveUnit(base[teamName].gDanger, unit)
        end

        -- Remove Unit from TELEPORT Group
        if teleport then
            GroupRemoveUnit(base[teamName].gTeleport, unit)
        end

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

            for i = 6, 11 do
                SetPlayerHandicapXPBJ(Player(i), GetPlayerHandicapXPBJ(Player(i)) + 10)
            end

            print("FEDERATION Base has Fallen!")
            u = CreateUnit(Player(20), FourCC("h00W"), x, y, bj_UNIT_FACING)

        else
            for i = 0, 5 do
                SetPlayerHandicapXPBJ(Player(i), GetPlayerHandicapXPBJ(Player(i)) + 10)
            end

            print("ALLIED Base has Fallen!")

            u = CreateUnit(Player(23), FourCC("h00W"), x, y, bj_UNIT_FACING)
        end

        print(name .. " has been razed.")
        PingMinimap(x, y, 15)
        base.add(u, 0, false, false, true)

    end

end
