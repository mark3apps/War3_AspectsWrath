
-- Hide UI Keep Mouse
BlzHideOriginFrames(true)
BlzFrameSetVisible(BlzGetFrameByName("ConsoleUIBackdrop", 0), false)

-- Lock Cam
CameraSetupApplyForPlayer(true, gg_cam_Base_Left, Player(0), 3)
local camX = CameraSetupGetDestPositionX(gg_cam_Base_Left)
local camY = CameraSetupGetDestPositionY(gg_cam_Base_Left)
SetCameraBounds(camX, camY, camX, camY,camX, camY, camX, camY)

-- Do Stuff

-- Reset back to normal
SetCameraBoundsToRect (bj_mapInitialCameraBounds)
ShowInterface(false, 0)
BlzHideOriginFrames(false)
BlzFrameSetVisible(BlzGetFrameByName("ConsoleUIBackdrop", 0), true)

-- Fade back to normal
ShowInterface(true, 5)
CameraSetupApplyForPlayer(true, gg_cam_Base_Left_Start,Player(0), 3)

