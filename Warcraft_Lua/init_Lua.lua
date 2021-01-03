function init_Lua()
    debugPrint = 2

    -- Define Classes
    debugfunc(function()
        init_heroClass()
        init_spawnClass()
        init_aiClass()
    end, "Define Classes")
    dprint("Classes Defined", 2)

    -- Init Classes
    debugfunc(function()
        hero = hero_Class:new()
        ai = ai_Class:new()
        spawn = spawn_Class:new()
    end, "Init Classes")

    dprint("Classes Initialized", 2)

    -- Init Trigger
    debugfunc(function()
        initTrig_Auto_Zoom()
        Init_Hero_Levels_Up()
        Init_AI_Spell_Start()
        init_spawnTimer()
        init_creepUpgradeTimer()
    end, "Init Triggers")

    dprint("Triggers Initialized", 2)

    -- Spawn Base / Unit Setup
    -- Init Trigger
    debugfunc(function()
        spawnAddBases()
        spawnAddUnits()
    end, "Init Spawn")

    dprint("Spawn Setup", 2)

    -- Setup Delayed Init Triggers
    init_Delayed_1()
    init_Delayed_10()

    dprint("Init Finished")
end

-- Init Delayed Functions 1 second after Map Init
function init_Delayed_1()
    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 1)
    TriggerAddAction(t, function()
        debugfunc(function()
            ai:pickHeroes()
            dprint("pick Heroes Successfull", 2)
            ai:init_loopStates()
            dprint("AI Started", 2)
            spawn:startSpawn()
            dprint("Spawn Started", 2)
        end, "Start Delayed Triggers")
    end)
end

-- Init Delayed Functions 10 second after Map Init
function init_Delayed_10()
    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 10)
    TriggerAddAction(t, function()
        debugfunc(function()
            FogMaskEnableOn()
            FogEnableOn()

            -- Set up the Creep Event Timer
            StartTimerBJ(udg_EventTimer, false, 350.00)
        end, "Start Delayed Triggers")
    end)
end

--
-- Init Classes
--

-- Spawn Class
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
        self.waveInterval = 20.00

        self.creepLevel = 1
        self.creeplevelTimer = CreateTimer()

        self.wave = 1
        self.base = ""
        self.baseI = 0
        self.unitIndex = ""
        self.alliedBaseAlive = false
        self.fedBaseAlive = false
        self.unitInWave = false
        self.unitInLevel = true
        self.numOfUnits = 0
        self.unitType = ""

        function self:addBase(baseName, alliedStart, alliedEnd, alliedCondition, fedStart, fedEnd, fedCondition,
            destination)
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
            local waves = self[self.base].units[self.unitIndex].waves

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
            local levelStart = self[self.base].units[self.unitIndex].level[1]
            local levelEnd = self[self.base].units[self.unitIndex].level[2]

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
            self.numOfUnits = self[self.base].units[self.unitIndex].numOfUnits
            self.unitType = self[self.base].units[self.unitIndex].unitType
        end

        function self:spawnUnits()
            local pStart
            local pDest
            local spawnedUnit

            for i = 1, self:unitCount(self.base) do
                self.unitIndex = i
                self:checkSpawnUnit()

                if self.unitInWave and self.unitInLevel then

                    if self.alliedBaseAlive then
                        for n = 1, self.numOfUnits do
                            pStart = GetRandomLocInRect(self[self.base].allied.startPoint)
                            pDest = GetRandomLocInRect(self[self.base].allied.endPoint)
                            spawnedUnit = CreateUnitAtLoc(Player(GetRandomInt(18, 20)), FourCC(self.unitType), pStart,
                                              bj_UNIT_FACING)
                            SetUnitUserData(spawnedUnit, self[self.base].destination)
                            IssuePointOrderLoc(spawnedUnit, "attack", pDest)

                            RemoveLocation(pStart)
                            RemoveLocation(pDest)
                        end
                    end

                    if self.fedBaseAlive then
                        for n = 1, self.numOfUnits do
                            pStart = GetRandomLocInRect(self[self.base].fed.startPoint)
                            pDest = GetRandomLocInRect(self[self.base].fed.endPoint)
                            spawnedUnit = CreateUnitAtLoc(Player(GetRandomInt(21, 23)), FourCC(self.unitType), pStart,
                                              bj_UNIT_FACING)
                            SetUnitUserData(spawnedUnit, self[self.base].destination)
                            IssuePointOrderLoc(spawnedUnit, "attack", pDest)

                            RemoveLocation(pStart)
                            RemoveLocation(pDest)
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
            DisableTrigger(gg_trg_Creeps_keep_going_after_Order)
            self:spawnUnits()
            EnableTrigger(gg_trg_Creeps_keep_going_after_Order)
        end

        function self:upgradeCreeps()
            print("UPGRADE!")
            self.creepLevel = self.creepLevel + 1
            print("UPGRADE!")
            print("Creep Level: " .. self.creepLevel)

            if self.creepLevel >= 12 then
                DisableTrigger(self.Trig_upgradeCreeps)
            else
                StartTimerBJ(self.creepLevelTimer, false, (70 + (15 * self.creepLevel)))
            end
        end

        -- Start the Spawn Loop
        function self:startSpawn()
            -- Start Spawn Timer
            StartTimerBJ(self.timer, false, 1)
            StartTimerBJ(self.creepLevelTimer, false, 1)

        end

        --
        -- Class Triggers
        --

        return self
    end
end

function init_spawnTimer()
    -- Create Spawn Loop Trigger
	Trig_spawnLoop = CreateTrigger()
	TriggerRegisterTimerExpireEvent(Trig_spawnLoop, self.timer)
    TriggerAddAction(Trig_spawnLoop, function()
        debugfunc(function()
            spawn:loopSpawn()
        end, "spawn:loopSpawn")
    end)
end


function init_creepUpgradeTimer()
    -- Create Upgrade Trigger
	Trig_upgradeCreeps = CreateTrigger()
	TriggerRegisterTimerExpireEvent(Trig_upgradeCreeps, self.creepLevelTimer)
	TriggerAddAction(Trig_upgradeCreeps, function()
		print("Is this even working?")
        debugfunc(function()
            spawn:upgradeCreeps()
        end, "spawn:upgradeCreeps()")
    end)
end

-- AI Class
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

        -- AI Picks Hero
        function self:pickHeroes()
            local i = 1
            local randInt
            local count = 12
            local x
            local y
            local selPlayer
            local g
            local u

            while (i <= count) do
                selPlayer = ConvertedPlayer(i)
                if (GetPlayerController(selPlayer) == MAP_CONTROL_COMPUTER) then
                    if (i < 7) then
                        udg_INT_TeamNumber[i] = 1
                        x = GetRectCenterX(gg_rct_Left_Hero)
                        y = GetRectCenterY(gg_rct_Left_Hero)
                    else
                        udg_INT_TeamNumber[i] = 2
                        x = GetRectCenterX(gg_rct_Right_Hero)
                        y = GetRectCenterY(gg_rct_Right_Hero)
                    end

                    randInt = GetRandomInt(3, 3)
                    if (randInt == 1) then
                        udg_TEMP_Unit = CreateUnit(selPlayer, hero.brawler.id, x, y, 0)
                    elseif (randInt == 2) then
                        udg_TEMP_Unit = CreateUnit(selPlayer, hero.manaAddict.id, x, y, 0)
                    elseif (randInt == 3) then
                        udg_TEMP_Unit = CreateUnit(selPlayer, hero.shiftMaster.id, x, y, 0)
                    elseif (randInt == 4) then
                        udg_TEMP_Unit = CreateUnit(selPlayer, hero.tactition.id, x, y, 0)
                    elseif (randInt == 5) then
                        udg_TEMP_Unit = CreateUnit(selPlayer, hero.timeMage.id, x, y, 0)
                    end

                    UnitAddItemByIdSwapped(FourCC("I000"), udg_TEMP_Unit)
                    udg_UNIT_pickedHero[GetConvertedPlayerId(selPlayer)] = udg_TEMP_Unit
                    ConditionalTriggerExecute(gg_trg_Hero_Add_Starting_Abilities)

                    debugfunc(function()
                        self:initHero(udg_TEMP_Unit)
                    end, "Init Hero")

                    g = GetUnitsOfPlayerAndTypeId(selPlayer, FourCC("halt"))

                    while true do
                        u = FirstOfGroup(g)
                        if u == nil then
                            break
                        end

                        if (GetUnitTypeId(udg_TEMP_Unit) == hero.brawler.id) then
                            ReplaceUnitBJ(u, hero.brawler.idAlter, bj_UNIT_STATE_METHOD_RELATIVE)
                        elseif (GetUnitTypeId(udg_TEMP_Unit) == hero.manaAddict.id) then
                            ReplaceUnitBJ(u, hero.manaAddict.idAlter, bj_UNIT_STATE_METHOD_RELATIVE)
                        elseif (GetUnitTypeId(udg_TEMP_Unit) == hero.tactition.id) then
                            ReplaceUnitBJ(u, hero.tactition.idAlter, bj_UNIT_STATE_METHOD_RELATIVE)
                        elseif (GetUnitTypeId(udg_TEMP_Unit) == hero.timeMage.id) then
                            ReplaceUnitBJ(u, hero.timeMage.idAlter, bj_UNIT_STATE_METHOD_RELATIVE)
                        elseif (GetUnitTypeId(udg_TEMP_Unit) == hero.shiftMaster.id) then
                            ReplaceUnitBJ(u, hero.shiftMaster.idAlter, bj_UNIT_STATE_METHOD_RELATIVE)

                            UnitMakeAbilityPermanent(udg_TEMP_Unit, true, FourCC("A031"))
                            UnitMakeAbilityPermanent(udg_TEMP_Unit, true, FourCC("A005"))
                            UnitMakeAbilityPermanent(udg_TEMP_Unit, true, FourCC("A037"))
                        end

                        udg_Alters[GetConvertedPlayerId(selPlayer)] = GetLastReplacedUnitBJ()

                        GroupRemoveUnit(g, u)
                    end
                    DestroyGroup(g)
                end

                i = i + 1
            end
        end

        function self:loopStates() -- Start AI Loop
            if self.loop >= self.count then
                self.loop = 1
            else
                self.loop = self.loop + 1
            end

            print(" -- ")
            local i = self.heroOptions[self.loop]

            debugfunc(function()
                self:updateIntel(i)

                if self:isAlive(i) then
                    self:STATEDead(i)
                    self:STATELowHealth(i)
                    self:STATEStopFleeing(i)
                    self:STATEFleeing(i)
                    self:STATEHighHealth(i)
                    self:STATEcastingSpell(i)
                    self:STATEAbilities(i)
                    self:CleanUp(i)
                else
                    self:STATERevived(i)
                end
                print("Finished")
            end, "AI STATES")
        end

        function self:init_loopStates()
            if (self.count > 0) then
                self.trig_loopStates = CreateTrigger()
                TriggerRegisterTimerEvent(self.trig_loopStates, ai.tick, true)
                TriggerAddAction(self.trig_loopStates, ai:loopStates())
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

                -- print("Clump Enemy: " .. R2S(self[i].clumpEnemyPower))
                -- print("Clump Both: " .. R2S(self[i].clumpBothPower))
                print("Enemies Nearby: " .. self[i].countUnitEnemy)
                print("Power Clump Enemy: " .. self[i].powerEnemy)
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
                if self[i].castingDuration == -10.00 then
                    if self[i].currentOrder ~= self[i].order then
                        self[i].casting = false
                        self[i].castingDanger = false
                        -- print("Stopped Casting")
                        self:ACTIONtravelToDest(i)
                        self[i].order = self[i].currentOrder
                    else
                        -- print("Still Casting Spell")
                    end
                elseif self[i].castingDuration > 0.00 then
                    -- print("Still Casting Spell")
                    self[i].castingDuration = self[i].castingDuration - aiTick
                else
                    -- print("Stopped Casting (Count)")
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
                -- print("Spell Cast")
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
                    IssuePointOrder(self[i].unit, curSpell.order, GetUnitX(self[i].clumpEnemy),
                        GetUnitY(self[i].clumpEnemy))
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
                if BlzGetUnitAbilityCooldownRemaining(self[i].unit, ironDefense.spell) == 0.00 and (self[i].mana) >
                    I2R(BlzGetAbilityManaCost(ironDefense.spell, ironDefense.level)) and ironDefense.level > 0 and
                    self[i].lifePercent < 85 then
                    -- Bolster
                    IssueImmediateOrder(self[i].unit, ironDefense.id)
                    self:castSpell(i)
                elseif BlzGetUnitAbilityCooldownRemaining(self[i].unit, bolster.spell) == 0.00 and (self[i].mana + 20) >
                    I2R(BlzGetAbilityManaCost(bolster.spell, bolster.level)) and bolster.level > 0 and
                    self[i].countUnitFriend > 2 and self[i].countUnitEnemy > 2 then
                    -- Attack
                    IssueImmediateOrder(self[i].unit, bolster.id)
                    self:castSpell(i, 2)
                elseif BlzGetUnitAbilityCooldownRemaining(self[i].unit, attack.spell) == 0.00 and (self[i].mana) >
                    I2R(BlzGetAbilityManaCost(attack.spell, attack.level)) and attack.level > 0 and
                    self[i].clumpEnemyPower > 250 then
                    -- Inspire
                    IssueTargetOrder(self[i].unit, attack.string, self[i].unitPowerEnemy)
                    self:castSpell(i)
                elseif BlzGetUnitAbilityCooldownRemaining(self[i].unit, inspire.spell) == 0.00 and (self[i].mana) >
                    I2R(BlzGetAbilityManaCost(inspire.spell, inspire.level)) and inspire.level > 0 and
                    self[i].countUnitFriend > 5 and self[i].countUnitEnemy > 5 then
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

-- Hero Class

function init_heroClass()
    -- Create Class Definition
    hero_Class = {}

    -- Define new() function
    hero_Class.new = function()
        local self = {}

        self.E001 = "brawler"
        self.brawler = {}
        self.brawler.four = "E001"
        self.brawler.fourAlter = "h00I"
        self.brawler.id = FourCC(self.brawler.four)
        self.brawler.idAlter = FourCC(self.brawler.fourAlter)
        self.brawler.spellLearnOrder = {"unleashRage", "drain", "warstomp", "bloodlust"}
        self.brawler.drain = {
            name = "Drain",
            four = "A01Y",
            id = FourCC("A01Y"),
            buff = 0,
            order = "stomp",
            ult = false
        }
        self.brawler.bloodlust = {
            name = "Bloodlust",
            four = "A007",
            id = FourCC("A007"),
            buff = 0,
            order = "stomp",
            ult = false
        }
        self.brawler.warstomp = {
            name = "War Stomp",
            four = "A002",
            id = FourCC("A002"),
            buff = 0,
            order = "stomp",
            ult = false
        }
        self.brawler.unleashRage = {
            name = "Unleassh Rage",
            four = "A029",
            id = FourCC("A029"),
            buff = 0,
            order = "stomp",
            ult = true
        }

        self.H009 = "tactition"
        self.tactition = {}
        self.tactition.four = "H009"
        self.tactition.fourAlter = "h00Y"
        self.tactition.id = FourCC(self.tactition.four)
        self.tactition.idAlter = FourCC(self.tactition.fourAlter)
        self.tactition.spellLearnOrder = {"inspire", "raiseBanner", "ironDefense", "bolster", "attack"}
        self.tactition.ironDefense = {
            name = "Iron Defense",
            four = "A019",
            id = FourCC("A019"),
            buff = 0,
            order = "roar",
            ult = false
        }
        self.tactition.raiseBanner = {
            name = "Raise Banner",
            four = "A01I",
            id = FourCC("A01I"),
            buff = 0,
            order = "healingward",
            ult = false
        }
        self.tactition.attack = {
            name = "Attack!",
            four = "A01B",
            id = FourCC("A01B"),
            buff = 0,
            order = "fingerofdeath",
            ult = false
        }
        self.tactition.bolster = {
            name = "Bolster",
            four = "A01Z",
            id = FourCC("A01Z"),
            buff = 0,
            order = "tranquility",
            ult = false
        }
        self.tactition.inspire = {
            name = "Inspire",
            four = "A042",
            id = FourCC("A042"),
            buff = 0,
            order = "channel",
            ult = true
        }

        self.E002 = "shiftMaster"
        self.shiftMaster = {}
        self.shiftMaster.four = "E002"
        self.shiftMaster.fourAlter = "h00Q"
        self.shiftMaster.id = FourCC(self.shiftMaster.four)
        self.shiftMaster.idAlter = FourCC(self.shiftMaster.fourAlter)
        self.shiftMaster.spellLearnOrder = {"shiftStorm", "felForm", "shiftBack", "fallingStrike", "shiftForward"}
        self.shiftMaster.shiftBack = {
            name = "Shift Back",
            four = "A03U",
            id = FourCC("A03U"),
            buff = 0,
            order = "stomp",
            ult = false
        }
        self.shiftMaster.shiftForward = {
            name = "Shift Forward",
            four = "A030",
            id = FourCC("A030"),
            buff = 0,
            order = "thunderclap",
            ult = false
        }
        self.shiftMaster.fallingStrike = {
            name = "Falling Strike",
            four = "A03T",
            id = FourCC("A03T"),
            buff = 0,
            order = "clusterrockets",
            ult = false
        }
        self.shiftMaster.shiftStorm = {
            name = "Shift Storm",
            four = "A03C",
            id = FourCC("A03C"),
            buff = 0,
            order = "channel",
            ult = true
        }
        self.shiftMaster.felForm = {
            name = "Fel Form",
            four = "A02Y",
            id = FourCC("A02Y"),
            buff = 0,
            order = "metamorphosis",
            ult = true
        }

        self.H00R = "manaAddict"
        self.manaAddict = {}
        self.manaAddict.four = "H00R"
        self.manaAddict.fourAlter = "h00B"
        self.manaAddict.id = FourCC(self.manaAddict.four)
        self.manaAddict.idAlter = FourCC(self.manaAddict.fourAlter)
        self.manaAddict.spellLearnOrder = {"starfall", "manaShield", "frostNova", "manaOverload", "manaBurst"}
        self.manaAddict.manaShield = {
            name = "Mana Shield",
            four = "A001",
            id = FourCC("A001"),
            buff = FourCC("BNms"),
            order = "manashieldon",
            ult = false
        }
        self.manaAddict.frostNova = {
            name = "Frost Nova",
            four = "A03S",
            id = FourCC("A03S"),
            buff = 0,
            order = "flamestrike",
            ult = false
        }
        self.manaAddict.manaOverload = {
            name = "Mana Overload",
            four = "A018",
            id = FourCC("A018"),
            buff = 0,
            order = "manashield",
            ult = false
        }
        self.manaAddict.manaBurst = {
            name = "Mana Burst",
            four = "A02B",
            id = FourCC("A02B"),
            buff = 0,
            order = "custerrockets",
            ult = false
        }
        self.manaAddict.starfall = {
            name = "Starfall",
            four = "A015",
            id = FourCC("A015"),
            buff = 0,
            order = "starfall",
            ult = true
        }

        self.H00J = "timeMage"
        self.timeMage = {}
        self.timeMage.four = "H00J"
        self.timeMage.fourAlter = "h00Z"
        self.timeMage.id = FourCC(self.timeMage.four)
        self.timeMage.idAlter = FourCC(self.timeMage.fourAlter)
        self.timeMage.spellLearnOrder = {"paradox", "timeTravel", "chronoAtrophy", "decay"}
        self.timeMage.chronoAtrophy = {
            name = "Chrono Atrophy",
            four = "A04K",
            id = FourCC("A04K"),
            buff = 0,
            order = "flamestrike",
            ult = false
        }
        self.timeMage.decay = {
            name = "Decay",
            four = "A032",
            id = FourCC("A032"),
            buff = 0,
            order = "shadowstrike",
            ult = false
        }
        self.timeMage.timeTravel = {
            name = "Time Travel",
            four = "A04P",
            id = FourCC("A04P"),
            buff = 0,
            order = "clusterrockets",
            ult = false
        }
        self.timeMage.paradox = {
            name = "Paradox",
            four = "A04N",
            id = FourCC("A04N"),
            buff = 0,
            order = "tranquility",
            ult = true
        }

        function self:spell(heroUnit, spellName)
            local spellDetails = self[heroUnit.name][spellName]
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
            return GetUnitAbilityLevel(heroUnit.unit, self[heroUnit.name][spellName].id)
        end

        function self:cooldown(heroUnit, spellName)
            return BlzGetUnitAbilityCooldownRemaining(heroUnit.unit, self[heroUnit.name][spellName].id)
        end

        function self:mana(heroUnit, spellName, level)
            return BlzGetUnitAbilityManaCost(heroUnit.unit, self[heroUnit.name][spellName].id, level)
        end

        function self:hasBuff(heroUnit, spellName)
            if self[heroUnit.name][spellName].buff == 0 then
                return false
            else
                return UnitHasBuffBJ(heroUnit.unit, self[heroUnit.name][spellName].buff)
            end
        end

        function self.levelUp(unit)
            local heroFour = CC2Four(GetUnitTypeId(unit))
            local heroLevel = GetHeroLevel(unit)
            local spells = self[self[heroFour]]

            print(self[heroFour])

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
            if GetPlayerController(GetOwningPlayer(unit)) == MAP_CONTROL_COMPUTER then
                local unspentPoints = GetHeroSkillPoints(unit)

                print("Unspent Abilities: " .. unspentPoints)

                if unspentPoints > 0 then
                    for i = 1, #spells.spellLearnOrder do
                        print(spells.spellLearnOrder[i])
                        SelectHeroSkill(unit, spells[spells.spellLearnOrder[i]].id)

                        if GetHeroSkillPoints(unit) == 0 then
                            break
                        end
                    end
                end
            end
        end

        return self
    end
end

--
-- Functions
--

function dprint(message, level)
    level = level or 1

    if debugPrint >= level then
        print("|cff00ff00[debug " .. level .. "]|r " .. tostring(message))
    end
end

function distance(x1, y1, x2, y2) -- Find Distance between points
    return SquareRoot(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)))
end

function debugfunc(func, name) -- Turn on runtime logging
    local passed, data = pcall(function()
        func()
        return "func " .. name .. " passed"
    end)
    if not passed then
        print("|cffff0000[ERROR]|r" .. name, passed, data)
    end
    passed = nil
    data = nil
end

function CC2Four(num) -- Convert from Handle ID to Four Char
    return string.pack(">I4", num)
end

--
-- Triggers
--

-- AI Triggers

-- Spawn Set up
function spawnAddBases()
    -- addBase(baseName, alliedStart, alliedEnd, alliedCondition, fedStart, fedEnd, fedCondition, destination)

    spawn:addBase("arcane", gg_rct_Left_Arcane, gg_rct_Right_Start_Bottom, gg_unit_h003_0015, gg_rct_Right_Arcane,
        gg_rct_Left_Start_Top, gg_unit_h003_0007, 3)
    spawn:addBase("arcaneCreep", gg_rct_Left_Arcane, gg_rct_Left_Elemental_Start, gg_unit_h003_0015,
        gg_rct_Right_Arcane, gg_rct_Right_Elemental_Start, gg_unit_h003_0007, 7)
    spawn:addBase("arcaneHero", gg_rct_Arcane_Hero_Left, gg_rct_Right_Start_Bottom, gg_unit_hars_0017,
        gg_rct_Arcane_Hero_Right, gg_rct_Left_Start_Top, gg_unit_hars_0158, 3)
    spawn:addBase("arcaneTop", gg_rct_Arcane_Left_Top, gg_rct_Right_Start_Bottom, gg_unit_hars_0355,
        gg_rct_Arcane_Right_Top, gg_rct_Left_Start_Top, gg_unit_hars_0293, 3)
    spawn:addBase("arcaneBottom", gg_rct_Arcane_Left_Bottom, gg_rct_Right_Start_Bottom, gg_unit_hars_0292,
        gg_rct_Arcane_Right_Bottom, gg_rct_Left_Start_Top, gg_unit_hars_0303, 3)
    spawn:addBase("blacksmith", gg_rct_Blacksmith_Left, gg_rct_Right_Everything, gg_unit_n00K_0802,
        gg_rct_Blacksmith_Right, gg_rct_Left_Everything, gg_unit_n00K_0477, 2)
    spawn:addBase("blacksmithCreep", gg_rct_Blacksmith_Left, gg_rct_Zombie_End_Left, gg_unit_n00K_0802,
        gg_rct_Blacksmith_Right, gg_rct_Zombie_End_Right, gg_unit_n00K_0477, 10)
    spawn:addBase("castle", gg_rct_Left_Hero, gg_rct_Right_Everything, gg_unit_h00E_0033, gg_rct_Right_Hero,
        gg_rct_Left_Everything, gg_unit_h00E_0081, 2)
    spawn:addBase("cityElves", gg_rct_City_Elves_Left, gg_rct_Right_Everything, gg_unit_hvlt_0207,
        gg_rct_City_Elves_Right, gg_rct_Left_Everything, gg_unit_hvlt_0406, 2)
    spawn:addBase("cityFront", gg_rct_Front_Town_Left, gg_rct_Right_Everything, gg_unit_n00B_0364,
        gg_rct_Front_City_Right, gg_rct_Left_Everything, gg_unit_n00B_0399, 2)
    spawn:addBase("citySide", gg_rct_Left_City, gg_rct_Right_Everything, gg_unit_n00B_0102, gg_rct_Right_City,
        gg_rct_Left_Everything, gg_unit_n00B_0038, 2)
    spawn:addBase("kobold", gg_rct_Furbolg_Left, gg_rct_Right_Start_Top, gg_unit_ngt2_0525, gg_rct_Furbolg_Right,
        gg_rct_Left_Start_Bottom, gg_unit_ngt2_0455, 1)
    spawn:addBase("highElves", gg_rct_Left_High_Elves, gg_rct_Right_Start_Top, gg_unit_nheb_0109,
        gg_rct_Right_High_Elves, gg_rct_Left_Start_Bottom, gg_unit_nheb_0036, 1)
    spawn:addBase("highElvesCreep", gg_rct_Left_High_Elves, gg_rct_Aspect_of_Forest_Left, gg_unit_nheb_0109,
        gg_rct_Right_High_Elves, gg_rct_Aspect_of_Forest_Right, gg_unit_nheb_0036, 9)
    spawn:addBase("merc", gg_rct_Camp_Bottom, gg_rct_Right_Start_Bottom, gg_unit_n001_0048, gg_rct_Camp_Top,
        gg_rct_Left_Start_Top, gg_unit_n001_0049, 3)
    spawn:addBase("mine", gg_rct_Left_Workshop, gg_rct_Right_Start_Bottom, gg_unit_h006_0074, gg_rct_Right_Workshop,
        gg_rct_Left_Start_Top, gg_unit_h006_0055, 3)
    spawn:addBase("naga", gg_rct_Naga_Left, gg_rct_Right_Start_Top, gg_unit_nntt_0135, gg_rct_Naga_Right,
        gg_rct_Left_Start_Bottom, gg_unit_nntt_0132, 1)
    spawn:addBase("murloc", gg_rct_Murloc_Spawn_Left, gg_rct_Right_Start_Top, gg_unit_nmh1_0735,
        gg_rct_Murloc_Spawn_Right, gg_rct_Left_Start_Bottom, gg_unit_nmh1_0783, 1)
    spawn:addBase("nagaCreep", gg_rct_Naga_Left, gg_rct_Murloc_Left, gg_unit_nntt_0135, gg_rct_Naga_Right,
        gg_rct_Murloc_Right, gg_unit_nntt_0132, 8)
    spawn:addBase("nightElves", gg_rct_Left_Tree, gg_rct_Right_Start_Top, gg_unit_e003_0058, gg_rct_Right_Tree,
        gg_rct_Left_Start_Bottom, gg_unit_e003_0014, 1)
    spawn:addBase("orc", gg_rct_Left_Orc, gg_rct_Right_Start_Top, gg_unit_o001_0075, gg_rct_Right_Orc,
        gg_rct_Left_Start_Bottom, gg_unit_o001_0078, 1)
    spawn:addBase("shipyard", gg_rct_Left_Shipyard, gg_rct_Shipyard_End, gg_unit_eshy_0120, gg_rct_Right_Shipyard,
        gg_rct_Shipyard_End, gg_unit_eshy_0047, 1)
    spawn:addBase("hshipyard", gg_rct_Human_Shipyard_Left, gg_rct_Right_Shipyard, gg_unit_hshy_0011,
        gg_rct_Human_Shipyard_Right, gg_rct_Left_Shipyard, gg_unit_hshy_0212, 3)
    spawn:addBase("town", gg_rct_Left_Forward_Camp, gg_rct_Right_Start_Bottom, gg_unit_h00F_0029, gg_rct_Right_Forward,
        gg_rct_Left_Start_Top, gg_unit_h00F_0066, 3)
    spawn:addBase("undead", gg_rct_Undead_Left, gg_rct_Right_Start, gg_unit_u001_0262, gg_rct_Undead_Right,
        gg_rct_Left_Start, gg_unit_u001_0264, 2)
end

function spawnAddUnits()
    -- addUnit(baseName, unitType, numOfUnits, {waves}, levelStart, levelEnd)

    -- Arcane Spawn
    spawn:addUnit("arcane", "h00C", 2, {5, 6, 7, 8, 9}, 3, 12) -- Sorcress
    spawn:addUnit("arcane", "hgry", 1, {2, 3, 4, 5, 6, 8, 10}, 10, 12) -- Gryphon Rider

    -- Arcane Creep Spawn
    spawn:addUnit("arcaneCreep", "narg", 2, {1, 2, 3, 4}, 2, 12) -- Battle Golem
    spawn:addUnit("arcaneCreep", "hwt2", 1, {1, 2, 3, 4}, 3, 12) -- Water Elemental (Level 2)
    spawn:addUnit("arcaneCreep", "hwt3", 1, {1, 2, 3, 4}, 4, 12) -- Water Elemental (Level 3)
    spawn:addUnit("arcaneCreep", "h00K", 1, {1, 2, 3, 4, 5, 10}, 6, 12) -- Magi Defender

    -- Arcane Hero Sapwn
    spawn:addUnit("arcaneHero", "n00A", 1, {5, 6}, 7, 12) -- Supreme Wizard
    spawn:addUnit("arcaneHero", "nsgg", 1, {4, 6}, 9, 12) -- Seige Golem

    -- Arcane Top Spawn
    spawn:addUnit("arcaneTop", "narg", 4, {4, 5, 6}, 2, 12) -- Battle Golem
    spawn:addUnit("arcaneTop", "hwt2", 1, {4, 5, 6}, 4, 12) -- Water Elemental (Level 2)
    spawn:addUnit("arcaneTop", "hwt3", 1, {5, 6}, 8, 12) -- Water Elemental (Level 3)

    -- Arcane Bottom Spawn
    spawn:addUnit("arcaneBottom", "narg", 4, {1, 2, 3}, 2, 12) -- Battle Golem
    spawn:addUnit("arcaneBottom", "hwt2", 1, {1, 2, 3}, 4, 12) -- Water Elemental (Level 2)
    spawn:addUnit("arcaneBottom", "hwt3", 1, {2, 3}, 8, 12) -- Water Elemental (Level 3)

    -- Blacksmith Spawn
    spawn:addUnit("blacksmith", "hfoo", 1, {1, 2, 3, 4, 5}, 3, 12) -- Footman 1
    spawn:addUnit("blacksmith", "h00L", 1, {1, 2, 3, 4}, 4, 12) -- Knight
    spawn:addUnit("blacksmith", "h00L", 1, {1, 2, 3, 4}, 5, 12) -- Knight
    spawn:addUnit("blacksmith", "h017", 1, {1, 2, 3}, 6, 12) -- Scarlet Commander
    spawn:addUnit("blacksmith", "hmtm", 1, {3, 8}, 7, 12) -- Catapult
    spawn:addUnit("blacksmith", "h00D", 1, {2}, 10, 12) -- Commander of the Guard

    -- Blacksmith Creep Spawn
    spawn:addUnit("blacksmithCreep", "h007", 4, {1, 2, 3, 4}, 1, 6) -- Militia
    spawn:addUnit("blacksmithCreep", "nhea", 1, {1, 2, 3, 4}, 3, 12) -- Archer
    spawn:addUnit("blacksmithCreep", "hspt", 1, {1, 2, 3, 4}, 5, 12) -- Tower Guard
    spawn:addUnit("blacksmithCreep", "h011", 2, {1, 2, 3, 4, 5}, 8, 12) -- Scarlet Commander
    spawn:addUnit("blacksmithCreep", "hcth", 2, {1, 2, 3, 4, 5}, 11, 12) -- Captian

    -- Castle Spawn
    spawn:addUnit("castle", "h018", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 8, 12) -- Commander

    -- City Elves
    spawn:addUnit("cityElves", "nhea", 1, {1, 2, 3, 4, 5, 6}, 1, 3) -- Archer
    spawn:addUnit("cityElves", "hspt", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 2, 3) -- Tower Guard
    spawn:addUnit("cityElves", "hspt", 2, {1, 2, 3, 4, 5, 6, 7}, 4, 5) -- Tower Guard
    spawn:addUnit("cityElves", "nchp", 1, {1, 2, 3, 4}, 3, 12) -- Mystic
    spawn:addUnit("cityElves", "hspt", 3, {1, 2, 3, 4, 5, 6}, 6, 12) -- Tower Guard
    spawn:addUnit("cityElves", "nhea", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 4, 12) -- Archer
    spawn:addUnit("cityElves", "nchp", 1, {1, 2, 3, 4, 5, 6, 7}, 7, 12) -- Mystic

    -- City Front Spawn
    spawn:addUnit("cityFront", "h007", 2, {2, 3, 4, 5, 6, 7}, 1, 2) -- Militia 1
    spawn:addUnit("cityFront", "h015", 3, {2, 3, 4, 5, 6, 7}, 3, 5) -- Militia 2
    spawn:addUnit("cityFront", "hfoo", 3, {2, 3, 4, 5, 6, 7}, 4, 12) -- Footman 1
    spawn:addUnit("cityFront", "hcth", 2, {2, 3, 4, 5, 6}, 6, 12) -- Captian

    -- City Side Spawn
    spawn:addUnit("citySide", "h015", 1, {6, 7, 8, 9, 10}, 1, 2) -- Militia 1
    spawn:addUnit("citySide", "hfoo", 2, {6, 7, 8, 9, 10}, 2, 12) -- Footman 1
    spawn:addUnit("citySide", "h015", 2, {1, 2, 3, 4, 6}, 3, 12) -- Militia 1

    -- Kobold Spawn
    spawn:addUnit("kobold", "nkob", 2, {1, 2, 3, 4, 5, 6, 7, 8, 9}, 1, 12) -- Kobold
    spawn:addUnit("kobold", "nkot", 1, {1, 2, 3, 5, 7, 9}, 3, 12) -- Kobold Tunneler
    spawn:addUnit("kobold", "nkog", 1, {1, 3, 5, 7, 9}, 4, 12) -- Kobold Geomancer
    spawn:addUnit("kobold", "nkol", 1, {4, 6, 8}, 5, 12) -- Kobold Taskmaster

    -- High Elves
    spawn:addUnit("highElves", "earc", 2, {1, 2, 3, 4, 5}, 1, 12) -- Ranger
    spawn:addUnit("highElves", "e000", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 2, 12) -- Elite Ranger
    spawn:addUnit("highElves", "hhes", 4, {1, 2, 3, 4}, 4, 12) -- Swordsman
    spawn:addUnit("highElves", "nemi", 1, {1, 2, 3, 4, 5, 6}, 5, 12) -- Emmisary

    -- High Elves Creep
    spawn:addUnit("highElvesCreep", "hhes", 2, {1, 2, 3, 4}, 1, 12) -- Swordsman
    spawn:addUnit("highElvesCreep", "nhea", 1, {1, 2, 3, 4, 5}, 2, 12) -- Archer
    spawn:addUnit("highElvesCreep", "nemi", 1, {1, 2, 3, 4}, 4, 12) -- Emmisary
    spawn:addUnit("highElvesCreep", "h010", 2, {1, 2, 3, 4, 5}, 5, 12) -- Elven Guardian

    -- Merc Spawn
    spawn:addUnit("merc", "nooL", 4, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 1, 12) -- Rogue
    spawn:addUnit("merc", "n003", 2, {4, 5, 6, 7, 8, 9, 10}, 2, 12) -- Merc Archer
    spawn:addUnit("merc", "n002", 3, {2, 3, 4, 7, 8, 9, 10}, 3, 12) -- Merc
    spawn:addUnit("merc", "n008", 1, {1, 2, 3, 4, 5, 6, 8, 9, 10}, 4, 12) -- Enforcer
    spawn:addUnit("merc", "nass", 1, {6, 7, 8, 9, 10}, 5, 12) -- Assasin
    spawn:addUnit("merc", "n004", 1, {7, 8, 9, 10}, 1, 12) -- Wizard Warrior
    spawn:addUnit("merc", "n005", 1, {7, 8, 9, 10}, 6, 12) -- Bandit Lord

    -- Mine Spawn
    spawn:addUnit("mine", "h001", 1, {2, 3, 4, 5, 6}, 2, 12) -- Morter Team
    spawn:addUnit("mine", "h008", 2, {1, 2, 3, 4, 5, 6, 7, 8}, 3, 12) -- Rifleman
    spawn:addUnit("mine", "h013", 1, {1, 2, 3, 4, 5, 6, 7, 8}, 4, 12) -- Rifleman Long
    spawn:addUnit("mine", "ncg2", 2, {1, 2, 3, 4, 5, 6, 7}, 4, 12) -- Clockwerk Goblin
    spawn:addUnit("mine", "hmtt", 1, {1, 3, 5, 7}, 5, 12) -- Seige Engine
    spawn:addUnit("mine", "n00F", 1, {2, 3, 4, 5, 6, 7}, 6, 12) -- Automaton

    -- Murloc Spawn
    spawn:addUnit("murloc", "nmcf", 4, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 1, 12) -- Mur'gul Cliffrunner
    spawn:addUnit("murloc", "nnmg", 1, {2, 4, 6, 7, 8}, 2, 12) -- Mur'gul Reaver
    spawn:addUnit("murloc", "nmsn", 1, {1, 3, 4, 6, 9}, 3, 12) -- Mur'gul Snarecaster
    spawn:addUnit("murloc", "nmtw", 1, {1, 3, 6}, 6, 12) -- Mur'gul Tidewarrior

    -- Naga Spawn
    spawn:addUnit("naga", "nmyr", 2, {1, 3, 4, 6, 7, 9, 10}, 1, 12) -- Naga Myrmidon
    spawn:addUnit("naga", "nnsw", 1, {4, 5, 7, 9, 10}, 3, 12) -- Naga Siren
    spawn:addUnit("naga", "nnrg", 1, {5, 8, 9, 10}, 6, 12) -- Naga Royal Guard
    spawn:addUnit("naga", "nhyc", 1, {1, 3, 5, 8, 9}, 9, 12) -- Dragon Turtle

    -- Naga Creep Spawn
    spawn:addUnit("nagaCreep", "nmyr", 2, {1, 2, 3, 4}, 2, 12) -- Naga Myrmidon
    spawn:addUnit("nagaCreep", "nnsw", 1, {2, 3, 4, 5}, 3, 12) -- Naga Siren
    spawn:addUnit("nagaCreep", "nsnp", 2, {2, 3, 4, 5, 6}, 5, 12) -- Snap Dragon

    -- Night Elves Spawn
    spawn:addUnit("nightElves", "nwat", 1, {3, 4, 5, 6, 7, 8, 9}, 2, 12) -- Sentry
    spawn:addUnit("nightElves", "edry", 1, {1, 4, 5, 7, 9}, 3, 12) -- Dryad
    spawn:addUnit("nightElves", "edoc", 2, {1, 3, 5, 7, 9}, 4, 12) -- Druid of the Claw
    spawn:addUnit("nightElves", "e005", 1, {2, 4, 6, 8}, 5, 12) -- Mountain Giant
    spawn:addUnit("nightElves", "nwnr", 1, {5, 10}, 9, 12) -- Ent

    -- Orc Spawn
    spawn:addUnit("orc", "o002", 2, {1, 3, 4, 5, 6, 7, 8, 9, 10}, 1, 12) -- Grunt
    spawn:addUnit("orc", "o002", 2, {5, 6, 7, 8, 9}, 3, 12) -- Grunt
    spawn:addUnit("orc", "nftr", 1, {4, 5, 7, 8, 9, 10}, 2, 12) -- Spearman
    spawn:addUnit("orc", "nogo", 3, {2, 4, 6, 8, 10}, 4, 12) -- Ogre
    spawn:addUnit("orc", "nw2w", 1, {1, 3, 5, 7, 9}, 3, 12) -- Warlock
    spawn:addUnit("orc", "owad", 1, {1, 6, 9}, 6, 12) -- Orc Warchief
    -- spawn:addUnit("orc", "ocat", 1, {1,5}, 6, 12)  -- Demolisher

    -- Human Shipyard Spawn
    spawn:addUnit("hshipyard", "hdes", 1, {2, 4}, 1, 2) -- Human Frigate
    spawn:addUnit("hshipyard", "hdes", 1, {2, 4, 8}, 3, 4) -- Human Frigate
    spawn:addUnit("hshipyard", "hdes", 1, {2, 4, 6, 8}, 5, 12) -- Human Frigate
    spawn:addUnit("hshipyard", "hbsh", 1, {3, 8}, 6, 12) -- Human Battleship

    -- Night Elf Shipyard Spawn
    spawn:addUnit("shipyard", "edes", 1, {1, 6}, 2, 3) -- Night Elf Frigate
    spawn:addUnit("shipyard", "edes", 1, {1, 3, 6}, 4, 5) -- Night Elf Frigate
    spawn:addUnit("shipyard", "edes", 1, {1, 3, 6, 10}, 6, 12) -- Night Elf Frigate
    spawn:addUnit("shipyard", "ebsh", 1, {3, 7}, 7, 12) -- Night Elf Battleship

    -- Town Spawn
    spawn:addUnit("town", "h007", 3, {1, 2, 3, 4, 5}, 1, 5) -- Militia
    spawn:addUnit("town", "h007", 2, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 3, 12) -- Militia
    spawn:addUnit("town", "hcth", 1, {1, 2, 3, 4}, 2, 12) -- Captian
    spawn:addUnit("town", "n00X", 2, {1, 2, 3, 4, 6, 8}, 3, 12) -- Arbalist
    spawn:addUnit("town", "hfoo", 5, {1, 2, 5, 6, 8}, 5, 12) -- Footman
    spawn:addUnit("town", "h00L", 2, {1, 3, 7, 9}, 4, 12) -- Knight

    -- Undead Spawn
    spawn:addUnit("undead", "ugho", 4, {1, 2, 3, 4, 5, 6, 7, 8, 9}, 1, 12) -- Ghoul
    spawn:addUnit("undead", "uskm", 2, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}, 2, 12) -- Skeleton Mage
    spawn:addUnit("undead", "unec", 1, {1, 2, 3, 4, 5, 6, 7}, 3, 12) -- Necromancer
    spawn:addUnit("undead", "nerw", 1, {1, 6}, 4, 12) -- Warlock
    spawn:addUnit("undead", "nfgl", 1, {2, 5, 8}, 5, 12) -- Giant Skeleton
end

-- Camera Setup
function initTrig_Auto_Zoom()
    trg_Auto_Zoom = CreateTrigger()
    DisableTrigger(trg_Auto_Zoom)
    TriggerRegisterTimerEventPeriodic(trg_Auto_Zoom, 3.00)

    TriggerAddAction(trg_Auto_Zoom, function()
        local i = 1
        local ug = CreateGroup()

        while (i <= 12) do
            ug = GetUnitsInRangeOfLocAll(1350, GetCameraTargetPositionLoc())
            SetCameraFieldForPlayer(ConvertedPlayer(i), CAMERA_FIELD_TARGET_DISTANCE,
                (1700.00 + (1.00 * I2R(CountUnitsInGroup(ug)))), 6.00)
            DestroyGroup(ug)
            i = i + 1
        end
    end)
end

--
-- Game Action Triggers
--

-- Hero Levels Up
function Init_Hero_Levels_Up()
    local t = CreateTrigger()

    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_HERO_LEVEL)
    TriggerAddAction(t, function()
        -- Get Locals
        local levelingUnit = GetLevelingUnit()

        debugfunc(function()
            hero.levelUp(levelingUnit)
        end, "hero.levelUp")
    end)
end

-- Unit Casts Spell
function Init_AI_Spell_Start()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_CAST)

    TriggerAddAction(t, function()
        local triggerUnit = GetTriggerUnit()

        debugfunc(function()
            CAST_aiHero(triggerUnit)
        end, "CAST_aiHero")
    end)
end

function CAST_aiHero(triggerUnit)
    if IsUnitInGroup(triggerUnit, ai.heroGroup) then
        local pickedHero = ai.heroOptions[S2I(GetUnitUserData(triggerUnit))]
        ai:castSpell(pickedHero)
    end
end
