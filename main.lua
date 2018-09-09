-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------


local physics = require("physics")
physics.start()
display.setStatusBar(display.HiddenStatusBar)

centroX = display.contentCenterX
centroY = display.contentCenterY

larguraTela = display.contentWidth + 100
alturaTela = display.contentHeight
local scrollSpeed = 1

local initialPosition = 10

enderecoBackground1 = "img/background.jpg"
enderecoBackground2 = "img/background2.jpg"
local background1 = display.newImage(enderecoBackground1)
background1.width = larguraTela
background1.height = alturaTela
background1.x = larguraTela/2
background1.y = alturaTela*0.5

-- background1.width = larguraTela
-- background1.height = alturaTela
-- background1.x = centroX
-- background1.y = centroY

local background2 = display.newImage(enderecoBackground1)
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
turttle.y = centroY

local garrafa = display.newImage("img/garrafa.png")
garrafa.x = centroX
garrafa.y = centroY
garrafa.width = 50
garrafa.height = 100

local estrela = display.newImage("img/estrela.png")
estrela.x = 100
estrela.y = 90
estrela.width = 50
estrela.height = 60


physics.addBody (garrafa, {isSensor = true})
garrafa.bodyType = "static"
garrafa.myName = "garrafa"

physics.addBody (estrela, {isSensor = true})
estrela.bodyType = "static"
estrela.myName = "estrela"

physics.addBody (turttle)
turttle.gravityScale = 0
turttle.isFixedRotation = true
turttle.isSensor = true
turttle.myName = "turtle"

score = 0
contadorVida = 100


local turttleFlapDelta = 0
local function flapTurttle (event)
  if (event.phase == "began") then
    turttleFlapDelta = 20
  end
end

local function onUpdate (event)

  if (turttleFlapDelta > 0) then
    turttle.y = turttle.y - turttleFlapDelta
    turttleFlapDelta = turttleFlapDelta - 0.8
    turttle.x = turttle.x + 0.5
  end
  turttle.y = turttle.y + 7

  if(turttle.x > larguraTela) then
    turttle.x = -20

  end
  -- if (turttle.y < -10) then
  --   endGame ()
  -- elseif (turttle.y > 480) then
  --   endGame ()
  -- end 
end

--[[local function moveTurttle( event )
    if (turttle.x + turttle.contentWidth > larguraTela + 100) then
      turttle.x = initialPosition
    else
      turttle.x = turttle.x + 1
    end
end ]]--



-- Global collision handling
local function onGlobalCollision( event )

  local obj1 = event.object1
  local obj2 = event.object2
  if(obj1.myName == "garrafa" and obj2.myName == "turtle") then
    display.remove(obj1)
    if(score < 10) then
    score = score - 0
    print("Score atual: " .. score)
    else 
      score = score - 10
      print("Score atual: " .. score)
    end  

  elseif(obj1.myName == "estrela" and obj2.myName == "turtle") then
    display.remove(obj1)
    score = score + 200
    print("Score atual: " .. score)
  end  
end

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


Runtime:addEventListener ("enterFrame", onUpdate)
Runtime:addEventListener ("touch", flapTurttle)
Runtime:addEventListener("collision", onGlobalCollision )
Runtime:addEventListener("enterFrame", move)

