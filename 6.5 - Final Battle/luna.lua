local hudoverride = require("hudoverride")
local textplus = require("textplus")
local pauseplus = require("pauseplus")
local littleDialogue = require("littleDialogue")

local gameFinished = false
local creditsFinished = false
local textLayouts = {}
local scrollY = 600
local alpha = 0

GameData.cutscene = false

local fonts = {
    [0] = textplus.loadFont("textplus/font/11.ini"),
    [1] = textplus.loadFont("bigFont.ini"),
}

function onEvent(eventName)
    if eventName == "pre boss music" then
        Audio.MusicChange(3, "6 - The Otherwordly Citadel/1-51 Final Boss Intro.mp3")
    end
    if eventName == "start boss" then
        Audio.MusicChange(3, "6 - The Otherwordly Citadel/1-52 Final Battle.mp3")
    end
    if eventName == "end" then
        Audio.MusicChange(3, "dungeon.ogg")
    end
    if eventName == "show exit 123" then
        GameData.cutscene = true
    end
    if eventName == "outro3" then
        gameFinished = true
        player.powerup = 2
    end
    if eventName == "message" then
        if SaveData.gameBeaten == false then
            littleDialogue.create{text = "You now have access to The Bros' Humble Abode! I wonder why Luigi hasn't left for vacation yet?|Return to Princess Toadstool's castle courtyard and head west to find out!"}
        end
    end
    if eventName == "render" then
        GameData.ach2:progressCondition(1, true)
        creditsFinished = true
    end
    if eventName == "exit" then
        SaveData.gameBeaten = true
        pauseplus.save()
        GameData.cutscene = false
        Level.exit()
    end
end

local exitState = nil

function onExitLevel()    
    if not exitState and player:mem(0x13C, FIELD_BOOL) then
        Level.load(Level.filename())
    end
end

function onLoadSection5()
    hudoverride.visible.score = false
    hudoverride.visible.coins = false
    hudoverride.visible.starcoins = false
    hudoverride.visible.itembox = false

    pauseplus.canPause = false
end

local text = {
    1,"TROUBLE FROM PURPLE PLANET",
    0,"",
    0,"",
    0,"",
    0,"",
    0,"",
    1,"CREDITS",
    0,"",
    0,"",
    1,"EPISODE CREATOR",
    0,"",
    0,"Chipss",
    0,"",
    1,"GRAPHICS",
    0,"",
    0,"Witchking666",
    0,"Squishy Rex",
    0,"PROX",
    0,"AirShip",
    0,"Gamma V",
    0,"AxelVoss",
    0,"Sednaiur",
    0,"PopYoshi",
    0,"Vito",
    0,"",
    1,"MUSIC",
    0,"",
    0,"Nintendo",
    0,"Newer Team",
    0,"Red&Green",
    0,"",
    1,"SCRIPTING",
    0,"",
    0,"Enjl",
    0,"MrDoubleA",
    0,"Sambo",
    0,"KBM-Quine",
    0,"",
    1,"SPECIAL THANKS",
    0,"",
    0,"1AmPlayer",
    0,"FyreNova",
    0,"Novarender",
    0,"Lusho"
}

local final = "THANKS FOR PLAYING!"
local layout2

function onStart()
    mem(0x00B2C5AC,FIELD_FLOAT,99)
    hudoverride.visible.lives = false

    for i = 1,#text,2 do
        local fontID = text[i]
        local font = fonts[fontID]
        local text = text[i+1]

        if text == "" then
            text = " "
        end

        local layout = textplus.layout(text,nil,{font = font,color = white,xscale = 2,yscale = 2})

        table.insert(textLayouts,layout)
    end

    layout2 = textplus.layout(final,nil,{font = fonts[1],color = white,xscale = 4,yscale = 4})
end

function onDraw()
    local layout = textLayouts[0]

    if gameFinished then
        local y = scrollY

        for _,layout in ipairs(textLayouts) do
            textplus.render{layout = layout,priority = -1,x = 200,y=y}

            y = y + layout.height + 4
        end

        hudoverride.visible.score = false
        hudoverride.visible.coins = false
        hudoverride.visible.starcoins = false
        hudoverride.visible.itembox = false
        hudoverride.visible.customCounter = false
    end

    if creditsFinished then
        textplus.render{layout = layout2, color = Color.white * alpha, priority = -1,x = 120,y=250}
    end
end

local noStop = true

function onTick()
    exitState = Level.winState() > 0

    if gameFinished then
        scrollY = scrollY - 0.47
    end

    if creditsFinished then
        if alpha < 1 and noStop then
            alpha = alpha + 0.01
        end
    end
end

function onLoadSection7()
    noStop = false
    alpha = 0
end