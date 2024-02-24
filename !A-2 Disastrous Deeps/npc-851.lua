local smwfuzzy = {}

local lineguide = require("lineguide")
local npcManager = require("npcManager")
local rammerheads = require("AI/rammerheads")

local npcID = NPC_ID

npcManager.registerDefines(npcID, {NPC.UNHITTABLE})

-- settings
local config = {
	id = npcID, 
	gfxoffsety = 16,
	width = 32, 
    height = 32,
    gfxwidth = 112,
    gfxheight = 64,
    frames = 4,
    framestyle = 1,
    noiceball = true,
    noyoshi = true,
	noblockcollision = true,
	nowaterphysics = true,
    jumphurt = true,
    nohurt = true,
    spinjumpSafe = false,

    bodyCollider = {size = vector(56,30), offset = vector(-8,0)},
    headCollider = {size = vector(70,30), offset = vector(8,-6)},
}

rammerheads.register(npcID, config)

lineguide.properties[npcID] = {lineSpeed = 2}

return smwfuzzy