
function init_heroClass()
    -- Create Class Definition
    heroClass = {}

    -- Define new() function
    heroClass.new = function()
        local self = {}
        self.H009 = {}
        self.H009.name = "Tactition"
        self.H009.ironDefense = {id = FourCC("A019"), buff = nil, string = "roar", ult = false}
        self.H009.raiseBanner = {id = FourCC("A01I"), buff = nil, string = "healingward", ult = false}
        self.H009.attack = {id = FourCC("A01B"), buff = nil, string = "fingerofdeath", ult = false}
        self.H009.bolster = {id = FourCC("A01Z"), buff = nil, string = "tranquility", ult = false}
        self.H009.inspire = {id = FourCC("A042"), buff = nil, string = "channel", ult = true}

        self.E002 = {}
        self.E002.name = "Shift Master"
        self.E002.shiftBack = {id = FourCC("A03U"), buff = nil, string = "stomp", ult = false}
        self.E002.shiftForward = {id = FourCC("A030"), buff = nil, string = "thunderclap", ult = false}
        self.E002.fallingStrike = {id = FourCC("A03T"), buff = nil, string = "clusterrockets", ult = false}
        self.E002.shiftStorm = {id = FourCC("A03C"), buff = nil, string = "channel", ult = true}
        self.E002.felForm = {id = FourCC("A02Y"), buff = nil, string = "metamorphosis", ult = true}

        self.H00R = {}
        self.H00R.name = "Mana Addict"
        self.H00R.manaShield = {id = FourCC("A001"), buff = FourCC("BNms"), string = "manashieldon", ult = false}
        self.H00R.frostNova = {id = FourCC("A03S"), buff = nil, string = "flamestrike", ult = false}
        self.H00R.manaOverload = {id = FourCC("A018"), buff = nil, string = "manashield", ult = false}
        self.H00R.manaBurst = {id = FourCC("A02B"), buff = nil, string = "custerrockets", ult = false}
        self.H00R.starfall = {id = FourCC("A015"), buff = nil, string = "starfall", ult = true}

        self.H00J = {}
        self.H00J.name = "Time Mage"
        self.H00J.chronoAtrophy = {id = FourCC("A04K"), buff = nil, string = "flamestrike", ult = false}
        self.H00J.decay = {id = FourCC("A032"), buff = nil, string = "shadowstrike", ult = false}
        self.H00J.timeTravel = {id = FourCC("A04P"), buff = nil, string = "clusterrockets", ult = false}
        self.H00J.paradox = {id = FourCC("A04N"), buff = nil, string = "tranquility", ult = true}


        function self:spell( heroUnit, spellName )
            local spellDetails = self[heroUnit.id][spellName]
            spellDetails.level = self:level(heroUnit, spellName)
            spellDetails.cooldown = self:cooldown(heroUnit, spellName)
            spellDetails.hasBuff = self:hasBuff(heroUnit, spellName)
            spellDetails.mana = self:mana(heroUnit, spellName, level)
            spellDetails.manaLeft = heroUnit.mana - spellDetails.mana

            if spellDetails.level > 0 and spellDetails.cooldown == 0 and spellDetails.manaLeft >= 0 then
                spellDetails.cacastablest = true
            else
                spellDetails.castable = false
            end

            return spellDetails
        end

        function self:level(heroUnit, spellName)
            return GetUnitAbilityLevel(heroUnit.unit, self[heroUnit.id][spellName].id)
        end

        function self:cooldown(heroUnit, spellName)
            return BlzGetUnitAbilityCooldownRemaining(heroUnit.unit, self[heroUnit.id][spellName].id)
        end

        function self:mana(heroUnit, spellName, level)
            return BlzGetUnitAbilityManaCost(heroUnit.unit, self[heroUnit.id][spellName].id, level)
        end

        function self:hasBuff(heroUnit, spellName)

            if self[heroUnit.id][spellName].buff == nil then
                return false
            else
                return UnitHasBuffBJ(heroUnit.unit, self[heroUnit.id][spellName].buff)
            end
        end

        return self
    end
end

