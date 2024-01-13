push = require 'push'
Class = require 'class'

require 'classes/Bee'
require 'classes/Pipe'
require 'classes/PipePair'
require 'classes/PipePairGenerator'
require 'classes/StateMachine'
require 'classes/states/BasicState'
require 'classes/states/CountdownState'
require 'classes/states/MenuState'
require 'classes/states/PlayState'
require 'classes/states/ScoreState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 416
VIRTUAL_HEIGHT = 234

GRAVITY_STRENGTH = 20

local BACKGROUND_X = 0
local BACKGROUND_SLIDE_SPEED = 30

local ROAD_X = 0
-- Variable is used by many objects, so I have to made it global
ROAD_SLIDE_SPEED = 50

local BACKGROUND = love.graphics.newImage('images/background.png')
local ROAD = love.graphics.newImage('images/road.png')
PAUSE_IMAGE = love.graphics.newImage('images/pause.png')

STATE_PARAMS = {}

RECENT_KEYS = {}

IS_GAME_RUNNING = true

SFX = {
    ['loop'] = love.audio.newSource('audio/loop.wav', 'static'),
    ['jump'] = love.audio.newSource('audio/jump.wav', 'static'),
    ['hit'] = love.audio.newSource('audio/hit.wav', 'static')
}

function love.load()
    love.window.setTitle('Flappy Bee')
    
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            resizable = false,
            vsync = false
        }
    )

    math.randomseed(os.time())

    -- DPComic by codeman38
    scoreFont = love.graphics.newFont('fonts/dpcomic.ttf', 30)
    love.graphics.setFont(scoreFont)

    STATE_MACHINE = StateMachine {
        ['menu'] = function() return MenuState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
    }

    STATE_MACHINE:change('menu', {})

    SFX['loop']:setLooping(true)

    SFX['loop']:play()
end

function love.update(dt)
    love.window.setTitle('Flappy Bee | FPS: ' .. tostring(love.timer.getFPS()))

    if IS_GAME_RUNNING then
        BACKGROUND_X = (BACKGROUND_X - BACKGROUND_SLIDE_SPEED * dt) % -VIRTUAL_WIDTH
            
        ROAD_X = (ROAD_X - ROAD_SLIDE_SPEED * dt) % -VIRTUAL_WIDTH
    end

    STATE_MACHINE:update(dt)
end

function love.keypressed(key)
    RECENT_KEYS[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()

    love.graphics.draw(BACKGROUND, BACKGROUND_X, 0)

    STATE_MACHINE:draw()
    
    love.graphics.draw(ROAD, ROAD_X, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end