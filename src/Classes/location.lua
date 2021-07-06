--
-- Location Class
-----------------
function init_locationClass()

	loc_Class = {}

	loc_Class.new = function()
		local self = {}
		self.regions = {}

		---Add a new location
		---@param name string
		---@param rect rect
		---@param nextRect rect
		---@param allied boolean
		function self:add(name, rect, nextRect, allied)
			nextRect = nextRect or ""
			allied = allied or false
			self[name] = {
				centerX = GetRectCenterX(rect),
				centerY = GetRectCenterY(rect),
				minX = GetRectMinX(rect),
				maxX = GetRectMaxX(rect),
				minY = GetRectMinY(rect),
				maxY = GetRectMaxY(rect)
			}
			self[name].reg = CreateRegion()
			RegionAddRect(self[name].reg, rect)

			self[name].rect = rect
			self[name].name = name

			self.regions[GetHandleId(self[name].rect)] = name
			self.regions[GetHandleId(self[name].reg)] = name

			if nextRect ~= "" then
				TriggerRegisterEnterRegionSimple(Trig_moveToNext, self[name].reg)
				self[name].next = nextRect
				self[name].allied = allied
				self[name].fed = not allied
			end
		end

		function self:getRandomXY(name)
			local region = self[name]
			return GetRandomReal(region.minX, region.maxX), GetRandomReal(region.minY, region.maxY)
		end

		function self:getRegion(region)
			local regionName = self.regions[GetHandleId(region)]
			return self[regionName]
		end

		return self
	end

end