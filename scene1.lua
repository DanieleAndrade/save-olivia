
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

local vidas = 3
local pontos = 0
local died = false
local tartarugaFlapDelta = 0
local tartaruga
local garrafa
local estrela
local copo
local lata
local sacola
local anzol
local anzolTable = {}
local garrafasTable = {}
local comidaTable = {}
local estrelaTable = {}
local coposTable = {}
local sacolasTable = {}
local latasTable = {}
local criaComidaTimer
local criaEstrelaTimer
local vidasText
local faseText
local pontuacaoText
local scrollSpeed = 1
local proximaFase = 0
faseContador = 2
gameAtivo = true

local backgroundmusic = audio.loadStream('audio/backgroundmusic.mp3')

function scene:create( event )
    
    --audio.play(backgroundmusic, { channel=1, loops=-1 })     
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen


   -- vidasText = display.newText( uiGroup, "Vidas: " .. vidas, 30, 15, native.systemFont, 20 )
    pontuacaoText = display.newText( uiGroup, "Scores: " .. pontos, 210, 15, 'fonts/SF Atarian System Extended Bold.ttf', 20 )
    faseText = display.newText( uiGroup, "Level: " .. faseContador, W - 110, 15, 'fonts/SF Atarian System Extended Bold.ttf', 20 )

    local function updatePontos()
        pontuacaoText.text = "Scores: " .. pontos
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

    local function dragTartaruga (event)

        local tartaruga = event.target
        local phase = event.phase

        if ( "began" == phase ) then
            -- Set touch focus on the ship
            display.currentStage:setFocus( tartaruga )
            tartaruga.touchOffsetY = event.y - tartaruga.y
        
        elseif ( "moved" == phase ) then
            -- Move the ship to the new touch position
            tartaruga.y = event.y - tartaruga.touchOffsetY
            
        elseif ( "ended" == phase or "cancelled" == phase ) then
            -- Release touch focus on the ship
            display.currentStage:setFocus( nil )    
        end

        return true 
    end

    tartaruga:addEventListener( "touch", dragTartaruga )

    -- local function flapTartaruga (event)
    --     if (event.phase == "began") then
    --         if(chamarFuncao) then
    --             audio.play(backgroundmusic, { loops= -1 })
    --             chamarFuncao = false
    --         end 
            
    --         tartarugaFlapDelta = 15
    --     end
    -- end

    -- local function onUpdate (event)

    --     local posicaoTartaruga = tartaruga.y + tartaruga.contentHeight

    --     if(posicaoTartaruga > 0 and posicaoTartaruga < H + 100) then
    --         if (tartarugaFlapDelta > 0) then
    --             tartaruga.y = tartaruga.y - tartarugaFlapDelta
    --             tartarugaFlapDelta = tartarugaFlapDelta - 0.6
    --         end
    --         tartaruga.y = tartaruga.y + 7
    --     elseif(posicaoTartaruga < 0) then
    --         tartaruga.y = tartaruga.contentHeight
    --     elseif(posicaoTartaruga > H) then
    --         tartaruga.y = centroY
    --     end    
      
    -- end

    levelSound = audio.loadSound( "audio/Level Up!/piano.wav" )

    function proximaFase( )
        faseContador = faseContador + 1   
        faseText.text = "Fase: " .. faseContador  
        audio.play( levelSound )    
    end

    function finalizarJogo( )
        if(faseContador > 3)then
            composer.gotoScene("parabens", { time=800, effect="crossFade" })
        end 
    end
   

    local mudarFaseTime = timer.performWithDelay(30000, proximaFase, 4)

        local function createAnzol()
            if(faseContador == 3) then
                if(#anzolTable < 4) then
                
                    newAnzol = display.newImageRect(mainGroup, 'img/personagens/anzol.png', 50, 50 )
                    table.insert( anzolTable, newAnzol )
                    physics.addBody( newAnzol, {isSensor = true})
                    newAnzol.bodyType = "dynamic"
                    newAnzol.myName = "anzol"
                
                    local whereFrom = 3
                    if ( whereFrom == 3 ) then
                        -- From the right
                        newAnzol.x = W + 10
                        newAnzol.y = math.random(H)
                        newAnzol:setLinearVelocity( math.random( -40,40 ), math.random( 1, 50 ) )
                    end

                end 
            else 
                display.remove(newAnzol)   
                for i = #anzolTable, 1, -1 do
                    if(anzolTable[i] == newAnzol) then
                        table.remove(anzolTable, i)
                        break
                    end
                end   
            end    
        end


    function moveAnzol( )
            for i = #anzolTable, 1, -1 do
                local anzol = anzolTable[i]
        
                if(anzol.x + anzol.contentWidth < -100) then
                    anzol.x = W + 10
                    anzol.y = math.random(math.random(H))
                else
                    local limiteAnzol = math.random(anzol.y - 30, anzol.y + 10)
                    if(limiteAnzol > H) then
                        limiteAnzol = H - 5
        
                    elseif(limiteAnzol < 0) then
                        limiteAnzol = 5
                    end 
                    transition.moveTo( anzol, { x=anzol.x - 50, y=limiteAnzol, time=400 } )
                end
            end  
           
    end

    local function createGarrafa()
            if(faseContador == 1) then
                if(#garrafasTable < 4) then
                
                    newGarrafa = display.newImageRect(mainGroup, 'img/personagens/garrafa.png', 50, 50 )
                    table.insert( garrafasTable, newGarrafa )
                    physics.addBody( newGarrafa, {isSensor = true})
                    newGarrafa.bodyType = "dynamic"
                    newGarrafa.myName = "garrafa"
                
                    local whereFrom = 3
                    if ( whereFrom == 3 ) then
                        -- From the right
                        newGarrafa.x = W + 10
                        newGarrafa.y = math.random(H)
                        newGarrafa:setLinearVelocity( math.random( -40,40 ), math.random( 1, 50 ) )
                    end

                end 
            else 
                display.remove(newGarrafa)   
                for i = #garrafasTable, 1, -1 do
                    if(garrafasTable[i] == newGarrafa) then
                        table.remove(garrafasTable, i)
                        break
                    end
                end   
            end    
    end

    
    function moveGarrafa( )
        if(faseContador == 1) then
            for i = #garrafasTable, 1, -1 do
                local garrafa = garrafasTable[i]
        
                if(garrafa.x + garrafa.contentWidth < -100) then
                    garrafa.x = W + 10
                    garrafa.y = math.random(math.random(H))
                else
                    local limiteGarrafa = math.random(garrafa.y - 8, garrafa.y + 8)
                    if(limiteGarrafa > H) then
                        limiteGarrafa = H - 5
        
                    elseif(limiteGarrafa < 0) then
                        limiteGarrafa = 5
                    end 
                    transition.moveTo( garrafa, { x=garrafa.x - 30, y=limiteGarrafa, time=300 } )
                end
            end  
        end    
    end

    local function createCopo()
        if(faseContador == 1) then
            if(#coposTable < 3) then
            
                newCopo = display.newImageRect(mainGroup, 'img/personagens/copo.png', 50, 50 )
                table.insert( coposTable, newCopo )
                physics.addBody( newCopo, {isSensor = true})
                newCopo.bodyType = "dynamic"
                newCopo.myName = "copo"
            
                local whereFrom = 3
                if ( whereFrom == 3 ) then
                    -- From the right
                    newCopo.x = W + 10
                    newCopo.y = math.random(H) + 5
                    newCopo:setLinearVelocity( math.random( -50,-4 ), math.random( 1, 20 ) )
                end

            end
        else
            display.remove(newCopo)  
            for i = #coposTable, 1, -1 do
                if(coposTable[i] == newCopo) then
                    table.remove(coposTable, i)
                    break
                end
            end  
        end      
    end

    function moveCopo( )
        for i = #coposTable, 1, -1 do
            local copo = coposTable[i]
    
            if(copo.x + copo.contentWidth < -100) then
                copo.x = W + 10
                copo.y = math.random(math.random(H))
            else
                transition.moveTo( copo, { x=copo.x - 10, y=copo.y, time=200 } )
            end
        end
    end
    
    local function createSacola()
        if(faseContador == 2) then
            if(#sacolasTable < 4) then
            
                newSacola = display.newImageRect(mainGroup, 'img/personagens/sacola.png', 50, 50 )
                table.insert( sacolasTable, newSacola )
                physics.addBody( newSacola, {isSensor = true})
                newSacola.bodyType = "dynamic"
                newSacola.myName = "sacola"
            
                local whereFrom = 3
                if ( whereFrom == 3 ) then
                    -- From the right
                    newSacola.x = W + 10
                    newSacola.y = math.random(H)
                    newSacola:setLinearVelocity( math.random( -40,40 ), math.random( 1, 50 ) )
                end

            end
        else 
            display.remove(newSacola) 
            for i = #sacolasTable, 1, -1 do
                if(sacolasTable[i] == newSacola) then
                    table.remove(sacolasTable, i)
                    break
                end
            end  
        end       
    end

    function moveSacola( )
        if(faseContador == 2) then
            for i = #sacolasTable, 1, -1 do
                local sacola = sacolasTable[i]
        
                if(sacola.x + sacola.contentWidth < -100) then
                    sacola.x = W + 10
                    sacola.y = math.random(math.random(H))
                else
                    local limiteSacola = math.random(sacola.y - 30, sacola.y + 10)
                    if(limiteSacola > H) then
                        limiteSacola = H - 5
        
                    elseif(limiteSacola < 0) then
                        limiteSacola = 5
                    end 
                    transition.moveTo( sacola, { x=sacola.x - 50, y=limiteSacola, time=400 } )
                end
            end
        end   
    end

    local function createLata()
        if(faseContador == 2) then
            if(#latasTable < 3) then
            
                newLata = display.newImageRect(mainGroup, 'img/personagens/lata.png', 50, 50 )
                table.insert( latasTable, newLata )
                physics.addBody( newLata, {isSensor = true})
                newLata.bodyType = "dynamic"
                newLata.myName = "lata"
            
                local whereFrom = 3
                if ( whereFrom == 3 ) then
                    -- From the right
                    newLata.x = W + 10
                    newLata.y = math.random(H) + 5
                    newLata:setLinearVelocity( math.random( -50,-4 ), math.random( 1, 20 ) )
                end

            end
        else 
            display.remove(newLata)
            for i = #latasTable, 1, -1 do
                if(latasTable[i] == newLata) then
                    table.remove(latasTable, i)
                    break
                end
            end  
        end        
    end

    function moveLata( )
        for i = #latasTable, 1, -1 do
            local lata = latasTable[i]
        
            if(lata.x + lata.contentWidth < -100) then
                lata.x = W + 10
                lata.y = math.random(math.random(H))
            else
                local limiteLata = math.random(lata.y - 30, lata.y + 10)
                    if(limiteLata > H) then
                        limiteLata = H - 5
        
                    elseif(limiteLata < 0) then
                        limiteLata = 5
                    end 
                transition.moveTo( lata, { x=lata.x - 60, y=limiteLata, time=400 } )
            end
        end   
    end

    local function createComida()
        if(#comidaTable < 4) then
            
            local newComida = display.newImageRect(mainGroup, 'img/personagens/comida.png', 30, 30 )
            table.insert( comidaTable, newComida )
            physics.addBody( newComida, {isSensor = true})
            newComida.bodyType = "dynamic"
            newComida.myName = "comida"
            
            local whereFrom = 3
            if (whereFrom == 3 ) then
                    -- From the right
                newComida.x = W + 10
                newComida.y = math.random(H)
                newComida:setLinearVelocity( math.random( -50,-4 ), math.random( 1,50 ) )
            end
        end    
    end

    function moveComida( )
   
        for i = #comidaTable, 1, -1 do
            local comida = comidaTable[i]
            if(comida.x + comida.contentWidth < -100) then
                comida.x = W + 10
                comida.y = math.random(math.random(H))
            else

                local limiteComida = math.random(comida.y - 5, comida.y + 5)
                if(limiteComida > H) then
                    limiteComida = H - 5
        
                elseif(limiteComida < 0) then
                    limiteComida = 5
                end 
                transition.moveTo( comida, { x=comida.x - 30, y=limiteComida, time=400 } )
            end
        end
           
    end

    local function createEstrela()

        if(#estrelaTable < 1) then
            
            local newEstrela = display.newImageRect(mainGroup,'img/personagens/estrela.png', 40, 40 )
            table.insert( estrelaTable, newEstrela )
            physics.addBody( newEstrela, {isSensor = true})
            newEstrela.bodyType = "dynamic"
            newEstrela.myName = "estrela"
            
            local whereFrom = math.random( 3 )

                
            if ( whereFrom == 1 or whereFrom == 2 or whereFrom == 3 ) then
                    -- From the right
                newEstrela.x = W + 10
                newEstrela.y = math.random(H)
                newEstrela:setLinearVelocity( math.random( -200,-4 ), math.random( 20,60 ) )
            end
            
                newEstrela:applyTorque( math.random( -6,6 ) )
        end
            
    end

    function moveEstrela( )
        for i = #estrelaTable, 1, -1 do
            local estrela = estrelaTable[i]
        
            if(estrela.x + estrela.contentWidth < -100) then
                estrela.x = W + 10
                estrela.y = math.random(math.random(H))
            else
                -- estrela.x = estrela.x - 10
            local limiteEstrela = math.random(estrela.y - 30, estrela.y + 30)

            if(limiteEstrela > H) then
                limiteEstrela = H -5

            elseif(limiteEstrela < 0) then
                limiteEstrela = 5
            end 
                transition.moveTo( estrela, { x=estrela.x - 15, y=limiteEstrela, time=100 } )
            end
        end        
    end

    local function gameLoopTimer()

        createSacola()
        createLata()
        createGarrafa()
        createAnzol()
        createCopo()
    end    
  
    local function moveLoopTimer()
        
        moveGarrafa()
        moveCopo()
        moveAnzol()
        moveLata()
        moveSacola()

    end  

    gameLoopTimer = timer.performWithDelay(3000, gameLoopTimer, -1)
    criaComidaTimer = timer.performWithDelay(1000, createComida, -1)
    criaEstrelaTimer = timer.performWithDelay(10000, createEstrela, -1)
    moveLoopTimer = timer.performWithDelay(450, moveLoopTimer, -1)
    moveComidaTimer = timer.performWithDelay(350, moveComida, -1)
    moveEstrelaTimer = timer.performWithDelay(100, moveEstrela, -1)


    local function onGlobalCollision( event )

        local obj1 = event.object1
        local obj2 = event.object2
    
        if(obj2.myName == "garrafa" and obj1.myName == "tartaruga" )then
            display.remove(obj2)
            vidas = vidas - 1
    
            for i = #garrafasTable, 1, -1 do
                if(garrafasTable[i] == obj2) then
                    table.remove(garrafasTable, i)
                    break
                end
            end
    
        elseif(obj1.myName == "garrafa" and obj2.myName == "tartaruga") then 
            display.remove(obj1)
            vidas = vidas - 1
    
            for i = #garrafasTable, 1, -1 do
                if(garrafasTable[i] == obj1) then
                    table.remove(garrafasTable, i)
                    break
                end
            end  
        
        elseif(obj2.myName == "copo" and obj1.myName == "tartaruga" )then
            display.remove(obj2)
            vidas = vidas - 1
        
            for i = #coposTable, 1, -1 do
                if(coposTable[i] == obj2) then
                    table.remove(coposTable, i)
                    break
                end
            end
        
        elseif(obj1.myName == "copo" and obj2.myName == "tartaruga") then 
            display.remove(obj1)
            vidas = vidas - 1
        
            for i = #coposTable, 1, -1 do
                if(coposTable[i] == obj1) then
                    table.remove(coposTable, i)
                    break
                end
            end      
        
        elseif(obj2.myName == "anzol" and obj1.myName == "tartaruga" )then
            display.remove(obj2)
            vidas = vidas - 1

            if(pontos > 10) then
                pontos = pontos - 10
            else
                print(pontos)   
            end 
        
            for i = #anzolTable, 1, -1 do
                if(anzolTable[i] == obj2) then
                    table.remove(anzolTable, i)
                    break
                end
            end
        
        elseif(obj1.myName == "anzol" and obj2.myName == "tartaruga") then 
            display.remove(obj1)
            vidas = vidas - 1

            if(pontos > 10) then
                pontos = pontos - 10
            else
                print(pontos)   
            end     
        
            for i = #anzolTable, 1, -1 do
                if(anzolTable[i] == obj1) then
                    table.remove(anzolTable, i)
                    break
                end
            end          
    
        elseif(obj1.myName == "estrela" and obj2.myName == "tartaruga") then
            display.remove(obj1)
            pontos = pontos + 200 
            
            for i = #estrelaTable, 1, -1 do
                if(estrelaTable[i] == obj1) then
                    table.remove(estrelaTable, i)
                    break
                end
            end 
    
        elseif(obj2.myName == "estrela" and obj1.myName == "tartaruga") then
            display.remove(obj2)
            pontos = pontos + 200 
            
            for i = #estrelaTable, 1, -1 do
                if(estrelaTable[i] == obj2) then
                    table.remove(estrelaTable, i)
                    break
                end
            end     
    
        elseif(obj1.myName == "comida" and obj2.myName == "tartaruga") then
            display.remove(obj1)
            pontos = pontos + 10
            if(vidas < 3) then
                vidas = vidas + 1 
            else
                vidas = vidas + 0
            end    
    
            for i = #comidaTable, 1, -1 do
                if(comidaTable[i] == obj1) then
                    table.remove(comidaTable, i)
                    break
                end
            end
        elseif(obj2.myName == "comida" and obj1.myName == "tartaruga") then
            display.remove(obj2)
            pontos = pontos + 10
            if(vidas < 3) then
                vidas = vidas + 1 
            else
                vidas = vidas + 0
            end  
    
            for i = #comidaTable, 1, -1 do
                if(comidaTable[i] == obj2) then
                    table.remove(comidaTable, i)
                    break
                end
            end
         
        elseif(obj2.myName == "sacola" and obj1.myName == "tartaruga" )then
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
    
        end  
    end


    local function gameOver() 
        local posicaoTartaruga = tartaruga.y + tartaruga.contentHeight
        if(vidas < 0 or (posicaoTartaruga < 10 or posicaoTartaruga > H + 15)) then
            audio.pause(1)
            audio.pause(levelSound)
            timer.cancel(mudarFaseTime)
            composer.gotoScene("gameOver", { time=800, effect="crossFade" })
        end
    end   


    -----------------------------------------------------------------------
    --                      Barra de Vida                                --
    -----------------------------------------------------------------------

    local larguraVida = 100
    local alturaVida = 35

    local posicaoX = 20
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
        Runtime:addEventListener("collision", onGlobalCollision)
        Runtime:addEventListener("enterFrame", updatePontos)
        Runtime:addEventListener("enterFrame", vida)
        timer.resume(criaComidaTimer)
        timer.resume(criaEstrelaTimer)
        timer.resume(moveComidaTimer)
        timer.resume(moveEstrelaTimer)
        timer.resume(gameLoopTimer)
        timer.resume(moveLoopTimer)
        audio.play(backgroundmusic)
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
        Runtime:removeEventListener("collision", onGlobalCollision)
        Runtime:removeEventListener("enterFrame", updatePontos)
        Runtime:removeEventListener("enterFrame", vida)
        timer.pause(gameLoopTimer)
        timer.pause(moveLoopTimer)
        timer.pause(moveComidaTimer)
        timer.pause(moveEstrelaTimer)
        audio.pause(backgroundmusic)
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
    Runtime:addEventListener("enterFrame", finalizarJogo)
    Runtime:addEventListener("enterFrame", moveBackground)
   -- Runtime:addEventListener ("enterFrame", onUpdate)
   -- Runtime:addEventListener ("touch", flapTartaruga)
    Runtime:addEventListener("collision", onGlobalCollision)
    Runtime:addEventListener ("enterFrame", updatePontos)
    Runtime:addEventListener("enterFrame", vida)
    
    

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
        audio.play( backgroundmusic, { channel=1, loops=-1 } )
     
    end
end
     
     
-- hide()
function scene:hide( event )
     
    local sceneGroup = self.view
    local phase = event.phase
     
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        Runtime:removeEventListener("enterFrame", gameOver)
        Runtime:removeEventListener("enterFrame", moveBackground)
        Runtime:removeEventListener("collision", onGlobalCollision)
        Runtime:removeEventListener("enterFrame", updatePontos)
        Runtime:removeEventListener("enterFrame", vida)
        Runtime:removeEventListener("enterFrame", proximaFase)
        timer.cancel(criaComidaTimer)
        timer.cancel(criaEstrelaTimer)
        timer.cancel(criaGarrafaTimer)
        timer.cancel(criaCopoTimer)
        timer.cancel(criaSacolaTimer)
        timer.cancel(moveComidaTimer)
        timer.cancel(moveGarrafaTimer)
        timer.cancel(moveEstrelaTimer)
        timer.cancel(moveSacolaTimer)
        timer.cancel(moveCopoTimer)   
        display.remove(backGroup)
        display.remove(mainGroup)
        display.remove(uiGroup) 
     
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        audio.stop( 1 )
     
    end
end
     
     
-- destroy()
function scene:destroy( event )
     
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    audio.dispose(backgroundmusic)
     
end
     
     
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
--scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
     
return scene