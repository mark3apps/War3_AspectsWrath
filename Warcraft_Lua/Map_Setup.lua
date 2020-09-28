function MapSetup()

	-- Classes
	init_SpawnClass()
	init_AIClass()
	mapAI = ai.new()

	-- Trigger Init=
	initTrig_Auto_Zoom()
	InitTrig_AI_MAIN()
	InitTrig_Computer_Picks()
	
	InitTrig_Hero_Level_Ups()
	InitTrig_AI_Spell_Start()
	
	
	--init_AI()

	-- Spawn
	print("Init Spawn")
	spawnSetup()
	print("Run Spawn")
	spawnRun()

	

end