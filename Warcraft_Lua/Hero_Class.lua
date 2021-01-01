
function init_heroClass()
    -- Create Class Definition
    hero_Class = {}

    -- Define new() function
    hero_Class.new = function()
        local self = {}

        self.E001 = "brawler"
        self.brawler = {}
        self.brawler.four = "E001"
        self.brawler.fourAlter = "h00I"
        self.brawler.id = FourCC(self.brawler.four)
        self.brawler.idAlter = FourCC(self.brawler.fourAlter)


        self.H009 = "tactition"
        self.tactition = {}
        self.tactition.four = "H009"
        self.tactition.fourAlter = "h00Y"
        self.tactition.id = FourCC(self.tactition.four)
        self.tactition.idAlter = FourCC(self.tactition.fourAlter)
        self.tactition.ironDefense = {four = "A019", id = FourCC("A019"), buff = 0, order = "roar", ult = false}
        self.tactition.raiseBanner = {four = "A01I", id = FourCC("A01I"), buff = 0, order = "healingward", ult = false}
        self.tactition.attack = {four = "A01B", id = FourCC("A01B"), buff = 0, order = "fingerofdeath", ult = false}
        self.tactition.bolster = {four = "A01Z", id = FourCC("A01Z"), buff = 0, order = "tranquility", ult = false}
        self.tactition.inspire = {four = "A042", id = FourCC("A042"), buff = 0, order = "channel", ult = true}

        self.E002 = "shiftMaster"
        self.shiftMaster = {}
        self.shiftMaster.four = "E002"
        self.shiftMaster.fourAlter = "h00Q"
        self.shiftMaster.id = FourCC(self.shiftMaster.four)
        self.shiftMaster.idAlter = FourCC(self.shiftMaster.fourAlter)
        self.shiftMaster.shiftBack = {four = "A03U", id = FourCC("A03U"), buff = 0, order = "stomp", ult = false}
        self.shiftMaster.shiftForward = {four = "A030", id = FourCC("A030"), buff = 0, order = "thunderclap", ult = false}
        self.shiftMaster.fallingStrike = {four = "A03T", id = FourCC("A03T"), buff = 0, order = "clusterrockets", ult = false}
        self.shiftMaster.shiftStorm = {four = "A03C", id = FourCC("A03C"), buff = 0, order = "channel", ult = true}
        self.shiftMaster.felForm = {four = "A02Y", id = FourCC("A02Y"), buff = 0, order = "metamorphosis", ult = true}

        self.H00R = "manaAddict"
        self.manaAddict = {}
        self.manaAddict.four = "H00R"
        self.manaAddict.fourAlter = "h00B"
        self.manaAddict.id = FourCC(self.manaAddict.four)
        self.manaAddict.idAlter = FourCC(self.manaAddict.fourAlter)
        self.manaAddict.manaShield = {four = "A001", id = FourCC("A001"), buff = FourCC("BNms"), order = "manashieldon", ult = false}
        self.manaAddict.frostNova = {four = "A03S", id = FourCC("A03S"), buff = 0, order = "flamestrike", ult = false}
        self.manaAddict.manaOverload = {four = "A018", id = FourCC("A018"), buff = 0, order = "manashield", ult = false}
        self.manaAddict.manaBurst = {four = "A02B", id = FourCC("A02B"), buff = 0, order = "custerrockets", ult = false}
        self.manaAddict.starfall = {four = "A015", id = FourCC("A015"), buff = 0, order = "starfall", ult = true}

        self.H00J = "timeMage"
        self.timeMage = {}
        self.timeMage.four = "H00J"
        self.timeMage.fourAlter = "h00Z"
        self.timeMage.id = FourCC(self.timeMage.four)
        self.timeMage.idAlter = FourCC(self.timeMage.fourAlter)
        self.timeMage.chronoAtrophy = {four = "A04K", id = FourCC("A04K"), buff = 0, order = "flamestrike", ult = false}
        self.timeMage.decay = {four = "A032", id = FourCC("A032"), buff = 0, order = "shadowstrike", ult = false}
        self.timeMage.timeTravel = {four = "A04P", id = FourCC("A04P"), buff = 0, order = "clusterrockets", ult = false}
        self.timeMage.paradox = {four = "A04N", id = FourCC("A04N"), buff = 0, order = "tranquility", ult = true}


        function self:spell( heroUnit, spellName )
            local spellDetails = self[heroUnit.name][spellName]
            spellDetails.level = self:level(heroUnit, spellName)
            spellDetails.cooldown = self:cooldown(heroUnit, spellName)
            spellDetails.hasBuff = self:hasBuff(heroUnit, spellName)
            spellDetails.mana = self:mana(heroUnit, spellName, spellDetails.level)
            spellDetails.manaLeft = heroUnit.mana - spellDetails.mana

            if spellDetails.level > 0 and spellDetails.cooldown == 0 and spellDetails.manaLeft >= 0 then
                spellDetails.castable = true
            else
                spellDetails.castable = false
            end

            print(spellName .. " : " .. spellDetails.level)
            print("Castable: " .. tostring(spellDetails.castable))

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

            if self[heroUnit.name][spellName].buff == 0 then
                return false
            else
                return UnitHasBuffBJ(heroUnit.unit, self[heroUnit.name][spellName].buff)
            end
        end

        return self
    end
end

