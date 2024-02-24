-------------------HUDOverride-------------------
-------Created by Hoeloe and Enjl  - 2017--------
--SMBX HUD Defaults & Override System Library----
--------------For Super Mario Bros X-------------
----------------------v1.1-----------------------
local HUDOverride = {}
local pm
local starcoin
local timer

local hasDied = false

local textplus = require("textplus")
local tplusnumberfont = textplus.loadFont("textplus/font/1.ini")


local textCache = {}
local textCacheLifetime = 640
local textCacheList = {}

local HUDSprites = {}

local function ConvertSprite(img)
	if type(img) == "table" and img.img then
		return img.img
	else
		return img
	end
end

local spritesMT = {}
function spritesMT.__index(tbl, key)
	return ConvertSprite(HUDSprites[key])
end
function spritesMT.__newindex(tbl, key, val)
	HUDSprites[key] = val
end
function spritesMT.__pairs(tbl)
  local function iter(tbl, k)
    local v
    k, v = next(tbl, k)
    if nil~=v then return k, ConvertSprite(v) end
  end
  return iter, HUDSprites, nil
end
HUDOverride.sprites = setmetatable({}, spritesMT)

local reserveBox2P = {}
reserveBox2P[1] = Graphics.sprites.hardcoded["48-1"]
reserveBox2P[2] = Graphics.sprites.hardcoded["48-2"]

HUDSprites.reserveBox = Graphics.sprites.hardcoded["48-0"]


HUDSprites.coins = Graphics.sprites.hardcoded["33-2"]


HUDSprites.cross = Graphics.sprites.hardcoded["33-1"]

HUDSprites.stars = Graphics.sprites.hardcoded["33-5"]


HUDSprites.lives = Graphics.sprites.hardcoded["33-3"]
HUDSprites.lives2 = Graphics.sprites.hardcoded["33-7"]
--2nd one exclusive to battle mode?

HUDSprites.heartEmpty = Graphics.sprites.hardcoded["36-2"]
HUDSprites.heartFull = Graphics.sprites.hardcoded["36-1"]


HUDSprites.keys = Graphics.sprites.hardcoded["33-0"]
HUDSprites.bombs = Graphics.sprites.hardcoded["33-8"]

HUDSprites.overworldBox = Graphics.sprites.hardcoded["33-4"]

HUDSprites.arrowUp = Graphics.sprites.hardcoded["34-1"]
HUDSprites.arrowDown = Graphics.sprites.hardcoded["34-2"]

HUDSprites.starcoinUncollected = Graphics.sprites.hardcoded["51-0"]
HUDSprites.starcoinCollected = Graphics.sprites.hardcoded["51-1"]

HUDSprites.timer = Graphics.sprites.hardcoded["52"]

local SpriteDefaults = {}
for k,v in pairs(HUDSprites) do
	SpriteDefaults[k] = v
end


HUDOverride.visible = {}
HUDOverride.visible.keys = true
HUDOverride.visible.itembox = true
HUDOverride.visible.bombs = true
HUDOverride.visible.coins = true
HUDOverride.visible.score = true
HUDOverride.visible.lives = true
HUDOverride.visible.stars = true
HUDOverride.visible.starcoins = true
HUDOverride.visible.timer = true
HUDOverride.visible.levelname = true
HUDOverride.visible.overworldPlayer = true

HUDOverride.priority = 4.999999;

HUDOverride.ALIGN_LEFT = 0;
HUDOverride.ALIGN_RIGHT = 1;
HUDOverride.ALIGN_MID = 0.5;

--TODO: Replace this with object-level offsets with named fields and alignments
HUDOverride.offsets = {}
HUDOverride.offsets.keys = 		{x = 64, 	y = 26, align = HUDOverride.ALIGN_LEFT};
HUDOverride.offsets.itembox = 	{x = 0, 	y = 16, item = {x = 28, y = 28, align = HUDOverride.ALIGN_MID}, align = HUDOverride.ALIGN_MID};
HUDOverride.offsets.hearts = 	{x = 5, 	y = 16, align = HUDOverride.ALIGN_MID};
HUDOverride.offsets.score = 	{x = 170, 	y = 47, align = HUDOverride.ALIGN_RIGHT};

HUDOverride.offsets.bombs = 	{x = 0, 	y = 52, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = HUDOverride.ALIGN_LEFT}, align = HUDOverride.ALIGN_MID};
HUDOverride.offsets.coins = 	{x = 88, 	y = 26, cross = {x = 24, y = 1}, value = {x = 82, y = 1, align = HUDOverride.ALIGN_RIGHT}, align = HUDOverride.ALIGN_LEFT};
HUDOverride.offsets.lives = 	{x = -166, 	y = 26, cross = {x = 40, y = 1}, value = {x = 62, y = 1, align = HUDOverride.ALIGN_LEFT}, align = HUDOverride.ALIGN_LEFT};
HUDOverride.offsets.stars = 	{x = -150, 	y = 46, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = HUDOverride.ALIGN_LEFT}, align = HUDOverride.ALIGN_LEFT};
HUDOverride.offsets.starcoins = {x = -384, y = 27, cross = {x = 24, y = 0},	value = {x = 45, y = 0, align = HUDOverride.ALIGN_LEFT}, grid = {x = 0, y = 40, width = 5, height = 3, offset = 0, table = {}, align = HUDOverride.ALIGN_LEFT},	align = HUDOverride.ALIGN_LEFT}
HUDOverride.offsets.timer = {x = 264, y = 25, cross = {x = 24, y = 2},	value = {x = 106, y = 2, align = HUDOverride.ALIGN_RIGHT}, align = HUDOverride.ALIGN_LEFT}

HUDOverride.overworld = {offsets = {}};
HUDOverride.overworld.offsets.lives = 		{x = -272, 	y = 110, cross = {x = 40, y = 2}, value = {x = 62, y = 2, align = HUDOverride.ALIGN_LEFT}, align = HUDOverride.ALIGN_LEFT};
HUDOverride.overworld.offsets.coins = 		{x = -256, 	y = 88, cross = {x = 24, y = 2}, value = {x = 46, y = 2, align = HUDOverride.ALIGN_LEFT}, align = HUDOverride.ALIGN_LEFT};
HUDOverride.overworld.offsets.stars = 		{x = -256, 	y = 66, cross = {x = 24, y = 2}, value = {x = 46, y = 2, align = HUDOverride.ALIGN_LEFT}, align = HUDOverride.ALIGN_LEFT};
HUDOverride.overworld.offsets.levelname = 	{x = -156, 	y = 109, align = HUDOverride.ALIGN_LEFT};
HUDOverride.overworld.offsets.player =		{x = -308, y = 124}

Graphics.HUD_NONE = 0;
Graphics.HUD_HEARTS = 1;
Graphics.HUD_ITEMBOX = 2;

HUDOverride.multiplayerOffsets = {[Graphics.HUD_NONE] = 0, [Graphics.HUD_ITEMBOX] = 40, [Graphics.HUD_HEARTS] = 57}

local isActive = true

local activeCameras = nil
local activePlayers = nil

local oldActivate = Graphics.activateHud

function HUDOverride.onInitAPI()
	registerEvent(HUDOverride, "onExitLevel", "onExitLevel", false)
	--TODO: Change onHUDDraw to "true" when onHUDUpdate is implemented
	registerEvent(HUDOverride, "onHUDDraw", "onHUDDraw", false)
	registerEvent(HUDOverride, "onDraw", "onDraw", false)

	if(oldActivate) then
		oldActivate(false)
	end

	SaveData._basegame = SaveData._basegame or {}

	if SaveData._basegame.hud == nil then
		SaveData._basegame.hud = {}
		SaveData._basegame.hud.score = 0
		SaveData._basegame.starcoin = {}
	end
	mem(0x00B2C8E4, FIELD_DWORD, 0)
	pm = require("playerManager")
	if not isOverworld then
		starcoin = require("npcs/ai/starcoin")
		timer = require("timer")
	end
end

function Graphics.activateHud(setActive)
	if type(setActive) == "boolean" then
		isActive = setActive
	elseif setActive == nil then
		isActive = not isActive
	else
		error("No matching overload found. Candidates: Graphics.activateHud(bool setActive), Graphics.activateHud()", 2)
	end
end

function Graphics.isHudActivated()
	return isActive
end

_G["hud"] = Graphics.activateHud

local function drawCounterValue(value, x, y, priority)
	local v = tostring(value)
	if textCache[v] == nil then
		textCache[v] = {[1] = textplus.layout(v, nil, {font = tplusnumberfont, plaintext = true}), [2] = textCacheLifetime}
		table.insert(textCacheList, v)
	end
	
	textplus.render{
					layout = textCache[v][1], 
					x = x,	
					y = y,
					priority = priority
				   }
	textCache[v][2] = textCacheLifetime
end

local function renderHUD(camIndex, priority, isSplit)
	if(mem(0x00B2C89C, FIELD_DWORD) ~= -1 and mem(0x00B2C620, FIELD_WORD) ~= -1 and mem(0x00B2C89C, FIELD_WORD) ~= -1) then
		Graphics.drawVanillaHUD(camIndex, priority, isSplit);
	end
end

local function renderOWHUD(priority)
	Graphics.drawVanillaOverworldHUD(priority);
end

local currentRenderFunc = renderHUD;
local currentOWRenderFunc = renderOWHUD;

function Graphics.overrideHUD(f)
	currentRenderFunc = f or renderHUD;
end

function Graphics.overrideOverworldHUD(f)
	currentOWRenderFunc = f or renderOWHUD;
end

local function drawLinkStuff(playerIdx, camObj, playerObj, priority, isSplit, playerCount)
	local offset = Graphics.getHUDOffset(playerIdx, isSplit);

	local keyOffset = 0
	if(playerIdx == 1 and not isSplit and playerCount > 1) then
		keyOffset = -132
	end

	if HUDOverride.visible.keys then
		HUDOverride.drawKey(offset + keyOffset, camObj, playerObj, priority)
	end
	if HUDOverride.visible.bombs then
		HUDOverride.drawBombs(offset, camObj, playerObj, priority)
	end
end

local charHUDActions =
{
	[CHARACTER_MARIO] = {type = Graphics.HUD_ITEMBOX},
	[CHARACTER_LUIGI] = {type = Graphics.HUD_ITEMBOX},
	[CHARACTER_TOAD] = {type = Graphics.HUD_HEARTS},
	[CHARACTER_PEACH] = {type = Graphics.HUD_HEARTS},
	[CHARACTER_LINK] = {type = Graphics.HUD_HEARTS, actions = drawLinkStuff, sprites = { coins = Graphics.sprites.hardcoded["33-6"] }}
}

function Graphics.registerCharacterHUD(characterID, hudType, actions, sprites)
	charHUDActions[characterID] = {type = hudType, actions = actions, sprites = sprites};
	if(hudType == Graphics.HUD_ITEMBOX) then
		if(sprites == nil or sprites.reserveBox2P == nil) then
			reserveBox2P[characterID] = reserveBox2P[1];
		else
			reserveBox2P[characterID] = sprites.reserveBox2P;
		end
	end
end

local customHUDElements = {}

function Graphics.addHUDElement(elementFunction)
	table.insert(customHUDElements, elementFunction)
end

function Graphics.getHUDType(characterID)
	local c = charHUDActions[characterID];
	if(c) then
		return c.type;
	else
		return Graphics.HUD_NONE;
	end
end

function Graphics.getHUDActions(characterID)
	local c = charHUDActions[characterID];
	if(c) then
		return c.actions;
	else
		return nil;
	end
end

function Graphics.getHUDOffset(playerIdx, isSplit)
	if (#activePlayers > 1 and not isSplit) then
		local offset = HUDOverride.multiplayerOffsets[Graphics.getHUDType(activePlayers[playerIdx].character)];
		if(playerIdx == 1) then
			offset = -offset;
		end
		return offset;
	else
		return 0;
	end
end

function Graphics.drawVanillaHUD(camIndex, priority, isSplit)
	local thisPlayer = activePlayers[camIndex]
	local thisCam = activeCameras[camIndex]

	local splitOffset = {0,0}

	if #activePlayers > 1 and not isSplit then
		splitOffset[1] = -HUDOverride.multiplayerOffsets[Graphics.getHUDType(activePlayers[1].character)]
		splitOffset[2] = HUDOverride.multiplayerOffsets[Graphics.getHUDType(activePlayers[2].character)]
		for i=1, 2 do
			local acts = Graphics.getHUDActions(activePlayers[i].character)
			if(acts) then
				acts(i, thisCam, activePlayers[i], priority, isSplit, #activePlayers);
			end
		end
	else
		local acts = Graphics.getHUDActions(thisPlayer.character);
		if(acts) then
			acts(camIdx, thisCam, thisPlayer, priority, isSplit, #activePlayers);
		end
	end

	if HUDOverride.visible.itembox then
		HUDOverride.countItemboxes(splitOffset, camIndex, #activePlayers > 1, isSplit, priority)
	end
	if HUDOverride.visible.lives then
		HUDOverride.drawLives(splitOffset[1], thisCam, thisPlayer, priority)
	end
	if HUDOverride.visible.score then
		HUDOverride.drawScore(splitOffset[2], thisCam, priority)
	end
	if HUDOverride.visible.coins then
		HUDOverride.drawCoins(splitOffset[2], thisCam, thisPlayer, priority)
	end
	if HUDOverride.visible.stars then
		HUDOverride.drawStars(splitOffset[1], thisCam, thisPlayer, priority)
	end
	if HUDOverride.visible.starcoins then
		if isSplit and (activeCameras[camIndex].width < 800) then
			HUDOverride.drawStarcoins(220, thisCam, thisPlayer, priority)
		else
			HUDOverride.drawStarcoins(0, thisCam, thisPlayer, priority)
		end
	end
	if HUDOverride.visible.timer and timer.isActive() then
		if isSplit and (activeCameras[camIndex].width < 800) then
			HUDOverride.drawTimer(-200, thisCam, thisPlayer, priority)
		else
			HUDOverride.drawTimer(0, thisCam, thisPlayer, priority)
		end
	end
end

do

	function Graphics.drawVanillaOverworldHUD(priority)
		local state = Graphics.getOverworldHudState();
		if(state == WHUD_ALL or state == WHUD_ONLY_OVERLAY) then
			HUDOverride.drawOverworldBox(priority);
		end

		if(state == WHUD_ALL) then
			if HUDOverride.visible.lives then
				HUDOverride.drawHUDLives(player, priority);
			end

			if HUDOverride.visible.coins then
				HUDOverride.drawHUDCoins(player, priority);
			end
			if HUDOverride.visible.stars then
				HUDOverride.drawHUDStars(player, priority);
			end

			if HUDOverride.visible.overworldPlayer then
				HUDOverride.drawHUDPlayer(player, priority);
			end

			if(HUDOverride.visible.levelname and world.levelTitle ~= nil and world.levelTitle ~= "") then
				local offset = -#world.levelTitle*HUDOverride.overworld.offsets.levelname.align*16;
				Text.printWP(world.levelTitle,2,400+HUDOverride.overworld.offsets.levelname.x+offset,HUDOverride.overworld.offsets.levelname.y,priority);
			end
		end
	end
end

function HUDOverride.drawHUDPlayer(player, priority, color, shader, uniforms)
	local x,y = 400+HUDOverride.overworld.offsets.player.x-(player.width*0.5), HUDOverride.overworld.offsets.player.y-player.height;
	player:render{x = x, y = y, ignorestate = true, sceneCoords = false, priority = priority, color = color, mountcolor = Color.white, shader = shader, uniforms = uniforms};
end

local function GetImageFromID(img, character)
	if(type(img) == "LuaImageResource" or (type(img) == "table" and img.img)) then --is an image type
		return img;
	elseif(pm) then --is a playermanager registered graphic id
		return pm.getGraphic(character, img);
	end
end

local function GetSprite(name, character)
	if(charHUDActions[character] == nil or charHUDActions[character].sprites == nil or charHUDActions[character].sprites[name] == nil) then
		return ConvertSprite(HUDSprites[name] or SpriteDefaults[name])
	else
		return ConvertSprite(GetImageFromID(charHUDActions[character].sprites[name], character) or HUDSprites[name] or SpriteDefaults[name])
	end
end

function HUDOverride.drawKey(splitOffset, thisCam, thisPlayer, priority)
	if thisPlayer:mem(0x12,FIELD_WORD) ~= 0 then
		local key = GetSprite("keys", thisPlayer.character);
		local x = HUDOverride.offsets.keys.x - key.width * HUDOverride.offsets.keys.align;
		Graphics.drawImageWP(key, 0.5 * thisCam.width + x + splitOffset, HUDOverride.offsets.keys.y, priority)
	end
end

local function drawCounter(splitOffset, thisCam, thisPlayer, obj, sprite, value, priority)
		local v = tostring(value)
		local left = math.min(0, obj.cross.x, obj.value.x - (#v * obj.value.align));
		local cross = GetSprite("cross", thisPlayer.character);
		local right = math.max(sprite.width, obj.cross.x + cross.width, obj.value.x + (#v * 18 * (HUDOverride.ALIGN_RIGHT-obj.value.align)));
		local wid = right-left;
		local x = obj.x - wid*(obj.align);
		Graphics.drawImageWP(sprite, 	0.5 * thisCam.width + 	x + splitOffset, obj.y, priority)
		Graphics.drawImageWP(cross, 	0.5 * thisCam.width + 	x + obj.cross.x + splitOffset, obj.y + obj.cross.y, priority)
						
		if type(value) == "number" and value >= 0 and math.floor(value) == value then
			Text.printWP(v, 1, 0.5 * thisCam.width +x + obj.value.x + splitOffset - (#v * obj.value.align * 18), obj.y + obj.value.y, priority)
		else
			drawCounterValue(v, 0.5 * thisCam.width +x + obj.value.x + splitOffset - (#v * obj.value.align * 18), obj.y + obj.value.y, priority)
		end
end

function HUDOverride.drawBombs(splitOffset, thisCam, thisPlayer, priority)
	local bombs = thisPlayer:mem(0x08, FIELD_WORD)
	if bombs > 0 then
		local sprite = GetSprite("bombs", thisPlayer.character);
		drawCounter(splitOffset, thisCam, thisPlayer, HUDOverride.offsets.bombs, sprite, bombs, priority);
	end
end

function HUDOverride.drawStars(splitOffset, thisCam, thisPlayer, priority)
	local stars = (mem(0x00B251E0,FIELD_WORD))
	if stars > 0 then
		local sprite = GetSprite("stars", thisPlayer.character);
		drawCounter(splitOffset, thisCam, thisPlayer, HUDOverride.offsets.stars, sprite, stars, priority);
	end
end

function HUDOverride.drawLives(splitOffset, thisCam, thisPlayer, priority)
	drawCounter(splitOffset, thisCam, thisPlayer, HUDOverride.offsets.lives, GetSprite("lives", thisPlayer.character), mem(0x00B2C5AC,FIELD_FLOAT), priority);
end

function HUDOverride.drawHUDLives(thisPlayer, priority)
	drawCounter(0, {width = 800}, thisPlayer, HUDOverride.overworld.offsets.lives, GetSprite("lives", thisPlayer.character), mem(0x00B2C5AC,FIELD_FLOAT), priority);
end

function HUDOverride.drawHUDCoins(thisPlayer, priority)
	drawCounter(0, {width = 800}, thisPlayer, HUDOverride.overworld.offsets.coins, GetSprite("coins", thisPlayer.character), mem(0x00B2C5A8,FIELD_WORD), priority);
end

function HUDOverride.drawHUDStars(thisPlayer, priority)
	local stars = (mem(0x00B251E0,FIELD_WORD))
	if stars > 0 then
		local sprite = GetSprite("stars", thisPlayer.character);
		drawCounter(0, {width = 800}, thisPlayer, HUDOverride.overworld.offsets.stars, sprite, stars, priority);
	end
end

do
	local huddraw = {
						vertexCoords =
						{
							0,0,800,0,0,130,			0,130,800,0,800,130,				--Top side
							0,130,66,130,0,534,			0,534,66,130,66,534,				--Left side
							734,130,800,130,734,534,	734,534,800,130,800,534,			--Right side
							0,534,800,534,0,600,		0,600,800,534,800,600				--Bottom side
						},
						textureCoords =
						{
							0,0,1,0,0,0.216667,							0,0.216667,1,0,1,0.216667,
							0,0.216667,0.0825,0.216667,0,0.89,			0,0.89,0.0825,0.216667,0.0825,0.89,
							0.9175,0.216667,1,0.216667,0.9175,0.89,		0.9175,0.89,1,0.216667,1,0.89,
							0,0.89,1,0.89,0,1,							0,1,1,0.89,1,1
						}
					};
	function HUDOverride.drawOverworldBox(priority)
		huddraw.texture = Graphics.sprites.hardcoded["33-4"].img;
		huddraw.priority = priority;
		Graphics.glDraw(huddraw);
	end
end

function HUDOverride.countItemboxes(splitOffset, camIndex, isMultiplayer, isSplit, priority)
	thisCam = activeCameras[camIndex]
	if isMultiplayer and not isSplit then
		for i=1, 2 do
			thisPlayer = activePlayers[i]
			HUDOverride.drawItembox(splitOffset[i], thisCam, camIndex, thisPlayer, isMultiplayer, priority)
		end
	else
		thisPlayer = activePlayers[camIndex]
		HUDOverride.drawItembox(splitOffset[1], thisCam, camIndex, thisPlayer, isMultiplayer, priority)
	end
end

function HUDOverride.drawItembox(splitOffset, thisCam, playerIdx, thisPlayer, isMultiplayer, priority)

	local reserve2p = ConvertSprite(GetImageFromID(reserveBox2P[thisPlayer.character], thisPlayer.character))

	if Graphics.getHUDType(thisPlayer.character) == Graphics.HUD_ITEMBOX then
		local reserveBox = GetSprite("reserveBox", thisPlayer.character);
		local x1 = HUDOverride.offsets.itembox.x - reserveBox.width * HUDOverride.offsets.itembox.align;
		local x2 = HUDOverride.offsets.itembox.x - reserve2p.width * HUDOverride.offsets.itembox.align;

		if isMultiplayer then
			Graphics.drawImageWP(reserve2p, 0.5 * thisCam.width + x1 + splitOffset, HUDOverride.offsets.itembox.y, priority)
		else
			Graphics.drawImageWP(reserveBox, 0.5 * thisCam.width + x2 + splitOffset, HUDOverride.offsets.itembox.y, priority)
		end

	elseif(Graphics.getHUDType(thisPlayer.character) == Graphics.HUD_HEARTS) then
		local x = HUDOverride.offsets.hearts.x - 96 * HUDOverride.offsets.hearts.align;

		local hearts = thisPlayer:mem(0x16, FIELD_WORD)
		for i=1, 3 do
			local displayedImg = GetSprite("heartEmpty", thisPlayer.character);
			if hearts >= i then
				displayedImg = GetSprite("heartFull", thisPlayer.character);
			end
			Graphics.drawImageWP(displayedImg, 0.5 * thisCam.width  + 	x + splitOffset + 32 * (i - 1),
																		HUDOverride.offsets.hearts.y, priority)
		end

	end
	if thisPlayer.reservePowerup > 0 and reserve2p then

		local reserve = Graphics.sprites.npc[thisPlayer.reservePowerup].img

		local w = NPC.config[thisPlayer.reservePowerup].gfxwidth
		if w == 0 then
			w = NPC.config[thisPlayer.reservePowerup].width
		end

		local h = NPC.config[thisPlayer.reservePowerup].gfxheight
		if h == 0 then
			h = NPC.config[thisPlayer.reservePowerup].height
		end

		local reserveBox = GetSprite("reserveBox", thisPlayer.character);
		local x1 = HUDOverride.offsets.itembox.x - reserveBox.width * HUDOverride.offsets.itembox.align;
		local x2 = HUDOverride.offsets.itembox.x - reserve2p.width * HUDOverride.offsets.itembox.align;
		local x;
		if isMultiplayer then
			x = x2;
		else
			x = x1;
		end

		local sourcex = 0;
		local sourcey = 0;

		--Special case for megashroom (TODO: Maybe make this a table for config?)
		if(thisPlayer.reservePowerup == 425) then
			sourcey = 5*h;
		end

		Graphics.draw{type = RTYPE_IMAGE, image = reserve, priority = priority, isSceneCoords = false,
						x= 0.5 * thisCam.width + 	x + HUDOverride.offsets.itembox.item.x + splitOffset - HUDOverride.offsets.itembox.item.align * w,
						y= 							HUDOverride.offsets.itembox.y + HUDOverride.offsets.itembox.item.y - 0.5 * h,
						sourceWidth = w,
						sourceHeight = h,
						sourceX = sourcex, sourceY = sourcey}
	end
end

function HUDOverride.drawScore(splitOffset, thisCam, priority)
	local scoreDisplay = tostring(SaveData._basegame.hud.score)
	Text.printWP(scoreDisplay, 1, 0.5 * thisCam.width + HUDOverride.offsets.score.x + splitOffset - #scoreDisplay * 18 * HUDOverride.offsets.score.align, HUDOverride.offsets.score.y, priority)
end

function HUDOverride.drawCoins(splitOffset, thisCam, thisPlayer, priority)
	local s = GetSprite("coins", thisPlayer.character);
	drawCounter(splitOffset, thisCam, thisPlayer, HUDOverride.offsets.coins, s, tostring(mem(0x00B2C5A8,FIELD_WORD)), priority);
end


local function validStarCoin(t, i)
	return t[i] and (not t.alive or t.alive[i])
end

function HUDOverride.drawStarcoins(splitOffset, thisCam, thisPlayer, priority)
	local count = starcoin.count()
	if count > 0 then
	
		local data = starcoin.getLevelList()
		local collNum = starcoin.getLevelCollected()
		local offset = HUDOverride.offsets.starcoins
		local grid = offset.grid
		local img_coll = GetSprite("starcoinCollected", thisPlayer.character)
		local img_uncoll = GetSprite("starcoinUncollected", thisPlayer.character)
		local halfCam = thisCam.width/2
		local offsety = 0

		  --Correct the offset if it goes out of bounds
		  if grid.offset < 0 then
		    grid.offset = 0
		  else
		    local m = math.floor((count - grid.width*grid.height)/grid.width)
		    if grid.width == 1 and grid.offset > m then
		      grid.offset = math.max(0, m)
		    elseif grid.offset > m + 1 then
		      grid.offset = math.max(0, m + 1)
		    end
		  end
		  
		  
		--hacky workaround to make 2p mode work
		local origoff = {offset.x, offset.y}
		offset.x = offset.x + splitOffset
		
		if splitOffset ~= 0 then
			offset.y = offset.y + 40
		end
		
		splitOffset = 0
		  
		  
		-- Draw the counter
		drawCounter(splitOffset, thisCam, thisPlayer, offset, img_coll, collNum.."/"..count, priority)
		
		-- Draw the arrows
		if grid.offset > 0 then
			local img = GetSprite("arrowUp", thisPlayer.character)
			Graphics.drawImageWP(img, halfCam + offset.x - img.width*grid.align + grid.x + grid.width*(img_coll.width + 2)/2 - img.width/2, offset.y + grid.y - img.height - 4, priority)
		else
			offsety = -24
		end
		if count > grid.width*(grid.offset + grid.height) then
			local img = GetSprite("arrowDown", thisPlayer.character)
			Graphics.drawImageWP(img, halfCam + offset.x - img.width*grid.align + grid.x + grid.width*(img_coll.width + 2)/2 - img.width/2, offset.y + offsety + grid.y + grid.height*(img_coll.height + 2) + 2, priority)
		end
		
		-- Draw the icons
		local i = 1
		local idx = 1
		while idx <= starcoin.max() do
			if validStarCoin(data, idx + grid.offset) then
				local img
				if data[idx + grid.offset] == 0 then
					img = img_uncoll
				else
					img = img_coll
				end
				Graphics.drawImageWP(img, halfCam + offset.x - img.width*grid.align + grid.x + ((i - 1)%grid.width)*(img.width + 2), offset.y + offsety + grid.y + math.floor((i - 1)/grid.width)*(img.height + 2), priority)
				i = i+1
				if i > math.min(count - grid.offset*grid.width, grid.width*grid.height) then
					break
				end
			end
			idx = idx+1
		end
		
		offset.x = origoff[1]
		offset.y = origoff[2]
	end
end

function HUDOverride.drawTimer(splitOffset, thisCam, thisPlayer, priority)
	local s = GetSprite("timer", thisPlayer.character);
	
	local offset = HUDOverride.offsets.timer
	
	--hacky workaround to make 2p mode work
	local origoff = {offset.x, offset.y}
	offset.x = offset.x + splitOffset
	
	if splitOffset ~= 0 then
		offset.y = offset.y + 40
	end
		
	splitOffset = 0
	
	drawCounter(splitOffset, thisCam, thisPlayer, offset, s, timer.getValue(), priority);
	
	offset.x = origoff[1]
	offset.y = origoff[2]
end

function HUDOverride.onDraw()
	local s = mem(0x00B2C8E4, FIELD_DWORD)
	if (s > 0) then
		SaveData._basegame.hud.score = math.min(SaveData._basegame.hud.score + s, 9999990)
		mem(0x00B2C8E4, FIELD_DWORD, 0)
	end
	activeCameras = Camera.get()
	activePlayers = Player.get()
	
	local i = 1
	while i <= #textCacheList do
		local c = textCache[textCacheList[i]]
		c[2] = c[2]-1
		if c[2] <= 0 then
			textCache[textCacheList[i]] = nil
			table.remove(textCacheList, i)
		else
			i = i+1
		end
	end
end

function HUDOverride.onHUDDraw(camIdx)
	if isActive then
		if(isOverworld) then
			currentOWRenderFunc(HUDOverride.priority);
		else
			--TODO: Replace with a better test for splitscreen
			local isSplit = (activeCameras[camIdx].width < 800) or (activeCameras[camIdx].height < 600)

			currentRenderFunc(camIdx, HUDOverride.priority, isSplit)

			for _,v in ipairs(customHUDElements) do
				v(camIdx, HUDOverride.priority, isSplit)
			end
		end
	end
end

return HUDOverride
