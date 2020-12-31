
function AI_MAIN()


	--print(" -- ")
	local pickedHero = mapAI.heroOptions[AI_Loop]

	-- debugfunc( function()
	-- 	mapAI:STATEAbilities(pickedHero)
	-- end, "mapAI:castSpell")

	mapAI:updateIntel(pickedHero)
   
	if mapAI:isAlive(pickedHero) then
		mapAI:STATEDead(pickedHero)	
		mapAI:STATELowHealth(pickedHero)
		mapAI:STATEStopFleeing(pickedHero)
		mapAI:STATEFleeing(pickedHero)
		mapAI:STATEHighHealth(pickedHero)
		mapAI:STATEAbilities(pickedHero)
		mapAI:STATEcastingSpell(pickedHero)
		mapAI:CleanUp(pickedHero)
    else
        mapAI:STATERevived(pickedHero)
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

            if (i < 7) then
                udg_INT_TeamNumber[i] = 1
                x = GetRectCenterX(gg_rct_Left_Hero)
                y = GetRectCenterY(gg_rct_Left_Hero)
            else
                udg_INT_TeamNumber[i] = 2
                x = GetRectCenterX(gg_rct_Right_Hero)
                y = GetRectCenterY(gg_rct_Right_Hero)
			end
			
            randInt = GetRandomInt(2, 5)
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
			mapAI:initHero(udg_TEMP_Unit)
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
			aiTick = 1.00/I2R(mapAI.count)
			TriggerRegisterTimerEvent(Trig_AI_MAIN, aiTick, true)
			
		end
		
        i = i + 1
    end
end

function InitTrig_Computer_Picks()
    local t = CreateTrigger()
    TriggerRegisterTimerEventSingle(t, 0.50)
    TriggerAddAction(t, Computer_Picks)
end

function InitTrig_AI_Spell_Start()
	local t = CreateTrigger()
	TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_CAST)

	TriggerAddCondition(t, Condition( function()
		return IsUnitInGroup(GetTriggerUnit(), udg_AI_Heroes)
	end))
	
	TriggerAddAction(t, function()

		debugfunc( function()
			local pickedHero = mapAI.heroOptions[S2I(GetUnitUserData(GetTriggerUnit()))]

			mapAI:castSpell(pickedHero)
		end, "mapAI:castSpell")
	end)
end


function InitTrig_Hero_Level_Up()
	local t = CreateTrigger()
	
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_HERO_LEVEL)
	TriggerAddAction(t, function()

		-- Get Locals
		local heroLevel = GetHeroLevel(GetLevelingUnit())
		local u = GetLevelingUnit()
		local uType = GetUnitTypeId(u)

		-- Remove Ability Points
		if (heroLevel < 15 and ModuloInteger(heroLevel, 2) ~= 0) then
			ModifyHeroSkillPoints(GetLevelingUnit(), bj_MODIFYMETHOD_SUB, 1)
		elseif (heroLevel < 25 and heroLevel >= 15 and ModuloInteger(heroLevel, 3) ~= 0) then
			ModifyHeroSkillPoints(GetLevelingUnit(), bj_MODIFYMETHOD_SUB, 1)
		elseif (heroLevel >= 25 and ModuloInteger(heroLevel, 4) ~= 0) then
			ModifyHeroSkillPoints(GetLevelingUnit(), bj_MODIFYMETHOD_SUB, 1)
		end


		-- If Computer, Learn Abilities
		if GetPlayerController( GetOwningPlayer(u) ) == MAP_CONTROL_COMPUTER then

			if uType == FourCC("H00R") then      -- Mana Addict
				SelectHeroSkill(u, FourCC("A015"))  -- Starfall
				SelectHeroSkill(u, FourCC("A001"))  -- Mana Shield
				SelectHeroSkill(u, FourCC("A03S"))  -- Frost Nova
				SelectHeroSkill(u, FourCC("A018"))  -- Mana Overload
				SelectHeroSkill(u, FourCC("A02B"))  -- Mana Burst
				
			elseif uType == FourCC("E001") then  -- Brawler
				SelectHeroSkill(u, FourCC("A029"))  -- Unleash Rage
				SelectHeroSkill(u, FourCC("A01Y"))  -- Drain
				SelectHeroSkill(u, FourCC("A007"))  -- Bloodlust
				SelectHeroSkill(u, FourCC("A002"))  -- War Stomp
				
			elseif uType == FourCC("E002") then  -- Shifter
				SelectHeroSkill(u, FourCC("A03C"))  -- Shifting Bladestorm
				SelectHeroSkill(u, FourCC("A02Y"))  -- Fel Form
				SelectHeroSkill(u, FourCC("A03U"))  -- Shift Back
				SelectHeroSkill(u, FourCC("A030"))  -- Shift Forwards
				SelectHeroSkill(u, FourCC("A03T"))  -- Falling Strike
				
			elseif uType == FourCC("H009") then  -- Tactition
				SelectHeroSkill(u, FourCC("A042"))  -- Inspire
				SelectHeroSkill(u, FourCC("A01I"))  -- Raise Banner
				SelectHeroSkill(u, FourCC("A01B"))  -- Attack
				SelectHeroSkill(u, FourCC("A01Z"))  -- Bolster
				SelectHeroSkill(u, FourCC("A019"))  -- Iron Defense
				
			elseif uType == FourCC("H00J") then  -- Time Mage
				SelectHeroSkill(u, FourCC("A04N"))  -- Paradox
				SelectHeroSkill(u, FourCC("A04I"))  -- Dimensional Phase
				SelectHeroSkill(u, FourCC("A04P"))  -- Time Travel
				SelectHeroSkill(u, FourCC("A04K"))  -- Chrono Atrophy
				SelectHeroSkill(u, FourCC("A032"))  -- Decay
			end
		end
	end )
end