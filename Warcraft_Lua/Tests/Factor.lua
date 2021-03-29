
function valueFactor(level, base, previousFactor, levelFactor, constant)

    local value = base
    print(value)

    if level > 1 then
        for i = 2, level do
            value = (value * previousFactor) + (i * levelFactor) + (constant)
            print(value)
        end
    end

    return value
end


valueFactor(6, 20, 1, 0, 0)