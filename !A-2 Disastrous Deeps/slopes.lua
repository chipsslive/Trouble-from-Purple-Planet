--Instructions on how to use: https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=43

--Note: lots of this is remains of older development. I didn't clean this up or really optimize it yet, I just wanted to get it working ASAP.
--Because of this, this level and everything with it are in beta.
--Another thing to note is that only the player has collision so far.
--All this is going to be one seamless system that I have to write from the ground up.
-----------------

--Lines only need recalculated when they are affected (do on-the-spot calculations)

--Clipping is possible with short lines. This can be solved by making a separate no clip version where either extra checks are made to prevent this or the colliding object's movement is broken up into smaller, multiple checks.
--Consider being able to make 'anti-clip areas' in the editor where the lines in that area are protected with no clip, or even just doing it for certain individual lines.

--[[For horizontal lines:
nil = uninitialized or outside boundary
0 = inside line
-1 = above line
1 = below line
]]

local slopes = {p, s}
local real = {}
slopes.version = 1.42

local flid

slopes.main = function()
	--printList(slopes.s[length(slopes.s)])
	--Text.print(math.floor((slopes.p[1].x - player.x)*10000)/10000,0,0)
	--Text.print(math.floor(slopes.p[1].xV*10000)/10000,0,16)
	--[[Text.print(slopes.s[1][2],0,16)
	Text.print(slopes.s[1][3],0,32)
	Text.print(slopes.s[1][4],0,48)]]
	
	for _,p in ipairs(slopes.p) do
		p.area = {false, false, false, false}
		p.slope = nil
		--local collided --Try doing one of two:
		--Save the first LID and recollide with it after all others to see if it was a loop
		--Save the first LID and see if the next collision will put it back on that LID
		
		--Trying the first one.
		--It works, but you can hold space to clip further into a wedge
		
		local xV = p.xV
		local yV = p.yV
		
		flid = nil
		for k,s in ipairs(slopes.s) do
			doCollision(k, s, p)
		end
		
		if flid and doCollision(flid, slopes.s[flid], p) then
			Text.print(true,0,0)
			p.x = p.oldX
			p.y = p.oldY
			p.area[2] = true
			p.xV = 0
			
			if doCollision(flid, slopes.s[flid], p) then
				p.x = p.oldX - xV
				p.y = p.oldY - yV
			end
		end
	end
end

function doCollision(k, s, p)
	local collided
--Text.print(length(slopes.s),0,0)
	--cMem holds the watch state for every encountered line
	if s[9] == 1 then --Horizontal line collision----------------------------------------------------------------------------
		if p.x + p.width > real[k][1] and p.x < real[k][3] then --Note: ends must be in order (already taken care of)
			local expected = (p.x + p.width/2)*s[7] + s[8]
			local mem = p.cMem[k]
			local temp
			
			if p.y >= expected then --Issue to fix: player can clip through a sequence of lines if they move diagonally through a seam. Fix by doing line watching outside of boundaries but not acting on it unless inside the boundaries.
				temp = 1           --This also should make 'leeway' obsolete.
			elseif p.y + p.height <= expected then
				temp = -1
			else
				temp = 0 
			end
			
			if mem and mem ~= 0 then
				if temp ~= p.cMem[k] then --If the player is on a different side of the line than last frame
					--[[if collided then
						p.x = p.oldX
						p.y = p.oldY
						p.area[2] = true
						p.xV = 0
						break
					else
						collided = true
					end]]
					collided = true		
					
					if not flid then flid = k end					
					
					if p.cMem[k] == -1 then
						p.y = expected - p.height
						p.area[2] = true
						p.slope = s[7]
						
						local calc = atan(p.slope)
						local yMax = p.xV/cos(calc)*sin(calc)
						--Text.print(yMax,0,64) --If the player is already traveling x-wise faster than normal (because of prior movement), the slope will act as a launcher and you will go flying
						if p.yV > yMax then p.yV = yMax end --Need to limit xV somehow while still allowing for cannon/ramp lines
					else
						p.y = expected
						if p.yV < 0 then p.yV = 0 end
					end
				end
			else
				p.cMem[k] = temp
			end
		else
			p.cMem[k] = nil
		end
	else --Vertical line collision------------------------------------------------------------------------------------------
		if p.y + p.height > real[k][2] and p.y < real[k][4] then
			local expected = (p.y + p.height/2)*s[7] + s[8]
			local mem = p.cMem[k]
			local temp
			
			if p.x >= expected then
				temp = 1
			elseif p.x + p.width <= expected then
				temp = -1
			else
				temp = 0
			end
			
			if mem and mem ~= 0 then
				if temp ~= p.cMem[k] then
					--[[if collided then
						p.x = p.oldX
						p.y = p.oldY
						p.area[2] = true
						p.xV = 0
						break
					else
						collided = true
					end]]
					
					collided = true
					if not flid then flid = k end
				
					if p.cMem[k] == -1 then
						p.x = expected - p.width
						if p.xV > 0 then p.xV = 0 end
					else
						p.x = expected
						if p.xV < 0 then p.xV = 0 end
					end
				end
			else
				p.cMem[k] = temp
			end
		else
			p.cMem[k] = nil
		end
	end
	
	return collided
end

slopes.draw = function()
	for _,s in ipairs(slopes.s) do
		Graphics.glDraw{vertexCoords={s[1], s[2], s[3], s[4]}, color={.12,.55,1,1}, primitive=Graphics.GL_LINES, sceneCoords = true}
	end
end

function recalculate(lObj) --Line object
	local tempX = (lObj[1] - lObj[3])
	local tempY = (lObj[2] - lObj[4])
	
	if math.abs(tempY) > 2*math.abs(tempX) then --Line type (value '2' is temporary)
		lObj[9] = -1 --Vertical-type
		lObj[7] = tempX/tempY
		lObj[8] = lObj[1] - lObj[7]*lObj[2]
	else
		lObj[9] = 1  --Horizontal-type
		lObj[7] = tempY/tempX
		lObj[8] = lObj[2] - lObj[7]*lObj[1]
	end
	return lObj
end

function rearrange(lObj, index1, index2)
	local temp = lObj[index1]
	lObj[index1] = lObj[index2]
	lObj[index2] = temp
	return lObj
end

slopes.add = function(s, leeway) --Creates a new line and calculates it
	s = recalculate(s)           --Greater leeway helps prevent clipping between lines but can let you 'hang off' the edge of the line more.
                                 --For leeway, a good average is 5px.	
	table.insert(slopes.s, s)
	local i = length(slopes.s)
	
	local t = slopes.s[i]
	real[i] = {t[1], t[2], t[3], t[4]}
	t = real[i]
	
	if t[1] > t[3] then
		real[i] = rearrange(real[i], 1, 3)
		
		if s[9] == 1 then
			t = real[i]
			real[i][1] = t[1] - player.width/2 + leeway
			real[i][2] = s[7]*t[1] + s[8]
			real[i][3] = t[3] + player.width/2 - leeway
			real[i][4] = s[7]*t[3] + s[8]
		end
	elseif s[9] == 1 then
		t = real[i]
		real[i][1] = t[1] + player.width/2 - leeway
		real[i][2] = s[7]*t[1] + s[8]
		real[i][3] = t[3] - player.width/2 + leeway
		real[i][4] = s[7]*t[3] + s[8]
	end
	if t[2] > t[4] then
		real[i] = rearrange(real[i], 2, 4)
		
		if s[9] == -1 then
				t = real[i]
				real[i][2] = t[2] - player.height/2 + leeway
				real[i][1] = s[7]*t[2] + s[8]
				real[i][4] = t[4] + player.height/2 - leeway
				real[i][3] = s[7]*t[4] + s[8]
		end
	elseif s[9] == -1 then
		t = real[i]
		real[i][2] = t[2] + player.height/2 - leeway
		real[i][1] = s[7]*t[2] + s[8]
		real[i][4] = t[4] - player.height/2 + leeway
		real[i][3] = s[7]*t[4] + s[8]
	end
end

slopes.checkAll = function() --Loops over and recalculates all lines
	for k,s in ipairs(slopes.s) do
		slopes.s[k] = recalculate(s)
		
		local t = slopes.s[k]
		real[k] = {t[1], t[2], t[3], t[4]}
		
		if s[1] > s[3] then
			real[k] = rearrange(real[k], 1, 3)
		end
		if s[2] > s[4] then
			real[k] = rearrange(real[k], 2, 4)
		end
	end
end

function length(t)
	local length = 0
	
	for _,_ in pairs(t) do
		length = length + 1
	end
	
	return length
end

function printList(t)
	for k,v in ipairs(t) do
		Text.print(v, 0, k*16)
	end
end

return slopes