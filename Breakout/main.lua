require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            resizable = false,
            vsync = true
        }
    )

    gSprites = {
        ['background'] = love.graphics.newImage('images/background.png'),
        ['atlas'] = love.graphics.newImage('images/atlas.png'),
        ['particle'] = love.graphics.newImage('images/particle.png')
    }

    gQuads = {
        ['paddles'] = GetPaddleQuads(gSprites['atlas']),
        ['arrows'] = GetArrowQuads(gSprites['atlas']),
        ['blocks'] = GetBlockQuads(gSprites['atlas']),
        ['balls'] = GetBallQuads(gSprites['atlas']),
        ['hearts'] = GetHeartQuads(gSprites['atlas']),
        ['powerups'] = GetPowerupQuads(gSprites['atlas'])
    }

    gLevelGenerator = LevelGenerator()

    gStateMachine = StateMachine {
        ['menu'] = function(params) return MenuState(params) end,
        ['dresser'] = function(params) return DresserState(params) end,
        ['serving'] = function(params) return ServingState(params) end,
        ['playing'] = function(params) return PlayingState(params) end,
        ['gameover'] = function(params) return GameOverState(params) end,
        ['new_highscore'] = function(params) return NewHighScoreState(params) end,
        ['highscores'] = function(params) return HighScoresState(params) end
    }

    gStateMachine:change('menu')

    -- 8 Bit Wonder
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 12),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['big'] = love.graphics.newFont('fonts/font.ttf', 20)
    }

    gSFX = {
        ['brick-hit-1'] = love.audio.newSource('audio/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('audio/brick-hit-2.wav', 'static'),
        ['confirm'] = love.audio.newSource('audio/confirm.wav', 'static'),
        ['high-score'] = love.audio.newSource('audio/high_score.wav', 'static'),
        ['hurt'] = love.audio.newSource('audio/hurt.wav', 'static'),
        ['no-select'] = love.audio.newSource('audio/no-select.wav', 'static'),
        ['paddle-hit'] = love.audio.newSource('audio/paddle_hit.wav', 'static'),
        ['pause'] = love.audio.newSource('audio/pause.wav', 'static'),
        ['recover'] = love.audio.newSource('audio/recover.wav', 'static'),
        ['score'] = love.audio.newSource('audio/score.wav', 'static'),
        ['select'] = love.audio.newSource('audio/select.wav', 'static'),
        ['victory'] = love.audio.newSource('audio/victory.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('audio/wall_hit.wav', 'static'),

        ['music'] = love.audio.newSource('audio/music.wav', 'static')
    }

    gSFX['music']:setLooping(true)
    gSFX['music']:play()

    gDebugRectangle = { x = VIRTUAL_WIDTH, y = VIRTUAL_HEIGHT }
    gDebugMessage = ''

    recentKeys = {}

    math.randomseed(os.time())

    love.filesystem.setIdentity('breakout')

    love.window.setTitle('Breakout')
end

function love.update(dt)
    gStateMachine:update(dt)

    recentKeys = {}
end

function love.draw()
    push:apply('start')

    love.graphics.draw(
        gSprites['background'], -- Sprite
        0, -- X
        0, -- Y
        0, -- Rotation
        VIRTUAL_WIDTH / gSprites['background']:getWidth() + 1, -- X-scale factor
        VIRTUAL_HEIGHT / gSprites['background']:getHeight() + 1 -- Y-scale factor
    )

    gStateMachine:draw()

    -- Draw a vertical line to show the center
    --love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 0.5, 0, 1, VIRTUAL_HEIGHT)

    if DEBUG_MODE then
        local mouseX, mouseY = love.mouse.getPosition() 
    
        mouseX = mouseX * (VIRTUAL_WIDTH / WINDOW_WIDTH)
        mouseY = mouseY * (VIRTUAL_HEIGHT / WINDOW_HEIGHT)
    
        love.graphics.print('X: ' .. mouseX .. ', Y: ' .. mouseY, mouseX, mouseY - 15)
    
        --love.graphics.rectangle('fill', gDebugRectangle.x, gDebugRectangle.y, 32, 16)
        love.graphics.print(gDebugMessage, 10, VIRTUAL_HEIGHT - 30)
    end

    push:apply('end')
end

function love.keypressed(key)
    recentKeys[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function isKeyDown(key)
    return recentKeys[key]
end

function drawHealth(health, gap)
    local x = VIRTUAL_WIDTH - MAX_HEALTH * 10 - MAX_HEALTH * gap - gap

    for i = 1, health do
        love.graphics.draw(gSprites['atlas'], gQuads['hearts'][0], x, gap)
        x = x + 10
    end

    for i = 1, MAX_HEALTH - health do
        love.graphics.draw(gSprites['atlas'], gQuads['hearts'][1], x, gap)
        x = x + 10
    end
end