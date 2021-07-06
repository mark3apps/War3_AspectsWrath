function init_gateClass()

	gate = {}
	gate.types = {}
	gate.typeIds = {}
	gate.g = CreateGroup()
	gate.gClosed = CreateGroup()
	gate.gOpen = CreateGroup()

	---Add a new Gate Type
	---@param unitTypeClosed unittype
	---@param unitTypeOpen unittype
	---@param rotation real
	---@return boolean
	function gate.addType(unitTypeClosed, unitTypeOpen, rotation)

		local data = {unitTypeClosed = FourCC(unitTypeClosed), unitTypeOpen = FourCC(unitTypeOpen), rotation = rotation}

		gate.types[FourCC(unitTypeOpen)] = data
		gate.types[FourCC(unitTypeClosed)] = data

		table.insert(gate.typeIds, unitTypeOpen)
		table.insert(gate.typeIds, unitTypeClosed)

		return true
	end

	---Add a new Gate to be monitored
	---@param unit unit
	---@param owningPlayer player
	function gate.add(unit, owningPlayer)

		local playerForce, facingAngle
		local unitTypeClosed ---@type unittype
		local unitTypeOpen ---@type unittype
		local unitType = GetUnitTypeId(unit)
		local x = GetUnitX(unit)
		local y = GetUnitY(unit)

		-- Find if unit is Allied or Fed
		if IsPlayerInForce(owningPlayer, udg_PLAYERGRPallied) then
			playerForce = "allied"
		else
			playerForce = "federation"
		end

		facingAngle = gate.types[unitType].rotation
		unitTypeOpen = gate.types[unitType].unitTypeOpen
		unitTypeClosed = gate.types[unitType].unitTypeClosed

		if playerForce == "federation" then
			facingAngle = facingAngle + 180

			if facingAngle >= 360 then facingAngle = facingAngle - 360 end
		end

		RemoveUnit(unit)
		unit = CreateUnit(owningPlayer, unitTypeOpen, x, y, facingAngle)

		-- Play animation
		SetUnitAnimation(unit, "Death Alternate 1")

		GroupAddUnit(gate.g, unit)
		GroupAddUnit(gate.gOpen, unit)

		local unitId = GetHandleId(unit)
		gate[unitId] = {}
		gate[unitId].force = playerForce
		gate[unitId].unitTypeClosed = unitTypeClosed
		gate[unitId].unitTypeOpen = unitTypeOpen
		gate[unitId].x = x
		gate[unitId].y = y
		gate[unitId].facing = facingAngle

	end

	---Update all Gates
	function gate.update()

		local gGates = CreateGroup()
		GroupAddGroup(gate.g, gGates)

		local pickedUnit = UNIT.GET(FirstOfGroup(gGates))
		while pickedUnit ~= nil do
			local u
			local heroes = 0
			local enemies = 0
			local unit = pickedUnit
			local info = gate[GetHandleId(unit.unit)] ---@type table
			local g = CreateGroup()


			GroupEnumUnitsInRange(g, unit:X(), unit:Y(), 700, nil)


			while true do
				u = FirstOfGroup(g)
				if u == nil then break end

				if not IsUnitAlly(u, unit:Player()) and IsUnitAliveBJ(u) then enemies = enemies + 1 end

				if IsUnitType(u, UNIT_TYPE_HERO) and IsUnitAlly(u, unit:Player()) then heroes = heroes + 1 end

				GroupRemoveUnit(g, u)
			end
			DestroyGroup(g)

			-- print("Enemies:" .. enemies .. " Heroes: " .. heroes)

			if enemies > 0 and heroes == 0 and IsUnitInGroup(unit.unit, gate.gOpen) then

				unit:GroupRemove(gate.gOpen)
				unit:GroupRemove(gate.g)

				gate[unit.handleId] = {}

				unit:SetTimeScale(-1)

				PolledWait(0.667)

				-- Replace Gate with Closed Gate
				DisableTrigger(gate.Trig_gateDies)
				ReplaceUnitBJ(unit.unit, info.unitTypeClosed, bj_UNIT_STATE_METHOD_RELATIVE)
				EnableTrigger(gate.Trig_gateDies)

				unit = UNIT.NEW(GetLastReplacedUnitBJ())
				gate[unit.handleId] = info
				unit:GroupAdd(gate.gClosed)
				unit:GroupAdd(gate.g)

			elseif (enemies == 0 or heroes > 0) and unit:InGroup(gate.gClosed) then
				unit:GroupRemove(gate.gClosed)
				unit:GroupRemove(gate.g)

				gate[unit.handleId] = {}

				-- Replace Gate with Opened Gate
				DisableTrigger(gate.Trig_gateDies)
				ReplaceUnitBJ(unit.unit, info.unitTypeOpen, bj_UNIT_STATE_METHOD_RELATIVE)
				EnableTrigger(gate.Trig_gateDies)

				unit = UNIT.NEW(GetLastReplacedUnitBJ())
				gate[unit.handleId] = info
				unit:GroupAdd(gate.gOpen)
				unit:GroupAdd(gate.g)

				-- Play animation
				unit:SetAnimation("Death Alternate 1")

			end

			pickedUnit:GroupRemove(gGates)
			pickedUnit = UNIT.GET(FirstOfGroup(gGates))
		end
		DestroyGroup(gGates)

		-- print("--")
	end

	--
	--  TRIGGERS
	--

	function gate.InitTrig_update()
		local t = CreateTrigger()
		TriggerRegisterTimerEventPeriodic(t, 2.5)
		TriggerAddAction(t, function() try(function() gate.update() end, "Update") end)
	end

	function gate.InitTrig_hitAnim()
		local t = CreateTrigger()
		TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ATTACKED)
		TriggerAddAction(t, function()

			local triggerUnit = UNIT.GET(GetAttackedUnitBJ())
			local unitId = triggerUnit.handleId

			if gate.types[unitId] ~= nil then
				PolledWait(0.2)
				triggerUnit:QueueAnimation("Stand Hit")
			end

		end)
	end

	function gate.InitTrig_dies()
		gate.Trig_gateDies = CreateTrigger()
		TriggerRegisterAnyUnitEventBJ(gate.Trig_gateDies, EVENT_PLAYER_UNIT_DEATH)
		TriggerAddAction(gate.Trig_gateDies, function()

			try(function()
				local dyingUnit = GetDyingUnit()

				if IsUnitInGroup(dyingUnit, gate.g) then
					local x = GetUnitX(dyingUnit)
					local y = GetUnitY(dyingUnit)
					local unitType = GetUnitTypeId(dyingUnit)
					local owningPlayer = GetOwningPlayer(dyingUnit)

					local facingAngle = gate.types[unitType].rotation
					local unitTypeOpen = gate.types[unitType].unitTypeOpen

					-- Remove Traces of Unit
					GroupRemoveUnit(gate.g, dyingUnit)
					RemoveUnit(dyingUnit)

					if not IsPlayerInForce(owningPlayer, udg_PLAYERGRPallied) then
						facingAngle = facingAngle + 180

						if facingAngle >= 360 then facingAngle = facingAngle - 360 end
					end

					unit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), unitTypeOpen, x, y, facingAngle)

					-- Play Death animation
					SetUnitAnimation(unit, "Death 1")
				end
			end, "Start Delayed Triggers")
		end)
	end

	--
	-- MAIN
	--

	function gate.main()
		local unitId ---@type unittype
		local u
		local g = CreateGroup()

		try(function()
			gate.addType("h021", "h020", 0) -- Castle Gate Vertical Right
			gate.addType("h023", "h022", 90) -- Castle Gate Horizontal Botoom
			gate.addType("h01G", "h01C", 0) -- City Gate Verical Right
			gate.addType("h01B", "h01D", 180) -- City Gate Vertical Left
			gate.addType("h01S", "h01T", 90) -- City Gate Horizontal Top

			for i = 1, #gate.typeIds do
				unitId = gate.typeIds[i]

				g = GetUnitsOfTypeIdAll(FourCC(unitId))

				while true do
					u = FirstOfGroup(g)
					if u == nil then break end

					gate.add(u, GetOwningPlayer(u))

					GroupRemoveUnit(g, u)
				end
				DestroyGroup(g)
			end
		end, "add Types")

		-- Init Triggers
		gate.InitTrig_update()
		gate.InitTrig_dies()
		gate.InitTrig_hitAnim()
	end
end
