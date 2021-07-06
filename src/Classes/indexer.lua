--
-- Unit Indexer Class
-----------------
function init_indexerClass()
	indexer_Class = {}

	indexer_Class.new = function()
		local self = {}

		self.data = {}

		function self:add(unit, order)
			order = order or "attack"
			local unitId = GetHandleId(unit)

			if self.data[unitId] == nil then
				local x = GetUnitX(unit)
				local y = GetUnitY(unit)

				self.data[unitId] = {}
				self.data[unitId] = {xSpawn = x, ySpawn = y, order = order, unit = unit, sfx = {}}
			end
		end

		function self:updateEnd(unit, x, y)
			local unitId = GetHandleId(unit)
			self.data[unitId].xEnd = x
			self.data[unitId].yEnd = y
		end

		function self:order(unit, order)

			local unitId = GetHandleId(unit)
			local alliedForce = IsUnitInForce(unit, udg_PLAYERGRPallied)
			local p
			local x = self.data[unitId].xEnd
			local y = self.data[unitId].yEnd
			order = order or self.data[unitId].order

			if self.data[unitId].xEnd == nil or self.data[unitId].yEnd == nil then

				if RectContainsUnit(gg_rct_Big_Top_Left, unit) or RectContainsUnit(gg_rct_Big_Top_Left_Center, unit) or
								RectContainsUnit(gg_rct_Big_Top_Right_Center, unit) or RectContainsUnit(gg_rct_Big_Top_Right, unit) then

					if alliedForce then
						p = GetRandomLocInRect(gg_rct_Right_Start_Top)
					else
						p = GetRandomLocInRect(gg_rct_Left_Start_Top)
					end

				elseif RectContainsUnit(gg_rct_Big_Middle_Left, unit) or RectContainsUnit(gg_rct_Big_Middle_Left_Center, unit) or
								RectContainsUnit(gg_rct_Big_Middle_Right_Center, unit) or RectContainsUnit(gg_rct_Big_Middle_Right, unit) then

					if alliedForce then
						p = GetRandomLocInRect(gg_rct_Right_Start)
					else
						p = GetRandomLocInRect(gg_rct_Left_Start)
					end

				else

					if alliedForce then
						p = GetRandomLocInRect(gg_rct_Right_Start_Bottom)
					else
						p = GetRandomLocInRect(gg_rct_Left_Start_Bottom)
					end
				end

				x = GetLocationX(p)
				y = GetLocationY(p)
				RemoveLocation(p)

				self.data[unitId].xEnd = x
				self.data[unitId].yEnd = y
			end

			-- Issue Order
			IssuePointOrder(unit, order, x, y)
			QueuedTriggerClearBJ()
		end

		function self:addKey(unit, key, value)
			value = value or 0
			local unitId = GetHandleId(unit)
			self.data[unitId][key] = value
		end

		function self:getKey(unit, key)
			local unitId = GetHandleId(unit)
			return self.data[unitId][key]
		end

		function self:get(unit)
			local unitId = GetHandleId(unit)
			return self.data[unitId]
		end

		function self:set(unit, data)
			local unitId = GetHandleId(unit)
			self.data[unitId] = data
		end

		function self:remove(unit)
			self.data[GetHandleId(unit)] = nil
			return true
		end

		return self
	end
end