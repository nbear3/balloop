math.randomseed( os.time() )



local spawnTimer
local spawnedObjects = {}
local plus_or_minus = 0
local previousColor = 0
local newColor = 0

local image_table = {"img/balloon_red_lit.png", "img/balloon_blue_lit.png", "img/balloon_green_lit.png", "img/balloon_purple_lit.png"}
local sound_table = {blop = audio.loadSound("blop.wav")}


local function destroyBalloons(obj)
	display.remove(obj)
	obj = nil
end

local function balloonTapListener( event )
    destroyBalloons(event.target)
    mySource = audio.play(sound_table.blop)
end

local function calculateColorIndex(color_table)
	while(newColor == previousColor) do
		newColor = math.random(1, #color_table)
	end
	previousColor = newColor
	return newColor
end

local function calculaterandomX(bounds)
	-- position item randomly within set bounds
	local randomDelta = math.random(25, 100)
	if(#spawnedObjects > 0) then 
		if(plus_or_minus == 0 and spawnedObjects[#spawnedObjects].x > 75) then
			--make the next balloon spawn at least 50 pixels to the left of the previous
			while(spawnedObjects[#spawnedObjects].x - randomDelta < bounds.xMin) do
				randomDelta = randomDelta / 2
			end
			x = math.random( bounds.xMin, spawnedObjects[#spawnedObjects].x - randomDelta )
		else
			--make the next balloon spawn at least 50 pixels to the right of the previous
			while(spawnedObjects[#spawnedObjects].x + randomDelta > bounds.xMax) do
				randomDelta = randomDelta / 2
			end
			x = math.random( spawnedObjects[#spawnedObjects].x +  randomDelta, bounds.xMax )
		end
	else
		x = math.random( bounds.xMin, bounds.xMax )
	end

	if(x > display.contentWidth - 75) then
		plus_or_minus = 0
	elseif(x < 75) then
		plus_or_minus = 1
	else
		plus_or_minus = math.random(0, 1)
	end

	return x
end

local function calculateRandomY(bounds) 
	y = math.random( bounds.yMin, bounds.yMax )
	return y
end

-- Spawn an item
local function spawnItem( bounds, physics)

	local item

	-- create sample item
	local index = calculateColorIndex(image_table)
	item = display.newImageRect( image_table[index], 96, 96 )

	local velocity = 150

	physics.addBody( item, { density=1.0, friction=0.3, bounce=0.3 } )
	item:setLinearVelocity(0, -velocity)
	
	-- position item randomly within set bounds
	item.x = calculaterandomX(bounds)
	item.y = calculateRandomY(bounds)

	-- add item to spawnedObjects table for tracking purposes
	spawnedObjects[#spawnedObjects+1] = item
	destroyTime = (item.y + 100) / velocity
	timer.performWithDelay(destroyTime * 1000, function() destroyBalloons(item); end)

	item:addEventListener( "tap", balloonTapListener )
end


-- Spawn controller
local function spawnController( action, params, physics)
	-- cancel timer on "start" or "stop", if it exists
	if ( spawnTimer and ( action == "start" or action == "stop" ) ) then
		timer.cancel( spawnTimer )
	end

	-- Start spawning
	if ( action == "start" ) then

		-- gather/set spawning bounds
		local spawnBounds = {}
		spawnBounds.xMin = params.xMin or 0
		spawnBounds.xMax = params.xMax or display.contentWidth
		spawnBounds.yMin = params.yMin or 0
		spawnBounds.yMax = params.yMax or display.contentHeight
		-- gather/set other spawning params
		local spawnTime = params.spawnTime or 1000
		local spawnOnTimer = params.spawnOnTimer or 50
		local spawnInitial = params.spawnInitial or 0

		-- if spawnInitial > 0, spawn n item(s) instantly
		if ( spawnInitial > 0 ) then
			for n = 1,spawnInitial do
				if(image_table ~= nil) then
					spawnItem( spawnBounds, physics)
				else
					spawnItem( spawnBounds, physics )
				end
			end
		end

		-- start repeating timer to spawn items
		if(image_table ~= nil) then
			spawnTimer = timer.performWithDelay( spawnTime,
				function() spawnItem( spawnBounds, physics); end, -1)
		else 
			spawnTimer = timer.performWithDelay( spawnTime,
				function() spawnItem( spawnBounds, physics ); end, -1)
		end
	
	-- Pause spawning
	elseif ( action == "pause" ) then
		timer.pause( spawnTimer )

	-- Resume spawning
	elseif ( action == "resume" ) then
		timer.resume( spawnTimer )

	end
end


--spawnController( "start", spawnParams )
--spawnController( "pause" )
--spawnController( "resume" )
--spawnController( "stop" )
local public = {}
public.spawnController = spawnController
public.spawnedObjects = spawnedObjects
return public
