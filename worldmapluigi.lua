local worldmapluigi = {}

local sprite = {
    Graphics.loadImage("luigi.png"),
    0,
    0,
    0,
    0,
}

local cam = Camera.get()[1]

local size = 64

local state = 0
local frame = 0

local waterstate = 0

local offsetx = 16
local offsety = 28

local walkt = 0
local climbt = 0
local reacht = 0
    
local anim = {3,1,2,0}    

local PATH_TYPE_NORMAL = nil
local PATH_TYPE_WATER  = 0
local PATH_TYPE_LADDER = 1

local pathTypes = {
    -- Water paths

    -- Ladder paths
    [23] = PATH_TYPE_LADDER,
    [58] = PATH_TYPE_LADDER,
}



function worldmapluigi.onInitAPI()
    registerEvent(worldmapluigi, "onDraw", "onDraw", false)
end

local function getPathType()
    local extra = 0
    for i,lvl in ipairs(Level.get()) do
        if world.playerX == math.clamp(world.playerX, lvl.x - 10, lvl.x + 10) and world.playerY == math.clamp(world.playerY, lvl.y - 10, lvl.y + 10) then
            extra = 11
        end
    end

    for _,path in ipairs(Path.getIntersecting(world.playerX+10-extra,world.playerY+10-extra,world.playerX+22+extra,world.playerY+22+extra)) do
        if path.visible then
            return pathTypes[path.id]
        end
    end
end

local function Animation()
    local walks = 8
    local climbs = 8
    local swims = 8

    -- Decide walking frame
    local currentPathType = getPathType()

	--Climbing state
    if currentPathType == PATH_TYPE_LADDER then
        walkt = 0
        state = 4
        if world.playerIsCurrentWalking then
			climbt = climbt + 1
            for i=0,1 do
                if climbt >= (climbs * i) and climbt < (climbs * (i + 1)) then
                    frame = i
                end
            end
            if climbt >= climbs * 2 then
                climbt = 0
            end
		end
    -- Walking and Swimming states
    else
        climbt = 0
        if currentPathType == PATH_TYPE_WATER then
            waterstate = 5
        else
            waterstate = 0
        end
        if world.playerIsCurrentWalking then                                  -- This is for a little pause after the player stops walking, just like in SMW
            reacht = 8                                                        -- Serves as a flag as well
        else
            reacht = reacht - 1
            if reacht <= 0 then
                reacht = 0
            end
        end
        if reacht ~= 0 and world.playerWalkingDirection ~= 0 then
            state = anim[world.playerWalkingDirection]
        elseif reacht == 0 then 
            state = 2
        end
        walkt = walkt + 1
        for i=0,3 do
            if walkt >= (walks * i) and walkt < (walks * (i + 1)) then
                frame = i
            end
        end
        if walkt >= walks * 4 then
            walkt = 0
        end
    end
end



function worldmapluigi.onDraw()
    Animation()

    if sprite[player.character] ~= 0 then
        Graphics.draw{
            type = RTYPE_IMAGE,
            image = sprite[player.character],
            x = (world.playerX - cam.x) - offsetx,
            y = (world.playerY - cam.y) - offsety,
            priority = -25,
            sourceX = (state + waterstate) * size,
            sourceY = frame * size,
            sourceWidth = size,
            sourceHeight = size,   
        }
    end
end

return worldmapluigi