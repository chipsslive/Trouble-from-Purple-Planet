local rooms = require("rooms")
local hudoverride = require("hudoverride")

local aw = require("anotherwalljump")
aw.registerAllPlayersDefault()

function onStart()
    if Checkpoint.getActive() ~= nil then
        aw.enable(player)
    else
        aw.disable(player)
    end
end

function onEvent(eventName)
    if eventName == "get walljump" then
        aw.enable(player)
        SFX.play("orb.wav")
    end
    if eventName == "wear off" then
        aw.disable(player)
    end
end

function onReset(fromRepsawn)
    if Checkpoint.getActive() ~= nil then
        aw.enable(player)
    else
        aw.disable(player)
    end
end
