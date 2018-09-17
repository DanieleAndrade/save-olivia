local composer = require( "composer" )

local scene = composer.newScene()


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )


	local background = display.newImageRect("img/menu-bg.png", 1355, 755)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local function gotoGame()
		composer.gotoScene( "game" )
	end

	local playButton = display.newImageRect("img/play.png", 100, 70 )
	      playButton.x = display.contentCenterX 
	      playButton.y = display.contentCenterY

	playButton:addEventListener( "tap", gotoGame )
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
--scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
--scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene