math.randomseed( os.time() )

local spawnTimer
local spawnedObjects = {}

-- Spawn an item
local function spawnItem( bounds, physics, image )

	local item

	-- create sample item
	if(image ~= nil) then
		item = display.newImageRect( image, 90, 90 )
	else
		item = display.newCircle( 0, 0, 20 )
		item:setFillColor( 1 )
	end

	physics.addBody( item, { density=1.0, friction=0.3, bounce=0.3 } )
	item:setLinearVelocity(0, -100)
	
	-- position item randomly within set bounds
	item.x = math.random( bounds.xMin, bounds.xMax )
	item.y = math.random( bounds.yMin, bounds.yMax )

	-- add item to spawnedObjects table for tracking purposes
	spawnedObjects[#spawnedObjects+1] = item
end


-- Spawn controller
local function spawnController( action, params, physics, image )

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
				if(image ~= nil) then
					spawnItem( spawnBounds, physics, image )
				else
					spawnItem( spawnBounds, physics )
				end
			end
		end

		-- start repeating timer to spawn items
		if(image ~= nil) then
			spawnTimer = timer.performWithDelay( spawnTime,
				function() spawnItem( spawnBounds, physics, image ); end, -1)
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
return public
