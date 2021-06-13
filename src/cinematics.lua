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
		local startCams = {gg_cam_intro01, gg_cam_intro02, gg_cam_intro03, gg_cam_intro04, gg_cam_intro05, gg_cam_intro06, gg_cam_intro07, gg_cam_intro08, gg_cam_intro09, gg_cam_intro10, gg_cam_intro11}

		for i = 0, 11, 1 do
			local camChoice = GetRandomInt(1, #startCams)
			CameraSetupApplyForPlayer(true, startCams[camChoice], Player(i), 0)
			local camX = CameraSetupGetDestPositionX(startCams[camChoice])
			local camY = CameraSetupGetDestPositionY(startCams[camChoice])

			local unit = CreateUnit(Player(19), FourCC("h01Z"), camX, camY, bj_UNIT_FACING)
			UnitApplyTimedLife(unit, FourCC("BTLF"), 20)

			SetCameraTargetControllerNoZForPlayer(Player(i), unit, 0, 0, false)
		end

	end)

	function cine.finish()

		-- Reset back to normal
		CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.00, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 0, 0, 0, 0)
		BlzHideOriginFrames(false)
		BlzFrameSetVisible(BlzGetFrameByName("ConsoleUIBackdrop", 0), true)

		PolledWait(1)

		for i = 0, 15, 1 do
			if i < 6 then
				CameraSetupApplyForPlayer(true, gg_cam_baseLeftStart, Player(i), 0)
			else
				CameraSetupApplyForPlayer(true, gg_cam_baseRightStart, Player(i), 0)
			end
		end

		CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.00, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 0, 0, 0, 0)
		FogMaskEnableOn()
		FogEnableOn()

		-- Fade back to normal

	end
end

