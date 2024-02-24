local npcManager = require("npcManager")

local lineguide = require("lineguide")

local npcutils = require("npcs/npcutils")

local rammerheads = {}

local function makeCollider(x, y, size, offset)
    local w, h = size.x * 0.5, size.y * 0.5
    return Colliders.Poly(x, y,
                          {-w + offset.x, -h + offset.y},
                          {w + offset.x, -h + offset.y},
                          {w + offset.x, h + offset.y},
                          {-w + offset.x, h + offset.y}
    )
end

local dirToAngle = {
    0,
    90,
    180,
    90
}

local fs1DirToAngle = {
    [-1] = {90,
    0,
    -90,
    180},
    [1] = {-90,
    180,
    90,
    0},
}

--Collider props more like v2

function rammerheads.register(id, config)
    if config.headCollider == nil then
        config.headCollider = {size = vector(78,30), offset = vector(22,10)}
    end
    if config.bodyCollider == nil then
        config.bodyCollider = {size = vector(32,32), offset = vector(0,0)}
    end

    npcManager.registerEvent(id, rammerheads, "onTickEndNPC")
    npcManager.registerEvent(id, rammerheads, "onDrawNPC")

    lineguide.registerNpcs(id)

    npcManager.setNpcSettings(config)
end

local function updateCollider(v, col, cfg, jumphurt)
    col:rotate(v.data.angle)
    local offset = vector(cfg.offset.x, cfg.offset.y)
    if v.data.direction == -1 then
        offset.x = 3 * -offset.x
    end
    offset = offset:rotate(v.data.angle)
    col.x = v.x + 0.5 * v.width + offset.x
    col.y = v.y + 0.5 * v.height + offset.y

    for k,p in ipairs(Player.get()) do
        if p.deathTimer == 0 and p.idx ~= v:mem(0x12C, FIELD_WORD) and p.idx ~= v:mem(0x130, FIELD_WORD) then
            local bounced = false
            if Colliders.bounce(p, col) then
                local response = 3
                if p.keys.jump or p.keys.altJump then
                    response = 10
                end
                
                if p.mount % 2 == 1 or p:mem(0x50, FIELD_BOOL) or not jumphurt then
                    Colliders.bounceResponse(p, response)
                    bounced = true
                end
            end
            
            if not bounced then
                if Colliders.collide(p, col) then
                    p:harm()
                end
            end
        end
    end
end

local function checkShouldFreeze()
	local forcedStateFreeze
	for _,p in ipairs(Player.get()) do
		if p.forcedState ~= 0 and p.forcedState ~= 7 and p.forcedState ~= 3 then
			forcedStateFreeze = true
		end
	end
	return forcedStateFreeze or Defines.levelFreeze
end

function rammerheads.onTickEndNPC(v)
    if Defines.levelFreeze then return end

    if v:mem(0x12A, FIELD_WORD) <= 0 then
        v.data.direction = nil
        return
    end

    local data = v.data._basegame.lineguide

    if v.data.direction == nil then
        v.data.direction = v:mem(0xD8, FIELD_FLOAT)
        v.data.cooldown = 0
        v.data.lerp = 0
    end
    
    local cfg = NPC.config[v.id]
    if v.data.angle == nil then
        local spawnDir = v:mem(0x144, FIELD_WORD)
        v.data.angle = 0
        if spawnDir > 0 then
            if cfg.framestyle == 0 then
                v.data.angle = dirToAngle[spawnDir] * v.data.direction
            else
                v.data.angle = fs1DirToAngle[v.data.direction][spawnDir]
            end
        end
        v.data.firstFrame = true
        v.data.targetAngle = v.data.angle
    end

    if v.data.bodyCollider == nil then
        v.data.bodyCollider = makeCollider(v.x, v.y, cfg.bodyCollider.size, cfg.bodyCollider.offset)
        v.data.headCollider = makeCollider(v.x, v.y, cfg.headCollider.size, cfg.headCollider.offset)
    end

    if v.data.cooldown == 0 then
        if data and not checkShouldFreeze() then
            if not v.data.firstFrame then
                v.data.bodyCollider:rotate(-v.data.angle)
                v.data.headCollider:rotate(-v.data.angle)
            end

            --Let's Rotate...
            if v.data.lastline == data.start then
                local spdvec = vector(v.speedX, v.speedY):normalize()
                local lastTargetAngle = v.data.targetAngle
                v.data.targetAngle = math.deg(math.atan(spdvec.y/spdvec.x))-- * v.data.direction

                if math.sign(spdvec.x) == -v.data.direction then
                    v.data.targetAngle = v.data.targetAngle + 180
                elseif spdvec.x == 0 then
                    v.data.targetAngle = 90 * math.sign(spdvec.y) * v.data.direction
                end

                if cfg.framestyle == 0 then
                    v.data.targetAngle = v.data.targetAngle + 90 * v.data.direction
                end

                if lastTargetAngle ~= v.data.targetAngle then
                    v.data.lerp = 0
                end
            else
                v.data.cooldown = 2
            end

            if v.data.angle ~= v.data.targetAngle then
                v.data.lerp = v.data.lerp + 0.1
                v.data.angle = math.anglelerp(v.data.angle, v.data.targetAngle, v.data.lerp)
                if v.data.lerp >= 1 then
                    v.data.angle = v.data.targetAngle
                end
            end

            if (not v.friendly) then
                updateCollider(v, v.data.bodyCollider, cfg.bodyCollider, false)
                updateCollider(v, v.data.headCollider, cfg.headCollider, cfg.jumphurt)
                v.data.firstFrame = false
            end

            v.data.lastline = data.start
        else
            v.data.cooldown = 2
        end
    else
        v.data.cooldown = v.data.cooldown - 1
    end
end

function rammerheads.onDrawNPC(v)
    if v:mem(0x12A, FIELD_WORD) <= 0 then
        return
    end

    local data = v.data._basegame.lineguide

    if v.data.direction and v.data.angle then
        local cfg = NPC.config[v.id]

        local p = -1
        if cfg.foreground then
            p = -15
        end

        local gfxw, gfxh = cfg.gfxwidth * 0.5, cfg.gfxheight * 0.5

        local vt = {
            vector(-gfxw, -gfxh),
            vector(gfxw, -gfxh),
            vector(gfxw, gfxh),
            vector(-gfxw, gfxh),
        }

        local totalframe = v.animationFrame % cfg.frames
        local totalframes = cfg.frames
        if cfg.framestyle == 1 then
            if v.data.direction == 1 then
                totalframe = totalframe + cfg.frames
            end
            totalframes = totalframes * 2
        end

        local f0 = totalframe / totalframes
        local f1 = (totalframe + 1) / totalframes

        local tx = {
            0, f0,
            1, f0,
            1, f1,
            0, f1,
        }

        local x, y = v.x + 0.5 * v.width, v.y + 0.5 * v.height

        for k,a in ipairs(vt) do
            vt[k] = a:rotate(v.data.angle or 0)
        end

        Graphics.glDraw{
            vertexCoords = {
                x + vt[1].x, y + vt[1].y,
                x + vt[2].x, y + vt[2].y,
                x + vt[3].x, y + vt[3].y,
                x + vt[4].x, y + vt[4].y,
            },
            textureCoords = tx,
            primitive = Graphics.GL_TRIANGLE_FAN,
            texture = Graphics.sprites.npc[v.id].img,
            sceneCoords = true,
            priority = p
        }

        npcutils.hideNPC(v)
    end
end

return rammerheads