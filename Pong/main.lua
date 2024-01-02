Class = require 'class'

require 'Paddle'
require 'Ball'

push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 550
VIRTUAL_HEIGHT = 450

SEPARATORS_COUNT = 7

PADDLE_SPEED = 300

USE_AI = false

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false;
            resizable = true;
            vsync = true;
        }
    )

    font = love.graphics.newFont('font.ttf')
    love.graphics.setFont(font, 60)

    player1 = Paddle(10, VIRTUAL_HEIGHT / 2, 15, 65)
    player2 = Paddle(VIRTUAL_WIDTH - 30 - 10, VIRTUAL_HEIGHT / 2, 15, 65)
    ball = Ball(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 15, 15)
end

function love.update(dt)
    love.window.setTitle('FPS: '..tostring(getFPS()) .. ' Ball DX: ' .. tostring(ball.dx) .. ' Ball DY: ' .. tostring(ball.dy))
 
    -- Player 1 control logic
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end
    
    -- Player 2 control logic. TODO: change AI behaviour
    if (USE_AI) then
        player2.y = ball.y / 2 > player2.y / 2 and player2.y + (ball.y - player2.y) or player2.y - (player2.y - ball.y)
    else
        if love.keyboard.isDown('up') then
            player2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            player2.dy = PADDLE_SPEED
        else
            player2.dy = 0
        end
    end
    
    -- Logic of the ball collision with paddles
    if ball:collides(player1) then
        ball.x = ball.x + 10
        ball.dx = -ball.dx * 1.05
        ball.dy = -math.random(ball.dy - 30, ball.dy + 30)
    elseif ball:collides(player2) then
        ball.x = ball.x - 10
        ball.dx = -ball.dx * 1.05
        ball.dy = -math.random(ball.dy - 30, ball.dy + 30)
    end

    -- Left and Right bounds logic
    if ball.x < 0 then
        ball:reset()
        player2.score = player2.score + 1
    elseif ball.x + ball.width > VIRTUAL_WIDTH then
        ball:reset()
        player1.score = player1.score + 1
    end

    -- Wall bounds logic
    if ball.y < 0 or ball.y + ball.height > VIRTUAL_HEIGHT then
        ball.dy = -math.random(ball.dy - 50, ball.dy + 50)
    end

    -- Speed control
    if ball.dx > 1000 then
        ball.dx = ball.dx / 2
    end

    player1:update(dt)
    player2:update(dt)

    ball:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        ball:reset()
    elseif key == 'c' then
        USE_AI = USE_AI == false and true or false
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(30/255, 30/255, 30/255, 255/255)

    drawSeparator()

    player1:render()
    player2:render()

    ball:render()

    love.graphics.printf(
        tostring(player1.score),
        VIRTUAL_WIDTH / 4,
        VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH,
        'left'
    )

    love.graphics.printf(
        tostring(player2.score),
        VIRTUAL_WIDTH / 2 + VIRTUAL_WIDTH / 4,
        VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH,
        'left'
    )

    if (USE_AI) then
        love.graphics.printf(
            'AI: Enabled',
            0,
            VIRTUAL_HEIGHT / 4,
            VIRTUAL_WIDTH,
            'center'
        )
    else
        love.graphics.printf(
            'AI: Disabled',
            0,
            VIRTUAL_HEIGHT / 4,
            VIRTUAL_WIDTH,
            'center'
        )
    end

    push:apply('end')
end

function drawSeparator()
    separatorX = VIRTUAL_WIDTH / 2 - 5
    separatorY = 0
    for i = 0, SEPARATORS_COUNT, 1
    do
        love.graphics.rectangle('fill', separatorX, separatorY, 10, 10)
        separatorY = separatorY + VIRTUAL_HEIGHT / SEPARATORS_COUNT
    end
end

function getFPS()
    return love.timer.getFPS()
end










