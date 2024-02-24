local smoothWorld = API.load("smoothWorld")
local wandr = API.load("wandr");
local travl = API.load("travl");
local sectTrans = require("sectTrans")
local pauseplus = require("pauseplus")
local worldmapluigi = require("worldmapluigi")
local hudoverride = require("hudoverride")

pauseplus.createDefaultMenu()

local overlayImage = Graphics.loadImageResolved("mapOverlay.png")

function onDraw()
    Graphics.drawImageWP(overlayImage,832 - camera.x,-1152 - camera.y,0)
end

function onStart()
    hudoverride.visible.lives = false
    hudoverride.visible.coins = false

    if SaveData.gameBeaten then
        for _,levelObj in ipairs(Level.findByFilename("!- Peach's Castle.lvlx")) do
            levelObj:mem(0x34,FIELD_STRING,"!PeachAfter.lvlx")
        end
    end
end

wandr.speed = 3