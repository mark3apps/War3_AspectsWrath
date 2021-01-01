-- Dummy Blizzard Functions
dofile("C:\\Users\\markwright\\Documents\\GitHub\\War3_AspectsWrath\\Warcraft_Lua\\Tests\\Dummy_Data.lua")
dofile("C:\\Users\\markwright\\Documents\\GitHub\\War3_AspectsWrath\\Warcraft_Lua\\Tests\\Blizzard_Functions.lua")

-- Hero Class
dofile("C:\\Users\\markwright\\Documents\\GitHub\\War3_AspectsWrath\\Warcraft_Lua\\Hero_Class.lua")

-- AI Class
dofile("C:\\Users\\markwright\\Documents\\GitHub\\War3_AspectsWrath\\Warcraft_Lua\\AI_Class.lua")


heroUnitTesting = {id="H009", mana = "134"}

init_SpellsClass()
hero = heroClass.new()
local theSpell = hero:spell(heroUnitTesting, "ironDefense")

print(theSpell.id)
print(theSpell.mana)
print(theSpell.manaLeft)
print(theSpell.castable)