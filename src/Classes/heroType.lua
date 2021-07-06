function HEROTYPE_INIT()

	-- Create Class Definition
	HEROTYPE = {}

	-- Init Globals
	HEROTYPE = {id = {}, names = {}, players = {}}
	--for i = 1, 12 do hero.players[i] = {picked = false} end

    ---comment
    ---@param u unit
    ---@return HEROTYPE
	function HEROTYPE.GET(u)
        local unit = UNIT.GET(u)

        return heroType[HEROTYPE.id[unit.unitTypeFour]]
    end

	function HEROTYPE.NEW(name, four, fourAlter)

		---@class HEROTYPE
		local self = {}

		self.name = name
		self.four = four
		self.id = FourCC(four)
		self.fourAlter = fourAlter
		self.idAlter = FourCC(fourAlter)
		self.spellsCount = 0
		self.spellsPermanent = {}
		self.spellsPermanentCount = 0
		self.spellsStarting = {}
		self.spellsStartingCount = 0
		self.spellsUlt = {}
		self.spells = {}
		self.items = {}
		self.itemCount = 0
		self.talents = {}

		---Add a spell to Hero
		---@param spellObj SPELL
		---@param ult boolean
		---@param starting boolean
		---@param permanent boolean
		---@return HEROSPELL
		function self:SpellAdd(spellObj, ult, starting, permanent)
			ult = ult or false
			starting = starting or false
			permanent = permanent or false

			---@class HEROSPELL
			local spellDetails = {
				name = spellObj.name,
				ult = ult,
				starting = starting,
				permanent = permanent
			}

			if starting then
				table.insert(self.spellsStarting, spellDetails)
				self.spellsStartingCount = self.spellsStartingCount + 1
			end

			if permanent then
				table.insert(self.spellsPermanent, spellDetails)
				self.spellsPermanentCount = self.spellsPermanentCount + 1
			end
		
			if ult then table.insert(self.spellsUlt, spellDetails) end

			table.insert(self.spells, spellDetails)
			self.spellsCount = self.spellsCount + 1

			return spellDetails
		end

		---Add an item to Hero
		---@param item ITEMTYPE
		---@return boolean
		function self:ItemAdd(item)
			table.insert(self.items, item.name)
			self.itemCount = self.itemCount + 1
			
			return true
		end

		---Add a talent to Hero
		---@param talent any
		---@param level integer
		---@return boolean
		function self:TalentAdd(talent, level) return true end

		-- Register newly created hero
		HEROTYPE.id[four] = name
		table.insert(HEROTYPE.names, name)

		return self
	end

end
