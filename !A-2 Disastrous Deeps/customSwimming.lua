--[[

    -- NOT PUBLICLY RELEASED --

    customSwimming.lua
    by MrDoubleA

]]

local playerManager = require("playerManager")

local customSwimming = {}


customSwimming.characterImages = {}


local function canSwim(p)
    return (
        customSwimming.swimmingTweakSettings.enabled
        and p.forcedState == 0 and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL)
        and p:mem(0x26,FIELD_WORD) == 0 -- Pulling grass
        and p:mem(0x40,FIELD_WORD) == 0 -- Climbing a vine

        and (p:mem(0x34,FIELD_WORD) > 0 and p:mem(0x06,FIELD_WORD) == 0) -- In water
        and not p:mem(0x4A,FIELD_BOOL) -- Statue
        and not p.isMega               -- Using mega mushroom
        and p.mount == 0               -- Using a mount
    )
end
local function canUseSwimAnimation(p)
    return (
        canSwim(p)
        and p:mem(0x14 ,FIELD_WORD) == 0 -- Stabbing with Link
        and p:mem(0x160,FIELD_WORD) == 0 -- Firing a fireball/iceball/hammer
        and p:mem(0x164,FIELD_WORD) == 0 -- Tail swipe
        and not p:mem(0x142,FIELD_BOOL)  -- Flashing with invincibility
    )
end


customSwimming.playerData = {}
local function getPlayerData(p)
    customSwimming.playerData[p] = customSwimming.playerData[p] or {}
    return customSwimming.playerData[p]
end


local POWERUP_COUNT = 7

local DIR = {
    UP    = 0,
    DOWN  = 1,
    RIGHT = 2,
    LEFT  = 4,
}
local swimDirections = {DIR.UP,DIR.DOWN,DIR.RIGHT,DIR.LEFT}

local function getSpeed(keys)
    local speed = vector.zero2

    if keys.left then
        speed.x = -1
    elseif keys.right then
        speed.x = 1
    end

    if keys.up then
        speed.y = -1
    elseif keys.down then
        speed.y = 1
    end

    return speed
end

local function getDirection(speed)
    if speed.x == 0 then
        if speed.y < 0 then
            return DIR.UP
        elseif speed.y > 0 then
            return DIR.DOWN
        end
    elseif speed.y == 0 then
        if speed.x < 0 then
            return DIR.LEFT
        elseif speed.x > 0 then
            return DIR.RIGHT
        end
    end

    return nil
end


local function loadCharacterImages(id,costumeName)
    local imageName = (costumeName or playerManager.getName(id))
    local storeName = (costumeName or id)

    for powerup=1,POWERUP_COUNT do        
        local path = Misc.resolveGraphicsFile(customSwimming.swimmingTweakSettings.imagePath:format(imageName,tostring(powerup)))

        if path ~= nil then
            customSwimming.characterImages[storeName] = customSwimming.characterImages[storeName] or {}

            customSwimming.characterImages[storeName][powerup] = Graphics.loadImage(path)
        end
    end
end


function customSwimming.onInitAPI()
    registerEvent(customSwimming,"onTick")
    registerEvent(customSwimming,"onDraw")
    registerEvent(customSwimming,"onDrawEnd")

    registerEvent(customSwimming,"onStart")
end


local function initialiseSwimming(p,data)
    if data.swimmingDirection ~= nil then return end

    if p.direction == DIR_LEFT then
        data.swimmingDirection = DIR.LEFT
    else
        data.swimmingDirection = DIR.RIGHT
    end

    data.swimmingFrame = 1
    data.swimmingAnimationTimer = 0


    Defines.player_runspeed = 16
    Defines.player_walkspeed = 16
end
local speedNames = {[1] = "speedX",[2] = "speedY"}

function customSwimming.onTickPlayer(p) -- pseudo-event that runs for every player
    local data = getPlayerData(p)

    if canSwim(p) then
        initialiseSwimming(p,data)


        p.speedY = p.speedY - (Defines.player_grav*0.1) - 0.0001


        local speed = getSpeed(p.keys)

        if not p.keys.run then
            speed = speed*customSwimming.swimmingTweakSettings.speed
        else
            speed = speed*customSwimming.swimmingTweakSettings.runSpeed
        end


        for i=1,2 do
            local speedName = speedNames[i]

            if p[speedName] > speed[i] then
                p[speedName] = math.max(speed[i],p[speedName]-customSwimming.swimmingTweakSettings.acceleration)
            elseif p[speedName] < speed[i] then
                p[speedName] = math.min(speed[i],p[speedName]+customSwimming.swimmingTweakSettings.acceleration)
            end
        end

        p:mem(0x38,FIELD_WORD,2) -- Prevent normal swimming


        local newDirection = getDirection(speed)

        if (math.abs(p.speedX) < 0.5 and math.abs(p.speedY) < 0.5) or (newDirection ~= nil and newDirection ~= data.swimmingDirection) then
            data.swimmingFrame = 1
            data.swimmingAnimationTimer = 0
        else
            data.swimmingAnimationTimer = data.swimmingAnimationTimer + 1
            data.swimmingFrame = (math.floor(data.swimmingAnimationTimer/6)%customSwimming.swimmingTweakSettings.frameCounts[data.swimmingDirection])+1
        end

        data.swimmingDirection = newDirection or data.swimmingDirection
    elseif data.swimmingDirection ~= nil then
        data.swimmingDirection = nil

        Defines.player_runspeed = nil
        Defines.player_walkspeed = nil
    end
end

function customSwimming.onDrawPlayer(p)
    local data = getPlayerData(p)

    local swimTexture = customSwimming.characterImages[p:getCostume() or p.character]
    if swimTexture ~= nil then
        swimTexture = swimTexture[p.powerup]
    end


    if canUseSwimAnimation(p) and swimTexture ~= nil then
        initialiseSwimming(p,data)


        if data.sprite == nil or data.sprite.texture ~= swimTexture then
            local highestFrameCount = 1
            for _,value in ipairs(swimDirections) do
                highestFrameCount = math.max(highestFrameCount,customSwimming.swimmingTweakSettings.frameCounts[value])
            end

            data.sprite = Sprite{texture = swimTexture,frames = vector(#swimDirections,highestFrameCount),pivot = Sprite.align.CENTRE}
        end

        data.sprite.position = vector(player.x+(player.width/2),player.y+(player.height/2))

        data.sprite:draw{frame = vector(data.swimmingDirection+1,data.swimmingFrame),priority = -25,sceneCoords = true}


        data.oldFlash = p:mem(0x142,FIELD_BOOL)
        p:mem(0x142,FIELD_BOOL,true)
    end
end
function customSwimming.onDrawEndPlayer(p)
    local data = getPlayerData(p)

    if data.oldFlash ~= nil then
        p:mem(0x142,FIELD_BOOL,data.oldFlash)
        data.oldFlash = nil
    end
end




function customSwimming.onStart()
    -- Load images
    for id,properties in pairs(playerManager.getCharacters()) do
        for _,name in ipairs(playerManager.getCostumes(id)) do
            loadCharacterImages(id,name)
        end

        loadCharacterImages(id)
    end
end


function customSwimming.onTick()
    customSwimming.onTickPlayer(player)
end
function customSwimming.onDraw()
    customSwimming.onDrawPlayer(player)
end
function customSwimming.onDrawEnd()
    customSwimming.onDrawEndPlayer(player)
end


customSwimming.swimmingTweakSettings = {
    enabled = true,

    speed = 2,
    runSpeed = 4,
    acceleration = 0.15,

    imagePath = "%s-%s-customSwimming.png",

    -- How many frames each direction has.
    frameCounts = {
        [DIR.UP]    = 3,
        [DIR.DOWN]  = 3,
        [DIR.RIGHT] = 5,
        [DIR.LEFT]  = 5,
    },
}


return customSwimming