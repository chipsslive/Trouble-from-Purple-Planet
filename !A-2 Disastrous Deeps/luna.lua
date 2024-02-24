local rooms = require("rooms")
local nsmbwalls = require("nsmbwalls")
local warpTransition = require('warpTransition')
local powerupGuard = require("powerupGuard")
local hudoverride = require('hudoverride')
local antizip = require("antizip")
local customSwimming = require("customSwimming")
local spawnzones = require("spawnzones")

function onStart()
	player.character = CHARACTER_LUIGI
	player.powerup = 2
    hudoverride.visible.lives = false
    hudoverride.visible.score = false
    hudoverride.visible.coins = false

	for _,npc in NPC.iterate() do
        if npc.section == 0 and Section.getFromCoords(npc) == nil then -- Out of bounds
            -- see what section it's above/below
            for _,sec in ipairs(Section.get()) do
                if npc.x+npc.width >= sec.boundary.left and npc.x <= sec.boundary.right then
                    npc.section = sec.idx
                    break
                end
            end
        end
    end
end

function onEvent(eventName)
    if eventName == "achievement" then
        GameData.ach3:progressCondition(1, true)
    end
end