--
-- Game Action Triggers
--
-- Hero Levels Up
function Init_HeroLevelsUp()
	local t = CreateTrigger()

	TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_HERO_LEVEL)
	TriggerAddAction(t, function()

		-- Run the default Level up stuff
		HERO.GET(GetLevelingUnit()):LevelUp()
	end)
end

-- Unit Casts Spell
function Init_UnitCastsSpell()
	trig_CastSpell = CreateTrigger()
	TriggerRegisterAnyUnitEventBJ(trig_CastSpell, EVENT_PLAYER_UNIT_SPELL_CAST)

	TriggerAddAction(trig_CastSpell, function()
		local triggerUnit = GetTriggerUnit()
		local order = OrderId2String(GetUnitCurrentOrder(triggerUnit))
		local spellCast = CC2Four(GetSpellAbilityId())

		try(function() CAST_aiHero(triggerUnit, spellCast) end, "CAST_aiHero")
	end)
end

-- Unit enters the Map
function Init_UnitEntersMap()
	-- DisableTrigger(Trig_UnitEntersMap)
	TriggerRegisterEnterRectSimple(Trig_UnitEntersMap, GetPlayableMapRect())
	TriggerAddAction(Trig_UnitEntersMap, function()
		local triggerUnit = GetTriggerUnit()

		if not IsUnitType(triggerUnit, UNIT_TYPE_HERO) and not IsUnitType(triggerUnit, UNIT_TYPE_STRUCTURE) then
			-- print(GetUnitName(triggerUnit) .. " Entered MAP MOVED")
			UNIT.NEW(unit)

			unitKeepMoving(triggerUnit, true)
		end
	end)
end

-- Unit Issued Target or no Target Order
function Init_IssuedOrder()

	TriggerRegisterAnyUnitEventBJ(Trig_IssuedOrder, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
	TriggerRegisterAnyUnitEventBJ(Trig_IssuedOrder, EVENT_PLAYER_UNIT_ISSUED_ORDER)
	TriggerRegisterAnyUnitEventBJ(Trig_IssuedOrder, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
	TriggerRegisterAnyUnitEventBJ(Trig_IssuedOrder, EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER)

	TriggerAddAction(Trig_IssuedOrder, function()
		local triggerUnit = GetTriggerUnit()
		local unitIdType = GetUnitTypeId(triggerUnit)

		unitKeepMoving(triggerUnit, false, GetIssuedOrderId())
	end)

end

-- Unit Dies
function Init_UnitDies()
	TriggerRegisterAnyUnitEventBJ(Trig_UnitDies, EVENT_PLAYER_UNIT_DEATH)
	TriggerAddAction(Trig_UnitDies, function()

		local dieingUnit = GetTriggerUnit()

		if IsUnitInGroup(dieingUnit, base.all.g) then base.died(dieingUnit) end

		if GetUnitTypeId(dieingUnit) == FourCC("n019") then
			local u
			local player = GetOwningPlayer(dieingUnit)

			if player == Player(20) then
				shieldTowers.allied = shieldTowers.allied - 1

				if shieldTowers.allied == 0 then
					u = gg_unit_h003_0015
					UnitRemoveAbility(u, FourCC("A02C"))
					BlzSetUnitName(u, "Arcane Citadel |cffff0000(Vulnerable)|r")
				end
			else
				shieldTowers.fed = shieldTowers.fed - 1
				if shieldTowers.fed == 0 then
					u = gg_unit_h003_0007
					UnitRemoveAbility(u, FourCC("A02C"))
					BlzSetUnitName(u, "Arcane Citadel |cffff0000(Vulnerable)|r")
				end
			end

		end
		-- Remove Index from Unit
		if not IsUnitType(dieingUnit, UNIT_TYPE_HERO) then
			PolledWait(10)
			UNIT.REMOVE(dieingUnit)
		end

	end)
end

-- Unit Enters region (Special)
function init_MoveToNext()
	TriggerAddAction(Trig_moveToNext, function()

		local triggerUnit = GetTriggerUnit()
		local player = GetOwningPlayer(triggerUnit)
		local isAllied = IsPlayerInForce(player, udg_PLAYERGRPallied)
		local isFed = IsPlayerInForce(player, udg_PLAYERGRPfederation)

		if not IsUnitType(triggerUnit, UNIT_TYPE_HERO) then
			if isAllied or isFed then
				local region = loc:getRegion(GetTriggeringRegion())

				if (isAllied and region.allied) or (isFed and region.fed) then
					local x, y = loc:getRandomXY(region.next)
					indexer:updateEnd(triggerUnit, x, y)
					indexer:order(triggerUnit)
				end
			end
		end
	end)
end

function init_Moonwell_cast()
	local t = CreateTrigger()
	TriggerRegisterTimerEventPeriodic(t, 4)
	TriggerAddAction(t, function()

		local l, u2
		local g = CreateGroup()
		local g2 = CreateGroup()

		g = GetUnitsOfTypeIdAll(FourCC("h024"))

		local u = FirstOfGroup(g)
		while u ~= nil do

			if GetUnitManaPercent(u) > 10 and BlzGetUnitAbilityCooldownRemaining(u, oid.recharge) == 0 then

				l = GetUnitLoc(u)
				g2 = GetUnitsInRangeOfLocAll(1200, l)
				RemoveLocation(l)

				u2 = FirstOfGroup(g2)
				while u2 ~= nil do

					if IsUnitType(u2, UNIT_TYPE_STRUCTURE) and GetUnitTypeId(u2) ~= FourCC("h024") and GetUnitManaPercent(u2) < 40 and
									GetUnitState(u2, UNIT_STATE_MAX_MANA) > 0 then
						DisableTrigger(Trig_IssuedOrder)
						IssueTargetOrderById(u, oid.recharge, u2)
						EnableTrigger(Trig_IssuedOrder)
					end

					GroupRemoveUnit(g2, u2)
					u2 = FirstOfGroup(g2)
				end
				DestroyGroup(g2)

			end

			GroupRemoveUnit(g, u)
			u = FirstOfGroup(g)
		end

		DestroyGroup(g)
	end)
end

-- Update Base Buildings
function init_BaseLoop()
	TriggerRegisterTimerEventPeriodic(Trig_baseLoop, 2.5)
	TriggerAddAction(Trig_baseLoop, function()

		local u, id
		local g = CreateGroup()

		GroupAddGroup(base.all.g, g)
		while true do
			u = FirstOfGroup(g)
			if u == nil then break end

			base.update(u)

			GroupRemoveUnit(g, u)
		end
		DestroyGroup(g)
	end)
end

do
	local real = MarkGameStarted
	function MarkGameStarted()
		real()
		local trigger = CreateTrigger()
		for i = 0, 11 do BlzTriggerRegisterPlayerKeyEvent(trigger, Player(i), OSKEY_G, 0, true) end
		TriggerAddAction(trigger, function()

			local player = GetTriggerPlayer()
			local playerDetails = PLAYERS[GetConvertedPlayerId(player)]
			SelectUnitForPlayerSingle(playerDetails.alter, player)
		end)

		trigger = CreateTrigger()
		for i = 0, 11 do BlzTriggerRegisterPlayerKeyEvent(trigger, Player(i), OSKEY_F, 0, true) end

		TriggerAddAction(trigger, function()

			local player = GetTriggerPlayer()
			local playerDetails = PLAYERS[GetConvertedPlayerId(player)]
			SelectUnitForPlayerSingle(playerDetails.hero, player)
		end)
	end
end

--
-- Trigger Functions
-----------------

-- Order starting units to attack
function orderStartingUnits()
	local g = CreateGroup()
	local u, typeId

	g = GetUnitsInRectAll(GetPlayableMapRect())
	while true do
		u = FirstOfGroup(g)
		if u == nil then break end

		try(function()

			indexer:add(u)
			unitKeepMoving(u, true)
		end)

		GroupRemoveUnit(g, u)
	end
	DestroyGroup(g)
end

-- Tell unit to keep Attack-Moving to it's indexed destination
---comment
---@param u unit
---@param withoutDelay boolean
function unitKeepMoving(u, withoutDelay, orderId)
	withoutDelay = withoutDelay or false
	local unit = UNIT.GET(u)
	
	orderId = orderId or unit:OrderCurrent()
	
	local typeId = unit.unitTypeId
	local owningPlayer = unit:Player()

	if owningPlayer ~= Player(PLAYER_NEUTRAL_AGGRESSIVE) and unit:Life() > 0 and not unit:IsType(UNIT_TYPE_STRUCTURE) and
					not unit:IsType(UNIT_TYPE_HERO) and not unit:HasBuff("B006") and typeIdTable[typeId] == nil and
					ordersIgnore[orderId] == nil then

		if not withoutDelay then
			PolledWait(3)
		end

		unit:OrderAgain()

	end
end
