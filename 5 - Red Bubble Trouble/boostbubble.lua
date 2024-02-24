local bub = {}

bub.currentBubble = nil

bub.cancelBGOID = 754
bub.speed = 8.5

local afterimages = require("afterimages")
local npcManager = require("npcManager")

function bub.register(id)
	npcManager.registerEvent(id, bub, "onTickEndNPC", "mirrorTempleBubbles")
	npcManager.registerEvent(id, bub, "onDrawNPC", "onDrawBubble")
	NPC.config[id].noblockcollision = true

	NPC.config[id].spinjumpsafe = false
	npcManager.registerHarmTypes(id, {}, {});
end

-- sfx
local enterSFX = Misc.resolveFile("game_05_redbooster_enter.ogg");
local tumbleSFX = Misc.resolveFile("game_05_redbooster_move_loop.ogg");
local endTumbleSFX = Misc.resolveFile("game_05_redbooster_move_end.ogg");
local jumpOutSFX = Misc.resolveFile("game_05_redbooster_dash.ogg");
local respawnSFX = Misc.resolveFile("game_05_redbooster_reappear.ogg");
local collisionSFX = Misc.resolveFile("game_05_redbooster_end.ogg");
local bounceSFX = Misc.resolveFile("game_06_feather_reappear.ogg");

local bubbleImage = Graphics.loadImage("bubble.png")

local pressedAltJump = false
local pressedAltJumpThisFrame = false
local pressedAltJumpLastFrame = false


-- vector launch table
local angleTable = {}
for i=-1, 1 do
	angleTable[i] = {}
end

angleTable[-1][-1] = 45
angleTable[0][-1] = 90
angleTable[1][-1] = 135
angleTable[1][0] = 180
angleTable[1][1] = 225
angleTable[0][1] = 270
angleTable[-1][1] = 315
angleTable[-1][0] = 0

local bashSpeed = vector.v2(-8.5, 0)

local function bashDir()
	local horizDir = 0
	if player.keys.right then
		horizDir = horizDir + 1
	elseif player.keys.left then
		horizDir = horizDir - 1
	end
	local vertDir = 0
	if player.keys.up then
		vertDir = vertDir - 1
	elseif player.keys.down then
		vertDir = vertDir + 1
	end
	
	return angleTable[horizDir][vertDir] or 90 + 90 * player.direction
end

local STATE_READY = 0;
local STATE_INSIDE = 1;
local STATE_FLYING = 2;
local STATE_RESPAWN = 3;

-- ai1: Status
-- ai2: timer
-- ai3: start x
-- ai4: start y

function bub.onInitAPI()
    registerEvent(bub, "onInputUpdate")
    registerEvent(bub, "onTick")
end

function bub.onInputUpdate()
	pressedAltJumpLastFrame = pressedAltJump
	pressedAltJump = player.altJumpKeyPressing
	pressedAltJumpThisFrame = pressedAltJump and not pressedAltJumpLastFrame
end

function bub.onTick()
	if bub.currentBubble and bub.currentBubble.isValid then
		if bub.currentBubble.ai1 == STATE_FLYING and bub.currentBubble.ai2 > 1 then
			player.downKeyPressing = false
			player.leftKeyPressing = false
			player.rightKeyPressing = false
		end
		if bub.currentBubble.ai1 == STATE_FLYING then
			for k,v in ipairs(BGO.getIntersecting(player.x, player.y, player.x + player.width, player.y + player.height)) do
				if v.id == bub.cancelBGOID then
					Animation.spawn(63, bub.currentBubble.x + bub.currentBubble.width/2, bub.currentBubble.y + bub.currentBubble.height/2);
					Audio.SfxStop(6);
					SFX.play(jumpOutSFX);
					SFX.play(endTumbleSFX);
			
					bub.currentBubble.ai1 = STATE_RESPAWN;
					bub.currentBubble.ai2 = 0;
					
					if player:mem(0x13E,FIELD_WORD) == 0 then
						player.speedX = bub.currentBubble.data.speed.x
						player.speedY = bub.currentBubble.data.speed.y
					end
			
					bub.currentBubble.speedX = 0;
					bub.currentBubble.speedY = 0;
					bub.currentBubble.data.speed = nil
					bub.currentBubble.ai5 = bub.currentBubble.data.ai5Init;
					bub.currentBubble = nil;
					break
				end
			end
		end
	end
	--wadl.controlled = bub.currentBubble and bub.currentBubble.isValid
end

function bub.onDrawBubble(v)
	if v.isHidden or v.despawnTimer <= 0 then return end
	
	Graphics.drawImageToSceneWP(
		bubbleImage,
		v.x + 0.5 * v.width - 24,
		v.y + 0.5 * v.height - 24,
		48 * (4 - v.ai5),
		48 * v.animationFrame,
		48,
		48,
		-25
	)
	--v.animationFrame = 999
end

local frameswitch = {0,1,0,2}
local colorTable = {
	[4] = Color.white .. 0,
	[3] = Color.white .. 0,
	[2] = Color(1,0.8,0.8, 0),
	[1] = Color(0.8,0.6,0.7,0),
	[0] = Color(0.5,0.4,0.7,0)
}

local IDX_TL = 1
local IDX_TR = 2
local IDX_BR = 3
local IDX_BL = 4

local function getFrontFacingVertices(vt, speed)
	local mainDir = 1
	if speed.x > 0 then
		if speed.y > 0 then
			mainDir = IDX_BR
		elseif speed.y < 0 then
			mainDir = IDX_TR
		else
			return {vt[2], vt[3]}
		end
	elseif speed.x < 0 then
		if speed.y > 0 then
			mainDir = IDX_BL
		elseif speed.y < 0 then
			mainDir = IDX_TL
		else
			return {vt[1], vt[4]}
		end
	else
		if speed.y > 0 then
			return {vt[3], vt[4]}
		elseif speed.y < 0 then
			return {vt[1], vt[2]}
		else
			return {}
		end
	end
	local l = mainDir - 1
	if l == 0 then l = 4 end
	local r = mainDir + 1
	if r == 5 then r = 1 end
	return {vt[mainDir], vt[l], vt[r]}
end

local function ccdCheck(v)
	local data = v.data
	if not data.speed then return end 
	
		
	local fullSpeed = vector.v2(data.speed.x, data.speed.y)
	local speed = vector.v2(data.speed.x, data.speed.y)
	local i = 0
	
	local hasCollided = false
	while true do
			
		i = i + 1
		if i == 5 then break end
	
		local candidates = {}
		local left, right, top, bottom
		left = math.min(player.x - 2, player.x + data.speed.x - 2)
		right = math.max(player.x + player.width + 2, player.x + player.width + data.speed.x + 2)
		top = math.min(player.y - 2, player.y + data.speed.y - 2)
		bottom = math.max(player.y + player.height + 2, player.y + player.height + data.speed.y + 2)
		
		for k,w in ipairs(Block.getIntersecting(left,top,right,bottom)) do
			if Block.SOLID_MAP[w.id] or Block.PLAYER_MAP[w.id] or (v.speedY > 0 and (Block.SEMISOLID_MAP[w.id] or Block.SIZEABLE_MAP[w.id])) then
				if not (w.isHidden or w:mem(0x5A, FIELD_BOOL)) then
					table.insert(candidates, w)
				end
			end
		end
		if #candidates > 0 then
			local magnitude = speed.length
			local d
			local dn
			local shortestVector
			local startvectorTable = {
				vector.v2(player.x - 2, player.y - 2),
				vector.v2(player.x + 2 + player.width, player.y - 2),
				vector.v2(player.x + 2 + player.width, player.y + player.height + 2),
				vector.v2(player.x - 2, player.y + player.height + 2)
			}
			for i,vt in ipairs(getFrontFacingVertices(startvectorTable, speed)) do
				local precheck = false
				for _,v2 in ipairs(candidates) do
					if(Colliders.collide(Colliders.Point(vt.x,vt.y), v2)) then
						d = 0;
						_,_,dn = Colliders.raycast(vt-speed, speed, v2)
						precheck = true;
						break;
					end
				end
				if(precheck) then
					break;
				end
			
				local ray, hit, normal = Colliders.raycast(vt, speed, candidates)
				if ray and (d == nil or ((hit - vt).sqrlength < d and normal.sqrlength > 0.5)) then
					d = (hit - vt).sqrlength
					dn = normal
				end
			end
			if not d then break end
			
			local s = speed:normalise()*math.sqrt(d)
			player.x = player.x + s.x
			player.y = player.y + s.y
			speed = speed - s
			speed = speed - (2 * (speed..dn)*dn)
			fullSpeed = fullSpeed - (2 * (fullSpeed..dn)*dn)
			if not hasCollided then
				hasCollided = true
				if v.ai5 > 0 then
					Defines.earthquake = 5;
					SFX.play(collisionSFX);
					SFX.play(bounceSFX);
					
					if v.ai5 <= 3 then
						v.ai5 = v.ai5 - 1;
					end
					player:mem(0x140, FIELD_WORD, 12)
				else
					Animation.spawn(63, v.x + v.width/2, v.y + v.height/2);
					Audio.SfxStop(6);
					SFX.play(collisionSFX);
					SFX.play(endTumbleSFX);
				
					v.ai1 = STATE_RESPAWN;
					v.ai2 = 0;
				
					v.speedX = 0;
					v.speedY = 0;
					v.ai5 = v.data.ai5Init;
					bub.currentBubble = nil;
					break
				end
			end
		end
	end
	if bub.currentBubble then
		player.x = player.x + speed.x
		player.y = player.y + speed.y
		v.x = player.x + 0.5 * player.width - 0.5 * v.width
		v.y = player.y + 0.5 * player.height - 0.5 * v.height
		v.speedX = 0
		v.speedY = 0
		data.speed = fullSpeed
	end
end

function bub.mirrorTempleBubbles(v)
	if v.isHidden or v.despawnTimer <= 0 then return end
	local data = v.data
	
	if data.ai5Init == nil then

		v.ai5 = v.ai2
		v.ai2 = 0
		
		data.ai5Init = v.ai5;
	end
	
	-- pls dont stomp
	v.friendly = true;
	
	-- timer
	if not Defines.levelFreeze then
		v.ai2 = v.ai2 + 1;
	end
	
	-- startX/startY setting
	if v.ai3 == 0 then
		v.ai3 = v.x;
	end
	if v.ai4 == 0 then
		v.ai4 = v.y;
	end
	
	if v.ai1 ~= STATE_FLYING then
		v.ai5 = data.ai5Init;
	end
	
	if v.ai1 == STATE_READY then
		v.animationFrame = frameswitch[math.floor(v.ai2*0.125)%4 + 1]
	-- routines that dont need player
	elseif v.ai1 == STATE_INSIDE then
		if data.spd == nil then data.spd = vector(0,0) end
		v.animationFrame = math.floor(v.ai2*0.125)%3 + 3
		player:mem(0x140, FIELD_WORD, 2);
		-- wobble
		data.modifiedBubblePos = data.bubblePos + data.spd * math.sin(v.ai2 * 0.1) * (20 - v.ai2);
		v.x, v.y = data.modifiedBubblePos.x, data.modifiedBubblePos.y;
		
		if v.ai2 == 20 then
			v.ai2 = 0;
			v.ai1 = 2;
			v.x = v.ai3;
			v.y = v.ai4;
		end
	-- bubble flying 
	elseif v.ai1 == STATE_FLYING then
		v.animationFrame = math.floor(v.ai2*0.25)%4 + 6
		-- die or bounce if it hits a wall
		if v.ai2 % 3 == 0 then
			local frame = v.animationFrame
			v.animationFrame = 0
			afterimages.create(v, 24, colorTable[v.ai5])
			v.animationFrame = frame
		end
	-- wait to respawn
	elseif v.ai1 == STATE_RESPAWN then
		v.animationFrame = 99; -- turn invisible;
		
		if v.ai2 == 120 then
			SFX.play(respawnSFX);
			v.animationFrame = 0;
			v.x = v.ai3;
			v.y = v.ai4;
			v.speedX = 0;
			v.speedY = 0;
			v.ai2 = 0
			v.ai1 = STATE_READY;
			Animation.spawn(63, v.x + v.width/2, v.y + v.height/2);
		end
	end
	for _,p in pairs(Player.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
		-- catch player in the bubble
		collides = true
		if v.ai1 == STATE_READY then
			if bub.currentBubble == nil then
				-- speed vector for bounce effect
				data.spd = vector.v2(p.speedX, p.speedY) * 0.5;
			else
				Animation.spawn(63, bub.currentBubble.x + bub.currentBubble.width/2, bub.currentBubble.y + bub.currentBubble.height/2);
				Audio.SfxStop(6);
				SFX.play(collisionSFX);
				SFX.play(endTumbleSFX);
			
				bub.currentBubble.ai1 = STATE_RESPAWN;
				bub.currentBubble.ai2 = 0;
				bub.currentBubble.data.speed = bub.currentBubble.data.speed or vector.zero2
				-- transfer speed
				data.spd = vector.v2(bub.currentBubble.data.speed.x, bub.currentBubble.data.speed.y) * 0.25;
			end
			
			bub.currentBubble = v;
			v.ai1 = STATE_INSIDE;
			v.ai2 = 0;
			
			SFX.play(enterSFX);
			
			data.bubblePos = vector.v2(v.x, v.y);
		elseif v.ai1 == STATE_FLYING then
		
			-- bubble takeoff
			if v.ai2 == 1 then
				local bashSpeed = vector.v2(-math.abs(bub.speed), 0)
				local angle = bashDir()
				local shotDir = bashSpeed:rotate(angle)
				
				data.speed = shotDir
				
				SFX.play(jumpOutSFX);
				local sfxToPlay = Audio.SfxOpen(tumbleSFX);
				Audio.SfxPlayCh(6, sfxToPlay, -1);
				Audio.SfxVolume(6, 60);
				player.x = v.x + v.width * 0.5 - player.width * 0.5
				player.y = v.y + v.height * 0.5 - player.height * 0.5
			end
			
			-- jump out of the bubble
			if v.ai2 > 5 then
				if p.keys.jump == KEYS_PRESSED or pressedAltJumpThisFrame
				or p:mem(0x13E,FIELD_WORD) ~= 0 or p:mem(0x122,FIELD_WORD) == 2 then
					Animation.spawn(63, v.x + v.width/2, v.y + v.height/2);
					Audio.SfxStop(6);
					SFX.play(jumpOutSFX);
					SFX.play(endTumbleSFX);
			
					v.ai1 = STATE_RESPAWN;
					v.ai2 = 0;
					
					if p:mem(0x13E,FIELD_WORD) == 0 then
						p.speedX = data.speed.x
						p.speedY = data.speed.y
					end
			
					v.speedX = 0;
					v.speedY = 0;
					data.speed = nil
					bub.currentBubble = nil;
					v.ai5 = data.ai5Init;
				end
			end
		end
	end
		
	--post-state-init pass for flight
	if v.ai1 == STATE_FLYING then
		--if data.speed ~= nil then
		--	v.speedX = data.speed.x
		--	v.speedY = data.speed.y
		--	data.speed = nil
		--end
		ccdCheck(v)
	end	
	
	-- freeze players in bubble
	if (v.ai1 ~= STATE_READY and v.ai1 ~= STATE_RESPAWN) then
		-- update player status. featuring: copied code from launchBarrel
		player.x = v.x + v.width * 0.5 - player.width * 0.5
		player.y = v.y + v.height * 0.5 - player.height * 0.5 - Defines.player_grav
		
		player.speedX = 0;
		player.speedY = 0;
		
		--p:mem(0x140, FIELD_WORD, 2);
		player:mem(0x142, FIELD_BOOL, true);
		
		player.keys.run = true;
		player.keys.altRun = true;
	end
end

return bub