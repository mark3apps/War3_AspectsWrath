function initTrig_Auto_Zoom()
	trg_Auto_Zoom = CreateTrigger()
	DisableTrigger(trg_Auto_Zoom)
	TriggerRegisterTimerEventPeriodic(trg_Auto_Zoom, 3.00)
	
	
    TriggerAddAction(trg_Auto_Zoom, function ()
		local i = 1
		local ug = CreateGroup()
		
		while (i <= 12 ) do
			
			ug = GetUnitsInRangeOfLocAll(1350, GetCameraTargetPositionLoc())
			SetCameraFieldForPlayer(ConvertedPlayer(i), CAMERA_FIELD_TARGET_DISTANCE, (2000.00 + (1.00 * I2R(CountUnitsInGroup(ug)))), 6.00)
			DestroyGroup(ug)
			i = i + 1
		end
	end)
end