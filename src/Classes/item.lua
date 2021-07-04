--
-- Hero Skills / Abilities Class
-----------------


---@class itemATA
function item.Init()
	item = {}
	item.id = {}
	item.names = {}

	-- comment
	---@param name string
	---@param properName string
	---@param four string
	---@param abilityFour string
	---@param order integer
	---@param instant boolean
	---@param castTime table
	function item.New(name, properName, four, abilityFour, order, instant, castTime)
		item[name] = {
			name = name,
			properName = properName,
			four = four,
			id = FourCC(four),
			abilityFour = abilityFour,
			abilityId = FourCC(abilityFour),
			order = order,
			instant = instant,
			castTime = castTime
		}

		table.insert(item.names, name)
		item.id[four] = name

		return true
	end

end



