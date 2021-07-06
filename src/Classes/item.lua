--
-- Item Class
-----------------
function ITEMTYPE_INIT()
	ITEMTYPE = {}
	ITEMTYPE.KEY = {}

	function ITEMTYPE.GET(id)

	end

	-- Create a New Item
	---@param name string
	---@param properName string
	---@param four string
	---@param abilityFour string
	---@param order integer
	---@param instant boolean
	---@param castTime table
	function ITEMTYPE.NEW(name, properName, four, abilityFour, order, instant, castTime)

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

		ITEMTYPE.KEY[name] = name
		ITEMTYPE.KEY[four] = name

		return self
	end

end

