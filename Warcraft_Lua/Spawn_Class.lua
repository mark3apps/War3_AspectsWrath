function init_SpawnClass()
	-- Create the table for the class definition
	spawn = {}

	-- Define the new() function
	spawn.new = function()
		local self = {}

		self.bases = {}

		function self.addBase(baseName, alliedStart, alliedEnd, alliedCondition, fedStart, fedEnd, fedCondition, destination)
			-- Add all of the info the base and add the base name to the base list
			self[baseName] = {
				allied = {startPoint = alliedStart, endPoint = alliedEnd, condition = alliedCondition},
				fed = {startPoint = fedStart, endPoint = fedEnd, condition = fedCondition},
				destination = destination,
				units = {}
			}
			table.insert(self.bases, baseName)
		end

		function self.baseCount()
			return #self.bases
		end

		function self.unitCount(baseName)
			return #self[baseName].units
		end

		function self.unitInWave(baseName, unitIndex, waveNumber)
			local waves = self[baseName].units[unitIndex].waves

			for index, value in ipairs(waves) do
				if value == waveNumber then
					return true
				end
			end

			return false
		end

		function self.unitInLevel(baseName, unitIndex, levelNumber)
			local levelStart, levelEnd = self[baseName].units[unitIndex].level[1], self[baseName].units[unitIndex].level[2]

			if (levelNumber >= levelStart and levelNumber <= levelEnd) then
				return true
			end

			return false
		end

		function self.baseAlive(baseName)
			local alliedBaseAlive = IsUnitAliveBJ(self[baseName].allied.condition)
			local fedBaseAlive = IsUnitAliveBJ(self[baseName].fed.condition)

			--local alliedBaseAlive = true
			--local fedBaseAlive = true

			return alliedBaseAlive, fedBaseAlive
		end

		function self.checkSpawnUnit(baseName, unitIndex, levelNumber, waveNumber)
			local alliedBaseAlive, fedBaseAlive = self.baseAlive(baseName)
			local unitInWave = self.unitInWave(baseName, unitIndex, waveNumber)
			local unitInLevel = self.unitInLevel(baseName, unitIndex, levelNumber)
			local numOfUnits = self[baseName].units[unitIndex].numOfUnits
			local unitType = self[baseName].units[unitIndex].unitType

			if unitInWave and unitInLevel then
				return alliedBaseAlive, fedBaseAlive, numOfUnits, unitType
			else
				return false, false, numOfUnits, unitType
			end
		end

		function self.addUnit(baseName, unitType, numOfUnits, waves, levelStart, levelEnd)
			table.insert(
				self[baseName].units,
				{unitType = unitType, numOfUnits = numOfUnits, waves = waves, level = {levelStart, levelEnd}}
			)
		end

		function self.spawnUnits(baseName, levelNumber, waveNumber)
			local pStart
			local pDest
			local allied = false
			local fed = false
			local lcu
			local unitType
			local numOfUnits

			for unitI = 1, self.unitCount(baseName) do
				allied, fed, numOfUnits, unitType = self.checkSpawnUnit(baseName, unitI, levelNumber, waveNumber)

				if allied then
					for i = 1, numOfUnits do
						pStart = GetRandomLocInRect(self[baseName].allied.startPoint)
						pDest = GetRandomLocInRect(self[baseName].allied.endPoint)

						lcu = CreateUnitAtLoc(Player(GetRandomInt(18, 20)), FourCC(unitType), pStart, bj_UNIT_FACING)
						SetUnitUserData(lcu, self[baseName].destination)
						IssuePointOrderLoc(lcu, "attack", pDest)

						RemoveLocation(pStart)
						RemoveLocation(pDest)
					end
				end

				if fed then
					for i = 1, numOfUnits do
						pStart = GetRandomLocInRect(self[baseName].fed.startPoint)
						pDest = GetRandomLocInRect(self[baseName].fed.endPoint)

						lcu = CreateUnitAtLoc(Player(GetRandomInt(21, 23)), FourCC(unitType), pStart, bj_UNIT_FACING)
						SetUnitUserData(lcu, self[baseName].destination)
						IssuePointOrderLoc(lcu, "attack", pDest)

						RemoveLocation(pStart)
						RemoveLocation(pDest)
					end
				end
			end
		end

		return self
	end
end
