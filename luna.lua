local nsmbwalls = require("nsmbwalls")
local littleDialogue = require("littleDialogue")
local warpTransition = require("warpTransition")
local pauseplus = require("pauseplus")
local hudoverride = require("hudoverride")
local modernReserveItems = require("modernReserveItems")
local antizip = require("antizip")

pauseplus.createDefaultMenu()
pauseplus.createOption("main",{text = "Exit Level",action = pauseplus.exitLevel}, 2)

local starcoin = require("npcs/AI/starcoin")
SaveData.starcoins = starcoin.getEpisodeCollected()

GameData.cutscene = false
SaveData.gameBeaten = false

local ach = Achievements(1)
GameData.ach2 = Achievements(2)
GameData.ach3 = Achievements(3)

function onTick()
    if SaveData.starcoins >= 18 then
        ach:progressCondition(1, true)
    end

    SaveData.coins = SaveData.coins + mem(0x00B2C5A8,FIELD_WORD)
	mem(0x00B2C5A8,FIELD_WORD,0)
	
	if SaveData.coins >= 9999 then
		SaveData.coins = 9999
	end
end

SaveData.coins = SaveData.coins or 0

local coin = Graphics.loadImage(Misc.resolveFile("coin1.png"))

function onStart()
    Progress.value = (SaveData.starcoins / 18) * 100
    mem(0x00B2C5AC,FIELD_FLOAT,99)
    player.character = CHARACTER_MARIO
    hudoverride.visible.lives = false
    hudoverride.visible.score = false
	hudoverride.visible.coins = false
    hudoverride.offsets.itembox = {x = 230, y = 16, item = {x = 28, y = 28, align = hudoverride.ALIGN_MID}, align = hudoverride.ALIGN_MID};
end

local function customCounter()
    if not GameData.cutscene then
        Graphics.draw{
            type = RTYPE_TEXT,
            text = "x".. tostring(SaveData.coins),
            priority = 0,
            x= 700,
            y= 30,
        }
        Graphics.draw{
            type = RTYPE_IMAGE,
            image = coin,
            x = 680,
            y = 30,
            priority = 0,
        }
    end
end

function onDraw()
    -- Antizip makes the player teleport upwards if they take damage while pressing down. WHY?!
	if player.forcedState == FORCEDSTATE_POWERDOWN_SMALL and player.downKeyPressing then
		antizip.enabled = false
	else
		antizip.enabled = true
	end
end

Graphics.addHUDElement(customCounter)