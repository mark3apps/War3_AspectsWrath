
function init_SpellsClass()

    spells = {}

    ai.new = function()
        local self = {}
        -- Tactitian
        self.ironDefense = {spell = FourCC("A019"), string = "roar"}
        self.attack = {spell = FourCC("A01B"), string = "fingerofdeath"}
        self.bolster = {spell = FourCC("A01Z"), string = "tranquility"}
        self.inspireSpell = {spell = FourCC("A042"), string = "channel"}

        -- Shift Master
        self.shiftBack = {spell = FourCC("A03U"), string = "stomp", ult = false}
        self.shiftForward = {spell = FourCC("A030"), string = "thunderclap", ult = false}
        self.fallingStrike = {spell = FourCC("A03T"), string = "clusterrockets", ult = false}
        self.shiftStorm = {FourCC("A03C"), string = "channel", ult = true}
        self.felForm = {spell = FourCC("A02Y"), string = "metamorphosis", ult = true}


        function self:spellLevel{spellName}
            
        end
    end
end