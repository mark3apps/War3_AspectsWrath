--
-- Game Action Triggers
--
-- Hero Levels Up
function Init_HeroLevelsUp()
    local t = CreateTrigger()

    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_HERO_LEVEL)
    TriggerAddAction(t, function()
        -- Get Locals
        local levelingUnit = GetLevelingUnit()

        debugfunc(function()
            hero.levelUp(levelingUnit)
        end, "hero.levelUp")
    end)
end

-- Unit Casts Spell
function Init_UnitCastsSpell()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_CAST)

    TriggerAddAction(t, function()
        local triggerUnit = GetTriggerUnit()

        debugfunc(function()
            CAST_aiHero(triggerUnit)
        end, "CAST_aiHero")
    end)
end

-- Unit buys Unit
function Init_PlayerBuysUnit()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SELL)
    TriggerAddAction(t, function()
        local sellingUnit = GetSellingUnit()
        local buyingUnit = GetBuyingUnit()
        local soldUnit = GetSoldUnit()
        local buyingPlayer = GetOwningPlayer(buyingUnit)
        local sellingPlayer = GetOwningPlayer(sellingUnit)

        debugfunc(function()

            -- Hero picked at beginning of game
            if sellingUnit == gg_unit_n00C_0082 then
                local g = CreateGroup()
                g = GetUnitsOfPlayerAndTypeId(buyingPlayer, FourCC("h00H"))
                if CountUnitsInGroup(g) == 1 then
                    RemoveUnit(buyingUnit)
                    hero:setupHero(soldUnit)
                else
                    RemoveUnit(soldUnit)
                end
                DestroyGroup(g)
            end
        end, "hero:setupHero")

    end)
end

-- Unit enters the Map
function Init_UnitEntersMap()

    TriggerRegisterEnterRectSimple(Trig_UnitEntersMap, GetPlayableMapRect())
    TriggerAddAction(Trig_UnitEntersMap, function()
        local triggerUnit = GetTriggerUnit()
        addUnitsToIndex(triggerUnit)
    end)
end

-- Unit Issued Target or no Target Order
function Init_IssuedOrder()

    TriggerRegisterAnyUnitEventBJ(Trig_IssuedOrder, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    TriggerRegisterAnyUnitEventBJ(Trig_IssuedOrder, EVENT_PLAYER_UNIT_ISSUED_ORDER)

    TriggerAddAction(Trig_IssuedOrder, function()
        local triggerUnit = GetTriggerUnit()
        local orderId = GetIssuedOrderId()
        local orderString = OrderId2String(orderId)

        if ordersIgnore[orderString] ~= nil and IsUnitType(triggerUnit, UNIT_TYPE_STRUCTURE) == false and
            IsUnitType(triggerUnit, UNIT_TYPE_HERO) == false and GetUnitTypeId(triggerUnit) ~= FourCC("uloc") and
            GetUnitTypeId(triggerUnit) ~= FourCC("h000") and GetUnitTypeId(triggerUnit) ~= FourCC("h00V") and
            GetUnitTypeId(triggerUnit) ~= FourCC("h00N") and GetUnitTypeId(triggerUnit) ~= FourCC("h00O") and
            GetUnitTypeId(triggerUnit) ~= FourCC("h00M") and GetUnitTypeId(triggerUnit) ~= FourCC("o006") and
            UnitHasBuffBJ(triggerUnit, FourCC("B006")) == false and --[[ Attack! Buff --]] GetOwningPlayer(triggerUnit) ~=
            Player(17) and GetOwningPlayer(triggerUnit) ~= Player(PLAYER_NEUTRAL_AGGRESSIVE) then

            PolledWait(0.5)
            indexer:order(triggerUnit)
        end
    end)

end

-- Unit finishes casting a spell
function Init_finishCasting()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_FINISH)
    TriggerAddAction(t, function()

        local triggerUnit = GetTriggerUnit()
        unitKeepMoving(triggerUnit)
    end)
end

-- Unit finishes Stops a spell
function Init_stopCasting()
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    TriggerAddAction(t, function()

        local triggerUnit = GetTriggerUnit()
        unitKeepMoving(triggerUnit)
    end)
end

-- Unit Dies
function Init_UnitDies()
    TriggerRegisterAnyUnitEventBJ(Trig_UnitDies, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(Trig_UnitDies, function()
        local dieingUnit = GetTriggerUnit()

        if not IsUnitType(dieingUnit, UNIT_TYPE_HERO) then
            indexer:remove(dieingUnit)
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

        if isAllied or isFed then
            local region = loc:getRegion(GetTriggeringRegion())

            if (isAllied and region.allied) or (isFed and region.fed) then
                local x, y = loc:getRandomXY(region.next)
                indexer:updateEnd(triggerUnit, x, y)
                indexer:order(triggerUnit)
            end
        end
    end)
end



--
-- Trigger Functions
-----------------


-- Add unit to index then order to move if unit is computer controlled and a correct unit
    function addUnitsToIndex(unit)

        if not IsUnitType(unit, UNIT_TYPE_HERO) then
            indexer:add(unit)
    
            if IsUnitType(unit, UNIT_TYPE_STRUCTURE) == false and
                (IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPallied) or
                    IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPfederation)) then
                indexer:order(unit)
            end
        end
    end


    function CAST_aiHero(triggerUnit)
        if IsUnitInGroup(triggerUnit, ai.heroGroup) then
            local heroName = indexer:getKey(triggerUnit, "heroName")
            ai:castSpell(heroName)
        end
    end

    -- Order starting units to attack
function orderStartingUnits()
    local g = CreateGroup()
    local u

    g = GetUnitsInRectAll(GetPlayableMapRect())
    while true do
        u = FirstOfGroup(g)
        if u == nil then
            break
        end

        debugfunc(function()

            indexer:add(u)
            if not (IsUnitType(u, UNIT_TYPE_STRUCTURE)) and not (IsUnitType(u, UNIT_TYPE_HERO)) and
                (IsPlayerInForce(GetOwningPlayer(u), udg_PLAYERGRPallied) or
                    IsPlayerInForce(GetOwningPlayer(u), udg_PLAYERGRPfederation)) then

                indexer:order(u)
            end
        end, "Index")

        GroupRemoveUnit(g, u)
    end
    DestroyGroup(g)
end

-- Tell unit to keep Attack-Moving to it's indexed destination
function unitKeepMoving(unit)
    if GetOwningPlayer(unit) ~= Player(PLAYER_NEUTRAL_AGGRESSIVE) and IsUnitType(unit, UNIT_TYPE_HERO) == false and
        UnitHasBuffBJ(unit, FourCC("B006")) == false and GetUnitTypeId(unit) ~= FourCC("h00M") and GetUnitTypeId(unit) ~=
        FourCC("h00M") and GetUnitTypeId(unit) ~= FourCC("h000") and GetUnitTypeId(unit) ~= FourCC("h00V") and
        GetUnitTypeId(unit) ~= FourCC("h00O") and
        (IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPallied) == true or
            IsPlayerInForce(GetOwningPlayer(unit), udg_PLAYERGRPfederation) == true) then
        PolledWait(0.5)
        indexer:order(unit, "attack")
    end
end