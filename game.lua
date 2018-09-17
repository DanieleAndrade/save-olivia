local composer = require( "composer" )

local scene = composer.newScene()

function scene:create( event )

    -- Set up display groups
    local backGroup = display.newGroup()  -- Display group for the background image
    local mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
    local uiGroup = display.newGroup()    -- Display group for UI objects like the score

    local physics = require("physics")
    physics.start()
    physics.setGravity( 0, 0 )
    display.setStatusBar(display.HiddenStatusBar)

    centroX = display.contentCenterX
    centroY = display.contentCenterY

    larguraTela = display.contentWidth + 100
    alturaTela = display.contentHeight
    local scrollSpeed = 1

    local initialPosition = 10

    enderecoBackground1 = "img/background.jpg"
    enderecoBackground2 = "img/background3.jpg"
    local background1 = display.newImage(enderecoBackground1)
    background1.width = larguraTela
    background1.height = alturaTela
    background1.x = larguraTela/2
    background1.y = alturaTela*0.5

    local background2 = display.newImage(enderecoBackground2)
    background2.width = larguraTela
    background2.height = alturaTela
    background2.x = background1.x + larguraTela
    background2.y = alturaTela*0.5

    local background3 = display.newImage(enderecoBackground1)
    background3.width = larguraTela
    background3.height = alturaTela
    background3.x = background2.x + larguraTela
    background3.y = alturaTela*0.5
    

    local turttle = display.newImage("img/turttle.png")
    turttle.x = initialPosition
    turttle.y = 5

    -- local estrela = display.newImage("img/estrela.png")
    -- estrela.x = 100
    -- estrela.y = 90
    -- estrela.width = 50
    -- estrela.height = 60

    -- local comida = display.newImage("img/comida.png")
    -- comida.x = 350
    -- comida.y = 200
    -- comida.width = 20
    -- comida.height = 20


    -- physics.addBody (estrela, {isSensor = true})
    -- estrela.bodyType = "static"
    -- estrela.myName = "estrela"

    -- physics.addBody (comida, {isSensor = true})
    -- comida.bodyType = "static"
    -- comida.myName = "comida"

    physics.addBody (turttle)
    turttle.isFixedRotation = true
    turttle.isSensor = true
    turttle.myName = "turtle"
    turttle.gravityScale = 0



    local score = 0
    local contadorVida = 100
    local turttleFlapDelta = 0

    -- Mostrar lives e score
    local livesText = display.newText( "Lives: " .. contadorVida, 30, 15, native.systemFont, 20 )
    local scoreText = display.newText( "Score: " .. score, 240, 15, native.systemFont, 20 )


    local function flapTurttle (event)
    if (event.phase == "began") then
        
        turttleFlapDelta = 18
    end
    end

    local function onUpdate (event)

    if (turttleFlapDelta > 0) then
        turttle.y = turttle.y - turttleFlapDelta
        turttleFlapDelta = turttleFlapDelta - 0.8
       -- turttle.x = turttle.x + 0.5
    end
    turttle.y = turttle.y + 7

    -- coloca o jabuti de volta ao jogo
    if(turttle.x > larguraTela) then
        turttle.x = -5

    end
    -- if (turttle.y < -10) then
    --   endGame ()
    -- elseif (turttle.y > 480) then
    --   endGame ()
    -- end 
    end


    local maxGarrafas = 4
    criar = true
    criado = false
    parar = 1
    local garrafasTable = {}
    local comidaTable = {}
    local estrelaTable = {}

    local function createGarrafa()

        if(#garrafasTable < 4) then
           
            local newGarrafa = display.newImageRect("img/garrafa.png", 30, 50 )
            table.insert( garrafasTable, newGarrafa )
            physics.addBody( newGarrafa, {isSensor = true})
            newGarrafa.bodyType = "static"
            newGarrafa.myName = "garrafa"
        
            local whereFrom = math.random( 3 )

            
            if ( whereFrom == 1 or whereFrom == 2 or whereFrom == 3 ) then
                -- From the right
                newGarrafa.x = larguraTela + 5
                newGarrafa.y = math.random(alturaTela)
                newGarrafa:setLinearVelocity( math.random( -200,-4 ), math.random( 20,60 ) )
            end
        
            newGarrafa:applyTorque( math.random( -6,6 ) )
        end
    end

    function moveGarrafa( )
        for i = #garrafasTable, 1, -1 do
            local garrafa = garrafasTable[i]
    
            if(garrafa.x + garrafa.contentWidth < -100) then
                garrafa.x = larguraTela + 5
                garrafa.y = math.random(math.random(alturaTela))
            else
                garrafa.x = garrafa.x - 10
            end
        end
    end

    local function createComida()

        if(#comidaTable < 4) then
           
            local newComida = display.newImageRect("img/comida.png", 15, 15 )
            table.insert( comidaTable, newComida )
            physics.addBody( newComida, {isSensor = true})
            newComida.bodyType = "static"
            newComida.myName = "comida"
        
            local whereFrom = math.random( 3 )

            
            if ( whereFrom == 1 or whereFrom == 2 or whereFrom == 3 ) then
                -- From the right
                newComida.x = larguraTela + 1
                newComida.y = math.random(alturaTela)
                newComida:setLinearVelocity( math.random( -200,-4 ), math.random( 20,60 ) )
            end
        
            newComida:applyTorque( math.random( -6,6 ) )
        end
    end

    function moveComida( )
        for i = #comidaTable, 1, -1 do
            local comida = comidaTable[i]
    
            if(comida.x + comida.contentWidth < -100) then
                comida.x = larguraTela + 1
                comida.y = math.random(math.random(alturaTela))
            else
                comida.x = comida.x - 10
            end
        end
    end

    local function createEstrela()

        if(#estrelaTable < 4) then
           
            local newEstrela = display.newImageRect("img/estrela.png", 20, 20 )
            table.insert( estrelaTable, newEstrela )
            physics.addBody( newEstrela, {isSensor = true})
            newEstrela.bodyType = "static"
            newEstrela.myName = "estrela"
        
            local whereFrom = math.random( 3 )

            
            if ( whereFrom == 1 or whereFrom == 2 or whereFrom == 3 ) then
                -- From the right
                newEstrela.x = larguraTela + 10
                newEstrela.y = math.random(alturaTela)
                newEstrela:setLinearVelocity( math.random( -200,-4 ), math.random( 20,60 ) )
            end
        
            newEstrela:applyTorque( math.random( -6,6 ) )
        end
    end

    function moveEstrela( )
        for i = #estrelaTable, 1, -1 do
            local estrela = estrelaTable[i]
    
            if(estrela.x + estrela.contentWidth < -100) then
                estrela.x = larguraTela + 10
                estrela.y = math.random(math.random(alturaTela))
            else
                estrela.x = estrela.x - 10
            end
        end
    end

    local function gameLoop()

        -- Create new bottle
        createGarrafa()

        createComida()

        --createEstrela()
    
        -- -- Remove asteroids which have drifted off screen
        -- for i = #garrafasTable, 1, -1 do
        --     local thisGarrafa = garrafasTable[i]
    
        --     if ( thisGarrafa.x < -100 or
        --          thisGarrafa.x > display.contentWidth + 100 or
        --          thisGarrafa.y < -100 or
        --          thisGarrafa.y > display.contentHeight + 100 )
        --     then
        --         display.remove( thisGarrafa )
        --         table.remove( garrafasTable, i )
        --     end
        -- end
    end
    
    contadorDeTempoTimer = timer.performWithDelay( 4000, gameLoop, 1000)
    local criaComidaTimer = timer.performWithDelay( 2000, gameLoop, 1000)
    local criaEstrelaTimer = timer.performWithDelay(10000, createEstrela, 10)

    local moveGarrafaTimer = timer.performWithDelay(500, moveGarrafa, 1000)
    local moveComidaTimer = timer.performWithDelay(100, moveComida, 1000)
    local moveEstrelaTimer = timer.performWithDelay(200, moveEstrela, 200)
    


    -- Global collision handling
    local function onGlobalCollision( event )

    local obj1 = event.object1
    local obj2 = event.object2

    if(obj2.myName == "garrafa" and obj1.myName == "turtle" )then
        display.remove(obj2)
        contadorVida = contadorVida - 10

        for i = #garrafasTable, 1, -1 do
            if(garrafasTable[i] == obj2) then
                table.remove(garrafasTable, i)
                break
            end
        end

    elseif(obj1.myName == "garrafa" and obj2.myName == "turtle") then 
        display.remove(obj1)
        contadorVida = contadorVida - 10

        for i = #garrafasTable, 1, -1 do
            if(garrafasTable[i] == obj1) then
                table.remove(garrafasTable, i)
                break
            end
        end  

    elseif(obj1.myName == "estrela" and obj2.myName == "turtle") then
        display.remove(obj1)
        score = score + 200 
        
        for i = #estrelaTable, 1, -1 do
            if(estrelaTable[i] == obj1) then
                table.remove(estrelaTable, i)
                break
            end
        end 

    elseif(obj2.myName == "estrela" and obj1.myName == "turtle") then
        display.remove(obj2)
        score = score + 200 
        
        for i = #estrelaTable, 1, -1 do
            if(estrelaTable[i] == obj2) then
                table.remove(estrelaTable, i)
                break
            end
        end     

    elseif(obj1.myName == "comida" and obj2.myName == "turtle") then
        display.remove(obj1)
        score = score + 10
        if(contadorVida < 100) then
            contadorVida = contadorVida + 5 
        else
            contadorVida = contadorVida + 0
        end    

        for i = #comidaTable, 1, -1 do
            if(comidaTable[i] == obj1) then
                table.remove(comidaTable, i)
                break
            end
        end
    elseif(obj2.myName == "comida" and obj1.myName == "turtle") then
        display.remove(obj2)
        score = score + 10
        if(contadorVida < 100) then
            contadorVida = contadorVida + 5 
        else
            contadorVida = contadorVida + 0
        end  

        for i = #comidaTable, 1, -1 do
            if(comidaTable[i] == obj2) then
                table.remove(comidaTable, i)
                break
            end
        end

    end  
    end

    -- local function gameOver () 
    --     if(contadorVida <= 0) then
    --         timer.cancel(contadorDeTempoTimer)
    --         timer.cancel(criaComidaTimer)
    --         timer.cancel(moveComidaTimer)
    --         timer.cancel(moveGarrafaTimer)
    --         composer.gotoScene("gameOver")
    --     end
    -- end   
    
    -- Runtime:addEventListener("enterFrame", gameOver)

    local function move(event)
    background1.x = background1.x - scrollSpeed
    background2.x = background2.x - scrollSpeed
    background3.x = background3.x - scrollSpeed

    if(background1.x + background1.contentWidth) < larguraTela/3  then
        background1.x = background3.x + background3.width
    end  
    if(background2.x + background2.contentWidth) <  larguraTela/3  then
        background2.x = background1.x + background1.width
    end
    if(background3.x + background3.contentWidth) <  larguraTela/3 then
        background3.x = background2.x + background2.width
    end
    end 

    local function updatePontos()
    livesText.text = "Lives: " .. contadorVida .. "%"
    scoreText.text = "Score: " .. score
    end

    Runtime:addEventListener ("enterFrame", onUpdate)
    Runtime:addEventListener ("touch", flapTurttle)
    Runtime:addEventListener("collision", onGlobalCollision )
    Runtime:addEventListener("enterFrame", move)
    Runtime:addEventListener ("enterFrame", updatePontos)

    end 
scene:addEventListener( "create", scene )
return scene