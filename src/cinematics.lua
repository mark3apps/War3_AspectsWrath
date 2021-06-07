cine = {}

function cine.Init()
	-- Hide UI Keep Mouse
    SetSkyModel("Environment\\Sky\\BlizzardSky\\BlizzardSky.mdl")
	BlzHideOriginFrames(true)
	BlzFrameSetVisible(BlzGetFrameByName("ConsoleUIBackdrop", 0), false)
	CinematicFilterGenericBJ(0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 0.00, 0.00, 0.00,
	                         0.00, 0, 0, 0, 0)

		local t = CreateTrigger()
		TriggerRegisterTimerEventSingle(t, 3)

		TriggerAddAction(t, function()
			CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 3.00, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 0, 0, 0, 0)

			-- Lock Cam
			CameraSetupApplyForPlayer(true, gg_cam_intro01Start, Player(0), 0)
			local camX = CameraSetupGetDestPositionX(gg_cam_intro01Start)
			local camY = CameraSetupGetDestPositionY(gg_cam_intro01Start)

			local unit = CreateUnit(Player(19), FourCC("h01Z"), camX, camY, bj_UNIT_FACING)
			UnitApplyTimedLife(unit, FourCC("BTLF"), 20)

			SetCameraTargetControllerNoZForPlayer(Player(0), unit, 0, 0, false)
            CameraSetupApplyForPlayer(true, gg_cam_intro01End, Player(0), 15)
            --for i = 1, 8 do HeroSelector.show(true, Player(i)) end
            PolledWait(15)
		end)

    function cine.finish()
        
			-- Reset back to normal
            CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.00, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 0, 0, 0, 0)
            
            PolledWait(1)
            
            CameraSetupApplyForPlayer(true, gg_cam_Base_Left_Start, Player(0), 0)
            CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.00, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 0, 0, 0, 0)
            FogMaskEnableOn()
			FogEnableOn()
            
            PolledWait(1)
			
            BlzHideOriginFrames(false)
			BlzFrameSetVisible(BlzGetFrameByName("ConsoleUIBackdrop", 0), true)
            CinematicModeBJ(true, bj_FORCE_ALL_PLAYERS)


            
            CinematicModeExBJ(false, bj_FORCE_ALL_PLAYERS, 0)
            
            -- Fade back to normal
			


    end
end

