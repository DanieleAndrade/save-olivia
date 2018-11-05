local composer = require("composer")

local scene = composer.newScene()

local widget = require("widget")

local physics = require("physics")
physics.start()
physics.setGravity( 0, 0 )

display.setStatusBar( display.HiddenStatusBar )

W = display.contentWidth   -- Largura da tela
H = display.contentHeight  -- Altura da tela

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

function scene:create( event )
     
    local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

		local bolhasTable = {}
		local backgroundmusic = audio.loadSound('audio/Winds Of Stories.mp3')
		audio.play(backgroundmusic, { loops=1 })
        
        local background = display.newImageRect( backGroup, 'img/background/back.png', 1250, 700)
        background.x = display.contentCenterX
		background.y = display.contentCenterY
		
		local background2 = display.newImageRect( backGroup, 'img/background/back2.png', 1000, 250)
        background2.x = display.contentCenterX 
		background2.y = display.contentCenterY + 100

		local agua_viva = display.newImageRect( backGroup, 'img/background/agua-viva.png', 50, 50)
		agua_viva.x = display.contentCenterX - 190
		agua_viva.y = display.contentCenterY + 80

		local function moveAguaViva()
			local limiteAguaViva = math.random(agua_viva.y - 5, agua_viva.y + 5)

			if(limiteAguaViva > H) then
			 limiteAguaViva = H - 5

			elseif(limiteAguaViva < 0) then
			 limiteAguaViva = 5
			end 

			transition.moveTo( agua_viva, { x=agua_viva.x, y=limiteAguaViva, time=300 } )
		end

		local moveAguaVivaTimer = timer.performWithDelay(500, moveAguaViva, 2000)

		local function createBolha()
			tamanhoBolha = math.random(10, 51)
			local newBolha = display.newImageRect( mainGroup, 'img/background/bolha.png', tamanhoBolha, tamanhoBolha, 85 )
			table.insert( bolhasTable, newBolha )
			physics.addBody( newBolha, "dynamic", { radius=40, bounce=0.8 } )
			newBolha.myName = "bolha"

			local whereFrom = 2
			if ( whereFrom == 2 ) then
				newBolha.x = math.random( display.contentWidth )
        		newBolha.y = H + 5
        		newBolha:setLinearVelocity( math.random( -40,40 ), math.random( 40,40 ) )
			end
			transition.moveTo( newBolha, { x=newBolha.x, y=-100, time=1500 } )
		end

		local function gameLoop()
			createBolha()

			-- Remove bubbles which have drifted off screen
			for i = #bolhasTable, 1, -1 do
				local thisBolha = bolhasTable[i]
 
				if ( thisBolha.x < -10 or
					 thisBolha.x > display.contentWidth + 10 or
					 thisBolha.y < -50 or
					 thisBolha.y > display.contentHeight + 10 )
				then
					display.remove( thisBolha )
					table.remove( bolhasTable, i )
				end
 
			end
 
		end

		gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )

		local function gotoPhaseOne()
			audio.pause(backgroundmusic)
			--timer.cancel(moveAguaVivaTimer)
			--timer.cancel(gameLoopTimer)
		    composer.gotoScene( "scene1", { time=800, effect="crossFade" } )
		   --composer.gotoScene( "gameOver", { time=800, effect="crossFade" } )
        end

		local logo = display.newImageRect( mainGroup, 'img/logo.png', 200, 200)
        logo.x = display.contentCenterX 
        logo.y = display.contentCenterY - 60

        local button_play = widget.newButton
        {
            left = 139,
            top = 180,
            width = 200,
            height = 60,
            defaultFile = 'img/botoes/play.png',
            overFile = 'img/botoes/play.png',
        }

		button_play:addEventListener( "tap", gotoPhaseOne )

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
     
     
-- hide()
function scene:hide( event )
     
    local sceneGroup = self.view
    local phase = event.phase
     
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
     
    elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		audio.pause(backgroundmusic)
     
	end
end
     
     
-- destroy()
function scene:destroy( event )
     
    local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	audio.pause(backgroundmusic)
     
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