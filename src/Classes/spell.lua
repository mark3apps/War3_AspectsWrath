function _SpellInit()

	_Spell = {}
	_Spell.id = {}
	_Spell.names = {}

	---Add a new Spell
	---@param name string
	---@param properName string
	---@param four string
	---@param buff integer
	---@param order integer
	---@param instant boolean
	---@param castTime table
	function _Spell.new(name, properName, four, buff, order, instant, castTime)
        instant = instant or false
        castTime = castTime or {}
        order = order or 0
        buff = buff or 0

		---@class spell
		local self = {}
		self.name = name
		self.properName = properName
		self.four = four
		self.id = FourCC(four)
		self.buff = buff
		self.order = order
		self.instant = instant
		self.castTime = castTime

		_Spell.id[four] = name
		table.insert(_Spell.names, name)

		return self
	end

    spell = {}
    spell.bonusArmor = _Spell.new("bonusArmor", "Bonus Armor", "Z001")
    spell.bonusAttackSpeed = _Spell.new("bonusAttackSpeed", "Bonus Attack Speed", "Z002")
    spell.bonusCriticalStrike = _Spell.new("bonusCriticalStrike", "Bonus Critical Strike", "Z003")
    spell.bonusDamage = _Spell.new("bonusDamage", "Bonus Damage", "Z004")
    spell.bonusEvasion = _Spell.new("bonusEvasion", "Bonus Evasion", "Z005")
    spell.bonusHealthRegen = _Spell.new("bonusHealthRegen", "Bonus Health Regeneration", "Z006")
    spell.bonusLifeSteal = _Spell.new("bonusLifeSteal", "Bonus Life Steal", "Z007")
    spell.bonusMagicResistance = _Spell.new("bonusMagicResistance", "Bonus Magic Resistance", "Z008")
    spell.bonusMovementSpeed = _Spell.new("bonusMovementSpeed", "Bonus Movement Speed", "Z009")
    spell.bonusStats = _Spell.new("bonusStats", "Bonus Stats", "Z010")
    spell.bonusManaRegen = _Spell.new("bonusManaRegen" , "Bonus Mana Regen", "Z011")
    
end
