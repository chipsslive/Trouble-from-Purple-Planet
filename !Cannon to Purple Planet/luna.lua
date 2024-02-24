local pipecannon = API.load("pipecannon")

pipecannon.exitspeed = {30}

pipecannon.angle[1] = 45

pipecannon.effect = 10

function onTick()
    if (player:mem(0x122, FIELD_WORD)) == 3 then
        Routine.setTimer(0.75, switchCannon, true);
        Routine.setTimer(1.2, exit, true);
    end
end

function switchCannon()
    Layer.get("first cannon"):hide(true)
    Layer.get("after cannon"):show(true)
end

function exit()
    Level.exit()
end