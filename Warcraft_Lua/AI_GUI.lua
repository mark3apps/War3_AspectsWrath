

function Trig_AI_MAIN_Snapshot_Func001Func019Func020Func008Func003Func006C()
    if (udg_AI_Strat_CalculateClumpAlly[udg_AI_Loop] == true) then
        return true
    end
    if (udg_AI_Strat_CalculateClumpComb[udg_AI_Loop] == true) then
        return true
    end
    return false
end

function Trig_AI_MAIN_Snapshot_Func001Func019Func020Func008Func003C()
    if (not (IsUnitAlly(GetEnumUnit(), GetOwningPlayer(udg_AI_Hero[udg_AI_Loop])) == true)) then
        return false
    end
    if (not (IsUnitType(GetEnumUnit(), UNIT_TYPE_STRUCTURE) == false)) then
        return false
    end
    if (not (IsUnitAliveBJ(GetEnumUnit()) == true)) then
        return false
    end
    if (not (GetEnumUnit() ~= udg_AI_Hero[udg_AI_Loop])) then
        return false
    end
    if (not Trig_AI_MAIN_Snapshot_Func001Func019Func020Func008Func003Func006C()) then
        return false
    end
    return true
end

function Trig_AI_MAIN_Snapshot_Func001Func019Func020Func008Func006Func006C()
    if (udg_AI_Strat_CalculateClumpComb[udg_AI_Loop] == true) then
        return true
    end
    if (udg_AI_Strat_CalculateClumpEnemy[udg_AI_Loop] == true) then
        return true
    end
    return false
end

function Trig_AI_MAIN_Snapshot_Func001Func019Func020Func008Func006C()
    if (not (IsUnitEnemy(GetEnumUnit(), GetOwningPlayer(udg_AI_Hero[udg_AI_Loop])) == true)) then
        return false
    end
    if (not (IsUnitType(GetEnumUnit(), UNIT_TYPE_STRUCTURE) == false)) then
        return false
    end
    if (not (IsUnitAliveBJ(GetEnumUnit()) == true)) then
        return false
    end
    if (not (GetEnumUnit() ~= udg_AI_Hero[udg_AI_Loop])) then
        return false
    end
    if (not Trig_AI_MAIN_Snapshot_Func001Func019Func020Func008Func006Func006C()) then
        return false
    end
    return true
end

function Trig_AI_MAIN_Snapshot_Func001Func019Func020Func008A()
    if (Trig_AI_MAIN_Snapshot_Func001Func019Func020Func008Func003C()) then
        udg_TEMP_A_REAL[4] = (udg_TEMP_A_REAL[4] + SquareRoot(I2R(GetUnitPointValue(GetEnumUnit()))))
    else
    end
    if (Trig_AI_MAIN_Snapshot_Func001Func019Func020Func008Func006C()) then
        udg_TEMP_A_REAL[5] = (udg_TEMP_A_REAL[5] + SquareRoot(I2R(GetUnitPointValue(GetEnumUnit()))))
    else
    end
end


function Trig_AI_MAIN_Snapshot_Actions()
	if (udg_AI_B_Alive[udg_AI_Loop] == true) then
		
        udg_AI_T_HeroesInRangeFriendly = GetUnitsOfTypeIdAll(0)
        udg_AI_T_HeroesInRangeEnemy = GetUnitsOfTypeIdAll(0)
		udg_AI_T_HeroPosition = GetUnitLoc(udg_AI_Hero[udg_AI_Loop])

		local heroX = GetUnitX(udg_AI_Hero[udg_AI_Loop])
		local heroY = GetUnitY(udg_AI_Hero[udg_AI_Loop])
		local g = CreateGroup()
		
        if (udg_AI_B_Fleeing[udg_AI_Loop] == true or udg_AI_B_Low_Health[udg_AI_Loop] == true) then
            if (IsUnitAliveBJ(udg_AI_HealDestination[udg_AI_Loop]) == true) then
                udg_AI_T_DestinationPosition = GetUnitLoc(udg_AI_HealDestination[udg_AI_Loop])
            else
                ConditionalTriggerExecute(gg_trg_AI_Go_To_Closest_Heal)
            end
        else
            if (udg_AI_B_Chasing[udg_AI_Loop] == true) then
                udg_AI_T_DestinationPosition = GetUnitLoc(udg_AI_ChaseHero[udg_AI_Loop])
            else
                if (IsUnitAliveBJ(udg_AI_Destination[udg_AI_Loop]) == true) then
                    udg_AI_T_DestinationPosition = GetUnitLoc(udg_AI_Destination[udg_AI_Loop])
                else
                    ConditionalTriggerExecute(gg_trg_AI_Attack_a_Base)
                end
            end
		end
		
		udg_AI_T_Units = GetUnitsInRangeOfLocMatching(1000.00, udg_AI_T_HeroPosition, Condition(Trig_AI_MAIN_Snapshot_Func001Func018002003))

		local v

		GroupEnumUnitsInRange(g, heroX, heroY, 1000, null)

		v = FirstOfGroup(g)
		repeat
			
			-- body
			if (IsUnitAliveBJ(GetFilterUnit()) == true and GetFilterUnit() ~= udg_AI_Hero[udg_AI_Loop]) then
				
 				if (IsUnitType(v, UNIT_TYPE_HERO) == true) then
					udg_TEMP_A_INT[1] = (GetHeroLevel(v) * 75)
					udg_TEMP_A_INT[2] = 1
					
					if (IsUnitAlly(v, GetOwningPlayer(udg_AI_Hero[udg_AI_Loop])) == true) then
						GroupAddUnitSimple(v, udg_AI_T_HeroesInRangeFriendly)
					else
						GroupAddUnitSimple(v, udg_AI_T_HeroesInRangeEnemy)
					end
				else
					udg_TEMP_A_INT[1] = GetUnitPointValue(v)
					udg_TEMP_A_INT[2] = 1
				end
				
				udg_TEMP_A_UNIT[1] = v
				udg_TEMP_Pos2 = GetUnitLoc(v)
				local unitX = GetUnitX(v)
				local unitY = GetUnitY(v)

				
				udg_TEMP_A_REAL[1] = DistanceBetweenPoints(udg_AI_T_HeroPosition, udg_TEMP_Pos2)
				udg_TEMP_A_REAL[2] = GetUnitLifePercent(v)
				udg_TEMP_A_REAL[3] = BlzGetUnitWeaponRealField(v, UNIT_WEAPON_RF_ATTACK_RANGE, 0)
				udg_TEMP_A_REAL[4] = 0.00
				
				if (IsUnitAlly(v, GetOwningPlayer(udg_AI_Hero[udg_AI_Loop])) == true) then
					
					if (udg_TEMP_A_INT[1] > GetUnitPointValue(udg_AI_T_PowerfulUnitAlly)) then
						udg_AI_T_PowerfulUnitAlly = v
					end
					
					if (udg_TEMP_A_REAL[1] <= 500.00) then
						udg_AI_T_CloseCountFriendly = (udg_AI_T_CloseCountFriendly + udg_TEMP_A_INT[2])
					end
					
					udg_AI_T_PowerFriendly = (udg_AI_T_PowerFriendly + R2I(((I2R(udg_TEMP_A_INT[1]) * (udg_TEMP_A_REAL[2] / 100.00)) / (udg_TEMP_A_REAL[1] / udg_TEMP_A_REAL[3]))))
				else
					
					if (udg_TEMP_A_INT[1] > GetUnitPointValue(udg_AI_T_PowerfulUnitEnemy)) then
						udg_AI_T_PowerfulUnitEnemy = v
					end
					
					if (udg_TEMP_A_REAL[1] <= 500.00) then
						udg_AI_T_CloseCountEnemy = (udg_AI_T_CloseCountEnemy + udg_TEMP_A_INT[2])
					end
					
					udg_AI_T_PowerEnemy = (udg_AI_T_PowerEnemy + R2I(((I2R(udg_TEMP_A_INT[1]) * (udg_TEMP_A_REAL[2] / 100.00)) / (udg_TEMP_A_REAL[1] / udg_TEMP_A_REAL[3]))))
				end
				
				if (dg_AI_Strat_CalculateClumpAlly[udg_AI_Loop] == true or udg_AI_Strat_CalculateClumpComb[udg_AI_Loop] == true or udg_AI_Strat_CalculateClumpEnemy[udg_AI_Loop] == true) then
					udg_TEMP_A_REAL[4] = 0.00
					udg_TEMP_A_REAL[5] = 0.00
					
					udg_TEMP_UnitGroup = GetUnitsInRangeOfLocAll(udg_AI_Strat_CalculateClumpRange[udg_AI_Loop], udg_TEMP_Pos2)
					ForGroupBJ(udg_TEMP_UnitGroup, Trig_AI_MAIN_Snapshot_Func001Func019Func020Func008A)

					local g = CreateGroup()
					
					DestroyGroup ( udg_TEMP_UnitGroup )
					
					if (udg_TEMP_A_REAL[4] > udg_AI_T_ClumpAllyScore and (udg_AI_Strat_CalculateClumpAlly[udg_AI_Loop] == true or udg_AI_Strat_CalculateClumpComb[udg_AI_Loop] == true)) then
						udg_AI_T_ClumpAllyScore = udg_TEMP_A_REAL[4]
						udg_AI_T_ClumpAllyUnit = udg_TEMP_A_UNIT[1]
					end
					
					if (udg_TEMP_A_REAL[5] > udg_AI_T_ClumpEnemyScore and (udg_AI_Strat_CalculateClumpEnemy[udg_AI_Loop] == true or udg_AI_Strat_CalculateClumpComb[udg_AI_Loop] == true)) then
						udg_AI_T_ClumpEnemyScore = udg_TEMP_A_REAL[5]
						udg_AI_T_ClumpEnemyUnit = udg_TEMP_A_UNIT[1]
					end
					
					if ((udg_TEMP_A_REAL[4] + udg_TEMP_A_REAL[5]) > udg_AI_T_ClumpCombinedScore and udg_AI_Strat_CalculateClumpComb[udg_AI_Loop] == true ) then
						udg_AI_T_ClumpCombinedScore = (udg_TEMP_A_REAL[4] + udg_TEMP_A_REAL[5])
						udg_AI_T_ClumpCombinedUnit = udg_TEMP_A_UNIT[1]
					end
					
				end
				
				RemoveLocation ( udg_TEMP_Pos2 )
			end
			

			GroupRemoveUnit(g, v)
			v = FirstOfGroup(g)
		until ( v == null )
		DestroyGroup(g)

		

		
        udg_TEMP_IntLoop1 = 1
        while (true) do
            if (udg_TEMP_IntLoop1 > 3) then break end
            udg_AI_Snaps_Health[((udg_AI_Loop * 3) + (3 - udg_TEMP_IntLoop1))] = udg_AI_Snaps_Health[((udg_AI_Loop * 3) + (2 - udg_TEMP_IntLoop1))]
            udg_TEMP_IntLoop1 = udg_TEMP_IntLoop1 + 1
		end
		
        udg_AI_Snaps_Health[(udg_AI_Loop * 3)] = GetUnitLifePercent(udg_AI_Hero[udg_AI_Loop])
        udg_AI_T_HealthCurrent = GetUnitStateSwap(UNIT_STATE_LIFE, udg_AI_Hero[udg_AI_Loop])
        udg_AI_T_ManaCurrent = GetUnitStateSwap(UNIT_STATE_MANA, udg_AI_Hero[udg_AI_Loop])
        udg_AI_T_SnapLifeCurrent = ((udg_AI_T_HealthCurrent * udg_AI_Strat_Heal_HealthFactor[udg_AI_Loop]) + (udg_AI_T_ManaCurrent * udg_AI_Strat_Heal_ManaFactor[udg_AI_Loop]))
        udg_AI_T_SnapLifeMax = ((GetUnitStateSwap(UNIT_STATE_MAX_LIFE, udg_AI_Hero[udg_AI_Loop]) * udg_AI_Strat_Heal_HealthFactor[udg_AI_Loop]) + (GetUnitStateSwap(UNIT_STATE_MAX_MANA, udg_AI_Hero[udg_AI_Loop]) * udg_AI_Strat_Heal_ManaFactor[udg_AI_Loop]))
        udg_AI_T_SnapLifePercent = ((udg_AI_T_SnapLifeCurrent / udg_AI_T_SnapLifeMax) * 100.00)
        udg_AI_T_HealthLost1 = (udg_AI_Snaps_Health[((udg_AI_Loop * 3) + 1)] - udg_AI_Snaps_Health[((udg_AI_Loop * 3) + 0)])
        udg_AI_T_HealthLostAll = (udg_AI_Snaps_Health[((udg_AI_Loop * 3) + 2)] - udg_AI_Snaps_Health[((udg_AI_Loop * 3) + 0)])
        udg_AI_T_PowerEnemy = R2I((I2R(udg_AI_T_PowerEnemy) * (((100.00 - udg_AI_T_SnapLifePercent) / 20.00) + 0.50)))
        udg_AI_T_PowerCount = (udg_AI_T_PowerEnemy - udg_AI_T_PowerFriendly)
        udg_AI_Strat_Power_Base[udg_AI_Loop] = (udg_AI_Strat_Power_Base[udg_AI_Loop] + (0.25 * I2R(GetHeroLevel(udg_AI_Hero[udg_AI_Loop]))))
        udg_AI_T_PowerHero = (R2I(udg_AI_Strat_Power_Base[udg_AI_Loop]) + (R2I(udg_AI_Strat_Power_LevelFactor[udg_AI_Loop]) * GetHeroLevel(udg_AI_Hero[udg_AI_Loop])))
    else
    end
end

function InitTrig_AI_MAIN_Snapshot()
    gg_trg_AI_MAIN_Snapshot = CreateTrigger()
    DisableTrigger(gg_trg_AI_MAIN_Snapshot)
    TriggerAddAction(gg_trg_AI_MAIN_Snapshot, Trig_AI_MAIN_Snapshot_Actions)
end



InitTrig_AI_MAIN_Snapshot()
