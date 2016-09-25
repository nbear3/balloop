math.randomseed( os.time() )



local spawnTimer
local spawnedObjects = {}

local image_table = {"img/balloon_red.png", "img/balloon_blue.png", "img/balloon_green.png"}

local function destroyBalloons(obj)
	display.remove(obj)
	obj = nil
end

local function balloonTapListener( event )
    destroyBalloons(event.target)
end

-- Spawn an item
local function spawnItem( bounds, physics)

	local item

	-- create sample item
	if(image_table ~= nil) then
		local image_index = math.random(1, table.maxn(image_table))
		item = display.newImageRect( image_table[image_index], 96, 96 )
	else
		item = display.newCircle( 0, 0, 20 )
		item:setFillColor( 1 )
	end

	local velocity = 100

	physics.addBody( item, { density=1.0, friction=0.3, bounce=0.3 } )
	item:setLinearVelocity(0, -velocity)
	
	-- position item randomly within set bounds
	item.x = math.random( bounds.xMin, bounds.xMax )
	item.y = math.random( bounds.yMin, bounds.yMax )

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
