function MapSetup()

	-- Classes
	init_SpawnClass()
	init_AIClass()
	mapAI = ai.new()

	-- Trigger Init
	init_Trig_Auto_Zoom()
	InitTrig_AI_MAIN()
	InitTrig_Computer_Picks()
	InitTrig_Hero_Level_Ups()
	InitTrig_AI_Spell_Start()
	
	--init_AI()

	-- Spawn
	spawnSetup()
	spawnRun()

	

end