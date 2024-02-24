local spawnzones = require("spawnzones")
local rooms = require("rooms")
local slm = require("simpleLayerMovement")
local hudoverride = require("hudoverride")

local move1
local myLayerTimer = 0

function onStart()
    move1 = Layer.get("move1")
    hudoverride.visible.lives = false
end

function onTick()
    if move1 then
        myLayerTimer = myLayerTimer + 1
    
        move1.speedY = math.cos(myLayerTimer/40)*2.5
    end
end

function onRespawnReset()
    myLayerTimer = 0
end

function onReset(fromRespawn)
    for _,v in ipairs(NPC.get{600,601,602,603}) do
        local d = v.data._basegame
        if d.state == 1 then
          d.player.forcedState = 0
          d.state = 0
        end
    end
end

function onEvent(eventName)
    if eventName == "pre boss music" then
        Audio.MusicChange(3, "6 - The Otherwordly Citadel/1-51 Final Boss Intro.mp3")
    end
    if eventName == "start boss music" then
        Audio.MusicChange(3, "6 - The Otherwordly Citadel/1-52 Final Battle.mp3")
    end
end
