local composer = require( "composer" )
local scene = composer.newScene()

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- create a grey rectangle as the backdrop
	local background = display.newImageRect( "credits.png", screenW, screenH )

	background.anchorX = 0
	background.anchorY = 0

    background.x, background.y = 0, 0
	
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
end

scene:addEventListener( "create", scene )

-----------------------------------------------------------------------------------------

return scene