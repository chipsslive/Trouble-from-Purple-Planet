local hudoverride = require("hudoverride")

function onEvent(eventName)
    if eventName == "Level - Start" then
        hudoverride.visible.itembox = false
        hudoverride.visible.starcoins = false
        GameData.cutscene = true
    end
    if eventName == "done" then
        hudoverride.visible.itembox = true
        hudoverride.visible.starcoins = true
        GameData.cutscene = false
    end
end

function onStart()
    player.powerup = 2
end