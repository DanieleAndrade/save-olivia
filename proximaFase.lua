local composer = require( "composer" )

local scene = composer.newScene()
composer.recycleOnSceneChange = false

local widget = require("widget")

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local mensagemText

larguraTela = display.contentWidth   -- Largura da tela
alturaTela = display.contentHeight  -- Altura da tela

-- create()
function scene:create( event )

	local sceneGroup = self.view

    local background = display.newImageRect( backGroup, 'img/background/back.png', 1250, 700)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local background2 = display.newImageRect( backGroup, 'img/background/back2.png', 1000, 350)
    background2.x = display.contentCenterX 
    background2.y = display.contentCenterY + 100

    local background3 = display.newImageRect( backGroup, 'img/background/back3.png', 1000, 300)
    background3.x = display.contentCenterX 
    background3.y = display.contentCenterY + 200


    local function moveBackground2()
        local limiteBack = math.random(background2.x - 6, background2.x + 6)
        transition.moveTo(background2, { x=limiteBack, y=background2.y, time=200 } )

    end    

    local moveBack2Timer = timer.performWithDelay(500, moveBackground2, 2000)

    local function moveBackground3()
        local limiteBack = math.random(background3.x - 6, background3.x + 6)
        transition.moveTo(background3, { x=limiteBack, y=background3.y, time=200 } )

    end    

    local moveBack3Timer = timer.performWithDelay(500, moveBackground3, 2000)

    centroX = display.contentCenterX
    centroY = display.contentCenterY

    mensagemText = display.newText( uiGroup, "Parabéns você passou\n" .."para fase 2! ", centroX, centroY - 20, native.systemFont, 30 )

    local function gotoFase2()
		composer.gotoScene( "scene2", { time=800, effect="crossFade" })
	end

    local button_play = widget.newButton
    {
        left = 139,
        top = 180,
        width = 200,
        height = 60,
        defaultFile = 'img/botoes/play.png',
        overFile = 'img/botoes/play.png',
    }

    button_play:addEventListener( "tap", gotoFase2 )


end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	end

end

-- -- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		display.remove(sceneGroup)
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
