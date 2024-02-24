local slm = require("simpleLayerMovement")

local move1
local move2
local move25
local myLayerTimer = 0

function onStart()
    move1 = Layer.get("move 1")
    move2 = Layer.get("move 2")
    move25 = Layer.get("move 2.5")
end

function onTick()
    if Layer.isPaused() == true then

    else
        if move1 then
            myLayerTimer = myLayerTimer + 1

            move1.speedX = math.cos(myLayerTimer/240)*3
        end
        if move2 then
            myLayerTimer = myLayerTimer + 1
        
            move2.speedY = math.cos(myLayerTimer/100)*2.5
        end
        if move25 then
            myLayerTimer = myLayerTimer + 1
            
            move25.speedY = math.cos(myLayerTimer/100)*-2.5
        end
    end
end

slm.addLayer{name = "move 3",movement = slm.MOVEMENT_CIRCLE,speed = 32,verticalDistance = 1,horizontalDistance = 4}

slm.addLayer{name = "move 4",movement = slm.MOVEMENT_CIRCLE,speed = 32,verticalDistance = 2.5,horizontalDistance = 3.75}

function onRespawnReset()
    myLayerTimer = 0
end

