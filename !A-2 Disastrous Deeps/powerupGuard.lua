---------------------------------------------------------------------------
---------> POWER-UP GUARD by Dracyoshi
---------------------------------------------------------------------------
---| A simple script that prevents the player from being reverted to
---| Small Mario or Small Luigi after taking damage with a Stage 3 Power-Up.
---------> Version 1.0.3 [7/27/2019]
---------------------------------------------------------------------------
local powerupGuard = {}

local playerPowerup = {}
local oldPowerup = {}
local takingDamage = {}
local playerYcoord = {}
local cameraYcoord = {}
local blinkingPowerupAnimation = {}
local targetPlayer = {}

function powerupGuard.onInitAPI()
    registerEvent(powerupGuard, "onDraw", "guard")
    registerEvent(powerupGuard, "onStart", "beginTrackingPowerup")
	registerEvent(powerupGuard, "onCameraUpdate", "cameraLock")
end

function powerupGuard.beginTrackingPowerup()
	targetPlayer = {Player.get()}
	for k in pairs(targetPlayer[1]) do
		local p = Player(k)
		playerPowerup[k] = p.powerup
		takingDamage[k] = false
		blinkingPowerupAnimation[k] = 0
	end
end

function powerupGuard.guard()
	targetPlayer = {Player.get()}
	for k in pairs(targetPlayer[1]) do
		local p = Player(k)
		local pCamera = Camera.get()[k]
		if p.character == CHARACTER_MARIO or p.character == CHARACTER_LUIGI then
			if p:mem(0x122, FIELD_WORD) == 2 then --Checks if the player is in the state of taking damage and reverting to Small Mario.
				if takingDamage[k] == false then --Detects that damage is being taken and sets the prerequisites for later code.
					if playerPowerup[k] ~= PLAYER_BIG and playerPowerup[k] ~= PLAYER_SMALL then
						local pSettings = PlayerSettings.get(p.character, p.powerup)
						local a = pSettings.hitboxHeight
						local b = pSettings.hitboxDuckHeight
						oldPowerup[k] = playerPowerup[k]
						takingDamage[k] = true
						if p:mem(0x12E, FIELD_BOOL) == true then
							p.y = p.y - (a - b)
						end
						playerYcoord[k] = p.y --Locks the player's Y position so that they aren't sent flying across the map because of the hitbox differences between Small Mario and Super Mario.
						cameraYcoord[k] = pCamera.y --Locks the camera position to eliminate jerkiness.
					end
				end
				if takingDamage[k] == true then --Controls the animation of switching between states.
					if blinkingPowerupAnimation[k] <= 4 then
						p.powerup = PLAYER_BIG
						p.y = playerYcoord[k]
						blinkingPowerupAnimation[k] = blinkingPowerupAnimation[k] + 1
					elseif blinkingPowerupAnimation[k] > 4 then
						if blinkingPowerupAnimation[k] == 9 then
							p.powerup = PLAYER_BIG
							p.y = playerYcoord[k]
							blinkingPowerupAnimation[k] = 0
						else
							p.powerup = oldPowerup[k]
							p.y = playerYcoord[k]
							blinkingPowerupAnimation[k] = blinkingPowerupAnimation[k] + 1
						end
					end
				end
			end
			if takingDamage[k] == true then --Checks if the script is in the Taking Damage state.
				if p:mem(0x122, FIELD_WORD) ~= 2 then --Sets the player's powerup to Super Mario if the player is no longer transitioning to Small Mario.
					p.powerup = PLAYER_BIG
					takingDamage[k] = false
					blinkingPowerupAnimation[k] = 0
				end
			end
		end
		playerPowerup[k] = p.powerup --Constantly updates and saves the player's current powerup to a variable. This is used to check if the player's powerup has changed, essential for the above code.
	end
end

function powerupGuard.cameraLock() --Takes the coordinates of the camera obtained for the cameraYcoord variable and uses them to lock the camera.
	for k in pairs(targetPlayer) do
		local p = Player(k)
		local pCamera = Camera.get()[k]
		if takingDamage[k] == true then
			pCamera.y = cameraYcoord[k]
		end
	end
end

return powerupGuard