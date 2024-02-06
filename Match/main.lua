require 'src/dependencies'

local backgroundX = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Match 3')
    
    math.randomseed(os.time())
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    gStateMachine = StateMachine {
        ['start'] = function(params) return StartState(params) end,
        ['loading'] = function(params) return LoadingState(params) end,
        ['play'] = function(params) return PlayState(params) end,
        ['end'] = function(params) return EndState(params) end
    }

    gStateMachine:change('start')

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    gDebugMessage = ''

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
      
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)

    backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt

    if backgroundX < -512 then
        backgroundX = 0
    end

    if love.keyboard.wasPressed('d') then
        DEBUG_MODE = DEBUG_MODE == false and true or false
    end

    love.keyboard.keysPressed = {}

    love.window.setTitle('Match 3 ' .. ' | FPS: ' .. tostring(love.timer.getFPS()))
end

function love.draw()
    push:start()

    love.graphics.draw(gSprites['background'], backgroundX, 0)

    gStateMachine:draw()

    push:finish()
end