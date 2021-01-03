
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
        self.brawler.spellLearnOrder = {"unleashRage", "drain", "warstomp", "bloodlust"}
        self.brawler.drain = {name="Drain", four = "A01Y", id = FourCC("A01Y"), buff = 0, order = "stomp", ult = false}
        self.brawler.bloodlust = {name="Bloodlust", four = "A007", id = FourCC("A007"), buff = 0, order = "stomp", ult = false}
        self.brawler.warstomp = {name="War Stomp", four = "A002", id = FourCC("A002"), buff = 0, order = "stomp", ult = false}
        self.brawler.unleashRage = {name="Unleassh Rage", four = "A029", id = FourCC("A029"), buff = 0, order = "stomp", ult = true}


        self.H009 = "tactition"
        self.tactition = {}
        self.tactition.four = "H009"
        self.tactition.fourAlter = "h00Y"
        self.tactition.id = FourCC(self.tactition.four)
        self.tactition.idAlter = FourCC(self.tactition.fourAlter)
        self.tactition.spellLearnOrder = {"inspire", "raiseBanner", "ironDefense", "bolster", "attack"}
        self.tactition.ironDefense = {name="Iron Defense", four = "A019", id = FourCC("A019"), buff = 0, order = "roar", ult = false}
        self.tactition.raiseBanner = {name="Raise Banner", four = "A01I", id = FourCC("A01I"), buff = 0, order = "healingward", ult = false}
        self.tactition.attack = {name="Attack!", four = "A01B", id = FourCC("A01B"), buff = 0, order = "fingerofdeath", ult = false}
        self.tactition.bolster = {name="Bolster", four = "A01Z", id = FourCC("A01Z"), buff = 0, order = "tranquility", ult = false}
        self.tactition.inspire = {name="Inspire", four = "A042", id = FourCC("A042"), buff = 0, order = "channel", ult = true}

        self.E002 = "shiftMaster"
        self.shiftMaster = {}
        self.shiftMaster.four = "E002"
        self.shiftMaster.fourAlter = "h00Q"
        self.shiftMaster.id = FourCC(self.shiftMaster.four)
        self.shiftMaster.idAlter = FourCC(self.shiftMaster.fourAlter)
        self.shiftMaster.spellLearnOrder = {"shiftStorm", "felForm", "shiftBack", "fallingStrike", "shiftForward"}
        self.shiftMaster.shiftBack = {name="Shift Back", four = "A03U", id = FourCC("A03U"), buff = 0, order = "stomp", ult = false}
        self.shiftMaster.shiftForward = {name="Shift Forward", four = "A030", id = FourCC("A030"), buff = 0, order = "thunderclap", ult = false}
        self.shiftMaster.fallingStrike = {name="Falling Strike", four = "A03T", id = FourCC("A03T"), buff = 0, order = "clusterrockets", ult = false}
        self.shiftMaster.shiftStorm = {name="Shift Storm", four = "A03C", id = FourCC("A03C"), buff = 0, order = "channel", ult = true}
        self.shiftMaster.felForm = {name="Fel Form", four = "A02Y", id = FourCC("A02Y"), buff = 0, order = "metamorphosis", ult = true}

        self.H00R = "manaAddict"
        self.manaAddict = {}
        self.manaAddict.four = "H00R"
        self.manaAddict.fourAlter = "h00B"
        self.manaAddict.id = FourCC(self.manaAddict.four)
        self.manaAddict.idAlter = FourCC(self.manaAddict.fourAlter)
        self.manaAddict.spellLearnOrder = {"starfall", "manaShield", "frostNova", "manaOverload", "manaBurst"}
        self.manaAddict.manaShield = {name="Mana Shield", four = "A001", id = FourCC("A001"), buff = FourCC("BNms"), order = "manashieldon", ult = false}
        self.manaAddict.frostNova = {name="Frost Nova", four = "A03S", id = FourCC("A03S"), buff = 0, order = "flamestrike", ult = false}
        self.manaAddict.manaOverload = {name="Mana Overload", four = "A018", id = FourCC("A018"), buff = 0, order = "manashield", ult = false}
        self.manaAddict.manaBurst = {name="Mana Burst", four = "A02B", id = FourCC("A02B"), buff = 0, order = "custerrockets", ult = false}
        self.manaAddict.starfall = {name="Starfall", four = "A015", id = FourCC("A015"), buff = 0, order = "starfall", ult = true}

        self.H00J = "timeMage"
        self.timeMage = {}
        self.timeMage.four = "H00J"
        self.timeMage.fourAlter = "h00Z"
        self.timeMage.id = FourCC(self.timeMage.four)
        self.timeMage.idAlter = FourCC(self.timeMage.fourAlter)
        self.timeMage.spellLearnOrder = {"paradox", "timeTravel", "chronoAtrophy", "decay"}
        self.timeMage.chronoAtrophy = {name="Chrono Atrophy", four = "A04K", id = FourCC("A04K"), buff = 0, order = "flamestrike", ult = false}
        self.timeMage.decay = {name="Decay", four = "A032", id = FourCC("A032"), buff = 0, order = "shadowstrike", ult = false}
        self.timeMage.timeTravel = {name="Time Travel", four = "A04P", id = FourCC("A04P"), buff = 0, order = "clusterrockets", ult = false}
        self.timeMage.paradox = {name="Paradox", four = "A04N", id = FourCC("A04N"), buff = 0, order = "tranquility", ult = true}


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

            --print(spellName .. " : " .. spellDetails.level)
            --print("Castable: " .. tostring(spellDetails.castable))

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


        function self.levelUp(unit)
            local heroFour = CC2Four(GetUnitTypeId(unit))
            local heroLevel = GetHeroLevel(unit)
            local spells = self[self[heroFour]]

            print(self[heroFour])

            -- Remove Ability Points
			if (heroLevel < 15 and ModuloInteger(heroLevel, 2) ~= 0) then
				ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SUB, 1)
			elseif (heroLevel < 25 and heroLevel >= 15 and ModuloInteger(heroLevel, 3) ~= 0) then
				ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SUB, 1)
			elseif (heroLevel >= 25 and ModuloInteger(heroLevel, 4) ~= 0) then
				ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SUB, 1)
			end

            print("Level Up, " .. heroFour .. " Level: " .. heroLevel)

            -- Learn Skill if the Hero is owned by a Computer
            if GetPlayerController(GetOwningPlayer(unit)) == MAP_CONTROL_COMPUTER then
                local unspentPoints = GetHeroSkillPoints(unit)

                print("Unspent Abilities: " .. unspentPoints)

                if unspentPoints > 0 then
                    for i=1, #spells.spellLearnOrder do
                        print(spells.spellLearnOrder[i])
                        SelectHeroSkill(unit, spells[spells.spellLearnOrder[i]].id)

                        if GetHeroSkillPoints(unit) == 0 then break end
                    end
                end
            end


            
        end

        return self
    end
end

