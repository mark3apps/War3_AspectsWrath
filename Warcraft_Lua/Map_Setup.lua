function MapSetup()
	-- Classes
	init_SpawnClass()
	init_AIClass()
	init_HeroClass()

	-- Globals
	mapAI = ai.new()
	hero = heroClass.new()

	-- Trigger Init
	initTrig_Auto_Zoom()
	InitTrig_AI_MAIN()
	InitTrig_Computer_Picks()

	InitTrig_Hero_Level_Up()
	InitTrig_AI_Spell_Start()

	-- Spawn
	spawnSetup()
	spawnRun()
end
