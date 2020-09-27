function distance (x1, y1, x2, y2)
    return SquareRoot(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)))
end


function debugfunc( func, name )
  local passed, data = pcall( function() func() return "func " .. name .. " passed" end )
  if not passed then
    print(name, passed, data)
  end
  passed = nil
  data = nil
end