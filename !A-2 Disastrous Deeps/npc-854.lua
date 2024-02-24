local smwfuzzy = {}

local lineguide = require("lineguide")
local npcManager = require("npcManager")
local rammerheads = require("AI/rammerheads")

local npcID = NPC_ID

npcManager.registerDefines(npcID, {NPC.UNHITTABLE})

-- settings
local config = {
	id = npcID, 
	gfxoffsety = 14, 
	width = 36, 
    height = 52,
    gfxwidth = 224,
    gfxheight = 104,
    frames = 4,
    framestyle = 0,
    noiceball = true,
    noyoshi = true,
	noblockcollision = true,
	nowaterphysics = true,
    jumphurt = true,
    nohurt = true,
	spinjumpSafe = false,

    bodyCollider = {size = vector(36,52), offset = vector(0,4)},
    headCollider = {size = vector(210,30), offset = vector(0,-14)},
}

rammerheads.register(npcID, config)

lineguide.properties[npcID] = {lineSpeed = 2}

return smwfuzzy