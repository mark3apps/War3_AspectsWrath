function mapInit()
	print("Working")
	Init_luaGlobals()
	print("Working")
	cine.Init()
	print("Working")

	local t = CreateTrigger()
	TriggerRegisterTimerEventSingle(t, 0)
	TriggerAddAction(t, function ()
		print("Working")
		cine.mapStart()
		print("Working")
	end)
end

cine = {}
function cine.Init()

	-- BlzFrameSetAbsPoint(frame.heroBar, FRAMEPOINT_BOTTOMLEFT, 0.5, 0.8)
	-- BlzFrameSetAbsPoint(frame.heroButton01, FRAMEPOINT_BOTTOMLEFT, 0.5, 0.20)
	-- BlzFrameSetAbsPoint(frame.heroButton01, FRAMEPOINT_BOTTOMLEFT, 0.5, 0.20)

	BlzEnableUIAutoPosition(false)
	BlzFrameSetAbsPoint()
	BlzFrameSetAbsPoint(BlzGetFrameByName("ConsoleUI", 0), FRAMEPOINT_BOTTOM, 0, 0)
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
		try(function()

			
			local x = 0.205
			local y = -0.025
			BlzFrameClearAllPoints(frame.hero.bar)
			BlzFrameClearAllPoints(frame.hero.hp[1])
			BlzFrameClearAllPoints(frame.resource.goldText)
			BlzFrameSetAbsPoint(frame.hero.bar, FRAMEPOINT_TOPLEFT, x + 0.00, y + 0.224)

			-- Menu Bar
			--BlzFrameSetVisible(frame.upperButtonBar.frame, false)
			--BlzFrameSetVisible(BlzGetFrameByName("ResorceBarFrame", 0), false)
			--BlzFrameSetVisible(BlzGetFrameByName("UpperButtonBarFrame", 0), false)
			
			BlzFrameClearAllPoints(frame.upperButtonBar.alliesButton)
			BlzFrameClearAllPoints(frame.upperButtonBar.questsButton)
			BlzFrameClearAllPoints(frame.upperButtonBar.menuButton)
			BlzFrameClearAllPoints(frame.upperButtonBar.chatButton)
			BlzFrameSetAbsPoint(frame.upperButtonBar.alliesButton, FRAMEPOINT_BOTTOMLEFT, 0, 1.5)
			BlzFrameSetAbsPoint(frame.upperButtonBar.questsButton, FRAMEPOINT_BOTTOMLEFT, 0, 1.5)
			BlzFrameSetAbsPoint(frame.upperButtonBar.menuButton, FRAMEPOINT_TOPLEFT, 0, 0.59)
			BlzFrameSetAbsPoint(frame.upperButtonBar.chatButton, FRAMEPOINT_TOPLEFT, 0, 0.57)

			-- Resource Bar
			BlzFrameSetAbsPoint(frame.resource.goldText, FRAMEPOINT_BOTTOMLEFT, x + 0.063, y + 0.2)
			BlzFrameSetAbsPoint(frame.resource.lumberText, FRAMEPOINT_TOPRIGHT, 0, 1.5)
			BlzFrameSetAbsPoint(frame.resource.upkeepText, FRAMEPOINT_TOPRIGHT, 0, 1.5)
			BlzFrameSetAbsPoint(frame.resource.supplyText, FRAMEPOINT_TOPRIGHT, 0, 1.5)
			

			BlzFrameSetScale(frame.hero.button[1], 1.5)
			BlzFrameSetAbsPoint(frame.hero.hp[1], FRAMEPOINT_BOTTOMLEFT, x + 0.061, y + 0.18)
			BlzFrameSetScale(frame.hero.hp[1], 2.4)
			BlzFrameSetScale(frame.hero.mana[1], 2.4)
		end)
	end

	function cine.finish()

		-- Reset back to normal
		CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.00, mask.black, 0, 0, 0, 0)
		-- BlzHideOriginFrames(false)
		-- BlzFrameSetVisible(BlzGetFrameByName("ConsoleUIBackdrop", 0), true)

		-- BlzEnableUIAutoPosition(false)

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

		-- BlzFrameClearAllPoints(frame.heroBar)

		-- BlzFrameSetAbsPoint(frame.heroBar, FRAMEPOINT_BOTTOMLEFT, 0.5, 0.8)

		PolledWait(2)

		-- BlzFrameClearAllPoints(frame.heroBar)

		-- BlzFrameClearAllPoints(frame.portrait)

		-- BlzFrameClearAllPoints(frame.heroButton01)
		-- BlzFrameSetAbsPoint(frame.heroButton01, FRAMEPOINT_BOTTOMLEFT, 0.30, 0.18)
		-- Fade back to normal

	end
end

