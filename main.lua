-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- Gerar número aleatórios
math.randomseed(os.time())

display.setStatusBar( display.HiddenStatusBar )

composer.gotoScene( "menu" )




