function MapSetup()

	-- Classes
	print("Init Spawn Class")
	init_SpawnClass()
	print("Init AI Class")
	init_AIClass()
	mapAI = ai.new()

	-- Trigger Init
	print("Init Camera")
	initTrig_Auto_Zoom()
	print("Init AI Main")
	InitTrig_AI_MAIN()
	print("Init Computer Picks")
	InitTrig_Computer_Picks()
	--InitTrig_Hero_Level_Ups()
	--InitTrig_AI_Spell_Start()
	
	--init_AI()

	-- Spawn
	print("Init Spawn")
	spawnSetup()
	print("Run Spawn")
	spawnRun()

	

end