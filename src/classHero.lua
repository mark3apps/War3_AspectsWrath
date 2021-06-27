--
-- Hero Skills / Abilities Class
-----------------

hero = {}

function hero.init()
	-- Create Class Definition



		hero.players = {}
		for i = 1, 12 do hero.players[i] = {picked = false} end

		hero.items = {"teleportation", "tank"}
		hero.item = {}

		hero.item.teleportation = {
			name = "teleportation",
			properName = "Teleport",
			four = "I000",
			id = FourCC("I000"),
			abilityFour = "A01M",
			abilityId = FourCC("A01M"),
			order = "",
			instant = false,
			castTime = {6}
		}

		hero.item.tank = {name = "tank", properName = "Tank", four = "I005", id = FourCC("I005"), order = "", instant = true}

		hero.item.mage = {name = "mage", properName = "Mage", four = "I006", id = FourCC("I006"), order = "", instant = true}

		hero.item[hero.item.teleportation.id] = hero.item[hero.item.teleportation.name]
		hero.item[hero.item.tank.id] = hero.item[hero.item.tank.name]
		hero.item[hero.item.mage.id] = hero.item[hero.item.mage.name]

		hero.heroes = {"brawler", "manaAddict", "shiftMaster", "tactition", "timeMage"}
		hero.id = {}

		hero.id.E001 = "brawler"
		hero.brawler = {}
		hero.brawler.four = "E001"
		hero.brawler.fourAlter = "h00I"
		hero.brawler.id = FourCC(hero.brawler.four)
		hero.brawler.idAlter = FourCC(hero.brawler.fourAlter)
		hero.brawler.spellLearnOrder = {"unleashRage", "drain", "warstomp", "bloodlust"}
		hero.brawler.upgrades = {}
		hero.brawler.startingSpells = {}
		hero.brawler.permanentSpells = {}
		hero.brawler.startingItems = {"teleportation", "tank"}

		hero.drain = {
			name = "drain",
			properName = "Drain",
			four = "A01Y",
			id = FourCC("A01Y"),
			buff = 0,
			order = "stomp",
			ult = false,
			instant = false,
			castTime = {6, 6, 6, 6, 6, 6}
		}
		hero.bloodlust = {
			name = "bloodlust",
			properName = "Bloodlust",
			four = "A007",
			id = FourCC("A007"),
			buff = 0,
			order = "stomp",
			ult = false,
			instant = true
		}
		hero.warstomp = {
			name = "warstomp",
			properName = "War Stomp",
			four = "A002",
			id = FourCC("A002"),
			buff = 0,
			order = "stomp",
			ult = false,
			instant = true
		}
		hero.unleashRage = {
			name = "unleashRage",
			properName = "Unleassh Rage",
			four = "A029",
			id = FourCC("A029"),
			buff = 0,
			order = "stomp",
			ult = true,
			instant = false,
			castTime = {6, 6, 6, 6, 6, 6}
		}

		hero[hero.drain.four] = hero.drain.name
		hero[hero.bloodlust.four] = hero.bloodlust.name
		hero[hero.warstomp.four] = hero.warstomp.name
		hero[hero.unleashRage.four] = hero.unleashRage.name

		hero.id.H009 = "tactition"
		hero.tactition = {}
		hero.tactition.four = "H009"
		hero.tactition.fourAlter = "h00Y"
		hero.tactition.id = FourCC(hero.tactition.four)
		hero.tactition.idAlter = FourCC(hero.tactition.fourAlter)
		hero.tactition.spellLearnOrder = {"inspire", "raiseBanner", "ironDefense", "bolster", "attack"}
		hero.tactition.startingSpells = {"raiseBanner"}
		hero.brawler.upgrades = {}
		hero.tactition.permanentSpells = {}
		hero.tactition.startingItems = {"teleportation", "tank"}
		hero.ironDefense = {
			name = "ironDefense",
			properName = "Iron Defense",
			four = "A019",
			id = FourCC("A019"),
			buff = 0,
			order = "roar",
			ult = false,
			instant = true
		}
		hero.raiseBanner = {
			name = "raiseBanner",
			properName = "Raise Banner",
			four = "A01I",
			id = FourCC("A01I"),
			buff = 0,
			order = "healingward",
			ult = false,
			instant = true
		}
		hero.attack = {
			name = "attack",
			properName = "Attack!",
			four = "A01B",
			id = FourCC("A01B"),
			buff = 0,
			order = "fingerofdeath",
			ult = false,
			instant = true
		}
		hero.bolster = {
			name = "bolster",
			properName = "Bolster",
			four = "A01Z",
			id = FourCC("A01Z"),
			buff = 0,
			order = "tranquility",
			ult = false,
			instant = true
		}
		hero.inspire = {
			name = "inspire",
			properName = "Inspire",
			four = "A042",
			id = FourCC("A042"),
			buff = 0,
			order = "channel",
			ult = true,
			instant = true
		}

		hero[hero.ironDefense.four] = hero.ironDefense.name
		hero[hero.raiseBanner.four] = hero.raiseBanner.name
		hero[hero.attack.four] = hero.attack.name
		hero[hero.bolster.four] = hero.bolster.name
		hero[hero.inspire.four] = hero.inspire.name

		hero.id.E002 = "shiftMaster"
		hero.shiftMaster = {}
		hero.shiftMaster.four = "E002"
		hero.shiftMaster.fourAlter = "h00Q"
		hero.shiftMaster.id = FourCC(hero.shiftMaster.four)
		hero.shiftMaster.idAlter = FourCC(hero.shiftMaster.fourAlter)
		hero.shiftMaster.spellLearnOrder = {"shiftStorm", "felForm", "switch", "fallingStrike", "shift"}
		hero.shiftMaster.startingSpells = {"shift"}
		hero.brawler.upgrades = {"shadeStrength", "swiftMoves", "swiftAttacks"}

		hero.shiftMaster.permanentSpells = {
			"felForm", "fallingStrike", "shadeStrength", "swiftMoves", "swiftAttacks", "attributeStiftMaster"
		}
		hero.shiftMaster.startingItems = {"teleportation", "tank"}
		hero.attributeStiftMaster = {
			name = "attributeStiftMaster",
			properName = "Attribute Bonus",
			four = "A031",
			id = FourCC("A031"),
			buff = 0,
			order = "",
			ult = false
		}
		hero.shadeStrength = {
			name = "shadeStrength",
			properName = "Shade Strength",
			four = "A037",
			id = FourCC("A037"),
			buff = 0,
			order = "",
			ult = false
		}
		hero.swiftMoves = {
			name = "swiftMoves",
			properName = "Swift Moves",
			four = "A056",
			id = FourCC("A056"),
			buff = 0,
			order = "",
			ult = false
		}
		hero.swiftAttacks = {
			name = "swiftAttacks",
			properName = "Swift Attacks",
			four = "A030",
			id = FourCC("A030"),
			buff = 0,
			order = "",
			ult = false
		}

		hero.switch = {
			name = "switch",
			properName = "Switch",
			four = "A03U",
			id = FourCC("A03U"),
			buff = 0,
			order = "reveal",
			ult = false,
			instant = true
		}

		hero.shift = {
			name = "shift",
			properName = "Shift",
			four = "A03T",
			id = FourCC("A03T"),
			buff = 0,
			order = "berserk",
			ult = false,
			instant = true
		}

		hero.fallingStrike = {
			name = "fallingStrike",
			properName = "Falling Strike",
			four = "A059",
			id = FourCC("A059"),
			buff = 0,
			order = "thunderbolt",
			ult = false,
			instant = false,
			castTime = {1.5, 1.5, 1.5, 1.5, 1.5, 1.5}
		}

		hero.shiftStorm = {
			name = "shiftStorm",
			properName = "Shift Storm",
			four = "A03C",
			id = FourCC("A03C"),
			buff = 0,
			order = "channel",
			ult = true,
			instant = true
		}

		hero.felForm = {
			name = "felForm",
			properName = "Fel Form",
			four = "A02Y",
			id = FourCC("A02Y"),
			buff = 0,
			order = "metamorphosis",
			ult = true,
			instant = true
		}

		hero[hero.switch.four] = hero.switch.name
		hero[hero.shift.four] = hero.shift.name
		hero[hero.fallingStrike.four] = hero.fallingStrike.name
		hero[hero.shiftStorm.four] = hero.shiftStorm.name
		hero[hero.felForm.four] = hero.felForm.name

		hero.id.H00R = "manaAddict"
		hero.manaAddict = {}
		hero.manaAddict.four = "H00R"
		hero.manaAddict.fourAlter = "h00B"
		hero.manaAddict.id = FourCC(hero.manaAddict.four)
		hero.manaAddict.idAlter = FourCC(hero.manaAddict.fourAlter)
		hero.manaAddict.spellLearnOrder = {"starfall", "manaShield", "manaExplosion", "manaBomb", "soulBind"}
		hero.manaAddict.startingSpells = {"manaShield"}
		hero.manaAddict.permanentSpells = {}
		hero.manaAddict.startingItems = {"teleportation", "mage"}
		hero.manaShield = {
			name = "manaShield",
			properName = "Mana Shield",
			four = "A001",
			id = FourCC("A001"),
			buff = FourCC("BNms"),
			order = "manashieldon",
			ult = false,
			instant = true
		}
		hero.manaBomb = {
			name = "manaBomb",
			properName = "Mana bomb",
			four = "A03P",
			id = FourCC("A03P"),
			buff = 0,
			order = "flamestrike",
			ult = false,
			instant = true
		}
		hero.manaExplosion = {
			name = "manaExplosion",
			properName = "Mana Explosion",
			four = "A018",
			id = FourCC("A018"),
			buff = 0,
			order = "thunderclap",
			ult = false,
			instant = true
		}
		hero.soulBind = {
			name = "soulBind",
			properName = "Soul Bind",
			four = "A015",
			id = FourCC("A015"),
			buff = FourCC("B00F"),
			order = "custerrockets",
			ult = false,
			instant = true
		}
		hero.unleashMana = {
			name = "unleashMana",
			properName = "Unleash Mana",
			four = "A03S",
			id = FourCC("A03S"),
			buff = 0,
			order = "starfall",
			ult = true,
			instant = false,
			castTime = {15, 15, 15, 15, 15, 15}
		}

		hero[hero.manaShield.four] = hero.manaShield.name
		hero[hero.manaBomb.four] = hero.manaBomb.name
		hero[hero.manaExplosion.four] = hero.manaExplosion.name
		hero[hero.soulBind.four] = hero.soulBind.name
		hero[hero.unleashMana.four] = hero.unleashMana.name

		hero.id.H00J = "timeMage"
		hero.timeMage = {}
		hero.timeMage.four = "H00J"
		hero.timeMage.fourAlter = "h00Z"
		hero.timeMage.id = FourCC(hero.timeMage.four)
		hero.timeMage.idAlter = FourCC(hero.timeMage.fourAlter)
		hero.timeMage.spellLearnOrder = {"paradox", "timeTravel", "chronoAtrophy", "decay"}
		hero.timeMage.startingSpells = {}
		hero.timeMage.permanentSpells = {}
		hero.timeMage.startingItems = {"teleportation", "mage"}
		hero.chronoAtrophy = {
			name = "chronoAtrophy",
			properName = "Chrono Atrophy",
			four = "A04K",
			id = FourCC("A04K"),
			buff = 0,
			order = "flamestrike",
			ult = false,
			instant = true
		}
		hero.decay = {
			name = "decay",
			properName = "Decay",
			four = "A032",
			id = FourCC("A032"),
			buff = 0,
			order = "shadowstrike",
			ult = false,
			instant = true
		}
		hero.timeTravel = {
			name = "timeTravel",
			properName = "Time Travel",
			four = "A04P",
			id = FourCC("A04P"),
			buff = 0,
			order = "clusterrockets",
			ult = false,
			instant = true
		}
		hero.paradox = {
			name = "paradox",
			properName = "Paradox",
			four = "A04N",
			id = FourCC("A04N"),
			buff = 0,
			order = "tranquility",
			ult = true,
			instant = false,
			castTime = {10, 10, 10}
		}

		hero[hero.chronoAtrophy.four] = hero.chronoAtrophy.name
		hero[hero.decay.four] = hero.decay.name
		hero[hero.timeTravel.four] = hero.timeTravel.name
		hero[hero.paradox.four] = hero.paradox.name

		function hero.spell(heroUnit, spellName)
			local spellDetails = hero[spellName]
			spellDetails.level = hero.level(heroUnit, spellName)
			spellDetails.cooldown = hero.cooldown(heroUnit, spellName)
			spellDetails.hasBuff = hero.hasBuff(heroUnit, spellName)
			spellDetails.mana = hero.mana(heroUnit, spellName, spellDetails.level)
			spellDetails.manaLeft = heroUnit.mana - spellDetails.mana

			if spellDetails.level > 0 and spellDetails.cooldown == 0 and spellDetails.manaLeft >= 0 then
				spellDetails.castable = true
			else
				spellDetails.castable = false
			end

			-- print(spellName .. " : " .. spellDetails.level)
			-- print("Castable: " .. tostring(spellDetails.castable))

			return spellDetails
		end
		

		function hero.level(heroUnit, spellName) return GetUnitAbilityLevel(heroUnit.unit, hero[spellName].id) end

		function hero.cooldown(heroUnit, spellName)
			return BlzGetUnitAbilityCooldownRemaining(heroUnit.unit, hero[spellName].id)
		end

		function hero.mana(heroUnit, spellName, level)
			return BlzGetUnitAbilityManaCost(heroUnit.unit, hero[spellName].id, level)
		end

		function hero.hasBuff(heroUnit, spellName)
			if hero[spellName].buff == 0 then
				return false
			else
				return UnitHasBuffBJ(heroUnit.unit, hero[spellName].buff)
			end
		end

		function hero.levelUp(unit)
			local heroFour = CC2Four(GetUnitTypeId(unit))
			local heroName = hero[heroFour]
			local heroLevel = GetHeroLevel(unit)
			local heroPlayer = GetOwningPlayer(unit)
			local spells = hero[heroName]

			AdjustPlayerStateBJ(50, heroPlayer, PLAYER_STATE_RESOURCE_LUMBER)
			SetPlayerTechResearchedSwap(FourCC("R005"), heroLevel - 1, heroPlayer)
			
			if (ModuloInteger(heroLevel, 4) == 0) then
				SetPlayerTechResearchedSwap(FourCC("R006"), heroLevel / 4, heroPlayer)
			end

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
			if GetPlayerController(heroPlayer) == MAP_CONTROL_COMPUTER then
				local unspentPoints = GetHeroSkillPoints(unit)

				print("Unspent Abilities: " .. unspentPoints)

				if unspentPoints > 0 then
					for i = 1, #spells.spellLearnOrder do
						SelectHeroSkill(unit, hero[spells.spellLearnOrder[i]].id)

						if GetHeroSkillPoints(unit) == 0 then return end
					end
				end
			end
		end

		function hero.upgrade(unit) IssueUpgradeOrderByIdBJ(udg_AI_PursueHero[0], FourCC("R00D")) end

		function hero.setupHero(unit)
			local heroFour = CC2Four(GetUnitTypeId(unit))
			local heroName = hero[heroFour]
			local player = GetOwningPlayer(unit)
			local playerNumber = GetConvertedPlayerId(player)
			local heroLevel = GetHeroLevel(unit)
			local spells = hero[heroName] ---@type table
			local picked, u, x, y, newAlter
			local g = CreateGroup()

			hero.players[playerNumber] = {}

			-- Get home Base Location
			if playerNumber < 7 then
				x = GetRectCenterX(gg_rct_Left_Castle)
				y = GetRectCenterY(gg_rct_Left_Castle)
			else
				x = GetRectCenterX(gg_rct_Right_Castle)
				y = GetRectCenterY(gg_rct_Right_Castle)
			end

			-- Move hero to home base
			SetUnitPosition(unit, x, y)

			-- Give the hero the required Skill points for the spells
			ModifyHeroSkillPoints(unit, bj_MODIFYMETHOD_SET, #spells.startingSpells + 1)
			for i = 1, #spells.startingSpells do
				picked = hero[spells.startingSpells[i]]

				-- Have the hero learn the spell
				SelectHeroSkill(unit, picked.id)
			end

			-- Add the Permanent Spells for the Hero
			for i = 1, #spells.permanentSpells do
				picked = hero[spells.permanentSpells[i]]

				-- Make the Spell Permanent
				UnitMakeAbilityPermanent(unit, true, picked.id)
			end

			-- Give the Hero starting Items
			for i = 1, #spells.startingItems do
				picked = hero.item[spells.startingItems[i]]

				-- Make the Spell Permanent
				UnitAddItemById(unit, picked.id)
			end

			-- Set up Alter
			g = GetUnitsOfPlayerAndTypeId(player, FourCC("halt"))
			while true do
				u = FirstOfGroup(g)
				if u == nil then break end

				-- Replace Unit Alter
				ReplaceUnitBJ(u, hero[heroName].idAlter, bj_UNIT_STATE_METHOD_MAXIMUM)
				newAlter = GetLastReplacedUnitBJ()
				GroupRemoveUnit(g, u)
			end
			DestroyGroup(g)

			hero.players[playerNumber].picked = true
			hero.players[playerNumber].cameraLock = false
			hero.players[playerNumber].alter = newAlter
			hero.players[playerNumber].hero = unit
		end

end