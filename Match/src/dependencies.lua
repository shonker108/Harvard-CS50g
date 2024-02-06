Class = require 'lib/class'
Timer = require 'lib/knife/timer'
push = require 'lib/push'

require 'src/constants'
require 'src/helpers'
require 'src/Grid'
require 'src/Tile'
require 'src/Button'
require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/LoadingState'
require 'src/states/PlayState'
require 'src/states/EndState'

gSprites = {
    ['background'] = love.graphics.newImage('images/background.png'),
    ['tiles'] = love.graphics.newImage('images/tiles.png'),
    ['star_particle'] = love.graphics.newImage('images/star_particle.png')
}

gQuads = getTileQuads(gSprites['tiles'])

gFonts = {
    ['title'] = love.graphics.newFont('fonts/infinimrgooglestructmax.ttf', 30),
    ['big'] = love.graphics.newFont('fonts/squarematic.ttf', 20),
    ['medium'] = love.graphics.newFont('fonts/squarematic.ttf', 15)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['error'] = love.audio.newSource('sounds/error.wav', 'static'),
    ['match'] = love.audio.newSource('sounds/match.wav', 'static'),
    ['clock'] = love.audio.newSource('sounds/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav', 'static')
}