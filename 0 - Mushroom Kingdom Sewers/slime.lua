-- name is a bit weird: this one runs a function only when a block is stood on by a player.

local slime = {}
local blockmanager = require("blockmanager")
local blockutils = require("blocks/blockutils")

local jumpsLimited = {0, 0}

local slimeIDs = {}

function slime.register(id)
    table.insert(slimeIDs, id)
    blockmanager.registerEvent(id, slime, "onTickBlock")
    blockmanager.registerEvent(id, slime, "onCameraDrawBlock")
end

function slime.onInitAPI()
    registerEvent(slime, "onTick")
    registerEvent(slime, "onDraw")
end

function slime.onTick()
    local ps = Player.get()
    for i=#ps, 1, -1 do
        if jumpsLimited[i] == nil then
            jumpsLimited[i] = 0
        end
        if jumpsLimited[i] > 0 then
            if ps[i]:mem(0x11C, FIELD_WORD) > 0 then
                ps[i]:mem(0x11C, FIELD_WORD, 0)
                Effect.spawn(271, player.x + 0.5 * player.width - 16, player.y + player.height - 32 - player.speedY)
                ps[i].speedY = math.max(ps[i].speedY, -2)
            end
        end
        jumpsLimited[i] = math.max(jumpsLimited[i] - 1, 0)
    end
end

function slime.onTickBlock(v)
    v.data._basegame.touched = false
end

function slime.onPlayerStood(v, p)
	if v.isHidden or v:mem(0x5A, FIELD_BOOL) then return end
    jumpsLimited[p.idx] = 2
    v.data._basegame.touched = true
end

return slime