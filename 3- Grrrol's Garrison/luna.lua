local spawnzones = require("spawnzones")
local autoscroll = require("autoscroll")

local scroll = false

function onEvent(eventName)
    if eventName == "raise platform" then
        scroll = true
        autoscroll.scrollUp(1)
    end
    if eventName == "big dude intro" then
        Audio.MusicChange(2, "3- Grrrol's Garrison/Captain Bowser.mp3")
    end
    if eventName == "fadeout" then
        Audio.MusicFadeOut(2, 1000)
    end
    if eventName == "boss message" then
        Audio.MusicChange(2, "dungeon.ogg")
    end
end

function onTick()
    Defines.levelFreeze = Layer.isPaused()
    if Layer.isPaused() and autoscroll.isSectionScrolling() then
        autoscroll.lockScreen()
    elseif scroll and not autoscroll.isSectionScrolling() then
        autoscroll.scrollUp(1)
    end
end

function onStart()
    Audio.MusicChange(2, "dungeon.ogg")
end