udg_TalentGUIAddSpell = nil
udg_TalentGUICreateChoice = nil
udg_TalentGUICopy = nil
udg_TalentGUI_Level = 0
udg_TalentGUI_UnitType = 0
udg_TalentGUI_UnitTypeCopied = 0
udg_TalentGUI_Icon = ""
udg_TalentGUI_Text = ""
udg_TalentGUI_Head = ""
udg_TalentGUI_Spell = 0
udg_TalentGUI_ReplacedSpell = 0
udg_Talent__Unit = nil
udg_Talent__UnitCode = 0
udg_Talent__Choice = nil
udg_Talent__Level = 0
udg_Talent__Button = 0
udg_TalentControlPreventReset = __jarray(false)
gg_trg_Talent_MountainKing_Init_Commented = nil
gg_trg_Talent_Muradin = nil
gg_trg_Talent_MK_Event = nil
gg_trg_Talent_MK_Event_Reset = nil
gg_trg_Demo_Event_Gain_a_Choice = nil
gg_trg_Demo_Event_Finished_Chocies = nil
gg_trg_Demo_Macro = nil
gg_trg_Demo_Get = nil
gg_trg_Demo_PreventReset = nil
function InitGlobals()
    local i = 0
    udg_TalentGUI_Level = 0
    udg_TalentGUI_Icon = ""
    udg_TalentGUI_Text = ""
    udg_TalentGUI_Head = ""
    globals.udg_Talent__Event = 0.0
    udg_Talent__Level = 0
    udg_Talent__Button = 0
    i = 0
    while (true) do
        if ((i > 1)) then break end
        udg_TalentControlPreventReset[i] = false
        i = i + 1
    end
end

-- in 1.31 and upto 1.32.9 PTR (when I wrote this). Frames are not correctly saved and loaded, breaking the game.
-- This runs all functions added to it with a 0s delay after the game was loaded.
do
    local data = {}
    local real = MarkGameStarted
    local timer
    
    function FrameLoaderAdd(func)
        table.insert(data, func)
    end
    function MarkGameStarted()
        real()
        local trigger = CreateTrigger()
        timer = CreateTimer()
        TriggerRegisterGameEvent(trigger, EVENT_GAME_LOADED)
        TriggerAddAction(trigger, function()
            TimerStart(timer, 0, false, function()
                for _,v in ipairs(data) do v() end
            end)
            
        end)
    end
end
--[[
Talent Lui 1.34b
By Tasyen
===========================================================================
Talent provides at wanted Levels a choice from a collection (Tier), from which the user picks one.
Tiers are unitType specific (a paladin has different Choices then a demon hunter), This also includes the Levels obtaining them.
One can  choices by Events or one can bind Code beeing executed when picking a choice.
Regardless using Events or binded , creating a reset (revert picking a choice) is quite easy.
Talent is mui.
===========================================================================
function TalentMacroDo(unit, text)
    executes a bunch of Picks/Resets for unit
    "-U123" ->Unlearn all, Pick 1, Pick 2, Pick 3
    "-112"  -> Pick 1, Pick 1, Pick 2, s has to start with "-"
    Each done action will evoke events/actions.

function TalentGetMacro(unit)
    returns the text to be used inside TalentMacroDo to pick the current Picks.
	the use of this function is to save Talentpicks in files.

function TalentAddUnitSheet(unitSheetFunction)
    unitSheetFunction will be called when the game started.

function TalentHeroCopy(unitCode, copyOrigin)
    units of unitCode will use the Talents of copyOrigin.

function TalentHeroCreate(unitCode)
    Create a plan for units of that Type has to be done before adding choices/tiers.
    This should be the first Talent related action inside a unitSheetFunction. Copies should not use this.

function TalentHeroCreateTier(unitCode, level)
    Creates for unitCode at level an tier.

function TalentHeroCreateChoice(unitCode) returns table
    Adds to the tier with the highest level of that unitCode an new choice, should be the last created one.
    Returns the new choice

function TalentHeroCreateChoiceAtLevel(unitCode, level) returns table
    calls TalentHeroCreate if needed.
    Creates a tier if needed and creates a new choice to it.
    Returns the new choice

function TalentChoiceAddAbility(choice, gainedAbility, lostAbility) 
    when picking choice the unit gains gainedAbility and loses loseAbility with loseAbility = 0 no ability is lost.
    This behavior can be altered much with Settings.

wrappers they use what you last mentioned for removed arguments from the not-Ex versions.
function TalentHeroCreateTierEx(level)
function TalentHeroCreateChoiceEx()
function TalentHeroCreateChoiceAtLevelEx(level)
function TalentChoiceAddAbilityEx(gainedAbility, lostAbility)
function TalentMacroDoEx(player, text)
    wrapper for current TalentTarget of player
function TalentGetMacroEx(player)

function TalentGetUnitCode(unitCode)
    returns the unitCode beeing used inside Talent.

function TalentAddUnit(unit)
    Manualy add an Unit to Talent, use this when The autodetection is disabled.
function TalentAddSelection(unit)
    Manualy check for choices.

===========================================================================
Variables inside Events and Code Binding:
===========================================================================
udg_Talent__Unit 		= the unit doing the choice
udg_Talent__UnitCode 	= the unitCode the unit is using
udg_Talent__Choice 		= selected choice its a table.
udg_Talent__Level 		= the level from which this choice/Tier is.
udg_Talent__Button		= the Index of the Button used, 1 to Settings.BoxOptionMaxCount.
                        , this variable is needed for Event based Talent usage.
===========================================================================
Event:
===========================================================================
To identyfy a choice in an Event use udg_Talent__UnitCode, udg_Talent__Level and udg_Talent__Button.
Inside condition check for heroType, to use the correct talent tree for this Event.
        udg_Talent__UnitCode equal to (==) "wanted orignal Type"
Now create ifs one for each udg_Talent__Level that tree has. (it is the level of the tier picked from). 
Inside this ifs check the Button beeing used: udg_Talent__Button equal (==) 1  -> yes, do actions of Level x Button 1
Create another one with udg_Talent__Button equal (==) 2 -> yes, do actions of Level x, Button 2.
You can skip Button Ifs not beeing used for that hero-Class on that Level.

udg_Talent__Event
    1 => on Choice.
        after the Auotskills are added
    2 => Tier aviable, does only when there is no choice for this hero yet, Reset does not trigger this event.
    3 => Finished all choices of its hero Type.
    -1 => on Reset for each choice reseted.
        before the autoskills are removed

Events can be indivudal (de)activaded inside Settings
===========================================================================
Choice Data
===========================================================================
choice.OnLearn    = when that choice is picked (function)
choice.OnReset    = when that choice is lost (function)
choice.Head       = The Title shown
choice.Text       = The description of this choice
choice.Icon       = The Icon shown
choice.Abilities  = a table with paris of gained/lost abilities

inside the action udg_Talent__Choice.Head would give the headText.
=====

 --]]
 do
    local Settings = { UnitSheet = {}}
    Talent = {
        Trigger = {},
        Strings = {}
    }
    TalentBox = {
        Trigger = {},
        Frame = {},
        Control = {},
        OptionTitlePrefix = __jarray(""),
        OptionTitleSufix = __jarray("")
    }
    do
        Talent.Strings.ButtonResetTooltip = "Unlearn choosen Talents from this Level and higher Levels.|nCan also be used to relearn Talents from this level upwards."
        Talent.Strings.ButtonResetText = "(Un)Learn"
        Talent.Strings.TitleLevel = "Talent Level: "
        Talent.Strings.ButtonShowText = "Show Talent"
        Talent.Strings.NoTalentUser = "No Talent User"
        TalentBox.OptionTitlePrefix[1] = "|cffffcc00"    --Prefix for first option Title
        TalentBox.OptionTitleSufix[1] = ""    --Prefix for first option
        TalentBox.OptionTitlePrefix[2] = "|cffff00cc"
        TalentBox.OptionTitlePrefix[3] = "|cffcccccc"
    end
    do	    
        --AutoDetectUnitsEvent (true) will create an " enters map"  for Talent.Trigger.AutoDetect
        --AutoDetectUnitsInit (true) will enum all units on the map at 0.0s and add all units having TalentData to Talent.
        Settings.AutoDetectUnitsEvent = true
        Settings.AutoDetectUnitsInit = true
        --When you disabled both you have to manualy add Units to Talent.
        

        Settings.CloseWhenNoChoice = true
        Settings.AutoCloseWithoutSelection = true

        --Increases the Level of abilities gained by choices, if the  is already owned.
        Settings.ImproveAbilities = true 
        
        --(true) only add the new  if the  has the to replaced Ability
        Settings.ReplacedAbilityRequiered = true
        
        --Throw an Event when an  picks a choiceTalent
        Settings.ThrowEventPick = true

        --Throw an Event when an  gains a choice to pick a talent
        Settings.ThrowEventAvailable = true

        --Throw an Event when an  resets a choice
        Settings.ThrowEventReset = true
        
        --Throw an Event when an  picked the last Talent of its unitType.
        Settings.ThrowEventFinish = true

        --With false the unlearn Button won't exist
        --TalentBox.Control[GetConvertedPlayerId(player)].PreventResetButton = true will prevent player to use reset/Relearn button.
        Settings.BoxHaveResetButton = true

        --MaxAmount of Options shown in the UI of one tier.
        --The Buttons start with 1 and include Settings.BoxOptionMaxCount
        --One could still learn the Choice when a chat command would be provided.
        Settings.BoxOptionMaxCount = 6
        
        --Amount of LevelBoxes, if an  got more tiers there will be a page control.
        --if you want lest more boxes you might change TalentBoxLevelSizeX & TalentBoxLevelSizeY
        Settings.BoxLevelAmount = 5

        Settings.BoxLevelSizeX = 0.02 --sane values are below 0.05
        Settings.BoxLevelSizeY = 0.02 --sane values are below 0.05<

        --Bigger Options allow bigger texts, but also take more space of the screen, which reduces the possible amount of showing options in one tier.
        --XSize of an option in the TalentBox
        Settings.BoxOptionSizeX = 0.25
        --YSize of an option in the TalentBox, shouldn't be smaller than 0.04, when using Font 0.0085
        Settings.BoxOptionSizeY = 0.045

        Settings.BoxResetSizeX = 0.07
        Settings.BoxResetSizeY = 0.025
        
        --IconSize, should be smaller than TalentBoxOptionSizeY
        Settings.BoxOptionIconSize = 0.028

        --YSpace between 2 options, + values increases the space between, - values reduces they can also overlap.
        Settings.BoxOption2OptionGap = -0.005
        --YSpace between Title and option at the top.
        Settings.BoxOption2TitleGap = 0.05
        --YSpace between LevelBoxes and option at the bottom
        Settings.BoxOption2BottomGap = 0.0
        --The total y size varies with amount of shown options.
        Settings.BoxBaseSizeY = 0.02
        
        --Default Position of the TalentBox
        Settings.BoxPosX = 0.005
        Settings.BoxPosY = 0.2
        Settings.BoxPosType = FRAMEPOINT_BOTTOMLEFT

        --Default Position for the ShowTalentBoxButton
        Settings.BoxShowButtonPosX = 0.00
        Settings.BoxShowButtonPosY = 0.18
        Settings.BoxShowButtonPosType = FRAMEPOINT_BOTTOMLEFT
    end

	function TalentHeroLevel2SelectionIndex(unitCode, level)
		local count = 0
		if not Talent[unitCode]["Tier"][level] then --The level has no tier?
			return -1
		end
        
        for i = 1, Talent[unitCode].MaxLevel
        do
			if i > level then break end
			if Talent[unitCode]["Tier"][i] then
				count = count + 1
			end
		end
		return count
	end
	function TalentMacroDo(unit, text)
		if SubString(text, 0, 1) ~= "-" then --Invalid macro, macro has to start with "-"
			return
        end
        local sLength = StringLength(text)
        for i = 0, sLength
        do
            local char =  SubString(text, i, i + 1)
            if char == "U" or char == "u" then
                while (TalentResetDo(unit)) do end
			end
			local charAsInt  = S2I(char)
			if charAsInt > 0 then
				TalentPickDo(unit, charAsInt)
			end
		end
	end
    function TalentMacroDoEx(player, text)
        TalentMacroDo(TalentBox.Control[player].Target, text)
    end
    function TalentGetMacro(unit)
        local text = "-U"
        for int = 1, TalentUnitGetSelectionsDone(unit) do
            text = text .. Talent[unit].SelectionsDone[int].ButtonNr
        end
        return text
    end
    function TalentGetMacroEx(player)
        return TalentGetMacro(TalentBox.Control[player].Target)
    end
    function TalentHeroCreate(unitCode)
        Talent[unitCode] = { Tier = {}, Page = {}, MaxLevel = 0 }
        Talent.LastUsedUnitCode = unitCode
    end
    function TalentGetUnitCode(unitCode)
        --if that unitCode has data check if it has copyData
        if Talent[unitCode] and Talent[unitCode].Copy then return TalentGetUnitCode(Talent[unitCode].Copy) end
        return unitCode
    end
    function TalentHeroCopy(unitCode, copyOrigin)
        Talent[unitCode] = {Copy = copyOrigin}
    end
    function TalentHeroCreateTier(unitCode, level)
        Talent[unitCode]["Tier"][level] = {}
        Talent[unitCode].MaxLevel = IMaxBJ(Talent[unitCode].MaxLevel, level)
        Talent.LastUsedUnitCode = unitCode
        table.insert(Talent[unitCode].Page, level)
    end
    function TalentHeroCreateTierEx(level) TalentHeroCreateTier(Talent.LastUsedUnitCode, level) end

    function TalentHeroCreateChoiceAtLevel(unitCode, level)
        if not Talent[unitCode] then TalentHeroCreate(unitCode) end
        if not Talent[unitCode]["Tier"][level] then --create not existing Tier
            Talent[unitCode]["Tier"][level] = {}
            Talent[unitCode].MaxLevel = IMaxBJ(Talent[unitCode].MaxLevel, level)
        end
        local choice = { Abilities = {}, Icon = "", Text = "", Head = "" }
        Talent.LastUsedUnitCode = unitCode
        Talent.LastUsedChoice = choice
        table.insert(Talent[unitCode]["Tier"][level], choice) --add new choice
        return choice
    end
    function TalentHeroCreateChoiceAtLevelEx(level) return TalentHeroCreateChoiceAtLevel(Talent.LastUsedUnitCode, level) end

    function TalentHeroCreateChoice(unitCode) --adds a choice to the highest Level Tier for that hero.
        local choice = { Abilities = {}, Icon = "", Text = "", Head = "" }
        Talent.LastUsedUnitCode = unitCode
        Talent.LastUsedChoice = choice
        table.insert(Talent[unitCode]["Tier"][Talent[unitCode].MaxLevel], choice) --add new choice
        return choice
    end
    function TalentHeroCreateChoiceEx() return TalentHeroCreateChoice(Talent.LastUsedUnitCode) end
    
    function TalentChoiceAddAbility(choice, gainedAbility, lostAbility)
        table.insert(choice.Abilities, {gainedAbility, lostAbility})
    end
    function TalentChoiceAddAbilityEx(gainedAbility, lostAbility) TalentChoiceAddAbility(Talent.LastUsedChoice, gainedAbility, lostAbility) end

    function TalentUnitAddSelectionDone(unit, level, buttonNr)
        if not Talent[unit] then TalentAddUnit(unit) end
        Talent[unit].SelectionsDoneCount = Talent[unit].SelectionsDoneCount + 1
        Talent[unit].MaxLevel = IMaxBJ(Talent[unit].MaxLevel, level)
        Talent[unit].SelectionsDone[Talent[unit].SelectionsDoneCount] = {
            Level = level,
            ButtonNr = buttonNr,
            UnLearned = false}
        --table.insert(Talent[unit].SelectionsDone, {Level = level, ButtonNr = buttonNr})
        
    end
    function TalentUnitGetButtonUsed(unit, level)
        for k,v in pairs(Talent[unit].SelectionsDone)
        do
            if v.Level == level then return v.ButtonNr end
        end
        return 0
    end
    function TalentUnitGetSelectionsDone(unit)
        return Talent[unit].SelectionsDoneCount
    end
    
    function TalentUnitGetCurrentLevel(unit)
        if Talent[unit] then
            return Talent[unit].CurrentLevel
        else
            return 0
        end
    end
    
    function TalentUnitSetCurrentLevel(unit, level)
        Talent[unit].CurrentLevel = level
    end
    function TalentUnitSetHasChoice(unit, flag)
        Talent[unit].HasChoice = flag
    end
    function TalentAddSkill(unit, skillGained, newLevel)
		local skillGainedLevel = GetUnitAbilityLevel(unit, skillGained)
		if skillGainedLevel == 0 then --Already got skillGained?
			UnitAddAbility(unit, skillGained)
			UnitMakeAbilityPermanent(unit, true, skillGained)
			SetUnitAbilityLevel(unit, skillGained, newLevel)
		elseif Settings.ImproveAbilities then--Can upgrade Levels?
			SetUnitAbilityLevel(unit, skillGained, skillGainedLevel + 1)
		end
	end
	function TalentRemoveSkill(unit, skillLost)
		local skillLostLevel = GetUnitAbilityLevel(unit, skillLost)
		if Settings.ImproveAbilities and skillLostLevel > 1 then --Can Decrease Level?
			skillLostLevel = skillLostLevel - 1
			SetUnitAbilityLevel(unit, skillLost, skillLostLevel)
		else
			UnitRemoveAbility(unit, skillLost)
		end
	end
	function TalentReplaceSkill(unit, skillReplaced, skillGained)
		local skillReplacedLevel = GetUnitAbilityLevel(unit, skillReplaced)
		if not Settings.ReplacedAbilityRequiered or skillReplacedLevel ~= 0 then
			TalentRemoveSkill(unit, skillReplaced)
			if skillGained and skillGained > 0 then
				TalentAddSkill(unit, skillGained, skillReplacedLevel)
			end
		end
    end
    function TalentAddUnit(unit)
        if not Talent[unit] then
        Talent[unit] = {
            SelectionsDone = {},
            SelectionsDoneCount = 0,
            CurrentLevel = 0,
            HasChoice = false,
            MaxLevel = 0
        }
        end
    end
    function TalentAddSelection(unit)
		local tierGained
		local unitCode = TalentGetUnitCode(GetUnitTypeId(unit))
        local currentLevel = IMaxBJ(GetHeroLevel(unit), GetUnitLevel(unit))
        local lastSelection = TalentUnitGetCurrentLevel(unit)

        -- Only show 1 SelectionContainer at the same time.
        if Talent[unit].HasChoice then return end
        for level = lastSelection, currentLevel, 1 do
            if Talent[unitCode]["Tier"][level] then
                if level > currentLevel then break end
                if level > lastSelection then
                    TalentUnitSetCurrentLevel(unit, level)
                    TalentUnitSetHasChoice(unit, true)
                    TalentBoxSetTier(level, GetOwningPlayer(unit))
                    if Settings.ThrowEventAvailable then --Throw Selection Event
                        udg_Talent__Choice = nil
                        udg_Talent__Unit = unit
                        udg_Talent__UnitCode = unitCode
                        udg_Talent__Level = level		
                        globals.udg_Talent__Event = 0.0
                        globals.udg_Talent__Event = 2.0
                        globals.udg_Talent__Event = 0.0
                    end
                    --break
                    return
                end
            end
        end
		--if this part of  is reached there is no choice avaible
        
        if not Settings.CloseWhenNoChoice then
            TalentBoxSetTier(Talent[unit].CurrentLevel, GetOwningPlayer(unit))
        elseif GetLocalPlayer() == GetTriggerPlayer() then
            BlzFrameSetVisible(TalentBox.Frame.Box, false)
            BlzFrameSetVisible(TalentBox.Frame.Show, true)
        end
	end

    function TalentPickDo(unit, buttonNr)
		local unitCode 		    = TalentGetUnitCode(GetUnitTypeId(unit))
        local tierLevel 		= Talent[unit].CurrentLevel
        local tier 			    = Talent[unitCode]["Tier"][tierLevel]
        local choice 		    = tier[buttonNr]
        if not Talent[unit].HasChoice or not choice then --Requiers to have a Choice
			return false
        end

        for k, v in pairs(choice.Abilities) do
            local skillGained   = v[1]
            local skillReplaced = v[2]

            if skillReplaced and skillReplaced > 0 then --Replaces?
				TalentReplaceSkill(unit, skillReplaced, skillGained)
            else
				TalentAddSkill(unit, skillGained,1)
			end
        end

        --Load Data for Action/Event
        udg_Talent__Unit = unit
        udg_Talent__UnitCode = unitCode
        udg_Talent__Button = buttonNr
        udg_Talent__Choice = choice
        udg_Talent__Level = tierLevel
        --print(GetObjectName(udg_Talent__UnitCode), "Level: "..udg_Talent__Level,"ButtonNr: "..udg_Talent__Button)
        if choice.OnLearn then choice.OnLearn() end
        if Settings.ThrowEventPick then --Throw Selection Event
            globals.udg_Talent__Event = 0.0
            globals.udg_Talent__Event = 1.0
            globals.udg_Talent__Event = 0.0
        end
		
        --Save Choice don
        TalentUnitAddSelectionDone(unit, tierLevel, buttonNr)
        --Unmark having a selection.
        TalentUnitSetHasChoice(unit, false)
        
		--Last choice for this heroType?
        if Talent[unitCode].MaxLevel == tierLevel then
            --Throw Finish Choices Event.
            if Settings.ThrowEventFinish then
                globals.udg_Talent__Event = 0.0
				globals.udg_Talent__Event = 3.0
				globals.udg_Talent__Event = 0.0
			end
            TalentBoxUpdate(GetTriggerPlayer())
            if Settings.CloseWhenNoChoice and GetLocalPlayer() == GetTriggerPlayer() then
                BlzFrameSetVisible(TalentBox.Frame.Box, false)
                BlzFrameSetVisible(TalentBox.Frame.Show, true)
            end
		else
			--Check for further choices.
			TalentAddSelection(unit)
        end
        return true
    end
    
    function TalentResetDo(unit)
        if Talent[unit].SelectionsDoneCount <= 0 then return false end --No selections done -> skip the rest.
        local lastSelection      = Talent[unit].SelectionsDone[Talent[unit].SelectionsDoneCount]
        local unitCode 		    = TalentGetUnitCode(GetUnitTypeId(unit))
        local buttonNr          = lastSelection.ButtonNr
        local tierLevel 		= lastSelection.Level
        local tier 			    = Talent[unitCode]["Tier"][tierLevel]
        local choice 		    = tier[buttonNr]
        
        --Load Data for Action/Event
        udg_Talent__Unit = unit
        udg_Talent__UnitCode = unitCode
        udg_Talent__Button = buttonNr
        udg_Talent__Choice = choice
        udg_Talent__Level = tierLevel
        --print(GetObjectName(udg_Talent__UnitCode), "Level: "..udg_Talent__Level,"ButtonNr: "..udg_Talent__Button)
        if choice.OnReset then choice.OnReset() end
        
        --Remove Autoadded Skills
        for k, v in pairs(choice.Abilities)do
            local skillGained   = v[1]
            local skillReplaced = v[2]
            if skillReplaced and skillReplaced > 0 then --Replaces?
				TalentReplaceSkill(unit, skillGained, skillReplaced)
			else
				TalentRemoveSkill(unit, skillGained)
			end
        end
        lastSelection.UnLearned = true
        Talent[unit].SelectionsDoneCount = Talent[unit].SelectionsDoneCount - 1
        TalentUnitSetCurrentLevel(unit, tierLevel)
        TalentUnitSetHasChoice(unit, true)
        if Settings.ThrowEventReset then	--Throw a  that this choice is going to be lost.
            globals.udg_Talent__Event = 0.0
            globals.udg_Talent__Event = -1.0
            globals.udg_Talent__Event = 0.0
        end
        return true
    end
   
    function TalentBoxShowEmpty(player)
		local frameSizeY = 0.08
		local frameSizeX = Settings.BoxOptionSizeX + 0.05
		local optionSizeY = Settings.BoxOptionSizeY
        TalentBox.Control[player].LevelsCurrent = 0
        
		if GetLocalPlayer() == player then
            BlzFrameSetVisible(TalentBox.Frame.Option.Parent, false)
            BlzFrameSetVisible(TalentBox.Frame.Level.Parent, false)
            
			BlzFrameSetSize(TalentBox.Frame.Box, frameSizeX, frameSizeY)
			BlzFrameSetText(TalentBox.Frame.BoxTitle, Talent.Strings.NoTalentUser)
		end
	end
    
	function TalentBoxSetTier(level, player)
        local unit = TalentBox.Control[player].Target
        if unit == nil then return end
        local unitCode = TalentGetUnitCode(GetUnitTypeId(unit))
		local buttonused = TalentUnitGetButtonUsed(unit, level)
		local enable = GetPlayerAlliance(GetOwningPlayer(unit), player, ALLIANCE_SHARED_CONTROL) and Talent[unit].CurrentLevel == level and Talent[unit].HasChoice
        local frameSizeY = Settings.BoxBaseSizeY + Settings.BoxOption2TitleGap + Settings.BoxOption2BottomGap + RMaxBJ(Settings.BoxResetSizeY, Settings.BoxLevelSizeY)
		local frameSizeX = Settings.BoxOptionSizeX + 0.05
		local optionSizeY = Settings.BoxOptionSizeY
        TalentBox.Control[player].LevelsCurrent = level
        --print("TalentBoxSetTier", player, level)
		if GetLocalPlayer() == player then
            BlzFrameSetVisible(TalentBox.Frame.Option.Parent, true)
            --BlzFrameSetVisible(TalentBox.Frame.Level.Parent, true)
            for i = Settings.BoxOptionMaxCount, 1, -1
            do

                local choice = Talent[unitCode]["Tier"][level][i]
                --print(i, choice)
                if choice then
                    --print(choice.Text, choice.Icon, choice.Head)
					BlzFrameSetVisible(TalentBox.Frame.Option[i].Frame, true)
					BlzFrameSetText(TalentBox.Frame.Option[i].TextText, choice.Text)
					BlzFrameSetTexture( TalentBox.Frame.Option[i].Icon, choice.Icon, 0, true)
                    BlzFrameSetText(TalentBox.Frame.Option[i].Title, TalentBox.OptionTitlePrefix[i] .. choice.Head .. TalentBox.OptionTitleSufix[i] )
                    if i < Settings.BoxOptionMaxCount and i > 1 then
                        frameSizeY = frameSizeY + optionSizeY + Settings.BoxOption2OptionGap
                    else
                        frameSizeY = frameSizeY + optionSizeY
                    end
				else
					BlzFrameSetVisible(TalentBox.Frame.Option[i].Frame, false)
				end
				BlzFrameSetEnable(TalentBox.Frame.Option[i].Frame, enable)
            end
            --has something selected for this tier this unit has earlier selected something and that earlier selected one is not Unlearned
            --TalentHeroLevel2SelectionIndex(unitCode, level) > 0 has to be done to avoid nil pointers.
            if buttonused > 0 and TalentHeroLevel2SelectionIndex(unitCode, level) > 0 and not Talent[unit].SelectionsDone[TalentHeroLevel2SelectionIndex(unitCode, level)].UnLearned then
                BlzFrameSetVisible(TalentBox.Frame.Selected,true)
				BlzFrameClearAllPoints(TalentBox.Frame.Selected)
				--BlzFrameSetParent(TalentBox.Frame.Selected, TalentBox.Frame.Option[buttonused].Frame)
				BlzFrameSetAllPoints(TalentBox.Frame.Selected, TalentBox.Frame.Option[buttonused].Frame)
			else
				BlzFrameSetVisible(TalentBox.Frame.Selected,false)
			end
			BlzFrameSetSize(TalentBox.Frame.Box, frameSizeX, frameSizeY)
            BlzFrameSetText(TalentBox.Frame.BoxTitle, Talent.Strings.TitleLevel .. level)
            if Settings.BoxHaveResetButton then BlzFrameSetEnable(TalentBox.Frame.Reset, TalentUnitGetCurrentLevel(unit) >= level and not TalentBox.Control[player].PreventResetButton and not udg_TalentControlPreventReset[GetConvertedPlayerId(player)])  end
		end
	end

    function TalentBoxUpdate(player)
        local unit = TalentBox.Control[player].Target
		TalentBoxSetTier(TalentUnitGetCurrentLevel(unit), player)
	end

    local function TalentBoxUpdateLevelBoxes(player, levelStart)
        local unitCode = TalentGetUnitCode(GetUnitTypeId(TalentBox.Control[player].Target))
        local count = 0
        
        if Talent[unitCode] then
            local level = levelStart
            local finalLevel = Talent[unitCode].MaxLevel
            if level > finalLevel then level = 1 end
            if level < 1 then level = 1 end
            while (level <= finalLevel) do
                if Talent[unitCode]["Tier"][level] then --Have tier on that Level?
                    count = count + 1
                    TalentBox.Control[player].Levels[count] = level
                    TalentBox.Control[player].MaxLevel = level
                    if GetLocalPlayer() == player then
                        BlzFrameSetText(TalentBox.Frame.Level[count], I2S(level))
                        BlzFrameSetVisible(TalentBox.Frame.Level[count], true)	
                    end
                    if count >= Settings.BoxLevelAmount  then break end
                end
                level = level + 1
            end
            BlzFrameSetVisible(TalentBox.Frame.Level.Parent, count > 1) --when there is only one level to choose from hide the levels
            
            if GetLocalPlayer() == player and levelStart <= 1 then -- only Local Player and update only at first page
                BlzFrameSetVisible(TalentBox.Frame.PageDown, TalentBox.Control[player].MaxLevel < finalLevel)
                BlzFrameSetVisible(TalentBox.Frame.PageUp, TalentBox.Control[player].MaxLevel < finalLevel)
            end
            TalentBoxSetTier(TalentBox.Control[player].Levels[1], player)
        else
            if GetLocalPlayer() == player then
                BlzFrameSetVisible(TalentBox.Frame.PageDown, false)
                BlzFrameSetVisible(TalentBox.Frame.PageUp, false)
            end
        end
        for i = count + 1, Settings.BoxLevelAmount, 1 do
            --print("hide", i)
			BlzFrameSetVisible(TalentBox.Frame.Level[i], false)
        end
        
	end

	local function TalentBoxUpdateLevelBoxesDown(player, levelStart)
		local count = Settings.BoxLevelAmount + 1
		local level = levelStart
		local unitCode = TalentGetUnitCode(GetUnitTypeId(TalentBox.Control[player].Target))
		local finalLevel = Talent[unitCode].MaxLevel
        local first = true

        if level < 1 then level = finalLevel end
        if TalentHeroLevel2SelectionIndex(unitCode, level) < Settings.BoxLevelAmount then count = TalentHeroLevel2SelectionIndex(unitCode, level) + 1  end
        while (level > 0 and count > 1) do
            if Talent[unitCode]["Tier"][level] then --Have tier on that Level?
                count = count - 1
                TalentBox.Control[player].Levels[count] = level
                if first then
                    TalentBox.Control[player].MaxLevel = TalentBox.Control[player].Levels[count]
                    first = false
                end
                if GetLocalPlayer() == player then
                    BlzFrameSetText(TalentBox.Frame.Level[count], level)
                    BlzFrameSetVisible(TalentBox.Frame.Level[count], true)
                end
            end
            level = level - 1
        end
        TalentBoxSetTier(TalentBox.Control[player].MaxLevel, player)
	end

	--Shows the TalentBox and sets the target for activePlayer.
    function TalentBoxShow(target, activePlayer)
        --print("Select", GetUnitName(target))
        TalentBox.Control[activePlayer].Target = target -- used look

        if Talent[target] then
            TalentBoxUpdateLevelBoxes(activePlayer, 0)
            --TalentBoxSetTier(TalentUnitGetCurrentLevel(target), activePlayer)
            if Settings.BoxHaveResetButton then
                BlzFrameSetVisible(TalentBox.Frame.Reset, GetPlayerAlliance(GetOwningPlayer(TalentBox.Control[activePlayer].Target), activePlayer, ALLIANCE_SHARED_CONTROL))
            end
        else
            TalentBoxShowEmpty(activePlayer)
            if Settings.BoxHaveResetButton then
                BlzFrameSetVisible(TalentBox.Frame.Reset, false)
            end
        end
	end

    local function FrameLoseFocus()
        if GetLocalPlayer() == GetTriggerPlayer() then
            BlzFrameSetEnable(BlzGetTriggerFrame(), false)
            BlzFrameSetEnable(BlzGetTriggerFrame(), true)
        end
    end

    function TalentBoxCreate()
        BlzLoadTOCFile("war3mapimported\\talentbox.toc")
        TalentBox.Frame = {}
        TalentBox.Frame.Box = BlzCreateFrameByType("Dialog", "TalentBox", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "ScriptDialog", 0)
        TalentBox.Frame.BoxTitle = BlzCreateFrameByType("TEXT", "TalentBoxTitle", TalentBox.Frame.Box, "TalentBoxTitle", 0)
        TalentBox.Frame.Option = {}
        TalentBox.Frame.Option.Parent = BlzCreateFrameByType("FRAME", "TalentBoxOptionParent", TalentBox.Frame.Box, "", 0)
        TalentBox.Frame.Level = {}
        TalentBox.Frame.Level.Parent = BlzCreateFrameByType("FRAME", "TalentBoxLevelParent", TalentBox.Frame.Box, "", 0)
        TalentBox.Frame.Selected = BlzCreateFrame("TalentHighlight", TalentBox.Frame.Box, 0, 0)
		TalentBox.Frame.PageUp = BlzCreateFrame("TalentButtonUp", TalentBox.Frame.Level.Parent, 0, 0)
		TalentBox.Frame.PageDown =  BlzCreateFrame("TalentButtonDown", TalentBox.Frame.Level.Parent, 0, 0)
		
		TalentBox.Frame.Close = BlzCreateFrameByType("GLUETEXTBUTTON", "TalentCloseButton",TalentBox.Frame.Box, "ScriptDialogButton", 0)
		TalentBox.Frame.Show = BlzCreateFrameByType("GLUETEXTBUTTON", "TalentShowButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "ScriptDialogButton", 0)
    
		BlzFrameSetSize(TalentBox.Frame.Show, 0.05, 0.05)
		BlzFrameSetText(TalentBox.Frame.Show, Talent.Strings.ButtonShowText)
		BlzFrameSetAbsPoint(TalentBox.Frame.Show, Settings.BoxShowButtonPosType, Settings.BoxShowButtonPosX, Settings.BoxShowButtonPosY)
		
		BlzFrameSetPoint(TalentBox.Frame.BoxTitle, FRAMEPOINT_TOP, TalentBox.Frame.Box, FRAMEPOINT_TOP, 0.0, -0.03)
		BlzFrameSetText(TalentBox.Frame.BoxTitle, Talent.Strings.TitleLevel)
		
        
        BlzFrameSetText(TalentBox.Frame.Close, "X")
		BlzFrameSetSize(TalentBox.Frame.Close, 0.035, 0.035)

		BlzFrameSetVisible(TalentBox.Frame.Selected, false)

		BlzFrameSetAbsPoint(TalentBox.Frame.Box, Settings.BoxPosType, Settings.BoxPosX, Settings.BoxPosY)
        
        BlzTriggerRegisterFrameEvent(TalentBox.Trigger.PageDown, TalentBox.Frame.PageDown, FRAMEEVENT_CONTROL_CLICK)
        BlzTriggerRegisterFrameEvent(TalentBox.Trigger.PageUp, TalentBox.Frame.PageUp, FRAMEEVENT_CONTROL_CLICK)
        BlzTriggerRegisterFrameEvent(TalentBox.Trigger.Close, TalentBox.Frame.Close, FRAMEEVENT_CONTROL_CLICK)
        BlzTriggerRegisterFrameEvent(TalentBox.Trigger.Show, TalentBox.Frame.Show, FRAMEEVENT_CONTROL_CLICK)
        
        for i = 1, Settings.BoxOptionMaxCount do
            local fh = BlzCreateFrame("TalentBoxItem", TalentBox.Frame.Option.Parent, 0, i)
            TalentBox.Frame.Option[i] = {}
            TalentBox.Frame.Option[i].Frame = fh
            TalentBox.Frame.Option[i].InfoText = BlzGetFrameByName("TalentBoxItemInfoText", i)
            TalentBox.Frame.Option[i].TextText = BlzGetFrameByName("TalentBoxItemTextText", i)
            TalentBox.Frame.Option[i].Title = BlzGetFrameByName("TalentBoxItemTitle", i)
            TalentBox.Frame.Option[i].Icon = BlzGetFrameByName("TalentBoxItemIcon", i)
            TalentBox.Frame[fh] = i --remember this is button i
            if i > 1 then
			    BlzFrameSetPoint(fh, FRAMEPOINT_BOTTOM, TalentBox.Frame.Option[i - 1].Frame, FRAMEPOINT_TOP, 0, Settings.BoxOption2OptionGap)
            end
			BlzFrameSetEnable(TalentBox.Frame.Option[i].InfoText, false)
			BlzFrameSetEnable(TalentBox.Frame.Option[i].TextText, false)
			BlzFrameSetEnable(TalentBox.Frame.Option[i].Title, false)
			BlzFrameSetSize(fh, Settings.BoxOptionSizeX, Settings.BoxOptionSizeY)
			BlzFrameSetSize(TalentBox.Frame.Option[i].Icon, Settings.BoxOptionIconSize, Settings.BoxOptionIconSize)
			BlzTriggerRegisterFrameEvent(TalentBox.Trigger.Choice, fh, FRAMEEVENT_CONTROL_CLICK)

		end
		
		BlzFrameSetPoint(TalentBox.Frame.Option[1].Frame, FRAMEPOINT_BOTTOMLEFT, TalentBox.Frame.Box, FRAMEPOINT_BOTTOMLEFT, 0.025, 0.0235 + Settings.BoxOption2BottomGap + RMaxBJ(Settings.BoxLevelSizeY, Settings.BoxResetSizeY))
        
        --BlzFrameSetVisible(BlzGetFrameByName("TalentHighlight", 1), false) --was ist das? warum 1, 0 ist der freie.
		
		BlzFrameSetPoint(TalentBox.Frame.Close, FRAMEPOINT_TOPRIGHT, TalentBox.Frame.Box, FRAMEPOINT_TOPRIGHT, 0.0, 0)
		
        
        for i = 1, Settings.BoxLevelAmount do
            local fh = BlzCreateFrame("TalentBoxLevelButton", TalentBox.Frame.Level.Parent, 0, i)
            TalentBox.Frame.Level[i] = fh
            TalentBox.Frame[fh] = i --remember this is button i
            if i > 1 then
                BlzFrameSetPoint(fh, FRAMEPOINT_BOTTOMLEFT,TalentBox.Frame.Level[i - 1] , FRAMEPOINT_BOTTOMRIGHT, 0,0)
            end
			BlzFrameSetSize(fh, Settings.BoxLevelSizeX, Settings.BoxLevelSizeY)
			BlzTriggerRegisterFrameEvent(TalentBox.Trigger.LevelBox, fh, FRAMEEVENT_CONTROL_CLICK)
		end
		BlzFrameSetPoint(TalentBox.Frame.Level[1], FRAMEPOINT_BOTTOMLEFT, TalentBox.Frame.Box, FRAMEPOINT_BOTTOMLEFT, 0.027,0.0235)
		
		BlzFrameSetVisible(TalentBox.Frame.Box, false)
		
		BlzFrameSetPoint(TalentBox.Frame.PageDown, FRAMEPOINT_BOTTOMLEFT, TalentBox.Frame.Level[Settings.BoxLevelAmount], FRAMEPOINT_BOTTOMRIGHT, 0, 0.0005)
		BlzFrameSetPoint(TalentBox.Frame.PageUp, FRAMEPOINT_BOTTOM, TalentBox.Frame.PageDown, FRAMEPOINT_TOP, 0, -0.0005)
		
		if Settings.BoxHaveResetButton then
			
            TalentBox.Frame.Reset = BlzCreateFrameByType("GLUETEXTBUTTON", "TalentResetButton",TalentBox.Frame.Box, "ScriptDialogButton", 0)
            TalentBox.Frame.ResetToolTip = BlzCreateFrame("TalentBoxTextArea", TalentBox.Frame.Box, 0, 0)
			BlzFrameSetPoint(TalentBox.Frame.ResetToolTip, FRAMEPOINT_LEFT, TalentBox.Frame.Box, FRAMEPOINT_RIGHT, 0.03,0)
			BlzFrameSetSize(TalentBox.Frame.ResetToolTip, 0.22, 0.09)
			BlzFrameSetText(TalentBox.Frame.ResetToolTip, Talent.Strings.ButtonResetTooltip)
			BlzFrameSetTooltip(TalentBox.Frame.Reset, TalentBox.Frame.ResetToolTip)
			BlzFrameSetText(TalentBox.Frame.Reset, Talent.Strings.ButtonResetText)
            BlzFrameSetSize(TalentBox.Frame.Reset, Settings.BoxResetSizeX, Settings.BoxResetSizeY)
            BlzFrameSetPoint(TalentBox.Frame.Reset, FRAMEPOINT_BOTTOMRIGHT, TalentBox.Frame.Box, FRAMEPOINT_BOTTOMRIGHT, -0.027, 0.0235)
            BlzTriggerRegisterFrameEvent(TalentBox.Trigger.Reset, TalentBox.Frame.Reset, FRAMEEVENT_CONTROL_CLICK)
            
			
		end
		
    end

	function TalentInit()
        Talent.Trigger.LevelUp = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(Talent.Trigger.LevelUp, EVENT_PLAYER_HERO_LEVEL, nil)
		TriggerAddAction(Talent.Trigger.LevelUp, function() TalentAddSelection(GetTriggerUnit()) end)
        
		--Get Choices on Entering Map for lvl 1.
        if Settings.AutoDetectUnitsEvent then
            Talent.Trigger.AutoDetect = CreateTrigger()
            TriggerRegisterEnterRectSimple(Talent.Trigger.AutoDetect, GetPlayableMapRect())
            TriggerAddAction(Talent.Trigger.AutoDetect, function() TalentAddUnit(GetTriggerUnit()) TalentAddSelection(GetTriggerUnit()) end)
            TriggerAddCondition(Talent.Trigger.AutoDetect, Condition( function() return Talent[TalentGetUnitCode(GetUnitTypeId(GetTriggerUnit()))] ~= nil end))
        end
        
        
        TalentBox.Trigger.Choice = CreateTrigger()
        TriggerAddAction(TalentBox.Trigger.Choice, function()
            local fh = BlzGetTriggerFrame()
            local index = TalentBox.Frame[fh]
            local player = GetTriggerPlayer()
            if GetLocalPlayer() == player then
                BlzFrameSetEnable(fh, false)
                BlzFrameSetEnable(fh, true)
            end
            TalentPickDo(TalentBox.Control[player].Target, index)
            TalentBoxUpdate(player)
        end)

        TalentBox.Trigger.LevelBox = CreateTrigger()
        TriggerAddAction(TalentBox.Trigger.LevelBox, function()
            local player = GetTriggerPlayer()
            local fh = BlzGetTriggerFrame()
            local index = TalentBox.Frame[fh]
            TalentBoxSetTier(TalentBox.Control[player].Levels[index], player)
        end)
        TalentBox.Trigger.PageDown = CreateTrigger()
        
        TriggerAddAction(TalentBox.Trigger.PageDown, function()
            TalentBoxUpdateLevelBoxesDown(GetTriggerPlayer(), TalentBox.Control[GetTriggerPlayer()].Levels[1]-1)            
        end)
        
        TalentBox.Trigger.PageUp = CreateTrigger()

        TriggerAddAction(TalentBox.Trigger.PageUp, function()
            TalentBoxUpdateLevelBoxes(GetTriggerPlayer(), TalentBox.Control[GetTriggerPlayer()].MaxLevel + 1)            
        end)

        TalentBox.Trigger.Select = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(TalentBox.Trigger.Select, EVENT_PLAYER_UNIT_SELECTED)
        TriggerAddAction(TalentBox.Trigger.Select, function()
            TalentBoxShow(GetTriggerUnit(), GetTriggerPlayer())
        end)
        

        TalentBox.Trigger.Close = CreateTrigger()
        
		TriggerAddAction(TalentBox.Trigger.Close, function()
            if GetLocalPlayer() == GetTriggerPlayer() then
                BlzFrameSetVisible(TalentBox.Frame.Box, false)
                BlzFrameSetVisible(TalentBox.Frame.Show, true)
            end
        end)
        TriggerAddAction(TalentBox.Trigger.Close, FrameLoseFocus)

        
        TalentBox.Trigger.Show = CreateTrigger()
		TriggerAddAction(TalentBox.Trigger.Show, function()
            if GetLocalPlayer() == GetTriggerPlayer() then
                BlzFrameSetVisible(TalentBox.Frame.Box, true)
                BlzFrameSetVisible(TalentBox.Frame.Show, false)
                TalentBoxUpdate(GetTriggerPlayer())
            end
        end)
        
		--TriggerAddAction(TalentBox.Trigger.Choice, FrameLoseFocus)
		TriggerAddAction(TalentBox.Trigger.LevelBox, FrameLoseFocus)
		TriggerAddAction(TalentBox.Trigger.PageDown, FrameLoseFocus)
		TriggerAddAction(TalentBox.Trigger.PageUp, FrameLoseFocus)
        

        TalentBox.Trigger.Reset = CreateTrigger()
        TriggerAddAction(TalentBox.Trigger.Reset, function()
            
            local player = GetTriggerPlayer()
            local unit = TalentBox.Control[player].Target
            local shownLevel = TalentBox.Control[player].LevelsCurrent
            local selectedCount = TalentUnitGetSelectionsDone(unit)
            local selectedLevel = 0
            if selectedCount > 0 then selectedLevel = Talent[unit].SelectionsDone[selectedCount].Level end

           -- print("selectedCount", selectedCount)
           -- print("selectedLevel", selectedLevel)
            --print("shownLevel", shownLevel)
            if selectedLevel >= shownLevel  then 
                --print("Reset")
                while(TalentUnitGetSelectionsDone(unit) > 0 and Talent[unit].SelectionsDone[TalentUnitGetSelectionsDone(unit)].Level >= shownLevel)
                do
                    --print("Reset", Talent[unit].SelectionsDone[TalentUnitGetSelectionsDone(unit)].Level)
                    TalentResetDo(TalentBox.Control[player].Target)
                end
            else
                --if TalentUnitGetCurrentLevel(unit) < shownLevel then print("lower talents not selected") end --Has to be avoided by disabling the option to do this in this case
                
                --learn reseted talents from the shown level to the max Level learned.
                for k, v in pairs(Talent[unit].SelectionsDone) do
                    if v.Level <= Talent[unit].MaxLevel and v.Level >= shownLevel then
                        --print("ReLearn", "Level: "..v.Level, "ButtonNr: "..v.ButtonNr)
                        TalentPickDo(TalentBox.Control[player].Target, v.ButtonNr)
                    end
                end                 
            end
            TalentBoxUpdate(player)
        end)
        TriggerAddAction(TalentBox.Trigger.Reset, FrameLoseFocus)

        
		
    end
    
    --Adds an function to the queue beeing executed as soon the game started.
    function TalentAddUnitSheet(unitSheetFunction)
        table.insert(Settings.UnitSheet, unitSheetFunction)
    end

    --Calls all unitSheetFunctions Added as soon the game starts.
    do
        local real = MarkGameStarted
     function MarkGameStarted()
            real()
            xpcall(function()
        TalentInit()
        TalentBoxCreate()
        if FrameLoaderAdd then FrameLoaderAdd(TalentBoxCreate) end
        --create needed tables for players
        for i = 0, bj_MAX_PLAYER_SLOTS - 1, 1 do
            TalentBox.Control[Player(i)] = {}
            TalentBox.Control[Player(i)].Levels = {}
            TalentBox.Control[Player(i)].PreventResetButton = false
        end
        if TalentPreMadeChoiceStrings then TalentPreMadeChoiceStrings() end
        --call all added UnitSheets
        for k,v in pairs(Settings.UnitSheet)
        do
            v()
        end

        if Settings.AutoDetectUnitsInit then
            --Add possible choices to all Units having the Talent book.
            local g = CreateGroup()
            GroupEnumUnitsInRect (g, GetPlayableMapRect(), nil)
            ForGroup(g, function()
                if Talent[TalentGetUnitCode(GetUnitTypeId(GetEnumUnit()))] ~= nil then
                    TalentAddUnit(GetEnumUnit())
                    TalentAddSelection(GetEnumUnit())
                end
            end)
            --cleanup
		    DestroyGroup(g)
        end
        
        
        Settings.UnitSheet = nil
    end,print)
     end
    end
    if Settings.AutoCloseWithoutSelection then
        TalentBox.Control.SelectionCheckGroup = CreateGroup()
        TalentBox.Control.SelectionCheckTimer = CreateTimer()
        TimerStart(TalentBox.Control.SelectionCheckTimer,0.1, true, function() 
            GroupEnumUnitsSelected(TalentBox.Control.SelectionCheckGroup, GetLocalPlayer(), nil)
            if FirstOfGroup(TalentBox.Control.SelectionCheckGroup) == nil then
                BlzFrameSetVisible(TalentBox.Frame.Box, false)
                BlzFrameSetVisible(TalentBox.Frame.Show, true)            
            end            
        end)
    end
end

--Buggy Has to be fixxed. Disallows Starting the map


--[[
TalentPreMadeChoice 1.2a
by Tasyen

Contains Predefined ChoiceCreations

API
=========
TalentChoiceCreateStats( strAdd,  agiAdd,  intAdd )
Create a new Choice which adds Str, agi and int.
The Choice is added to the last created Tier.
This also generates Main-Text showing the stats gained.
If you wana add pre Text do it as shown below
choice.Text = "your Text" .. choice.Text

TalentChoiceCreateStr( add )
TalentChoiceCreateAgi( add )
TalentChoiceCreateInt( add )

TalentChoiceCreateSustain(lifeAdd, lifeRegAdd, manaAdd, manaRegAdd, armorAdd)

TalentChoiceCreateImproveWeapon( weaponIndex,  damageAdd,  cooldownAdd )

TalentChoiceCreateImproveSpell(spell, manaCostAdd, cooldownAdd, rangeAdd, unitDurAdd, heroDurAdd, missileSpeedAdd, radiusAdd, castTimeAdd)

TalentChoiceCreateAddSpells( spell1,  spell2,  spell3 )
creates a new choice add it to the last created Tier and pushes spell1, spell2, and spell3 onto the choice.
spell2 and spell3 are only added if they are not 0.

TalentChoiceCreateAddSpell( spell,  useButtonInfos )
this choice will add 1 , if useButtonInfos is used then text, HeadLine and Icon are taken from the spell

TalentChoiceCreateReplaceSpell( oldSpell,  newSpell )

=======================
--]]
function TalentPreMadeChoiceStrings()
    Talent.Strings.AddSpellFirst = "Learn:"
    Talent.Strings.AddSpellFirstSeperator = " "
    Talent.Strings.AddSpellSeperator = ", "

    Talent.Strings.ImproveSpellFirst = ""
    Talent.Strings.ImproveSpellSeperatorFirst = ""
    Talent.Strings.ImproveSpellSeperator = ", "
    Talent.Strings.ImproveSpellManaCost = "Manacost-Change"
    Talent.Strings.ImproveSpellCoolDown = "Cooldown-Change"
    Talent.Strings.ImproveSpellRange = "Range-Change"
    Talent.Strings.ImproveSpellRadius = "Radius-Change"
    Talent.Strings.ImproveSpellDurHero = "Hero-Duration-Change"
    Talent.Strings.ImproveSpellDurUnit = "Unit-Duration-Change"
    Talent.Strings.ImproveSpellMissile = "MissleSpeed-Change"
    Talent.Strings.ImproveSpellCastTime = "CastTime-Change"

    Talent.Strings.ImproveWeaponFirst = "Weapon: "
    Talent.Strings.ImproveWeaponSeperatorFirst = ""
    Talent.Strings.ImproveWeaponSeperator = ", "
    Talent.Strings.ImproveWeaponDamage = GetLocalizedString("COLON_DAMAGE")
    Talent.Strings.ImproveWeaponCooldown = GetLocalizedString("COLON_SPEED")

    Talent.Strings.SustainFirst = ""
    Talent.Strings.SustainSeperatorFirst = ""
    Talent.Strings.SustainSeperator = ", "
    Talent.Strings.SustainLife = "Life-Bonus "
    Talent.Strings.SustainLifeReg = "LifeReg-Bonus "
    Talent.Strings.SustainMana = "Mana-Bonus "
    Talent.Strings.SustainManaReg = "ManaReg-Bonus "
    Talent.Strings.SustainArmor = GetLocalizedString("COLON_ARMOR")
    
    Talent.Strings.HeroStatsFirst = ""
    Talent.Strings.HeroStatsSeperator = ", "
    Talent.Strings.HeroStatsSeperatorFirst = ""
    Talent.Strings.HeroStatsStr = GetLocalizedString("COLON_STRENGTH")
    Talent.Strings.HeroStatsAgi = GetLocalizedString("COLON_AGILITY")
    Talent.Strings.HeroStatsInt = GetLocalizedString("COLON_INTELLECT")
end
function TalentChoiceStatsLearn()
	SetHeroStr(udg_Talent__Unit, GetHeroStr(udg_Talent__Unit,false) + udg_Talent__Choice.Str,true)
	SetHeroAgi(udg_Talent__Unit, GetHeroAgi(udg_Talent__Unit,false) + udg_Talent__Choice.Agi,true)
	SetHeroInt(udg_Talent__Unit, GetHeroInt(udg_Talent__Unit,false) + udg_Talent__Choice.Int,true)
end
function TalentChoiceStatsReset()
	SetHeroStr(udg_Talent__Unit, GetHeroStr(udg_Talent__Unit,false) - udg_Talent__Choice.Str,true)
	SetHeroAgi(udg_Talent__Unit, GetHeroAgi(udg_Talent__Unit,false) - udg_Talent__Choice.Agi,true)
	SetHeroInt(udg_Talent__Unit, GetHeroInt(udg_Talent__Unit,false) - udg_Talent__Choice.Int,true)
end
function TalentChoiceSustainLearn()
	BlzSetUnitMaxHP(udg_Talent__Unit, BlzGetUnitMaxHP(udg_Talent__Unit) + udg_Talent__Choice.BonusLife)
	BlzSetUnitMaxMana(udg_Talent__Unit, BlzGetUnitMaxMana(udg_Talent__Unit) + udg_Talent__Choice.BonusMana)
	BlzSetUnitArmor(udg_Talent__Unit, BlzGetUnitArmor(udg_Talent__Unit) + udg_Talent__Choice.BonusArmor)
	BlzSetUnitRealField(udg_Talent__Unit, UNIT_RF_HIT_POINTS_REGENERATION_RATE, BlzGetUnitRealField(udg_Talent__Unit, UNIT_RF_HIT_POINTS_REGENERATION_RATE) + udg_Talent__Choice.BonusLifeReg)
	BlzSetUnitRealField(udg_Talent__Unit, UNIT_RF_MANA_REGENERATION, BlzGetUnitRealField(udg_Talent__Unit, UNIT_RF_MANA_REGENERATION) + udg_Talent__Choice.BonusManaReg)
	SetUnitState(udg_Talent__Unit, UNIT_STATE_LIFE, GetUnitState(udg_Talent__Unit,UNIT_STATE_LIFE) + udg_Talent__Choice.BonusLife)
	SetUnitState(udg_Talent__Unit, UNIT_STATE_MANA, GetUnitState(udg_Talent__Unit,UNIT_STATE_MANA) + udg_Talent__Choice.BonusMana)
end
function TalentChoiceSustainReset()
	BlzSetUnitMaxHP(udg_Talent__Unit, BlzGetUnitMaxHP(udg_Talent__Unit) - udg_Talent__Choice.BonusLife)
	BlzSetUnitMaxMana(udg_Talent__Unit, BlzGetUnitMaxMana(udg_Talent__Unit) - udg_Talent__Choice.BonusMana)
	BlzSetUnitArmor(udg_Talent__Unit, BlzGetUnitArmor(udg_Talent__Unit) - udg_Talent__Choice.BonusArmor)
	BlzSetUnitRealField(udg_Talent__Unit, UNIT_RF_HIT_POINTS_REGENERATION_RATE, BlzGetUnitRealField(udg_Talent__Unit, UNIT_RF_HIT_POINTS_REGENERATION_RATE) - udg_Talent__Choice.BonusLifeReg)
	BlzSetUnitRealField(udg_Talent__Unit, UNIT_RF_MANA_REGENERATION, BlzGetUnitRealField(udg_Talent__Unit, UNIT_RF_MANA_REGENERATION) - udg_Talent__Choice.BonusManaReg)
end

function TalentChoiceImproveWeaponLearn()
	BlzSetUnitAttackCooldown(udg_Talent__Unit, BlzGetUnitAttackCooldown(udg_Talent__Unit, udg_Talent__Choice.WeaponIndex) + udg_Talent__Choice.BonusCooldown, udg_Talent__Choice.WeaponIndex)
	BlzSetUnitBaseDamage(udg_Talent__Unit, BlzGetUnitBaseDamage(udg_Talent__Unit, udg_Talent__Choice.WeaponIndex) + udg_Talent__Choice.BonusDamage, udg_Talent__Choice.WeaponIndex)
end
function TalentChoiceImproveWeaponReset()
	BlzSetUnitAttackCooldown(udg_Talent__Unit, BlzGetUnitAttackCooldown(udg_Talent__Unit, udg_Talent__Choice.WeaponIndex) - udg_Talent__Choice.BonusCooldown, udg_Talent__Choice.WeaponIndex)
	BlzSetUnitBaseDamage(udg_Talent__Unit, BlzGetUnitBaseDamage(udg_Talent__Unit, udg_Talent__Choice.WeaponIndex) - udg_Talent__Choice.BonusDamage, udg_Talent__Choice.WeaponIndex)
end
function TalentChoiceCreateStats(strAdd, agiAdd, intAdd)
    local choice = TalentHeroCreateChoiceEx()
    
	choice.OnLearn = TalentChoiceStatsLearn
	choice.OnReset = TalentChoiceStatsReset
	choice.Str = strAdd
	choice.Agi = agiAdd
	choice.Int = intAdd
	
    choice.Text = Talent.Strings.HeroStatsFirst
    local seperator = Talent.Strings.HeroStatsSeperatorFirst
    local seperator2 = Talent.Strings.HeroStatsSeperator
    if strAdd ~= 0 then	choice.Text = choice.Text.. seperator .. Talent.Strings.HeroStatsStr .. strAdd seperator = seperator2 end
	if agiAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.HeroStatsAgi .. agiAdd seperator = seperator2 end
	if intAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.HeroStatsInt .. intAdd seperator = seperator2 end
	return choice
end
function TalentChoiceCreateStr( add )
	return TalentChoiceCreateStats(add,0,0)
end
function TalentChoiceCreateAgi( add )
	return TalentChoiceCreateStats(0,add,0)
end
function TalentChoiceCreateInt( add )
	return TalentChoiceCreateStats(0,0,add)
end
function TalentChoiceCreateSustain(lifeAdd, lifeRegAdd, manaAdd, manaRegAdd, armorAdd)
	local choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = TalentChoiceSustainLearn
	choice.OnReset = TalentChoiceSustainReset
	choice.BonusLife = lifeAdd
	choice.BonusLifeReg = lifeRegAdd
	choice.BonusMana = manaAdd
	choice.BonusManaReg = manaRegAdd
	choice.BonusArmor = armorAdd

    choice.Text = Talent.Strings.SustainFirst
    local seperator = Talent.Strings.SustainSeperatorFirst
    local seperator2 = Talent.Strings.SustainSeperator
    if armorAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.SustainArmor .. armorAdd seperator = seperator2 end
	if lifeAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.SustainLife .. lifeAdd seperator = seperator2 end
    if lifeRegAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.SustainLifeReg .. lifeRegAdd seperator = seperator2 end
    if manaAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.SustainMana .. manaAdd seperator = seperator2 end
    if manaRegAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.SustainManaReg .. manaRegAdd seperator = seperator2 end

	return choice
end
function TalentChoiceCreateImproveWeapon( weaponIndex,  damageAdd,  cooldownAdd )
	local choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = TalentChoiceImproveWeaponLearn
	choice.OnReset = TalentChoiceImproveWeaponReset
	choice.WeaponIndex = weaponIndex
	choice.BonusDamage = damageAdd
	choice.BonusCooldown = cooldownAdd

    choice.Text = Talent.Strings.ImproveWeaponFirst
    local seperator = Talent.Strings.ImproveWeaponSeperatorFirst
    if damageAdd ~= 0 then choice.Text = choice.Text.. seperator .. Talent.Strings.ImproveWeaponDamage .. damageAdd seperator = Talent.Strings.ImproveWeaponSeperator end
    if cooldownAdd ~= 0 then thenchoice.Text = choice.Text.. seperator .. Talent.Strings.ImproveWeaponCooldown .. cooldownAdd end
	return choice
end

function TalentChoiceImproveSpellLearn()
    local spell = BlzGetUnitAbility(udg_Talent__Unit, udg_Talent__Choice.Spell)
    
    BlzSetAbilityIntegerField(spell, ABILITY_IF_MISSILE_SPEED, BlzGetAbilityIntegerField(spell, ABILITY_IF_MISSILE_SPEED) + udg_Talent__Choice.Speed)
    for level = 0, BlzGetAbilityIntegerField(spell,ABILITY_IF_LEVELS), 1 do
        BlzSetAbilityIntegerLevelField(spell, ABILITY_ILF_MANA_COST, level, BlzGetAbilityIntegerLevelField(spell, ABILITY_ILF_MANA_COST, level) + udg_Talent__Choice.Mana)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_NORMAL, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_NORMAL, level) + udg_Talent__Choice.DurUnit)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_HERO, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_HERO, level) + udg_Talent__Choice.DurHero)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_COOLDOWN, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_COOLDOWN, level) + udg_Talent__Choice.Cool)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_AREA_OF_EFFECT, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_AREA_OF_EFFECT, level) + udg_Talent__Choice.Area)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_CAST_RANGE, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_CAST_RANGE, level) + udg_Talent__Choice.Range)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_CASTING_TIME, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_CASTING_TIME, level) + udg_Talent__Choice.CastTime)
    end
end
function TalentChoiceImproveSpellReset()
    local spell = BlzGetUnitAbility(udg_Talent__Unit, udg_Talent__Choice.Spell)
    
    BlzSetAbilityIntegerField(spell, ABILITY_IF_MISSILE_SPEED, BlzGetAbilityIntegerField(spell, ABILITY_IF_MISSILE_SPEED) - udg_Talent__Choice.Speed)
    for level = 0, BlzGetAbilityIntegerField(spell,ABILITY_IF_LEVELS), 1 do
        BlzSetAbilityIntegerLevelField(spell, ABILITY_ILF_MANA_COST, level, BlzGetAbilityIntegerLevelField(spell, ABILITY_ILF_MANA_COST, level) - udg_Talent__Choice.Mana)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_NORMAL, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_NORMAL, level) - udg_Talent__Choice.DurUnit)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_HERO, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DURATION_HERO, level) - udg_Talent__Choice.DurHero)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_COOLDOWN, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_COOLDOWN, level) - udg_Talent__Choice.Cool)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_AREA_OF_EFFECT, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_AREA_OF_EFFECT, level) - udg_Talent__Choice.Area)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_CAST_RANGE, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_CAST_RANGE, level) - udg_Talent__Choice.Range)
        BlzSetAbilityRealLevelField(spell, ABILITY_RLF_CASTING_TIME, level, BlzGetAbilityRealLevelField(spell, ABILITY_RLF_CASTING_TIME, level) - udg_Talent__Choice.CastTime)
    end
end
function TalentChoiceCreateImproveSpell(spell, manaCostAdd, cooldownAdd, rangeAdd, unitDurAdd, heroDurAdd, missileSpeedAdd, radiusAdd, castTimeAdd)
	local choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = TalentChoiceImproveSpellLearn
	choice.OnReset = TalentChoiceImproveSpellReset
	choice.Spell = spell
	choice.Mana = manaCostAdd
    choice.Cool = cooldownAdd
    choice.Range = rangeAdd
    choice.DurUnit = unitDurAdd
    choice.DurHero = heroDurAdd
    choice.Speed = missileSpeedAdd
    choice.Area = radiusAdd
    choice.CastTime = castTimeAdd

    choice.Text = Talent.Strings.ImproveSpellFirst
    local seperator = Talent.Strings.ImproveSpellSeperatorFirst
    local seperator2 = Talent.Strings.ImproveSpellSeperator
    if manaCostAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellManaCost .. manaCostAdd seperator = seperator2 end
    if cooldownAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellCoolDown .. cooldownAdd seperator = seperator2 end
    if rangeAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellRange .. rangeAdd seperator = seperator2 end
    if unitDurAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellDurUnit .. unitDurAdd seperator = seperator2 end
    if heroDurAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellDurHero .. heroDurAdd seperator = seperator2 end
    if missileSpeedAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellMissile .. missileSpeedAdd seperator = seperator2 end
    if radiusAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellRadius .. radiusAdd seperator = seperator2 end
    if castTimeAdd ~= 0 then choice.Text = choice.Text .. seperator .. Talent.Strings.ImproveSpellCastTime .. castTimeAdd seperator = seperator2 end
	return choice
end
function TalentChoiceCreateAddSpell( spell,  useButtonInfos )
	local choice = TalentHeroCreateChoiceEx()
	TalentChoiceAddAbilityEx(spell, 0)
	
	if useButtonInfos then
		choice.Text = BlzGetAbilityExtendedTooltip(spell,0)
		choice.Head = BlzGetAbilityTooltip(spell,0)
		choice.Icon = BlzGetAbilityIcon(spell)
	end
	return choice
end
function TalentChoiceCreateReplaceSpell( oldSpell,  newSpell )
	local choice = TalentHeroCreateChoiceEx()
	TalentChoiceAddAbilityEx(newSpell, oldSpell)
	return choice
end
function TalentChoiceCreateAddSpells(...)
    local arg = {...} -- get the variable arguments, for some reason it adds an addtional entry at the end.
    local choice = TalentHeroCreateChoiceEx()
    choice.Text = Talent.Strings.AddSpellFirst

    for i = 1, #arg - 1, 1 do
        TalentChoiceAddAbilityEx(arg[i], 0)
        if i == 1 then
			choice.Text = choice.Text .. Talent.Strings.AddSpellFirstSeperator .. GetObjectName(arg[i]).."|r"
        else
			choice.Text = choice.Text .. Talent.Strings.AddSpellSeperator .. GetObjectName(arg[i]).."|r"
		end
	end
	return choice
end


--Example for using Talent by Tasyen.

TalentAddUnitSheet(function()

	local heroTypeId =  FourCC('H005')	--Custom BloodMage
	local choice
	TalentHeroCreate(heroTypeId)

	TalentHeroCreateTierEx(1)
	choice = TalentChoiceCreateAddSpells( FourCC('AHfs'), FourCC('ANbf'), FourCC('ANfb'))
	choice.Head = "Fire Magic"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNFire.blp"

--	choice = TalentChoiceCreateAddSpells( FourCC('ANfl'), FourCC('AOcl'), FourCC('ANmo'))
	choice = TalentChoiceCreateAddSpells( FourCC('ANfl'), FourCC('AOcl'))
	choice.Head = "Lightning Magic"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNMonsoon.blp"

    --LEVEL 5

	TalentHeroCreateTierEx(5)

 	choice = TalentChoiceCreateStats(6, 3, 3)
	choice.Head = "Magic Power: Str"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNHelmOfValor.blp"

 	choice = TalentChoiceCreateStats(3, 6, 3)
	choice.Head = "Magic Power: AGI"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNHoodOfCunning.blp"

 	choice = TalentChoiceCreateStats(3, 3, 6)
	choice.Head = "Magic Power: Int"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNPipeOfInsight.blp"

    --Level 10

	TalentHeroCreateTierEx(10)
  	TalentChoiceCreateAddSpell(FourCC('AHpx'),true)
	TalentChoiceCreateAddSpell(FourCC('AUin'),true)

end)
function TalentStatChange( )
	ModifyHeroStat(udg_Talent__Choice.StatType, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, udg_Talent__Choice.StatPower )
end
function TalentStatChangeReset( )
	ModifyHeroStat(udg_Talent__Choice.StatType, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, udg_Talent__Choice.StatPower )
end
--Example for using Talent by Tasyen.
TalentAddUnitSheet(function()
	--Which HeroType is this; Custom Paladin

	local heroTypeId =  FourCC('H001')
    local choice

	TalentHeroCreate(heroTypeId)
	--HeroTypeId gains at Level 0: create a new Tier
	TalentHeroCreateTierEx(1)

	--Create a new Choice and add it to the last Created Tier
	choice = TalentHeroCreateChoiceEx()	--activade  TalentStr when Picking this Talent
	choice.OnLearn = function() ModifyHeroStat( bj_HEROSTAT_STR, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6 ) end
	choice.OnReset = function() ModifyHeroStat( bj_HEROSTAT_STR, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6 ) end
	choice.Text = "Gain 6 Str"
	choice.Head = "Handschuhe der Kraft"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNGauntletsOfOgrePower.blp"

	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = function() ModifyHeroStat( bj_HEROSTAT_AGI, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6 ) end
	choice.OnReset = function() ModifyHeroStat( bj_HEROSTAT_AGI, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6 ) end
	choice.Text = "Gain 6 Agi"
	choice.Head = "Schuhe der Beweglichkeit"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNSlippersOfAgility.blp"

	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = function() ModifyHeroStat( bj_HEROSTAT_INT, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6 ) end
	choice.OnReset = function() ModifyHeroStat( bj_HEROSTAT_INT, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6 ) end
	choice.Text = "Gain 6 Int"
	choice.Head = "Robe der Weißen"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNRobeOfTheMagi.blp"

	--Level 2
	TalentHeroCreateTierEx(2)
 
	choice = TalentHeroCreateChoiceEx()
	abilityId =  FourCC('Awfb')
	TalentChoiceAddAbility(choice, abilityId) --Skill gained when picking this choice
	choice.Text = BlzGetAbilityExtendedTooltip(abilityId,1)
	choice.Head = BlzGetAbilityTooltip(abilityId,1)
	choice.Icon = BlzGetAbilityIcon(abilityId)

	choice = TalentHeroCreateChoiceEx()
	abilityId =  FourCC('AHhb')
	TalentChoiceAddAbility(choice, abilityId)
	choice.Text = BlzGetAbilityExtendedTooltip(abilityId,1)
	choice.Head = BlzGetAbilityTooltip(abilityId,1)
	choice.Icon = BlzGetAbilityIcon(abilityId)


	--Level 4
	TalentHeroCreateTierEx(4)

	choice = TalentHeroCreateChoiceEx()
	abilityId =  FourCC('ACif')
	TalentChoiceAddAbility(choice, abilityId)
	choice.Text = BlzGetAbilityExtendedTooltip(abilityId,1)
	choice.Head = BlzGetAbilityTooltip(abilityId,1)
	choice.Icon = BlzGetAbilityIcon(abilityId)

	choice = TalentHeroCreateChoiceEx()
	abilityId =  FourCC('Afbt')
	TalentChoiceAddAbility(choice, abilityId)
	choice.Text = BlzGetAbilityExtendedTooltip(abilityId,1)
	choice.Head = BlzGetAbilityTooltip(abilityId,1)
	choice.Icon = BlzGetAbilityIcon(abilityId)

	--Create Own Variabes and attach them

	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = TalentStatChange
	choice.OnReset = TalentStatChangeReset
	choice.Text = "Gain 8 Str"
	choice.Head = "Gürtel der Gigantenkraft"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNBelt.blp"
	choice.StatType = bj_HEROSTAT_STR --save custom Data, one should not overwrite indexes expected with different data
	choice.StatPower = 8
	
	
	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = TalentStatChange
	choice.OnReset = TalentStatChangeReset
	choice.Text = "Gain 8 Int"
	choice.Head = "Robe der Weißen"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNRobeOfTheMagi.blp"
	choice.StatType = bj_HEROSTAT_INT
	choice.StatPower = 8

	--Level 6
	TalentHeroCreateTierEx(6)

	choice = TalentHeroCreateChoiceEx()
	abilityId =  FourCC('AHre')
	TalentChoiceAddAbilityEx(abilityId, 0)
	choice.Text = BlzGetAbilityExtendedTooltip(abilityId,1)
	choice.Head = BlzGetAbilityTooltip(abilityId,1)
	choice.Icon = BlzGetAbilityIcon(abilityId)

	choice = TalentHeroCreateChoiceEx()
	abilityId =  FourCC('AHav')
	TalentChoiceAddAbilityEx(abilityId, 0)
	choice.Text = BlzGetAbilityExtendedTooltip(abilityId,1)
	choice.Head = BlzGetAbilityTooltip(abilityId,1)
	choice.Icon = BlzGetAbilityIcon(abilityId)

	--Level 8
	TalentHeroCreateTierEx(8)

	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = function()
		ModifyHeroStat( bj_HEROSTAT_INT, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6 )
		ModifyHeroStat( bj_HEROSTAT_STR, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6 )
		ModifyHeroStat( bj_HEROSTAT_AGI, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6 )	
	end
	choice.OnReset = function()
		ModifyHeroStat( bj_HEROSTAT_INT, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6 )
		ModifyHeroStat( bj_HEROSTAT_STR, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6 )
		ModifyHeroStat( bj_HEROSTAT_AGI, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6 )	
	end
	choice.Text = "Gain + 6 to all stats"
	choice.Head = "Krone des Königs"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNHelmutPurple.blp"

	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = function() BlzSetUnitBaseDamage(udg_Talent__Unit, BlzGetUnitBaseDamage(udg_Talent__Unit, 0) + 20, 0) end
	choice.OnReset = function() BlzSetUnitBaseDamage(udg_Talent__Unit, BlzGetUnitBaseDamage(udg_Talent__Unit, 0) - 20, 0) end
	choice.Text = "Gain 20 ATK"
	choice.Head = "Mithril Blade"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp"
	
	choice = TalentHeroCreateChoiceEx()
	choice.OnLearn = function() BlzSetUnitArmor(udg_Talent__Unit, BlzGetUnitArmor(udg_Talent__Unit) + 10) end
	choice.OnReset = function() BlzSetUnitArmor(udg_Talent__Unit, BlzGetUnitArmor(udg_Talent__Unit) - 10) end
	choice.Text = "Gain 10 Armor"
	choice.Head = "Mithril Armor"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNHumanArmorUpThree.blp"
end)





TalentAddUnitSheet(function()
	TalentHeroCopy(FourCC('H003'), FourCC('H001'))	-- FourCC('H003') uses the same talents as  FourCC('H001')
	TalentHeroCopy(FourCC('H004'), FourCC('H002'))
	TalentHeroCopy(FourCC('H007'), FourCC('H006'))
end)
--Example for using Talent by Tasyen.
TalentAddUnitSheet(function()
	local  choice

	--Which HeroType is this; Footmen
	local  heroTypeId =  FourCC('hfoo')
	TalentHeroCreate(heroTypeId)
	TalentHeroCreateTierEx(1)
	
	--Create a new Choice and add it to the last Created Tier
	choice = TalentChoiceCreateImproveWeapon(0, 6, 0)
	choice.Head = "Deadly Footman"
	choice.Text = "Increases Base AttackDamage by 6"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNSteelMelee.blp"

	choice = TalentChoiceCreateSustain(0, 0, 0, 0, 4)
	choice.Head = "Tanky Footman"
	choice.Text = "Increases Armor by 4"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNHumanArmorUpOne.blp"

end)
--Example for using Talent by Tasyen.
TalentAddUnitSheet(function()
	local  choice

	--Which HeroType is this; Shadow Priest
	local  heroTypeId =  FourCC('nfsp')
	TalentHeroCreate(heroTypeId)
	TalentHeroCreateTierEx(1)

	--Create a new Choice and add it to the last Created Tier
	choice = TalentChoiceCreateReplaceSpell(FourCC('Anh1'),FourCC('Anh2'))
	choice.Head = "More Heal"
	choice.Text = "Increases Heal by 13"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNHealOn.blp"

--	TalentChoiceCreateImproveSpell(spell, manaCostAdd, cooldownAdd, rangeAdd, unitDurAdd, heroDurAdd, missileSpeedAdd, radiusAdd, castTimeAdd)
	choice = TalentChoiceCreateImproveSpell(FourCC('Anh1'), -2, -0.1, 0, 0, 0, 0, 0, 0)
	choice.Head = "Cheaper Heal"
	choice.Text = "Reduce Manacosts by 2 and improves cooldown by 10%"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNHealOn.blp"

	choice = TalentChoiceCreateSustain(200, 0, 100, 0, 1)
	choice.Head = "Sustain Healer"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNForestTrollShadowPriest.blp"

end)

--Example for using Talent by Tasyen.

TalentAddUnitSheet(function()
	local  heroTypeId =  FourCC('H002')	--Custom Uther
	local  choice
	TalentHeroCreate(heroTypeId)

    TalentHeroCreateTierEx(1)
    choice = TalentChoiceCreateStr(6)
    choice.Text = "Gain 6 Str"
    choice.Head = "Handschuhe der Kraft"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNGauntletsOfOgrePower.blp"
	
	choice = TalentChoiceCreateAgi(6)
    choice.Text = "Gain 6 agi"
    choice.Head = "Schuhe der Beweglichkeit"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNSlippersOfAgility.blp"

    choice = TalentChoiceCreateInt(6)
    choice.Text = "Gain 6 Int"
    choice.Head = "Robe der Weißen"
    choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNRobeOfTheMagi.blp"
    
    TalentHeroCreateTierEx(2)
	
 	choice = TalentChoiceCreateStats(6, 3, 3)
	choice.Head = "Magic Power: Str"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNHelmOfValor.blp"

 	choice = TalentChoiceCreateStats(3, 6, 3)
	choice.Head = "Magic Power: AGI"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNHoodOfCunning.blp"

 	choice = TalentChoiceCreateStats(3, 3, 6)
	choice.Head = "Magic Power: Int"
	choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNPipeOfInsight.blp"

	TalentHeroCreateTierEx(3)
    TalentChoiceCreateAddSpell(FourCC('ACif'),true)
    TalentChoiceCreateAddSpell(FourCC('Afbt'),true)
    
    choice = TalentChoiceCreateStr(8)
    choice.Head = "Gürtel der Kraft"
    choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNBelt.blp"

    choice = TalentChoiceCreateInt(8)
    choice.Head = "Robe der Weißen"
    choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNRobeOfTheMagi.blp"
    TalentChoiceCreateAddSpell(FourCC('ACam'),true)
    TalentChoiceCreateAddSpell(FourCC('ACmp'),true)
    
    TalentHeroCreateTierEx(4)
    TalentChoiceCreateAddSpell(FourCC('AHre'),true)
    TalentChoiceCreateAddSpell(FourCC('AHav'),true)
    
    TalentHeroCreateTierEx(5)
    choice = TalentChoiceCreateStats(5, 5, 5)
    choice.Text = "Gain + 5 to all stats"
    choice.Head = "Krone des Königs"
    choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNHelmutPurple.blp"

    choice = TalentChoiceCreateImproveWeapon(0, 20, 0)
	choice.Text = "Gain 20 ATK"
	choice.Head = "Mithril Blade"
    choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp"
    
    choice = TalentChoiceCreateSustain(0, 0, 0, 0, 10)
	choice.Text = "Gain 10 Armor"
	choice.Head = "Mithril Armor"
    choice.Icon  = "ReplaceableTextures\\CommandButtons\\BTNHumanArmorUpThree.blp"

end)

--Example for using Talent by Tasyen.
TalentAddUnitSheet(function()
	--Which HeroType is this; Pitlord

	TalentHeroCreate(FourCC('N000'))
	for i = 1, 20, 1 do
		TalentHeroCreateTierEx(i)
		local  choice
		choice = TalentChoiceCreateStr(6)
		choice.Text = "Gain 6 Str"
		choice.Head = "Handschuhe der Kraft"
		choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNGauntletsOfOgrePower.blp"
	
		choice = TalentChoiceCreateAgi(6)
		choice.Text = "Gain 6 Agi"
		choice.Head = "Schuhe der Beweglichkeit"
		choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNSlippersOfAgility.blp"
	
		choice = TalentChoiceCreateInt(6)
		choice.Text = "Gain 6 Int"
		choice.Head = "Robe der Weißen"
		choice.Icon = "ReplaceableTextures\\CommandButtons\\BTNRobeOfTheMagi.blp"
	end
	
end)
--Talent GUI 1.03
--by Tasyen
--===========================================================================
-- Makes Talent Registering useable using GUI only.
--===========================================================================
udg_TalentGUICreateChoice = CreateTrigger()
TriggerAddAction(udg_TalentGUICreateChoice, function()
    local choice = TalentHeroCreateChoiceAtLevel(udg_TalentGUI_UnitType, udg_TalentGUI_Level)
    choice.Text = udg_TalentGUI_Text
    choice.Head = udg_TalentGUI_Head
    choice.Icon = udg_TalentGUI_Icon
	TalentChoiceAddAbility(choice, udg_TalentGUI_Spell, udg_TalentGUI_ReplacedSpell) 
    udg_TalentGUI_Spell = 0
    udg_TalentGUI_ReplacedSpell = 0
end)

udg_TalentGUIAddSpell = CreateTrigger()
TriggerAddAction(udg_TalentGUIAddSpell, function()
    TalentChoiceAddAbility(Talent.LastCreatedChoice, udg_TalentGUI_Spell, udg_TalentGUI_ReplacedSpell) 
end)

udg_TalentGUICopy = CreateTrigger()
TriggerAddAction(udg_TalentGUICopy, function()
    TalentHeroCopy(udg_TalentGUI_UnitType, udg_TalentGUI_UnitTypeCopied)    
end)

--This triggers become unusable as soon garbage collector runs, but should be valid at map init.


TimerStart(CreateTimer(),0,false, function()
	local fh = BlzCreateFrame("TalentBoxTextArea", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
	BlzFrameSetSize(fh, 0.22, 0.22)
	BlzFrameSetAbsPoint(fh, FRAMEPOINT_TOPRIGHT, 0.8, 0.5)
	BlzFrameSetText(fh, "Talent Jui, gives units/heroes at levels you want a tier. An unit can pick 1 option from the given options the tier has.|n|nSelect an unit and click the ShowTalent Button to show the TalentBox.|n|nWhen the talentBox is shown you can observe talents choosen from the selected unit regardless of ownerhship.|n|nYou can pick/unlearn talents from any unit you have shared control of.")
	BlzFrameSetEnable(fh, false)
end)
function CreateAllItems()
    local itemID
    BlzCreateItemWithSkin(FourCC("ciri"), -462.2, 333.0, FourCC("ciri"))
    BlzCreateItemWithSkin(FourCC("ciri"), -466.1, 441.5, FourCC("ciri"))
    BlzCreateItemWithSkin(FourCC("ciri"), -574.9, 314.3, FourCC("ciri"))
    BlzCreateItemWithSkin(FourCC("stel"), -527.8, 152.8, FourCC("stel"))
    BlzCreateItemWithSkin(FourCC("stel"), -453.5, 183.1, FourCC("stel"))
    BlzCreateItemWithSkin(FourCC("tkno"), 155.5, 145.1, FourCC("tkno"))
    BlzCreateItemWithSkin(FourCC("tkno"), -83.7, 157.5, FourCC("tkno"))
    BlzCreateItemWithSkin(FourCC("tkno"), -145.3, 157.5, FourCC("tkno"))
    BlzCreateItemWithSkin(FourCC("tkno"), -76.1, 102.3, FourCC("tkno"))
    BlzCreateItemWithSkin(FourCC("tkno"), 208.4, 128.4, FourCC("tkno"))
    BlzCreateItemWithSkin(FourCC("tkno"), -128.9, 119.1, FourCC("tkno"))
    BlzCreateItemWithSkin(FourCC("tkno"), -2.5, 153.2, FourCC("tkno"))
end

function CreateUnitsForPlayer0()
    local p = Player(0)
    local u
    local unitID
    local t
    local life
    u = BlzCreateUnitWithSkin(p, FourCC("ngnw"), 780.5, -67.7, 161.152, FourCC("ngnw"))
    u = BlzCreateUnitWithSkin(p, FourCC("nomg"), 719.4, 73.3, 62.778, FourCC("nomg"))
    u = BlzCreateUnitWithSkin(p, FourCC("nfsp"), 542.3, 236.7, 52.930, FourCC("nfsp"))
    u = BlzCreateUnitWithSkin(p, FourCC("H007"), -401.5, -597.2, 94.230, FourCC("H007"))
    u = BlzCreateUnitWithSkin(p, FourCC("H006"), -83.9, -504.3, 141.321, FourCC("H006"))
    u = BlzCreateUnitWithSkin(p, FourCC("H001"), 579.6, -267.2, 26.390, FourCC("H001"))
    u = BlzCreateUnitWithSkin(p, FourCC("H004"), -262.0, -356.8, 244.240, FourCC("H004"))
    u = BlzCreateUnitWithSkin(p, FourCC("H005"), -482.0, -135.1, 7.340, FourCC("H005"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 517.0, -194.1, 352.188, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 507.0, -12.0, 352.188, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("H003"), 88.0, -362.9, 102.934, FourCC("H003"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), 511.5, -389.8, 352.188, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("H001"), 135.4, -111.3, 179.750, FourCC("H001"))
    u = BlzCreateUnitWithSkin(p, FourCC("H001"), -33.3, -141.4, 305.330, FourCC("H001"))
    u = BlzCreateUnitWithSkin(p, FourCC("N000"), -684.4, -327.8, 180.580, FourCC("N000"))
    SetHeroLevel(u, 20, false)
    SelectHeroSkill(u, FourCC("ANdo"))
    SelectHeroSkill(u, FourCC("ANrf"))
    SelectHeroSkill(u, FourCC("ANrf"))
    SelectHeroSkill(u, FourCC("ANrf"))
    SelectHeroSkill(u, FourCC("ANht"))
    SelectHeroSkill(u, FourCC("ANht"))
    SelectHeroSkill(u, FourCC("ANht"))
    SelectHeroSkill(u, FourCC("ANca"))
    SelectHeroSkill(u, FourCC("ANca"))
    SelectHeroSkill(u, FourCC("ANca"))
    u = BlzCreateUnitWithSkin(p, FourCC("H002"), -272.4, -151.9, 135.170, FourCC("H002"))
end

function CreateUnitsForPlayer1()
    local p = Player(1)
    local u
    local unitID
    local t
    local life
    u = BlzCreateUnitWithSkin(p, FourCC("nfsp"), -466.0, 846.8, 52.930, FourCC("nfsp"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -667.6, 764.6, 352.190, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("H005"), -365.4, 1070.4, 7.340, FourCC("H005"))
    u = BlzCreateUnitWithSkin(p, FourCC("H002"), -155.8, 1053.6, 135.170, FourCC("H002"))
end

function CreateUnitsForPlayer2()
    local p = Player(2)
    local u
    local unitID
    local t
    local life
    u = BlzCreateUnitWithSkin(p, FourCC("H005"), -1051.4, -899.9, 7.340, FourCC("H005"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1172.7, -910.2, 352.188, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1182.7, -728.1, 352.188, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("hfoo"), -1178.2, -1105.9, 352.188, FourCC("hfoo"))
    u = BlzCreateUnitWithSkin(p, FourCC("H001"), -1110.2, -983.3, 26.390, FourCC("H001"))
    u = BlzCreateUnitWithSkin(p, FourCC("uabo"), -1280.5, -999.2, 17.502, FourCC("uabo"))
end

function CreatePlayerBuildings()
end

function CreatePlayerUnits()
    CreateUnitsForPlayer0()
    CreateUnitsForPlayer1()
    CreateUnitsForPlayer2()
end

function CreateAllUnits()
    CreatePlayerBuildings()
    CreatePlayerUnits()
end

function Trig_Talent_MountainKing_Init_Commented_Actions()
    udg_TalentGUI_UnitType = FourCC("Hmkg")
    udg_TalentGUI_Level = 1
    udg_TalentGUI_Head = "Axe"
    udg_TalentGUI_Icon = "ReplaceableTextures\\CommandButtons\\BTNOrcMeleeUpOne.blp"
    udg_TalentGUI_Text = "Gain 20 Base-ATK"
    TriggerExecute(udg_TalentGUICreateChoice)
    udg_TalentGUI_Spell = FourCC("ACpv")
    udg_TalentGUI_Head = GetAbilityName(udg_TalentGUI_Spell)
    udg_TalentGUI_Icon = BlzGetAbilityIcon(udg_TalentGUI_Spell)
    udg_TalentGUI_Text = BlzGetAbilityExtendedTooltip(udg_TalentGUI_Spell, 1)
    TriggerExecute(udg_TalentGUICreateChoice)
    udg_TalentGUI_Level = 4
    udg_TalentGUI_Head = "Helm"
    udg_TalentGUI_Icon = "ReplaceableTextures\\CommandButtons\\BTNHelmOfValor.blp"
    udg_TalentGUI_Text = "+6 STR|n+6 AGI"
    TriggerExecute(udg_TalentGUICreateChoice)
    udg_TalentGUI_Spell = FourCC("SCae")
    udg_TalentGUI_Head = GetAbilityName(udg_TalentGUI_Spell)
    udg_TalentGUI_Icon = BlzGetAbilityIcon(udg_TalentGUI_Spell)
    udg_TalentGUI_Text = BlzGetAbilityExtendedTooltip(udg_TalentGUI_Spell, 1)
    TriggerExecute(udg_TalentGUICreateChoice)
    udg_TalentGUI_Level = 7
    udg_TalentGUI_Head = "Armor"
    udg_TalentGUI_Icon = "ReplaceableTextures\\CommandButtons\\BTNArmorGolem.blp"
    udg_TalentGUI_Text = "+500 Max Life"
    TriggerExecute(udg_TalentGUICreateChoice)
    udg_TalentGUI_Head = "ManaStone"
    udg_TalentGUI_Icon = "ReplaceableTextures\\CommandButtons\\BTNPendantOfMana.blp"
    udg_TalentGUI_Text = "+250 Max Mana"
    TriggerExecute(udg_TalentGUICreateChoice)
    udg_TalentGUI_Spell = FourCC("AHfs")
    udg_TalentGUI_Head = GetAbilityName(udg_TalentGUI_Spell)
    udg_TalentGUI_Icon = BlzGetAbilityIcon(udg_TalentGUI_Spell)
    udg_TalentGUI_Text = BlzGetAbilityExtendedTooltip(udg_TalentGUI_Spell, 3)
    TriggerExecute(udg_TalentGUICreateChoice)
    udg_TalentGUI_Spell = FourCC("AHfs")
    TriggerExecute(udg_TalentGUIAddSpell)
    TriggerExecute(udg_TalentGUIAddSpell)
end

function InitTrig_Talent_MountainKing_Init_Commented()
    gg_trg_Talent_MountainKing_Init_Commented = CreateTrigger()
    TriggerAddAction(gg_trg_Talent_MountainKing_Init_Commented, Trig_Talent_MountainKing_Init_Commented_Actions)
end

function Trig_Talent_Muradin_Actions()
    udg_TalentGUI_UnitType = FourCC("Hmbr")
    udg_TalentGUI_UnitTypeCopied = FourCC("Hmkg")
    TriggerExecute(udg_TalentGUICopy)
    udg_TalentGUI_UnitType = FourCC("H007")
    udg_TalentGUI_UnitTypeCopied = FourCC("Hmkg")
    TriggerExecute(udg_TalentGUICopy)
    udg_TalentGUI_UnitType = FourCC("H006")
    udg_TalentGUI_UnitTypeCopied = FourCC("Hmkg")
    TriggerExecute(udg_TalentGUICopy)
end

function InitTrig_Talent_Muradin()
    gg_trg_Talent_Muradin = CreateTrigger()
    TriggerAddAction(gg_trg_Talent_Muradin, Trig_Talent_Muradin_Actions)
end

function Trig_Talent_MK_Event_Conditions()
    if (not (udg_Talent__UnitCode == FourCC("Hmkg"))) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Func006Func003C()
    if (not (udg_Talent__Button == 1)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Func006C()
    if (not (udg_Talent__Level == 1)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Func007Func003C()
    if (not (udg_Talent__Button == 1)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Func007C()
    if (not (udg_Talent__Level == 4)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Func008Func003C()
    if (not (udg_Talent__Button == 1)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Func008Func004C()
    if (not (udg_Talent__Button == 2)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Func008C()
    if (not (udg_Talent__Level == 7)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Actions()
    if (Trig_Talent_MK_Event_Func006C()) then
        if (Trig_Talent_MK_Event_Func006Func003C()) then
            BlzSetUnitBaseDamage(udg_Talent__Unit, (BlzGetUnitBaseDamage(udg_Talent__Unit, 0) + 20), 0)
        else
        end
    else
    end
    if (Trig_Talent_MK_Event_Func007C()) then
        if (Trig_Talent_MK_Event_Func007Func003C()) then
            ModifyHeroStat(bj_HEROSTAT_STR, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6)
            ModifyHeroStat(bj_HEROSTAT_AGI, udg_Talent__Unit, bj_MODIFYMETHOD_ADD, 6)
        else
        end
    else
    end
    if (Trig_Talent_MK_Event_Func008C()) then
        if (Trig_Talent_MK_Event_Func008Func003C()) then
            BlzSetUnitMaxHP(udg_Talent__Unit, (BlzGetUnitMaxHP(udg_Talent__Unit) + 500))
            SetUnitLifeBJ(udg_Talent__Unit, (GetUnitStateSwap(UNIT_STATE_LIFE, udg_Talent__Unit) + 500.00))
        else
        end
        if (Trig_Talent_MK_Event_Func008Func004C()) then
            BlzSetUnitMaxMana(udg_Talent__Unit, (BlzGetUnitMaxMana(udg_Talent__Unit) + 250))
            SetUnitManaBJ(udg_Talent__Unit, (GetUnitStateSwap(UNIT_STATE_MANA, udg_Talent__Unit) + 250.00))
        else
        end
    else
    end
end

function InitTrig_Talent_MK_Event()
    gg_trg_Talent_MK_Event = CreateTrigger()
    TriggerRegisterVariableEvent(gg_trg_Talent_MK_Event, "udg_Talent__Event", EQUAL, 1.00)
    TriggerAddCondition(gg_trg_Talent_MK_Event, Condition(Trig_Talent_MK_Event_Conditions))
    TriggerAddAction(gg_trg_Talent_MK_Event, Trig_Talent_MK_Event_Actions)
end

function Trig_Talent_MK_Event_Reset_Conditions()
    if (not (udg_Talent__UnitCode == FourCC("Hmkg"))) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Reset_Func002Func001C()
    if (not (udg_Talent__Button == 1)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Reset_Func002C()
    if (not (udg_Talent__Level == 1)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Reset_Func003Func001C()
    if (not (udg_Talent__Button == 1)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Reset_Func003C()
    if (not (udg_Talent__Level == 4)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Reset_Func004Func001C()
    if (not (udg_Talent__Button == 1)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Reset_Func004Func002C()
    if (not (udg_Talent__Button == 2)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Reset_Func004C()
    if (not (udg_Talent__Level == 7)) then
        return false
    end
    return true
end

function Trig_Talent_MK_Event_Reset_Actions()
    if (Trig_Talent_MK_Event_Reset_Func002C()) then
        if (Trig_Talent_MK_Event_Reset_Func002Func001C()) then
            BlzSetUnitBaseDamage(udg_Talent__Unit, (BlzGetUnitBaseDamage(udg_Talent__Unit, 0) - 20), 0)
        else
        end
    else
    end
    if (Trig_Talent_MK_Event_Reset_Func003C()) then
        if (Trig_Talent_MK_Event_Reset_Func003Func001C()) then
            ModifyHeroStat(bj_HEROSTAT_STR, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6)
            ModifyHeroStat(bj_HEROSTAT_AGI, udg_Talent__Unit, bj_MODIFYMETHOD_SUB, 6)
        else
        end
    else
    end
    if (Trig_Talent_MK_Event_Reset_Func004C()) then
        if (Trig_Talent_MK_Event_Reset_Func004Func001C()) then
            BlzSetUnitMaxHP(udg_Talent__Unit, (BlzGetUnitMaxHP(udg_Talent__Unit) - 500))
        else
        end
        if (Trig_Talent_MK_Event_Reset_Func004Func002C()) then
            BlzSetUnitMaxMana(udg_Talent__Unit, (BlzGetUnitMaxMana(udg_Talent__Unit) - 250))
        else
        end
    else
    end
end

function InitTrig_Talent_MK_Event_Reset()
    gg_trg_Talent_MK_Event_Reset = CreateTrigger()
    TriggerRegisterVariableEvent(gg_trg_Talent_MK_Event_Reset, "udg_Talent__Event", EQUAL, -1.00)
    TriggerAddCondition(gg_trg_Talent_MK_Event_Reset, Condition(Trig_Talent_MK_Event_Reset_Conditions))
    TriggerAddAction(gg_trg_Talent_MK_Event_Reset, Trig_Talent_MK_Event_Reset_Actions)
end

function Trig_Demo_Event_Gain_a_Choice_Actions()
    DisplayTextToForce(GetPlayersAll(), (GetHeroProperName(udg_Talent__Unit) .. (" can pick a choice for Level:  " .. I2S(udg_Talent__Level))))
end

function InitTrig_Demo_Event_Gain_a_Choice()
    gg_trg_Demo_Event_Gain_a_Choice = CreateTrigger()
    TriggerRegisterVariableEvent(gg_trg_Demo_Event_Gain_a_Choice, "udg_Talent__Event", EQUAL, 2.00)
    TriggerAddAction(gg_trg_Demo_Event_Gain_a_Choice, Trig_Demo_Event_Gain_a_Choice_Actions)
end

function Trig_Demo_Event_Finished_Chocies_Actions()
    DisplayTextToForce(GetPlayersAll(), (GetHeroProperName(udg_Talent__Unit) .. " has reached the end of it's Talents."))
end

function InitTrig_Demo_Event_Finished_Chocies()
    gg_trg_Demo_Event_Finished_Chocies = CreateTrigger()
    TriggerRegisterVariableEvent(gg_trg_Demo_Event_Finished_Chocies, "udg_Talent__Event", EQUAL, 3.00)
    TriggerAddAction(gg_trg_Demo_Event_Finished_Chocies, Trig_Demo_Event_Finished_Chocies_Actions)
end

function Trig_Demo_Macro_Conditions()
    if (not (SubStringBJ(GetEventPlayerChatString(), 1, 1) == "-")) then
        return false
    end
    return true
end

function Trig_Demo_Macro_Actions()
        TalentMacroDoEx(GetTriggerPlayer(), GetEventPlayerChatString())
end

function InitTrig_Demo_Macro()
    gg_trg_Demo_Macro = CreateTrigger()
    TriggerRegisterPlayerChatEvent(gg_trg_Demo_Macro, Player(0), "-", false)
    TriggerAddCondition(gg_trg_Demo_Macro, Condition(Trig_Demo_Macro_Conditions))
    TriggerAddAction(gg_trg_Demo_Macro, Trig_Demo_Macro_Actions)
end

function Trig_Demo_Get_Actions()
        print(TalentGetMacroEx(GetTriggerPlayer()))
end

function InitTrig_Demo_Get()
    gg_trg_Demo_Get = CreateTrigger()
    TriggerRegisterPlayerChatEvent(gg_trg_Demo_Get, Player(0), "Get", true)
    TriggerAddAction(gg_trg_Demo_Get, Trig_Demo_Get_Actions)
end

function Trig_Demo_PreventReset_Func001C()
    if (not (BlzBitAnd(GetTriggerExecCount(GetTriggeringTrigger()), 1) == 1)) then
        return false
    end
    return true
end

function Trig_Demo_PreventReset_Actions()
    if (Trig_Demo_PreventReset_Func001C()) then
        udg_TalentControlPreventReset[GetConvertedPlayerId(GetTriggerPlayer())] = true
        DisplayTextToForce(GetPlayersAll(), "TRIGSTR_025")
                TalentBoxUpdate(GetTriggerPlayer())
    else
        DisplayTextToForce(GetPlayersAll(), "TRIGSTR_024")
        udg_TalentControlPreventReset[GetConvertedPlayerId(GetTriggerPlayer())] = false
                TalentBoxUpdate(GetTriggerPlayer())
    end
end

function InitTrig_Demo_PreventReset()
    gg_trg_Demo_PreventReset = CreateTrigger()
    TriggerRegisterPlayerChatEvent(gg_trg_Demo_PreventReset, Player(0), "PreventReset", true)
    TriggerAddAction(gg_trg_Demo_PreventReset, Trig_Demo_PreventReset_Actions)
end

function InitCustomTriggers()
    InitTrig_Talent_MountainKing_Init_Commented()
    InitTrig_Talent_Muradin()
    InitTrig_Talent_MK_Event()
    InitTrig_Talent_MK_Event_Reset()
    InitTrig_Demo_Event_Gain_a_Choice()
    InitTrig_Demo_Event_Finished_Chocies()
    InitTrig_Demo_Macro()
    InitTrig_Demo_Get()
    InitTrig_Demo_PreventReset()
end

function RunInitializationTriggers()
    ConditionalTriggerExecute(gg_trg_Talent_MountainKing_Init_Commented)
    ConditionalTriggerExecute(gg_trg_Talent_Muradin)
end

function InitCustomPlayerSlots()
    SetPlayerStartLocation(Player(0), 0)
    SetPlayerColor(Player(0), ConvertPlayerColor(0))
    SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
    SetPlayerRaceSelectable(Player(0), true)
    SetPlayerController(Player(0), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(1), 1)
    SetPlayerColor(Player(1), ConvertPlayerColor(1))
    SetPlayerRacePreference(Player(1), RACE_PREF_ORC)
    SetPlayerRaceSelectable(Player(1), true)
    SetPlayerController(Player(1), MAP_CONTROL_USER)
    SetPlayerStartLocation(Player(2), 2)
    SetPlayerColor(Player(2), ConvertPlayerColor(2))
    SetPlayerRacePreference(Player(2), RACE_PREF_UNDEAD)
    SetPlayerRaceSelectable(Player(2), true)
    SetPlayerController(Player(2), MAP_CONTROL_USER)
end

function InitCustomTeams()
    SetPlayerTeam(Player(0), 0)
    SetPlayerTeam(Player(2), 0)
    SetPlayerAllianceStateAllyBJ(Player(0), Player(2), true)
    SetPlayerAllianceStateAllyBJ(Player(2), Player(0), true)
    SetPlayerAllianceStateVisionBJ(Player(0), Player(2), true)
    SetPlayerAllianceStateVisionBJ(Player(2), Player(0), true)
    SetPlayerAllianceStateControlBJ(Player(0), Player(2), true)
    SetPlayerAllianceStateControlBJ(Player(2), Player(0), true)
    SetPlayerTeam(Player(1), 1)
end

function InitAllyPriorities()
    SetStartLocPrioCount(0, 2)
    SetStartLocPrio(0, 0, 1, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(0, 1, 2, MAP_LOC_PRIO_HIGH)
    SetStartLocPrioCount(1, 2)
    SetStartLocPrio(1, 0, 0, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(1, 1, 2, MAP_LOC_PRIO_LOW)
    SetStartLocPrioCount(2, 2)
    SetStartLocPrio(2, 0, 0, MAP_LOC_PRIO_HIGH)
    SetStartLocPrio(2, 1, 1, MAP_LOC_PRIO_LOW)
end

function main()
    SetCameraBounds(-3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    NewSoundEnvironment("Default")
    SetAmbientDaySound("LordaeronSummerDay")
    SetAmbientNightSound("LordaeronSummerNight")
    SetMapMusic("Music", true, 0)
    CreateAllItems()
    CreateAllUnits()
    InitBlizzard()
    InitGlobals()
    InitCustomTriggers()
    RunInitializationTriggers()
end

function config()
    SetMapName("TRIGSTR_001")
    SetMapDescription("TRIGSTR_003")
    SetPlayers(3)
    SetTeams(3)
    SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)
    DefineStartLocation(0, 320.0, -320.0)
    DefineStartLocation(1, -448.0, 960.0)
    DefineStartLocation(2, -896.0, -1216.0)
    InitCustomPlayerSlots()
    InitCustomTeams()
    InitAllyPriorities()
end


globals(function(_ENV)
    udg_Talent__Event = 0.0
end)

