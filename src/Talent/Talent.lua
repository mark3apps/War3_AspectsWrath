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
