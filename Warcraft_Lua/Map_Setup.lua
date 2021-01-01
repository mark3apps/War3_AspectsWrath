function MapSetup()

	-- Define Classes
	debugfunc(
		function()
			init_heroClass()
			init_SpawnClass()
			init_AIClass()
		end,
		"Define Classes"
	)

	-- Init Classes
	debugfunc(
		function()
			hero = hero_Class.new()
		end,
		"Init Heroes"
	)
	debugfunc(
		function()
			ai = ai_Class.new()
		end,
		"Init AI"
	)


	-- Init Trigger
	debugfunc(
		function()
			initTrig_Auto_Zoom()
			InitTrig_AI_MAIN()
			InitTrig_Computer_Picks()

			InitTrig_Hero_Level_Up()
			InitTrig_AI_Spell_Start()
		end,
		"Init Triggers"
	)

	-- Spawn
	spawnSetup()
	spawnRun()
end
