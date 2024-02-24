local littleDialogue = require("littleDialogue")

function onEvent(eventName)
    if eventName == "message" then
        if SaveData.starcoins < 18 then
            littleDialogue.create{text = "<portrait luigi>Woah there, bro! You need 18 Star Coins to enter. You only have " .. SaveData.starcoins .. " so far."} 
        else
            littleDialogue.create{text = "<portrait luigi>You've got enough Star Coins! Go right in, bro!"} 
            Level.load("!A-2 Disastrous Deeps.lvlx")
        end
    end
end