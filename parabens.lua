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
        local limiteBack = math.random(background2.x - 6, background2.x + 6)
        transition.moveTo(background2, { x=limiteBack, y=background2.y, time=200 } )

    end    

    local moveBack2Timer = timer.performWithDelay(500, moveBackground2, 2000)

    local function moveBackground3()
        local limiteBack = math.random(background3.x - 6, background3.x + 6)
        transition.moveTo(background3, { x=limiteBack, y=background3.y, time=200 } )

    end    

    local moveBack3Timer = timer.performWithDelay(500, moveBackground3, 2000)

    local balaoTable = {}

    local function createBalao()
        tamanhoBalao = math.random(30, 60)
        local newBalao = display.newImageRect( mainGroup, 'img/background/balao.png', tamanhoBalao, tamanhoBalao, 85 )
        table.insert( balaoTable, newBalao )
        physics.addBody( newBalao, "dynamic", { radius=40, bounce=0.8 } )
        newBalao.myName = "balao"

        local whereFrom = 2
        if ( whereFrom == 2 ) then
            newBalao.x = math.random( display.contentWidth )
            newBalao.y = H + 5
            newBalao:setLinearVelocity( math.random( -40,40 ), math.random( 40,40 ) )
        end
        transition.moveTo( newBalao, { x=newBalao.x, y=-100, time=1500 } )
    end

    local function gameLoop()
        createBalao()

        -- Remove bubbles which have drifted off screen
        for i = #balaoTable, 1, -1 do
            local thisbalao = balaoTable[i]

            if ( thisbalao.x < -10 or
                 thisbalao.x > display.contentWidth + 10 or
                 thisbalao.y < -50 or
                 thisbalao.y > display.contentHeight + 10 )
            then
                display.remove( thisbalao )
                table.remove( balaoTable, i )
            end

        end

    end

    gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )

    mensagemText = display.newText( uiGroup, "Parabens! A Olivia foi salva! ", centroX + 40, centroY - 20, 'fonts/SF Atarian System Extended Bold.ttf', 25 )
    
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
 

    local myButton = widget.newButton
    {
        left = 139,
        top = 180,
        width = 200,
        height = 60,
        defaultFile = 'img/botoes/sair.png',
        overFile = 'img/botoes/sair.png',
        onPress = myButton
    }

    myButton:addEventListener( "tap", myButton )


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
