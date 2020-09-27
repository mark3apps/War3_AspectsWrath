function errorHandler( err )
   BJDebugMsg( "ERROR:", err )
end

function AI_MAIN()



	BJDebugMsg(" -- ")
	local pickedHero = mapAI.heroOptions[AI_Loop]
    
    mapAI.updateIntel(pickedHero)

	if mapAI.isAlive(pickedHero) then	
		mapAI.STATELowHealth(pickedHero)
        mapAI.STATEHighHealth(pickedHero)
        mapAI.STATEFleeing(pickedHero)
        mapAI.STATEStopFleeing(pickedHero)
		mapAI.STATEDead(pickedHero)
	else
		mapAI.STATERevived(pickedHero)
	end
	
    if (AI_Loop >= mapAI.count) then
        AI_Loop = 1
    else
        AI_Loop = (AI_Loop + 1)
    end
end

function InitTrig_AI_MAIN()
	Trig_AI_MAIN = CreateTrigger()
    TriggerAddAction(Trig_AI_MAIN, AI_MAIN)
end




function Computer_Picks()

    local i = 1
    local randInt
	local count = 12
    local x
    local y
    local selPlayer
    local g
    local u

	AI_Loop = 1

    while (i <= count) do
        
        selPlayer = ConvertedPlayer(i)
		if (GetPlayerController(selPlayer) == MAP_CONTROL_COMPUTER) then

            if (IsPlayerAlly(selPlayer, ForcePickRandomPlayer(udg_PLAYERGRPallied)) == true) then
                udg_INT_TeamNumber[i] = 1
                x = GetRectCenterX(gg_rct_Left_Hero)
                y = GetRectCenterY(gg_rct_Left_Hero)
            else
                udg_INT_TeamNumber[i] = 2
                x = GetRectCenterX(gg_rct_Right_Hero)
                y = GetRectCenterY(gg_rct_Right_Hero)
			end
			
            randInt = GetRandomInt(1, 5)
            if (randInt == 1) then
                udg_TEMP_Unit = CreateUnit(selPlayer, FourCC("E001"), x, y, 0)
				
            elseif (randInt == 2) then
                udg_TEMP_Unit = CreateUnit(selPlayer, FourCC("H00R"), x, y, 0)
				
            elseif (randInt == 3) then
                udg_TEMP_Unit = CreateUnit(selPlayer, FourCC("E002"), x, y, 0)
				
            elseif (randInt == 4) then
                udg_TEMP_Unit = CreateUnit(selPlayer, FourCC("H009"), x, y, 0)
				
            elseif (randInt == 5) then
                udg_TEMP_Unit = CreateUnit(selPlayer, FourCC("H00J"), x, y, 0)
            end
			
			UnitAddItemByIdSwapped(FourCC("I000"), udg_TEMP_Unit)
			udg_UNIT_pickedHero[GetConvertedPlayerId(selPlayer)] = udg_TEMP_Unit
			ConditionalTriggerExecute(gg_trg_Hero_Add_Starting_Abilities)
			
			BJDebugMsg("Creating New Hero")
			mapAI.initHero(udg_TEMP_Unit)
			BJDebugMsg("Finished Creating New hero")
			
            g = GetUnitsOfPlayerAndTypeId(selPlayer, FourCC("halt"))

            while true do
                u = FirstOfGroup(g)
                if u == nil then break end

                if (GetUnitTypeId(udg_TEMP_Unit) == FourCC("E001")) then
                    ReplaceUnitBJ(u, FourCC("h00I"), bj_UNIT_STATE_METHOD_RELATIVE)

                elseif (GetUnitTypeId(udg_TEMP_Unit) == FourCC("H00R")) then
                    ReplaceUnitBJ(u, FourCC("h00B"), bj_UNIT_STATE_METHOD_RELATIVE)

                elseif (GetUnitTypeId(udg_TEMP_Unit) == FourCC("H009")) then
                    ReplaceUnitBJ(u, FourCC("h00Y"), bj_UNIT_STATE_METHOD_RELATIVE)

                elseif (GetUnitTypeId(udg_TEMP_Unit) == FourCC("H00J")) then
                    ReplaceUnitBJ(u, FourCC("h00Z"), bj_UNIT_STATE_METHOD_RELATIVE)

                elseif (GetUnitTypeId(udg_TEMP_Unit) == FourCC("E002")) then
                    ReplaceUnitBJ(u, FourCC("h00Q"), bj_UNIT_STATE_METHOD_RELATIVE)

                    UnitMakeAbilityPermanent(udg_TEMP_Unit, true, FourCC("A031"))
                    UnitMakeAbilityPermanent(udg_TEMP_Unit, true, FourCC("A005"))
                    UnitMakeAbilityPermanent(udg_TEMP_Unit, true, FourCC("A037"))
                end
                
                udg_Alters[GetConvertedPlayerId(selPlayer)] = GetLastReplacedUnitBJ()

                GroupRemoveUnit(g, u)
            end
            DestroyGroup(g)

		end
		

        if (i >= 12 and mapAI.count > 0) then
            BJDebugMsg("Heroes:" .. I2S(mapAI.count))
			TriggerRegisterTimerEvent(Trig_AI_MAIN, 1.50, true)
		end
		
        i = i + 1
    end
end

function InitTrig_Computer_Picks()
    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 0.50)
    TriggerAddAction(t, Computer_Picks)
end