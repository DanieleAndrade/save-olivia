local composer = require( "composer" )

local scene = composer.newScene()
composer.recycleOnSceneChange = true


-- create()
function scene:create( event )

	local sceneGroup = self.view

	local centroX = display.contentCenterX
	local centroY = display.contentCenterY

	local background = display.newImageRect( sceneGroup, "img/gameover.png", larguraTela, alturaTela+450 )
	background.x = centroX
    background.y = centroY
    
    local function gotoMenu()
		composer.gotoScene( "menu" )
	end

end

-- -- show()
-- function scene:show( event )

-- 	local sceneGroup = self.view
-- 	local phase = event.phase

-- 	if ( phase == "will" ) then
-- 		-- Code here runs when the scene is still off screen (but is about to come on screen)
-- 	elseif ( phase == "did" ) then
-- 		-- Code here runs when the scene is entirely on screen
-- 	end

-- end

-- -- hide()
-- function scene:hide( event )

-- 	local sceneGroup = self.view
-- 	local phase = event.phase

-- 	if ( phase == "will" ) then
-- 		-- Code here runs when the scene is on screen (but is about to go off screen)
-- 	elseif ( phase == "did" ) then
-- 		-- Code here runs immediately after the scene goes entirely off screen
-- 		display.remove(sceneGroup)
-- 	end
-- end


-- -- destroy()
-- function scene:destroy( event )

-- 	local sceneGroup = self.view
-- 	-- Code here runs prior to the removal of scene's view
-- end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
--scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
--scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene