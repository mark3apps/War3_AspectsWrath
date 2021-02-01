--HeroInfo 1.1a
--Plugin for HeroInfo by Tasyen
--This Creates a TextArea which displays the name and the Extended tooltip of selected units.

HeroInfo = {}
--TextArea
HeroInfo.DescHeroNamePrefix     = "|cffffcc00"   --added before the Units Name
HeroInfo.DescHeroNameSufix      = "|r"           --added after the units Name
HeroInfo.TextAreaSizeX          = 0.2
HeroInfo.TextAreaSizeY          = 0.2
HeroInfo.TextAreaOffsetX        = 0
HeroInfo.TextAreaOffsetY        = 0
HeroInfo.TextAreaPoint          = FRAMEPOINT_TOPLEFT --pos the Tooltip with which Point
HeroInfo.TextAreaRelativePoint  = FRAMEPOINT_TOPRIGHT --pos the Tooltip to which Point of the Relative
HeroInfo.TextAreaRelativeGame   = false --(false) relativ to box, (true) relativ to GameUI
HeroInfo.BackupSelected         = HeroSelector.buttonSelected
HeroInfo.BackupDestroy          = HeroSelector.destroy

function HeroSelector.destroy()
    BlzDestroyFrame(HeroInfo.TextArea)
    HeroInfo.BackupDestroy()
    HeroInfo = nil
end

function HeroInfo.Init()
    HeroInfo.TextArea = BlzCreateFrame("HeroSelectorTextArea", HeroSelector.Box, 0, 0)    
    BlzFrameSetSize(HeroInfo.TextArea , HeroInfo.TextAreaSizeX, HeroInfo.TextAreaSizeY)
    if not HeroInfo.TextAreaRelativeGame then
        BlzFrameSetPoint(HeroInfo.TextArea, HeroInfo.TextAreaPoint, HeroSelector.Box, HeroInfo.TextAreaRelativePoint, HeroInfo.TextAreaOffsetX, HeroInfo.TextAreaOffsetY)
    else
        BlzFrameSetPoint(HeroInfo.TextArea, HeroInfo.TextAreaPoint, BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), HeroInfo.TextAreaRelativePoint, HeroInfo.TextAreaOffsetX, HeroInfo.TextAreaOffsetY)
    end
end

function HeroSelector.buttonSelected(player, unitCode)
    HeroInfo.BackupSelected(player, unitCode)

    if GetLocalPlayer() == player then
        BlzFrameSetText(HeroInfo.TextArea, HeroInfo.DescHeroNamePrefix .. GetObjectName(unitCode).. HeroInfo.DescHeroNameSufix)
        BlzFrameAddText(HeroInfo.TextArea, BlzGetAbilityExtendedTooltip(unitCode,0))
    end
end