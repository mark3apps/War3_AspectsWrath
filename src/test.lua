function mapInit()

	Init_luaGlobals()
	cine.Init()

	local t = CreateTrigger()
	TriggerRegisterTimerEventSingle(t, 0.1)
	TriggerAddAction(t, function()

		cine.mapStart()
		print("Working")
	end)
end

cine = {}
function cine.Init()

	-- BlzFrameSetAbsPoint(frame.heroBar, FRAMEPOINT_BOTTOMLEFT, 0.5, 0.8)
	-- BlzFrameSetAbsPoint(frame.heroButton01, FRAMEPOINT_BOTTOMLEFT, 0.5, 0.20)
	-- BlzFrameSetAbsPoint(frame.heroButton01, FRAMEPOINT_BOTTOMLEFT, 0.5, 0.20)

	-- Hide UI Keep Mouse

end

function cine.mapStart()
	try(function()

		local x = 0.205
		local y = -0.025

		BlzEnableUIAutoPosition(false)
		imageTest = BlzCreateFrameByType("BACKDROP", "image", BlzGetFrameByName("ConsoleUIBackdrop", 0),
		                                 "ButtonBackdropTemplate", 0)
		BlzFrameSetTexture(imageTest, "UI\\ResourceBar.tga", 0, true)
		BlzFrameSetAbsPoint(imageTest, FRAMEPOINT_TOPLEFT, x + 0.059, y + 0.215)
		BlzFrameSetSize(imageTest, 0.092, 0.022)
		BlzFrameSetLevel(imageTest, 1)

		BlzFrameSetAbsPoint(frame.consoleUI, FRAMEPOINT_TOPLEFT, 0, -0.1)
		BlzFrameSetAbsPoint(frame.consoleUI, FRAMEPOINT_BOTTOM, 0, 0)



		BlzFrameClearAllPoints(frame.upperButtonBar.alliesButton)
		BlzFrameClearAllPoints(frame.upperButtonBar.questsButton)
		BlzFrameClearAllPoints(frame.upperButtonBar.menuButton)
		BlzFrameClearAllPoints(frame.upperButtonBar.chatButton)

		-- Button Bar
		BlzFrameSetAbsPoint(frame.upperButtonBar.alliesButton, FRAMEPOINT_BOTTOMLEFT, 0, 1.5)
		BlzFrameSetAbsPoint(frame.upperButtonBar.questsButton, FRAMEPOINT_BOTTOMLEFT, 0, 1.5)
		BlzFrameSetAbsPoint(frame.upperButtonBar.menuButton, FRAMEPOINT_TOPLEFT, 0.255, 0.60)
		BlzFrameSetAbsPoint(frame.upperButtonBar.chatButton, FRAMEPOINT_TOPLEFT, 0.463, 0.60)

		-- Resource Bar
		BlzFrameClearAllPoints(frame.resource.frame)
		BlzFrameClearAllPoints(frame.resource.goldText)
		BlzFrameClearAllPoints(frame.resource.lumberText)
		BlzFrameSetAbsPoint(frame.resource.frame, FRAMEPOINT_TOPLEFT, 0.0, 1.5)
		BlzFrameSetAbsPoint(frame.resource.goldText, FRAMEPOINT_TOPLEFT, x + 0.073, y + 0.213)
		BlzFrameSetAbsPoint(frame.resource.lumberText, FRAMEPOINT_TOPLEFT, 0, 1.5)
		BlzFrameSetAbsPoint(frame.resource.upkeepText, FRAMEPOINT_TOPRIGHT, 0, 1.5)
		BlzFrameSetAbsPoint(frame.resource.supplyText, FRAMEPOINT_TOPRIGHT, 0, 1.5)


        BlzFrameClearAllPoints(frame.hero.bar)
		BlzFrameClearAllPoints(frame.hero.hp[1])

		BlzFrameSetAbsPoint(frame.hero.bar, FRAMEPOINT_TOPLEFT, x + 0.01, y + 0.214)
		BlzFrameSetScale(frame.hero.button[1], 1.25)
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

