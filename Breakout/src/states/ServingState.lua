ServingState = Class{__include = BaseState}

function ServingState:init(params)
    self.paddle = params.paddle

    self.level = params.level

    self.ball = Ball(
        (self.paddle.x + self.paddle.width / 2) - 4,
        (self.paddle.y + self.paddle.height / 2) - 4 - 16,
        math.random(-200, 200)
    )

    self.health = params.health
    self.score = params.score or 0
end

function ServingState:update(dt)
    self.paddle:update(dt)
    self.level:update(dt)

    if isKeyDown('return') then
        gStateMachine:change('playing', { paddle = self.paddle, level = self.level, ball = self.ball, health = self.health, score = self.score})
        gSFX['confirm']:play()
    end

    self.ball.x = (self.paddle.x + self.paddle.width / 2) - 4
    self.ball.y = (self.paddle.y + self.paddle.height / 2) - 4 - 16
end

function ServingState:draw()
    self.paddle:draw()
    self.level:draw()
    self.ball:draw()
    
    love.graphics.printf('Level ' .. tostring(self.level.number), 10, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Score ' .. tostring(self.score), -10, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'right')

    drawHealth(self.health, 3)
end