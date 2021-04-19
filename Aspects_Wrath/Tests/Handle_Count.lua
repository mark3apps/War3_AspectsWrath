function HandleCount()
    local location L = Location(0,0)
    BJDebugMsg(I2S(GetHandleId(L)-0x100000))
    RemoveLocation(L)
    RemoveLocation(L)
end


function InitTrig_HandleCounter()
    local trigger t = CreateTrigger()
    TriggerRegisterTimerEvent(t,0.09,true)
    TriggerAddAction(t, HandleCount)
end