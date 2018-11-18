local composer = require( "composer" )

local scene = composer.newScene()
composer.recycleOnSceneChange = true

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

    local gameOverdMusic = audio.loadSound('audio/game-over.mp3')
    audio.play( gameOverdMusic, { loops=1 } )

    local background = display.newImageRect( backGroup, 'img/background/back.png', 1250, 700)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local background2 = display.newImageRect( backGroup, 'img/background/back2.png', 1000, 350)
    background2.x = display.contentCenterX 
    background2.y = display.contentCenterY + 100

    local background3 = display.newImageRect( backGroup, 'img/background/back3.png', 1000, 300)
    background3.x = display.contentCenterX 
    background3.y = display.contentCenterY + 200

    local ancora = display.newImageRect( backGroup, 'img/background/ancora.png', 100, 300)
    ancora.x = display.contentCenterX - 190
    ancora.y = display.contentCenterY - 80

    centroX = display.contentCenterX
    centroY = display.contentCenterY

    local function moveAncora()
        local limiteAncora = math.random(ancora.y - 5, ancora.y + 5)
        transition.moveTo( ancora, { x=ancora.x, y=limiteAncora, time=500 } )
    end

    local moveAncoraTimer = timer.performWithDelay(500, moveAncora, 2000)

    local function moveBackground2()
        local limiteBack2 = math.random(background2.x - 6, background2.x + 6)
        transition.moveTo(background2, { x=limiteBack2, y=background2.y, time=200 } )

        local limiteBack3 = math.random(background3.x - 6, background3.x + 6)
        transition.moveTo(background3, { x=limiteBack3, y=background3.y, time=200 } )

    end    

    local moveBack2Timer = timer.performWithDelay(500, moveBackground2, 2000)


    mensagemText = display.newText( uiGroup, "Game Over! ", centroX + 40, centroY - 20, 'fonts/SF Atarian System Extended Bold.ttf', 50 )
    
    local function closeapp()
        if  system.getInfo("platformName")=="Android" then
            native.requestExit()
        else
            os.exit() 
       end
 
    end
 
    local function myButton( event )
        timer.performWithDelay(1000,closeapp)
    end 

    local button_voltar = widget.newButton
    {
        left = 180,
        top = 180,
        width = 200,
        height = 60,
        defaultFile = 'img/botoes/sair.png',
        overFile = 'img/botoes/sair.png',
        onPress = myButton
    }

    button_voltar:addEventListener( "tap", myButton )


end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        composer.removeScene('scene1')
	elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        --audio.play( gameOverdMusic, { channel=1, loops=-1 } )
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
		--display.remove(sceneGroup)
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
--scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
--scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
