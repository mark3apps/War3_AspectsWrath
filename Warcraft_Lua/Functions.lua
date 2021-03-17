--
-- Functions
--
function dprint(message, level)
    level = level or 1

    if debugprint >= level then
        print("|cff00ff00[debug " .. level .. "]|r " .. tostring(message))
    end
end

function distanceBetweenCoordinates(x1, y1, x2, y2) -- Find Distance between points
    return SquareRoot(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)))
end

function distanceBetweenUnits(unitA, unitB)
    return distanceBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA), GetUnitX(unitB), GetUnitY(unitB))
end

function angleBetweenCoordinates(x1, y1, x2, y2)
    return bj_RADTODEG * Atan2(y2 - y1, x2 - x1)
end

function angleBetweenUnits(unitA, unitB)
    return angleBetweenCoordinates(GetUnitX(unitA), GetUnitY(unitA), GetUnitX(unitB), GetUnitY(unitB))
end

function PolarProjectionCoordinates(x, y, dist, angle)
    local newX = x + dist * Cos(angle * bj_DEGTORAD)
    local newY = y + dist * Sin(angle * bj_DEGTORAD)
    return {newX, newY}
end



function debugfunc(func, name) -- Turn on runtime logging
    local passed, data = pcall(function()
        func()
        return "func " .. name .. " passed"
    end)
    if not passed then
        print("|cffff0000[ERROR]|r" .. name, passed, data)
    end
end

function CC2Four(num) -- Convert from Handle ID to Four Char
    return string.pack(">I4", num)
end