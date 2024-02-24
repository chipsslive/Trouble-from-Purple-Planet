--camLock by Enjl
--register camera volumes like so:
--camLock.addZone(x,y,width,height,lerpFactor)
--or:
--camLock.addZone{left=number, top=number, right=number, bottom=number, lerp=lerpFactor}
--or:
--camLock.addZone{x=number, y=number, width=number, height=number, lerp=lerpFactor}
--lerpFactor determines how fast the camera moves over. 0 is never, 1 is instant.

local camLock = {}
local vectr = API.load("vectr")

local cams = Camera.get()

function camLock.onInitAPI()
	if isOverworld then
		registerEvent(camLock, "onDraw", "onCamUpdateWorld")
	else
		registerEvent(camLock, "onCameraUpdate", "onCamUpdateLevel")
	end
	
	registerEvent(camLock, "onDraw")
	registerEvent(camLock, "onDrawEnd")
end

local camZones = {}

local cameraLerpTime = {0,0}
local lerpedCamPos = {0,0}

local inVolume = {0,0}

--accepts a table with left, top, right, bottom, but also with x,y,width,height, or just the fields as individual args
function camLock.addZone(bounds, y, w, h, lerp)
	local entry = {}
	if y ~= nil then
		entry.left = bounds
		entry.top = y
		entry.right = bounds + w
		entry.bottom = y + h
		entry.lerp = lerp or 0.05
	else
		entry = bounds
		if entry.x ~= nil then
			entry.left = bounds.x
			entry.top = bounds.y
			entry.right = bounds.x + bounds.width
			entry.bottom = bounds.y + bounds.height
		end
		entry.lerp = entry.lerp or 0.05
	end
	
	table.insert(camZones, entry)
end

local function lerpCamera(camIdx, target, lerpTime)
	local camera = cams[camIdx]
	camera.x = vectr.lerp(camera.x, target.x, lerpTime)
	camera.y = vectr.lerp(camera.y, target.y, lerpTime)
	
	lerpedCamPos[camIdx] = {x=camera.x, y=camera.y}
end

	
local worldBuffer = {0,0}

if isOverworld and Graphics.getOverworldHudState() ~= WHUD_NONE then
	worldBuffer = {68, 130}
end

local function moveCameraInZone(camIdx, zone)
	local camera = cams[camIdx]
	local target = {x=camera.x, y=camera.y}

	if camera.x + worldBuffer[1] < zone.left then
		if camera.x + camera.width - worldBuffer[1] <= zone.right then
			target.x = zone.left - worldBuffer[1]
		end
	elseif camera.x + camera.width - worldBuffer[1] > zone.right then
		if camera.x >= zone.left + worldBuffer[1] then
			target.x = zone.right - camera.width + worldBuffer[1]
		end
	end
	
	if camera.y + worldBuffer[2]  < zone.top then
		if camera.y + camera.height - worldBuffer[1] <= zone.right then
			target.y = zone.top - worldBuffer[2]
		end
	elseif camera.y + camera.height - worldBuffer[1] > zone.bottom then
		if camera.y >= zone.top + worldBuffer[2] then
			target.y = zone.bottom - camera.height + worldBuffer[1]
		end
	end
	
	lerpCamera(camIdx, target, cameraLerpTime[camIdx])
end

local function checkVolumes(playerPos, id)
	local camera = cams[id]
	local loopDidntBreak = true
	for k,v in ipairs(camZones) do
		Graphics.glDraw{
			vertexCoords={v.left, v.top, v.right, v.top, v.right, v.bottom, v.left, v.bottom},
			primitive=Graphics.GL_TRIANGLE_FAN
		
		}
		if  playerPos.x + playerPos.w > v.left
		and playerPos.x < v.right
		and playerPos.y + playerPos.h > v.top
		and playerPos.y < v.bottom then
			inVolume[id] = v.lerp
			cameraLerpTime[id] = math.min(cameraLerpTime[id] + v.lerp, 1)
			moveCameraInZone(id, v)
			loopDidntBreak = false
			break
		end
	end
	if inVolume[id] > 0 and loopDidntBreak then
		lerpCamera(id, lerpedCamPos[id], cameraLerpTime[id])
		cameraLerpTime[id] = cameraLerpTime[id] - inVolume[id]
		if cameraLerpTime[id] <= 0 then
			cameraLerpTime[id] = 0
			inVolume[id] = 0
		end
	end
end

function camLock.onCamUpdateWorld()
	local position = {x=world.playerX, y=world.playerY, w=32, h=32}
	checkVolumes(position, 1)
end

function camLock.onCamUpdateLevel(event, camIdx)
	local p = Player.get()[camIdx]
	local position = {x=p.x, y=p.y, w=p.width, h=p.height}
	
	checkVolumes(position, camIdx)
end


return camLock