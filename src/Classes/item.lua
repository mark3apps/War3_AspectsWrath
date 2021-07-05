--
-- Hero Skills / Abilities Class
-----------------
---@class itemATA
function ITEM_INIT()
	ITEM = {}
	ITEM.KEY = {}

	function ITEM.GET(id)

	end

	-- comment
	---@param name string
	---@param properName string
	---@param four string
	---@param abilityFour string
	---@param order integer
	---@param instant boolean
	---@param castTime table
	function ITEM.NEW(name, properName, four, abilityFour, order, instant, castTime)

		---@class ITEMTYPE
		local self = {}

		self.name = name
		self.properName = properName
		self.four = four
		self.id = FourCC(four)
		self.abilityFour = abilityFour
		self.abilityId = FourCC(abilityFour)
		self.order = order
		self.instant = instant
		self.castTime = castTime

		ITEM.KEY[name] = name
		ITEM.KEY[four] = name

		return self
	end

end

