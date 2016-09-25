local composer = require( "composer" )
local scene = composer.newScene()

local widget = require "widget"

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-- 'onRelease' event listener for backBtn
local function onBackBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "menu", "fade", 500 )
	
	return true	-- indicates successful touch
end

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- create a grey rectangle as the backdrop
	local background = display.newImageRect( "credits.png", 360, 456 )

	background.anchorX = 0
	background.anchorY = 0

    background.x, background.y = 0, 0
	
	-- create a button to show credits
	backBtn = widget.newButton{
		defaultFile="img/back_button.png",
		width=30, height=15,
		onRelease = onBackBtnRelease
	}
	backBtn.x = display.contentWidth - 20
	backBtn.y = display.contentHeight - 15
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( backBtn )
end

scene:addEventListener( "create", scene )

-----------------------------------------------------------------------------------------

return scene