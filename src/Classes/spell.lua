function SPELL_INIT()

	SPELL = {}
	SPELL.ID = {}
	SPELL.NAMES = {}
	SPELL.TARGET = {
		AOE = 1,
		SINGLETARGET = 2,
		CONE = 3
	}
	

	---Add a new Spell
	---@param name string
	---@param four string
	---@param buff string
	---@param order integer
	---@param instant boolean
	---@param castTime table
	function SPELL.NEW(name, four, buff, order, instant, castTime)
		instant = instant or false
		castTime = castTime or {}
		order = order or 0
		buff = buff or ""

		---@class SPELL
		local self = {}
		self.name = name
		self.four = four
		self.id = FourCC(four)
		self.properName = GetAbilityName(self.id)
		self.buff = buff
		self.order = order
		self.instant = instant
		self.castTime = castTime

		if buff ~= "" then
			self.buffId = FourCC(buff)
		else
			self.buffId = 0
		end

		---Get Spell Icon Path
		---@return string
		function self:Icon()
			return BlzGetAbilityIcon(self.id)
		end
		
		---Get Spell Activated Icon Path
		---@return string
		function self:IconActivated()
			return BlzGetAbilityActivatedIcon(self.id)
		end

		SPELL.id[four] = name
		table.insert(SPELL.names, name)

		return self
	end

end
