-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- Gerar número aleatórios
math.randomseed(os.time())

display.setStatusBar( display.HiddenStatusBar )

audio.reserveChannels( 1 )
audio.setVolume( 0.5, { channel=1 } )

composer.gotoScene( "menu" )




