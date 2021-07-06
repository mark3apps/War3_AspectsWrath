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