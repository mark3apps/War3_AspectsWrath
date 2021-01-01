
function init_heroClass()
    -- Create Class Definition
    heroClass = {}

    -- Define new() function
    heroClass.new = function()
        local self = {}

        self.E001 = "brawler"
        self.brawler = {}
        self.brawler.string = "E001"
        self.brawler.alter = "h00I"
        self.brawler.idAlter = FourCC(self.brawler.alter)
        self.brawler.id = FourCC(self.brawler.string)

        self.H009 = "tactition"
        self.tactition = {}
        self.tactition.string = "H009"
        self.tactition.alter = "h00Y"
        self.tactition.idAlter = FourCC(self.tactition.alter)
        self.tactition.id = FourCC(self.tactition.string)
        self.tactition.ironDefense = {string = "A019", id = FourCC("A019"), buff = nil, order = "roar", ult = false}
        self.tactition.raiseBanner = {string = "A01I", id = FourCC("A01I"), buff = nil, order = "healingward", ult = false}
        self.tactition.attack = {string = "A01B", id = FourCC("A01B"), buff = nil, order = "fingerofdeath", ult = false}
        self.tactition.bolster = {string = "A01Z", id = FourCC("A01Z"), buff = nil, order = "tranquility", ult = false}
        self.tactition.inspire = {string = "A042", id = FourCC("A042"), buff = nil, order = "channel", ult = true}

        self.E002 = "shiftMaster"
        self.shiftMaster = {}
        self.shiftMaster.string = "E002"
        self.shiftMaster.alter = "h00Q"
        self.shiftMaster.idAlter = FourCC(self.shiftMaster.alter)
        self.shiftMaster.id = FourCC(self.shiftMaster.string)
        self.shiftMaster.shiftBack = {string = "A03U", id = FourCC("A03U"), buff = nil, order = "stomp", ult = false}
        self.shiftMaster.shiftForward = {string = "A030", id = FourCC("A030"), buff = nil, order = "thunderclap", ult = false}
        self.shiftMaster.fallingStrike = {string = "A03T", id = FourCC("A03T"), buff = nil, order = "clusterrockets", ult = false}
        self.shiftMaster.shiftStorm = {string = "A03C", id = FourCC("A03C"), buff = nil, order = "channel", ult = true}
        self.shiftMaster.felForm = {string = "A02Y", id = FourCC("A02Y"), buff = nil, order = "metamorphosis", ult = true}

        self.H00R = "manaAddict"
        self.manaAddict = {}
        self.manaAddict.string = "H00R"
        self.manaAddict.alter = "h00B"
        self.manaAddict.idAlter = FourCC(self.manaAddict.alter)
        self.manaAddict.id = FourCC(self.manaAddict.string)
        self.manaAddict.manaShield = {string = "A001", id = FourCC("A001"), buff = FourCC("BNms"), order = "manashieldon", ult = false}
        self.manaAddict.frostNova = {string = "A03S", id = FourCC("A03S"), buff = nil, order = "flamestrike", ult = false}
        self.manaAddict.manaOverload = {string = "A018", id = FourCC("A018"), buff = nil, order = "manashield", ult = false}
        self.manaAddict.manaBurst = {string = "A02B", id = FourCC("A02B"), buff = nil, order = "custerrockets", ult = false}
        self.manaAddict.starfall = {string = "A015", id = FourCC("A015"), buff = nil, order = "starfall", ult = true}

        self.H00J = "timeMage"
        self.timeMage = {}
        self.timeMage.string = "H00J"
        self.timeMage.alter = "h00Z"
        self.timeMage.idAlter = FourCC(self.timeMage.alter)
        self.timeMage.id = FourCC(self.timeMage.string)
        self.timeMage.chronoAtrophy = {string = "A04K", id = FourCC("A04K"), buff = nil, order = "flamestrike", ult = false}
        self.timeMage.decay = {string = "A032", id = FourCC("A032"), buff = nil, order = "shadowstrike", ult = false}
        self.timeMage.timeTravel = {string = "A04P", id = FourCC("A04P"), buff = nil, order = "clusterrockets", ult = false}
        self.timeMage.paradox = {string = "A04N", id = FourCC("A04N"), buff = nil, order = "tranquility", ult = true}


        function self:spell( heroUnit, spellName )
            local spellDetails = self[heroUnit.name][spellName]
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
            return GetUnitAbilityLevel(heroUnit.unit, self[heroUnit.name][spellName].id)
        end

        function self:cooldown(heroUnit, spellName)
            return BlzGetUnitAbilityCooldownRemaining(heroUnit.unit, self[heroUnit.name][spellName].id)
        end

        function self:mana(heroUnit, spellName, level)
            return BlzGetUnitAbilityManaCost(heroUnit.unit, self[heroUnit.name][spellName].id, level)
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

