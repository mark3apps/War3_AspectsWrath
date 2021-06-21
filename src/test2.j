function UISetup takes nothing returns nothing
	//Local Variables
	local framehandle fh = null
	local framehandle chatButton = null
	local framehandle questButton = null
	local framehandle allyButton = null
	local framehandle MiniMap = null
	local framehandle gridButtons = null
	local framehandle imageTest = BlzCreateFrameByType("BACKDROP", "image", BlzGetFrameByName("ConsoleUIBackdrop", 0), "ButtonBackdropTemplate", 0)
	
	//Top UI & System Buttons
	set fh = BlzGetFrameByName("UpperButtonBarFrame", 0)
	call BlzFrameSetVisible(fh, true)
	set allyButton = BlzGetFrameByName("UpperButtonBarAlliesButton", 0)
	set fh = BlzGetFrameByName("UpperButtonBarMenuButton", 0)
	set chatButton = BlzGetFrameByName("UpperButtonBarChatButton", 0)
	set questButton = BlzGetFrameByName("UpperButtonBarQuestsButton", 0)
	call BlzFrameClearAllPoints(fh)
	call BlzFrameClearAllPoints(allyButton)
	call BlzFrameClearAllPoints(chatButton)
	call BlzFrameClearAllPoints(questButton)
	call BlzFrameSetAbsPoint(questButton, FRAMEPOINT_TOPLEFT, 0.77, 0.6)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_TOPLEFT, 0.85, 0.6)
	call BlzFrameSetAbsPoint(allyButton, FRAMEPOINT_TOPLEFT, 0.77, 0.583)
	call BlzFrameSetAbsPoint(chatButton, FRAMEPOINT_TOPLEFT, 0.85, 0.583)
	
	//Hiding clock UI and creating new frame bar
	call BlzFrameSetTexture(imageTest, "UI\\ResourceBar.tga", 0, true)
	call BlzFrameSetPoint(imageTest, FRAMEPOINT_TOP, BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0), FRAMEPOINT_TOP, 0, 0)
	call BlzFrameSetSize(imageTest, 0.4, 0.025)
	call BlzFrameSetVisible(BlzFrameGetChild(BlzFrameGetChild(BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 5), 0), false)
	call BlzFrameSetLevel(imageTest, 1)
	
	//Food
	set fh = BlzGetFrameByName("ResourceBarSupplyText", 0)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_TOPRIGHT, 0.58, 0.5965)
	
	//Upkeep
	set fh = BlzGetFrameByName("ResourceBarUpkeepText", 0)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_TOPRIGHT, 0.295, 0.5965)
	
	//Gold
	set fh = BlzGetFrameByName("ResourceBarGoldText", 0)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_TOPRIGHT, 0.389, 0.5965)
	
	//Lumber
	set fh = BlzGetFrameByName("ResourceBarLumberText", 0)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_TOPRIGHT, 0.485, 0.5965)
	
	//Bottom UI & Idle Worker Icon
	set fh = BlzGetFrameByName("ConsoleUI", 0)
	set fh = BlzFrameGetChild(fh, 7)
	call BlzFrameClearAllPoints(fh)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_TOPRIGHT, 0.09, 0.179)
	
	//Remove Deadspace
	set fh = BlzGetFrameByName("ConsoleUI", 0)
	call BlzFrameSetVisible(BlzFrameGetChild(fh, 5), false)
	
	//Minimap
	set MiniMap = BlzGetFrameByName("MiniMapFrame", 0)
	call BlzFrameSetVisible(MiniMap, true)
	call BlzFrameClearAllPoints(MiniMap)
	call BlzFrameSetAbsPoint(MiniMap, FRAMEPOINT_BOTTOMLEFT, 0.0525, 0.0)
	call BlzFrameSetAbsPoint(MiniMap, FRAMEPOINT_TOPRIGHT, 0.2125, 0.141)
	
	//Minimap Buttons
	set fh = BlzGetFrameByName("MinimapSignalButton", 0)
	call BlzFrameClearAllPoints(fh)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_BOTTOMLEFT, 0.222, 0.116)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_TOPRIGHT, 0.242, 0.136)
	call BlzFrameSetTexture(fh, "UI\\ButtonBorder.dds", 0, true)
	set fh = BlzGetFrameByName("MiniMapAllyButton", 0)
	call BlzFrameClearAllPoints(fh)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_BOTTOMLEFT, 0.242, 0.116)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_TOPRIGHT, 0.262, 0.136)
	call BlzFrameSetTexture(fh, "UI\\ButtonBorder.dds", 0, true)
	set fh = BlzGetFrameByName("MiniMapTerrainButton", 0)
	call BlzFrameClearAllPoints(fh)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_BOTTOMLEFT, 0.262, 0.116)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_TOPRIGHT, 0.282, 0.136)
	call BlzFrameSetTexture(fh, "UI\\ButtonBorder.dds", 0, true)
	set fh = BlzGetFrameByName("MiniMapCreepButton", 0)
	call BlzFrameSetVisible(fh, false)
	set fh = BlzGetFrameByName("FormationButton", 0)
	call BlzFrameSetVisible(fh, false)
	
	//Minimap Border
	set fh = BlzCreateFrameByType("BACKDROP", "MinimapBorder", MiniMap, "", 0)
	call BlzFrameSetPoint(fh, FRAMEPOINT_TOPLEFT, MiniMap, FRAMEPOINT_TOPLEFT, 0, 0)
	call BlzFrameSetPoint(fh, FRAMEPOINT_BOTTOMRIGHT, MiniMap, FRAMEPOINT_BOTTOMRIGHT, 0, 0)
	call BlzFrameSetTexture(fh, "UI\\MiniMapBorder.dds", 0, true)
	
	//Tooltips
	set fh = BlzGetOriginFrame(ORIGIN_FRAME_TOOLTIP, 0)
	call BlzFrameSetVisible(fh, true)
	set fh = BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP, 0)
	call BlzFrameSetVisible(fh, true)
	call BlzFrameClearAllPoints(fh)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_BOTTOMRIGHT, 0.7725, 0.141)
	
	//Command Buttons
	set gridButtons = BlzGetFrameByName("CommandBarFrame", 0)
	call BlzFrameSetVisible(gridButtons, true)
	call BlzFrameClearAllPoints(gridButtons)
	call BlzFrameSetAbsPoint(gridButtons, FRAMEPOINT_BOTTOMLEFT, 0.5950, 0.005)
	
	//Backdrop
	set fh = BlzGetFrameByName("ConsoleUIBackdrop", 0)
	call BlzFrameClearAllPoints(fh)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_BOTTOMLEFT, 0.052, 0)
	call BlzFrameSetAbsPoint(fh, FRAMEPOINT_TOPRIGHT, 0.770, 0.141)
	
	//Command buttons border
	set fh = BlzCreateFrameByType("BACKDROP", "CommandBorder", MiniMap, "", 0)
	call BlzFrameSetPoint(fh, FRAMEPOINT_TOPLEFT, gridButtons, FRAMEPOINT_TOPLEFT, -0.007, 0.007)
	call BlzFrameSetPoint(fh, FRAMEPOINT_BOTTOMRIGHT, gridButtons, FRAMEPOINT_BOTTOMRIGHT, 0.0025, -0.005)
	call BlzFrameSetTexture(fh, "UI\\CommandCard.dds", 0, true)
	
	// Prevent multiplayer desyncs by forcing the creation of the QuestDialog frame
	call BlzFrameClick(BlzGetFrameByName("UpperButtonBarQuestsButton", 0))
	call ForceUICancel()
	
	// Expand TextArea
	call BlzFrameSetPoint(BlzGetFrameByName("QuestDisplay", 0), FRAMEPOINT_TOPLEFT, BlzGetFrameByName("QuestDetailsTitle", 0), FRAMEPOINT_BOTTOMLEFT, 0.003, -0.003)
	call BlzFrameSetPoint(BlzGetFrameByName("QuestDisplay", 0), FRAMEPOINT_BOTTOMRIGHT, BlzGetFrameByName("QuestDisplayBackdrop", 0), FRAMEPOINT_BOTTOMRIGHT, -0.003, 0.)
	
	// Relocate button
	call BlzFrameSetPoint(BlzGetFrameByName("QuestDisplayBackdrop", 0), FRAMEPOINT_BOTTOM, BlzGetFrameByName("QuestBackdrop", 0), FRAMEPOINT_BOTTOM, 0., 0.017)
	call BlzFrameClearAllPoints(BlzGetFrameByName("QuestAcceptButton", 0))
	call BlzFrameSetPoint(BlzGetFrameByName("QuestAcceptButton", 0), FRAMEPOINT_TOPRIGHT, BlzGetFrameByName("QuestBackdrop", 0), FRAMEPOINT_TOPRIGHT, -0.016, -0.016)
	call BlzFrameSetText(BlzGetFrameByName("QuestAcceptButton", 0), "×")
	call BlzFrameSetSize(BlzGetFrameByName("QuestAcceptButton", 0), 0.03, 0.03)

	// Add back ally resource icons
	call BlzFrameSetTexture(BlzGetFrameByName("InfoPanelIconAllyGoldIcon", 7), "UI\\RGReplacement.dds", 0, false)
	call BlzFrameSetTexture(BlzGetFrameByName("InfoPanelIconAllyWoodIcon", 7), "UI\\RLReplacement.dds", 0, false)
	call BlzFrameSetTexture(BlzGetFrameByName("InfoPanelIconAllyFoodIcon", 7), "UI\\RSReplacement.dds", 0, false)
	
endfunction

scope init initializer Init
private function Init takes nothing returns nothing
	call UISetup()
endfunction
endscope