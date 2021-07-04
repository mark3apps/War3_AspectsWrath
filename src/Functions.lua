---This contains all of the generic functions that can be used.  A lot of it is to make handlefree versions of normal blizzard commands 
---Returns true if the value is found in the table. Author: KickKing
---@param table table
---@param element any
---@return boolean @true if found, false if not
function TableContains(table, element)
	for _, value in pairs(table) do if value == element then return true end end
	return false
end

---Remove a value from a table
---@param table table
---@param value any
---@return boolean @true if successful
function TableRemoveValue(table, value) return table.remove(table, TableFind(table, value)) end

---Find the index of a value in a table.
---@param tab table
---@param el any
---@return number @Returns the index
function TableFind(tab, el) for index, value in pairs(tab) do if value == el then return index end end end

---Get the distance between 2 sets of Coordinates (Not handles used)
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function DistanceBetweenCoordinates(x1, y1, x2, y2) return SquareRoot(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1))) end

-- **Credit** KickKing
-- get distance without locations
---Get Distance between two units.  (Doesn't leak)
---@param unitA any
---@param unitB any
---@return number
function DistanceBetweenUnits(unitA, unitB)
	return DistanceBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA), GetUnitX(unitB), GetUnitY(unitB))
end

--- get angle between two sets of coordinates without locations
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number @angle between 0 and 360
function AngleBetweenCoordinates(x1, y1, x2, y2) return bj_RADTODEG * Atan2(y2 - y1, x2 - x1) end

---get angle between two units without locations
---@param unitA any @Unit 1
---@param unitB any @Unit 2
---@return number @angle between 0 and 360
function AngleBetweenUnits(unitA, unitB)
	return AngleBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA), GetUnitX(unitB), GetUnitY(unitB))
end

---Polar projection from point (Doesn't Leak)
---@param x number
---@param y number
---@param dist number
---@param angle number
---@return number @x
---@return number @y
function PolarProjectionCoordinates(x, y, dist, angle)
	local newX = x + dist * Cos(angle * bj_DEGTORAD)
	local newY = y + dist * Sin(angle * bj_DEGTORAD)
	return newX, newY
end

---raps your code in a "Try" loop so you can see errors printed in the log at runtime.  Author: Planetary
---@param func function
function try(func) -- Turn on runtime logging
	local passed, data = pcall(function()
		func()
		return "func " .. " passed"
	end)
	if not passed then print("|cffff0000[ERROR]|r", passed, data) end
end

---Converts integer formated types into the 4 digit strings (Opposite of FourCC()) Author: Taysen
---@param num any
---@return any
function CC2Four(num) -- Convert from Handle ID to Four Char
	return string.pack(">I4", num)
end

--- Get a random xy in the specified rect
---@param rect any
---@return any
---@return any
function GetRandomCoordinatesInRect(rect)
	return GetRandomReal(GetRectMinX(rect), GetRectMaxX(rect)), GetRandomReal(GetRectMinY(rect), GetRectMaxY(rect))
end

---Get a random xy in the specified datapoints
---@param xMin number
---@param xMax number
---@param yMin number
---@param yMax number
---@return number
---@return number
function GetRandomCoordinatesInPoints(xMin, xMax, yMin, yMax) return GetRandomReal(xMin, xMax),
                                                                     GetRandomReal(yMin, yMax) end

---Wait until Order ends or until the amount of time specified
---@param unit any @This is the Unit to watch
---@param time any @OPTIONAL | 2 | The max amount of time to wait
---@param order any @OPTIONAL | oid.move | The order the continue to wait until it's no longer what the unit is doing
---@param tick any @OPTIONAL | 0.1 | The amount of time to wait between checks
---@return boolean
function WaitWhileOrder(unit, time, order, tick)

	-- Set Defaults
	time = time or 2
	order = order or oid.move
	tick = tick or 0.1

	-- Set Local Variables
	local i = 1
	local unitOrder = GetUnitCurrentOrder(unit)

	-- Loop
	while unitOrder == oid.move and i < time do
		unitOrder = GetUnitCurrentOrder(unit)
		PolledWait(tick)
		i = i + tick
	end

	return true
end

---A system that allow you to duplicate the functionality of auto-filling in the Object Editor
---@param level             number @How many Levels or iterations to use for this
---@param base              number @The number to start with
---@param previousFactor    number @Multiply the previous level by this value
---@param levelFactor       number @This value exponential adds to itself every level
---@param constant          number @This gets added every level
---@return                  number @The calculated Value
function ValueFactor(level, base, previousFactor, levelFactor, constant)

	local value = base

	if level > 1 then for i = 2, level do value = (value * previousFactor) + (i * levelFactor) + (constant) end end

	return value
end
