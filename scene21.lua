
local composer = require("composer")

local widget = require("widget")

local physics = require("physics")
physics.start()
physics.setGravity( 0, 0 )

local scene = composer.newScene()

W = display.contentWidth   -- Largura da tela
H = display.contentHeight  -- Altura da tela

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local vidas = 1
local pontos = 0
local died = false
local tartarugaFlapDelta = 0
local tartaruga
local sacola
local estrela2
local lata
local sacolasTable = {}
local comida2Table = {}
local estrela2Table = {}
local latasTable = {}
local criaComida2Timer
local criaSacolaTimer
local criaLataTimer
local criaEstrela2Timer
local vidasText
local pontuacaoText
local scrollSpeed = 1
local proximaFase = 0
local mensagemText
local gameAtivo = true

function scene:create( event )
    backgroundmusic2 = audio.loadSound('audio/backgroundmusic.mp3')
    audio.play(backgroundmusic2, { loops= -1 })     
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    centroX = display.contentCenterX
    centroY = display.contentCenterY

    pontuacaoText = display.newText( uiGroup, "Pontuacao: " .. pontos, 240, 15, native.systemFont, 20 )
    mensagemText = display.newText( uiGroup, "Bem vindo a fase 2! ", centroX, centroY - 20, native.systemFont, 30 )

    local function esconderMensagem()
        display.remove(mensagemText)
    end  

    local mostraMsgTimer = timer.performWithDelay(1000, esconderMensagem, 1)

    local function updatePontos()
        pontuacaoText.text = "Pontuacao: " .. pontos
    end

    local background = display.newImageRect( backGroup, 'img/background/back.png', 1250, 700)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    
    local background2 = display.newImageRect( backGroup, 'img/background/back2.png', 1000, 250)
    background2.x = W/2
    background2.y = display.contentCenterY + 100

    local background3 = display.newImageRect( backGroup, 'img/background/back2.png', 1000, 250)
    background3.x = background2.x + W
    background3.y = display.contentCenterY + 100

    local background4 = display.newImageRect( backGroup, 'img/background/back2.png', 1000, 250)
    background4.x = background3.x + W
    background4.y = display.contentCenterY + 100

    local function moveBackground(event)

        background2.x = background2.x - scrollSpeed
        background3.x = background3.x - scrollSpeed
        background4.x = background4.x - scrollSpeed

        if(background2.x + background2.contentWidth) < W/3  then
            background2.x = background4.x + background4.width
         end  
        if(background3.x + background3.contentWidth) <  W/3  then
            background3.x = background2.x + background2.width
        end
        if(background4.x + background4.contentWidth) <  W/3 then
            background4.x = background3.x + background3.width
        end
    end


    tartaruga = display.newImageRect(mainGroup, "img/personagens/tartaruga.png", 60, 30)
    tartaruga.x = 10
    tartaruga.y = 100
    physics.addBody(tartaruga, "dynamic")
    tartaruga.isFixedRotation = true
    tartaruga.isSensor = true
    tartaruga.myName = "tartaruga"
    tartaruga.gravityScale = 0

    chamarFuncao = true

    local function flapTartaruga (event)
        if (event.phase == "began") then
            -- if(chamarFuncao) then
            --     audio.play(backgroundmusic2, { loops= -1 })
            --     chamarFuncao = false
            -- end 
            tartarugaFlapDelta = 15
        end
    end

    local function onUpdate (event)

        local posicaoTartaruga = tartaruga.y + tartaruga.contentHeight

        if(posicaoTartaruga > 0 and posicaoTartaruga < H + 100) then
            if (tartarugaFlapDelta > 0) then
                tartaruga.y = tartaruga.y - tartarugaFlapDelta
                tartarugaFlapDelta = tartarugaFlapDelta - 0.6
            end
            tartaruga.y = tartaruga.y + 7
        elseif(posicaoTartaruga < 0) then
            tartaruga.y = tartaruga.contentHeight
        elseif(posicaoTartaruga > H) then
            tartaruga.y = centroY
        end    
      
    end

    local function createsacola()

        if(#sacolasTable < 4) then
           
            local newsacola = display.newImageRect(mainGroup, 'img/personagens/sacola.png', 50, 50 )
            table.insert( sacolasTable, newsacola )
            physics.addBody( newsacola, {isSensor = true})
            newsacola.bodyType = "static"
            newsacola.myName = "sacola"
        
            local whereFrom = 3
            if ( whereFrom == 3 ) then
                -- From the right
                newsacola.x = W + 10
                newsacola.y = math.random(H)
                newsacola:setLinearVelocity( math.random( -40,40 ), math.random( 1, 50 ) )
            end

        end
    end

    function movesacola( )
        print('movesacola')
        for i = #sacolasTable, 1, -1 do
            local sacola = sacolasTable[i]
    
            if(sacola.x + sacola.contentWidth < -100) then
                sacola.x = W + 10
                sacola.y = math.random(math.random(H))
            else
                transition.moveTo( sacola, { x=sacola.x - 10, y=sacola.y, time=500 } )
            end
        end
    end

    local function createlata()

        if(#latasTable < 3) then
           
            local newlata = display.newImageRect(mainGroup, 'img/personagens/lata.png', 50, 50 )
            table.insert( latasTable, newlata )
            physics.addBody( newlata, {isSensor = true})
            newlata.bodyType = "static"
            newlata.myName = "lata"
        
            local whereFrom = 3
            if ( whereFrom == 3 ) then
                -- From the right
                newlata.x = W + 10
                newlata.y = math.random(H) + 5
                newlata:setLinearVelocity( math.random( -50,-4 ), math.random( 1, 20 ) )
            end

        end
    end

    function movelata( )
        for i = #latasTable, 1, -1 do
            local lata = latasTable[i]
    
            if(lata.x + lata.contentWidth < -100) then
                lata.x = W + 10
                lata.y = math.random(math.random(H))
            else
                transition.moveTo( lata, { x=lata.x - 10, y=lata.y, time=500 } )
            end
        end
    end

    local function createcomida2()
        print("entrou")

        if(#comida2Table < 4) then
            local newcomida2 = display.newImageRect(mainGroup, 'img/personagens/comida.png', 30, 30 )
            table.insert( comida2Table, newcomida2 )
            physics.addBody( newcomida2, {isSensor = true})
            newcomida2.bodyType = "static"
            newcomida2.myName = "comida2"
        
            local whereFrom = 3
            if (whereFrom == 3 ) then
                -- From the right
                newcomida2.x = W + 10
                newcomida2.y = math.random(H)
                newcomida2:setLinearVelocity( math.random( -50,-4 ), math.random( 1,50 ) )
            end
        end
    end

    function movecomida2( )
        for i = #comida2Table, 1, -1 do
            local comida2 = comida2Table[i]
    
            if(comida2.x + comida2.contentWidth < -100) then
                comida2.x = W + 10
                comida2.y = math.random(math.random(H))
            else

                local limitecomida2 = math.random(comida2.y - 5, comida2.y + 5)
                if(limitecomida2 > H) then
                    limitecomida2 = H - 5
    
                elseif(limitecomida2 < 0) then
                    limitecomida2 = 5
                end 
                transition.moveTo( comida2, { x=comida2.x - 10, y=limitecomida2, time=500 } )
            end
        end
    end

    local function createestrela2()

        if(#estrela2Table < 1) then
           
            local newestrela2 = display.newImageRect(mainGroup,'img/personagens/estrela.png', 40, 40 )
            table.insert( estrela2Table, newestrela2 )
            physics.addBody( newestrela2, {isSensor = true})
            newestrela2.bodyType = "static"
            newestrela2.myName = "estrela2"
        
            local whereFrom = math.random( 3 )

            
            if ( whereFrom == 1 or whereFrom == 2 or whereFrom == 3 ) then
                -- From the right
                newestrela2.x = W + 10
                newestrela2.y = math.random(H)
                newestrela2:setLinearVelocity( math.random( -200,-4 ), math.random( 20,60 ) )
            end
        
            newestrela2:applyTorque( math.random( -6,6 ) )
        end
    end

    function moveestrela2( )
        for i = #estrela2Table, 1, -1 do
            local estrela2 = estrela2Table[i]
    
            if(estrela2.x + estrela2.contentWidth < -100) then
                estrela2.x = W + 10
                estrela2.y = math.random(math.random(H))
            else
               -- estrela2.x = estrela2.x - 10
               local limiteestrela2 = math.random(estrela2.y - 30, estrela2.y + 30)

               if(limiteestrela2 > H) then
                limiteestrela2 = H -5

               elseif(limiteestrela2 < 0) then
                limiteestrela2 = 5
               end 
                transition.moveTo( estrela2, { x=estrela2.x - 15, y=limiteestrela2, time=100 } )
            end
        end
    end

    -- function proximaFase( )
    --     if(pontos >= 10 and vidas >= 0) then
    --         composer.gotoScene("scene2", { time=800, effect="crossFade" })
    --     end    
    -- end

    --contadorDeTempoTimer = timer.performWithDelay( 500, proximaFase, 1)
    criaComida2Timer = timer.performWithDelay(1, createcomida2, -1)
    criaEstrela2Timer = timer.performWithDelay(1000, createestrela2, -1)
    criaSacolaTimer = timer.performWithDelay(1000, createsacola, -1)
    criaLataTimer = timer.performWithDelay(1000, createlata, -1)

    print('timers')
    moveSacolaTimer = timer.performWithDelay(500, movesacola, -1)
    moveLataTimer = timer.performWithDelay(500, movelata, -1)
    moveComida2Timer = timer.performWithDelay(350, movecomida2, -1)
    moveEstrela2Timer = timer.performWithDelay(200, moveestrela2, -1)

    local function onGlobalCollision( event )

        local obj1 = event.object1
        local obj2 = event.object2
    
        if(obj2.myName == "sacola" and obj1.myName == "tartaruga" )then
            display.remove(obj2)
            vidas = vidas - 1
    
            for i = #sacolasTable, 1, -1 do
                if(sacolasTable[i] == obj2) then
                    table.remove(sacolasTable, i)
                    break
                end
            end
    
        elseif(obj1.myName == "sacola" and obj2.myName == "tartaruga") then 
            display.remove(obj1)
            vidas = vidas - 1
    
            for i = #sacolasTable, 1, -1 do
                if(sacolasTable[i] == obj1) then
                    table.remove(sacolasTable, i)
                    break
                end
            end  
        
        elseif(obj2.myName == "lata" and obj1.myName == "tartaruga" )then
            display.remove(obj2)
            vidas = vidas - 1
        
            for i = #latasTable, 1, -1 do
                if(latasTable[i] == obj2) then
                    table.remove(latasTable, i)
                    break
                end
            end
        
        elseif(obj1.myName == "lata" and obj2.myName == "tartaruga") then 
            display.remove(obj1)
            vidas = vidas - 1
        
            for i = #latasTable, 1, -1 do
                if(latasTable[i] == obj1) then
                    table.remove(latasTable, i)
                    break
                end
            end      
    
        elseif(obj1.myName == "estrela2" and obj2.myName == "tartaruga") then
            display.remove(obj1)
            pontos = pontos + 200 
            
            for i = #estrela2Table, 1, -1 do
                if(estrela2Table[i] == obj1) then
                    table.remove(estrela2Table, i)
                    break
                end
            end 
    
        elseif(obj2.myName == "estrela2" and obj1.myName == "tartaruga") then
            display.remove(obj2)
            pontos = pontos + 200 
            
            for i = #estrela2Table, 1, -1 do
                if(estrela2Table[i] == obj2) then
                    table.remove(estrela2Table, i)
                    break
                end
            end     
    
        elseif(obj1.myName == "comida2" and obj2.myName == "tartaruga") then
            display.remove(obj1)
            pontos = pontos + 10
            if(vidas < 3) then
                vidas = vidas + 1 
            else
                vidas = vidas + 0
            end    
    
            for i = #comida2Table, 1, -1 do
                if(comida2Table[i] == obj1) then
                    table.remove(comida2Table, i)
                    break
                end
            end
        elseif(obj2.myName == "comida2" and obj1.myName == "tartaruga") then
            display.remove(obj2)
            pontos = pontos + 10
            if(vidas < 3) then
                vidas = vidas + 1 
            else
                vidas = vidas + 0
            end  
    
            for i = #comida2Table, 1, -1 do
                if(comida2Table[i] == obj2) then
                    table.remove(comida2Table, i)
                    break
                end
            end
    
        end  
    end

    local function gameOver () 
        if(vidas < 0) then
           --timer.cancel(contadorDeTempoTimer)
            
            audio.stop()
            --composer.removeScene( "scene2" )
            composer.gotoScene("gameOver", { time=800, effect="crossFade" })
        end
    end   


    -----------------------------------------------------------------------
    --                      Barra de Vida                                --
    -----------------------------------------------------------------------

    local larguraVida = 70
    local alturaVida = 35

    local posicaoX = 7
    local posicaoY = 22

    barraDeVida = display.newImageRect(uiGroup, 'img/vida/vida3.png', larguraVida, alturaVida)
	barraDeVida.x = posicaoX
    barraDeVida.y = posicaoY
    
    vida1 = display.newImageRect(uiGroup, "img/vida/vida1.png", larguraVida, alturaVida)
	vida1.x = posicaoX
    vida1.y = posicaoY
    vida1.alpha = 0
    
    vida2 = display.newImageRect(uiGroup, "img/vida/vida2.png", larguraVida, alturaVida)
	vida2.x = posicaoX
    vida2.y = posicaoY
    vida2.alpha = 0
    
    vida0 = display.newImageRect(uiGroup, "img/vida/vida.png", larguraVida, alturaVida)
	vida0.x = posicaoX
    vida0.y = posicaoY
    vida0.alpha = 0

    local function vida( event )
        barraDeVida.alpha = 0
        vida2.alpha = 0
        vida1.alpha = 0    
        vida0.alpha = 0
        
        if(vidas == 2) then
            vida2.alpha = 1 

        elseif(vidas == 1) then
            
            vida1.alpha = 1

        elseif(vidas == 0) then
            
            vida0.alpha = 1
        elseif(vidas == 3) then
            
            barraDeVida.alpha = 1 
        -- else
        --     vida.alpha = 1
        end
    end

    local function resumeGame()

        Runtime:addEventListener("enterFrame", gameOver)
        Runtime:addEventListener("enterFrame", moveBackground)
        Runtime:addEventListener("enterFrame", onUpdate)
        Runtime:addEventListener("touch", flapTartaruga)
        Runtime:addEventListener("collision", onGlobalCollision)
        Runtime:addEventListener("enterFrame", updatePontos)
        Runtime:addEventListener("enterFrame", vida)
       -- Runtime:addEventListener("enterFrame", proximaFase)
        timer.resume(criaComida2Timer)
        timer.resume(criaEstrela2Timer)
        timer.resume(criaSacolaTimer)
        timer.resume(criaLataTimer)
        timer.resume(moveComida2Timer)
        timer.resume(moveSacolaTimer)
        timer.resume(moveEstrela2Timer)
        timer.resume(moveLataTimer)
        audio.play(backgroundmusic2)
        physics.start()  
        
    end    

    local resumeButtonPress = function( event )
        button_voltar.alpha = 0
        resumeGame()
    end

    button_voltar = widget.newButton
    {
        left = 139,
        top = 140,
        width = 200,
        height = 60,
        defaultFile = 'img/botoes/voltar.png',
        overFile = 'img/botoes/voltar.png',
        onRelease = resumeButtonPress
    }

    button_voltar.alpha = 0

    local function pauseGame()
        gameAtivo = false
        Runtime:removeEventListener("enterFrame", gameOver)
        Runtime:removeEventListener("enterFrame", moveBackground)
        Runtime:removeEventListener("enterFrame", onUpdate)
        Runtime:removeEventListener("touch", flapTartaruga)
        Runtime:removeEventListener("collision", onGlobalCollision)
        Runtime:removeEventListener("enterFrame", updatePontos)
        Runtime:removeEventListener("enterFrame", vida)
        --Runtime:removeEventListener("enterFrame", proximaFase)
        timer.pause(criaComida2Timer)
        timer.pause(criaEstrela2Timer)
        timer.pause(criaSacolaTimer)
        timer.pause(criaLataTimer)
        timer.pause(moveComida2Timer)
        timer.pause(moveSacolaTimer)
        timer.pause(moveEstrela2Timer)
        timer.pause(moveLataTimer)
        audio.pause(backgroundmusic2)
        physics.pause() 
            
    end    

    local pauseButtonPress = function( event )
        pauseGame()
        button_voltar.alpha = 1
    end

    local button_pause = widget.newButton
    {
        left = 480,
        top = 10,
        width = 20,
        height = 20,
        defaultFile = 'img/botoes/pause.png',
        overFile = 'img/botoes/pause.png',
        onRelease = pauseButtonPress
    }



    Runtime:addEventListener("enterFrame", gameOver)
    Runtime:addEventListener("enterFrame", moveBackground)
    Runtime:addEventListener ("enterFrame", onUpdate)
    Runtime:addEventListener ("touch", flapTartaruga)
    Runtime:addEventListener("collision", onGlobalCollision)
    Runtime:addEventListener ("enterFrame", updatePontos)
    Runtime:addEventListener("enterFrame", vida)
    --Runtime:addEventListener("enterFrame", proximaFase)
    


end
     
     
-- show()
function scene:show( event )
     
    local sceneGroup = self.view
    local phase = event.phase
    --audio.play(backgroundmusic)
     
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
        -- Runtime:removeEventListener("enterFrame", gameOver)
        -- Runtime:removeEventListener("enterFrame", moveBackground)
        -- Runtime:removeEventListener("enterFrame", onUpdate)
        -- Runtime:removeEventListener("touch", flapTartaruga)
        -- Runtime:removeEventListener("collision", onGlobalCollision)
        -- Runtime:removeEventListener("enterFrame", updatePontos)
        -- Runtime:removeEventListener("enterFrame", vida)
        --Runtime:removeEventListener("enterFrame", proximaFase)
        
        audio.stop()
        physics.pause() 
     
    end
end
     
     
-- destroy()
function scene:destroy( event )
     
    local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	--audio.pause(backgroundmusic)
     
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
