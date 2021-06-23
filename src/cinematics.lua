cine = {}
function cine.Init()
	-- Hide UI Keep Mouse
	SetSkyModel(sky.blizzardSky)
	-- BlzHideOriginFrames(true)
	-- BlzFrameSetVisible(BlzGetFrameByName("ConsoleUIBackdrop", 0), false)
	CinematicFilterGenericBJ(0.00, BLEND_MODE_BLEND, mask.black, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0)

	local t = CreateTrigger()
	TriggerRegisterTimerEventSingle(t, 3)

	TriggerAddAction(t, function()
		CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 3.00, mask.black, 0, 0, 0, 0)

		-- Lock Cam
		local startCams = {
			gg_cam_intro01, gg_cam_intro02, gg_cam_intro03, gg_cam_intro04, gg_cam_intro05, gg_cam_intro06, gg_cam_intro07,
   gg_cam_intro08, gg_cam_intro09, gg_cam_intro10, gg_cam_intro11
		}

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

	function cine.mapStart()

		-- Set Hero Bar Offsets
		local x = 0.205
		local y = -0.025

		-- Turn off Auto Positioning
		BlzEnableUIAutoPosition(false)

		-- Create Hero Bar Background UI Texture
		heroBarUI = BlzCreateFrameByType("BACKDROP", "image", BlzGetFrameByName("ConsoleUIBackdrop", 0),
		                                 "ButtonBackdropTemplate", 0)
		BlzFrameSetTexture(heroBarUI, "UI\\ResourceBar_combined.dds", 0, true)
		BlzFrameSetAbsPoint(heroBarUI, FRAMEPOINT_TOPLEFT, x + 0.046, y + 0.255)
		BlzFrameSetAbsPoint(heroBarUI, FRAMEPOINT_BOTTOMRIGHT, x + 0.17, y + 0.126)
		BlzFrameSetLevel(heroBarUI, 1)

		-- Remove Upper Button Bar Back
		BlzFrameSetAbsPoint(frame.consoleUI, FRAMEPOINT_TOPLEFT, 0, -0.1)
		BlzFrameSetAbsPoint(frame.consoleUI, FRAMEPOINT_BOTTOM, 0, 0)

		-- Hide Upper Button Bar Buttons
		BlzFrameClearAllPoints(frame.upperButtonBar.alliesButton)
		BlzFrameClearAllPoints(frame.upperButtonBar.questsButton)
		BlzFrameSetAbsPoint(frame.upperButtonBar.alliesButton, FRAMEPOINT_BOTTOMLEFT, 0, 1.5)
		BlzFrameSetAbsPoint(frame.upperButtonBar.questsButton, FRAMEPOINT_BOTTOMLEFT, 0, 1.5)

		-- Move Upper Button Bar Buttons we like
		BlzFrameClearAllPoints(frame.upperButtonBar.menuButton)
		BlzFrameClearAllPoints(frame.upperButtonBar.chatButton)
		BlzFrameSetAbsPoint(frame.upperButtonBar.menuButton, FRAMEPOINT_TOPLEFT, 0.255, 0.60)
		BlzFrameSetAbsPoint(frame.upperButtonBar.chatButton, FRAMEPOINT_TOPLEFT, 0.463, 0.60)

		-- Move Gold Bar
		BlzFrameClearAllPoints(frame.resource.goldText)
		BlzFrameSetAbsPoint(frame.resource.goldText, FRAMEPOINT_TOPLEFT, x + 0.073, y + 0.213)
		

		-- Hide Resource Bar
		BlzFrameClearAllPoints(frame.resource.frame)
		BlzFrameClearAllPoints(frame.resource.lumberText)
		BlzFrameSetAbsPoint(frame.resource.frame, FRAMEPOINT_TOPLEFT, 0.0, 1.5)
		BlzFrameSetAbsPoint(frame.resource.lumberText, FRAMEPOINT_TOPLEFT, 0, 1.5)
		BlzFrameSetAbsPoint(frame.resource.upkeepText, FRAMEPOINT_TOPRIGHT, 0, 1.5)
		BlzFrameSetAbsPoint(frame.resource.supplyText, FRAMEPOINT_TOPRIGHT, 0, 1.5)

		-- Hero Bar
		BlzFrameClearAllPoints(frame.hero.bar)
		BlzFrameSetAbsPoint(frame.hero.bar, FRAMEPOINT_TOPLEFT, x + 0.01, y + 0.214)
		BlzFrameSetScale(frame.hero.button[1], 1.25)

		-- HP Bar
		BlzFrameClearAllPoints(frame.hero.hp[1])
		BlzFrameSetAbsPoint(frame.hero.hp[1], FRAMEPOINT_BOTTOMLEFT, x + 0.065, y + 0.181)
		BlzFrameSetScale(frame.hero.hp[1], 2.3)

		-- Mana Bar
		BlzFrameClearAllPoints(frame.hero.mana[1])
		BlzFrameSetAbsPoint(frame.hero.mana[1], FRAMEPOINT_BOTTOMLEFT, x + 0.065, y + 0.175)
		BlzFrameSetScale(frame.hero.mana[1], 2.3)

	end

	function cine.finish()

		-- Reset back to normal
		CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.00, mask.black, 0, 0, 0, 0)
		-- BlzHideOriginFrames(false)
		-- BlzFrameSetVisible(BlzGetFrameByName("ConsoleUIBackdrop", 0), true)

		PolledWait(1)

		for i = 0, 15, 1 do
			if i < 6 then
				CameraSetupApplyForPlayer(true, gg_cam_baseLeftStart, Player(i), 0)
			else
				CameraSetupApplyForPlayer(true, gg_cam_baseRightStart, Player(i), 0)
			end
		end

		CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.00, mask.black, 0, 0, 0, 0)
		FogMaskEnableOn()
		FogEnableOn()
	end
end

