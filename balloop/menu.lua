-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "level1", "fade", 500 )
	
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for credBtn
local function onCredBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "credits", "fade", 500 )
	
	return true	-- indicates successful touch
end

local screenW, screenH = display.contentWidth, display.contentHeight
local halfW, halfH = screenW * 0.5, screenH * 0.5

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "balloop_title.png", 360, 480 )
	background.anchorX = .5
	background.anchorY = .5
	background.x, background.y = display.contentCenterX, display.contentCenterY
	
	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{

		defaultFile="balloon_lit.png",
		overFile="img/balloon_red.png",
		width=96, height=96,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125	

	-- create a button to show credits
	credBtn = widget.newButton{
		defaultFile="img/credits_button.png",
		width=60, height=15,
		onRelease = onCredBtnRelease
	}
	credBtn.x = display.contentWidth - 20
	credBtn.y = display.contentHeight - 15
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( credBtn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene