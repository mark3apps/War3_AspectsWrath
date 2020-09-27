
--
--  TESTS
--
local mapSpawn = spawn.new()
local baseI
local unitI
local baseName
local levelNumber
local waveNumber


mapSpawn.addBase("outpost", "gg_rct_Left_Forward_Camp", "gg_unit_h00F_0029", "gg_rct_Right_Forward", "gg_unit_h00F_0066", 3)
mapSpawn.addBase("castle", "gg_rct_Left_Forward_Camp", "gg_unit_h00F_0029", "gg_rct_Right_Forward", "gg_unit_h00F_0066", 3)

mapSpawn.addUnit("outpost", "h003", 5, {1, 3, 7}, 3, 7)
mapSpawn.addUnit("outpost", "h004", 5, {2, 3, 4, 5, 8}, 1, 10)
mapSpawn.addUnit("outpost", "h005", 5, {4, 5, 6}, 1, 10)
mapSpawn.addUnit("castle", "h006", 5, {4, 5, 6}, 1, 10)
mapSpawn.addUnit("castle", "h007", 5, {4, 5, 6}, 1, 10)



print("testing")


for levelNumber=1,10 do
	print("Level: " .. levelNumber)

	for waveNumber=1,10 do
		print("Wave: " .. waveNumber)

		for baseI=1,mapSpawn.baseCount() do
			baseName = mapSpawn.bases[baseI]

			for unitI=1,mapSpawn.unitCount(baseName) do
				allied, fed, unit = mapSpawn.SpawnUnit(baseName, unitI, levelNumber, waveNumber)
				print(baseName, allied, fed, unit.unitType)
			end
		end

		print("")

	end
end

print("testing2")