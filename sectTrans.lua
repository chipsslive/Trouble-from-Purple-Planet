sectTrans = {}
local startSectionFade = false
local sectTransCaptureBuffer = Graphics.CaptureBuffer(800,600)
local fadeIn = 1.0
local startFadeIn = 1.0
local curSect = 0
local framesPassed = 0
local exitfadeOut = 0.00
local exitfade = false
local dontfade = false
function onExitDraw()
    if (exitfade == false) then
        exitfadeOut = 1.0
        return nil 
    end
    if dontfade then
        exitfadeOut = 1.0
        Graphics.drawScreen{color = Color(0,0,0,1), priority = 11}
        Misc.unpause();
        return nil
    end
    exitfadeOut = exitfadeOut + (2/65)
    Graphics.drawScreen{color = Color(0,0,0,exitfadeOut), priority = 11}
    if (exitfadeOut >= 1) then Misc.unpause() end
end
function sectTrans.onExitLevel()
    if dontfade then return nil end
    Misc.pause()
    exitfadeOut = 0
    exitfade = true
end
function sectTrans.onDraw()
    if curSect ~= player.section then
        startSectionFade = true
        fadeIn = 1.0
        framesPassed = 0
    end
    if not startSectionFade then sectTransCaptureBuffer:captureAt(4) end
    if startSectionFade then 
        Graphics.glDraw {
            vertexCoords = {
                0,   0,
                800, 0, 
                0,   600, 
                0,   600, 
                800, 600, 
                800, 0
            }, 
            texture = sectTransCaptureBuffer, 
            textureCoords = {0,0, 1,0, 0,1, 0,1, 1,1, 1,0}, 
            primitive = Graphics.GL_TRIANGLE,
            color = {1,1,1,fadeIn}, 
            priority = 4.9
        }
        fadeIn = fadeIn - ((1/65) * 2)
        framesPassed = framesPassed + 2
        if (framesPassed >= 65) then
            framesPassed = 0
            startSectionFade = false
        end
    end
    curSect = player.section
    if (startFadeIn > 0) then startFadeIn = startFadeIn - ((1/65) * 2) end
    Graphics.drawScreen{color=Color(0,0,0,startFadeIn), priority = 10};
    if (player:mem(0x13C,FIELD_BOOL) == true) then
        unregisterEvent(sectTrans, "onExitLevel","onExitLevel")
        dontfade = true
    end
    onExitDraw()
end

function sectTrans.onInitAPI()
    registerEvent(sectTrans,"onDraw")
    registerEvent(sectTrans,"onExitLevel")
end
return sectTrans;