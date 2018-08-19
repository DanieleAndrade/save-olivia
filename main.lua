-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------


local physics = require("physics")
physics.start()
physics.setGravity(0,0)

centroX = display.contentCenterX
centroY = display.contentCenterY

larguraTela = display.contentWidth + 100
alturaTela = display.contentHeight

local initialPosition = -100


local background = display.newImage("img/background.png")
background.width = larguraTela
background.height = alturaTela
background.x = centroX
background.y = centroY

local turttle 
turttle = display.newImage("img/turttle.png")
turttle.x = initialPosition
turttle.y = centroY


local function moveTurttle( event )
    if (turttle.x + turttle.contentWidth > larguraTela + 100) then
      turttle.x = initialPosition
    else
      turttle.x = turttle.x + 1
    end
end


Runtime:addEventListener("enterFrame", moveTurttle)
