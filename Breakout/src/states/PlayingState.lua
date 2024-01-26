PlayingState = Class{__include = BaseState}

local timer = 0

function PlayingState:init(params)
    self.paddle = params.paddle
    self.level = params.level
    self.balls = { params.ball }
    self.health = params.health
    self.score = params.score
    self.pManager = PowerupManager(self.level.keyExists)
end

function PlayingState:update(dt)
    self.paddle:update(dt)
    self.level:update(dt)

    -- Balls updating
    for k, ball in pairs(self.balls) do
        ball:update(dt)

        if ball.belowFloor then
            -- If an extra ball is below the paddle, just remove him
            if #self.balls > 1 then
                table.remove(self.balls, k)
            else
                self.health = self.health - 1

                if self.health == 0 then
                    gStateMachine:change('gameover', { score = self.score })
                else
                    self.paddle:changeSize(self.paddle.size - 1)
            
                    gStateMachine:change('serving', { paddle = self.paddle, level = self.level, health = self.health, score = self.score})
                    gSFX['hurt']:play()
                end
            end
        end

        -- Collision with paddle handling
        if ball:collides(self.paddle) then
            ball:handleCollision(self.paddle)

            local diff = self.paddle.x + self.paddle.width / 2 - ball.x

            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * diff)
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(diff))
            end

            gSFX['paddle-hit']:play()
        end
        
        -- Collision with blocks handling
        for i = 1, #self.level.blocks do
            if self.level.blocks[i].isActive and ball:collides(self.level.blocks[i]) then
                ball:handleCollision(self.level.blocks[i])
                
                -- If it is a key block, then break because we can't decrease it's tear if that is locked
                if self.level.blocks[i].isKey then
                    break
                end

                self.level.blocks[i].particles:setColors(
                    gParticleColors[self.level.blocks[i].tier][1],
                    gParticleColors[self.level.blocks[i].tier][2],
                    gParticleColors[self.level.blocks[i].tier][3],
                    200/255,
                    gParticleColors[self.level.blocks[i].tier][1],
                    gParticleColors[self.level.blocks[i].tier][2],
                    gParticleColors[self.level.blocks[i].tier][3],
                    0
                )
    
                self.level.blocks[i].particles:emit(64)
                self.level.blocks[i].tier = self.level.blocks[i].tier - 1
    
                if self.level.blocks[i].tier < 0 then
                    self.level.blocks[i].isActive = false

                    self.score = self.score + self.level.blocks[i].score

                    if self.score % PADDLE_GROW_AFTER_SCORE == 0 then
                        self.paddle:changeSize(self.paddle.size + 1)
                    end
                end
                
                if math.random(0, 1) == 0 then
                    gSFX['brick-hit-1']:play()
                else
                    gSFX['brick-hit-2']:play()
                end

                break
            end

        end
    end

    -- Powerups updating
    self.pManager:update(dt)

    for i = 1, #self.pManager.powerups do
        if not self.pManager.powerups[i].toDelete and
            self.pManager.powerups[i]:collides(self.paddle) then
            self.pManager.powerups[i].toDelete = true

            -- If this is the Extra ball powerup
            if self.pManager.powerups[i].type == 0 then
                self.balls[#self.balls + 1] = Ball(
                    self.balls[#self.balls].x,
                    self.balls[#self.balls].y + 8,
                    math.random(-200, 200)
                )

            -- If this is the Key powerup
            else
                self.level.blocks[self.level.keyIndex].isKey = false
                self.level.keyExists = false
                self.pManager.keyAvailible = self.level.keyExists
                self.level.blocks[self.level.keyIndex].particles:setColors(
                    gParticleColors[4][1],
                    gParticleColors[4][2],
                    gParticleColors[4][3],
                    200/255,
                    gParticleColors[4][1],
                    gParticleColors[4][2],
                    gParticleColors[4][3],
                    0
                )
    
                self.level.blocks[self.level.keyIndex].particles:emit(64)
                self.level.blocks[self.level.keyIndex].tier = self.level.blocks[self.level.keyIndex].tier - 1
                
                self.pManager:deleteKeyPowerups()

                gSFX['recover']:play()
            end
            gSFX['select']:play()
        end
    end

    self.pManager:clear()

    -- Check if there are no any active blocks
    -- and go to the next level, if so
    if self.level:isEmpty() then
        gStateMachine:change('serving', {
            paddle = self.paddle,
            ball = self.ball,
            level = Level(self.level.number + 1, gLevelGenerator:generate(self.level.number - 1)),
            health = self.health,
            score = self.score
        })
        gSFX['victory']:play()
    end

    -- DEBUG FEATURE: Add a new ball to the state
    if isKeyDown('a') then
        self.balls[#self.balls + 1] = Ball(
            self.balls[#self.balls].x,
            self.balls[#self.balls].y + 8,
            math.random(-200, 200)
        )
    elseif isKeyDown('e') then
        gStateMachine:change('gameover', { score = 9999 })
    elseif isKeyDown('s') then
        gStateMachine:change('serving', {
            paddle = self.paddle,
            ball = self.ball,
            level = Level(self.level.number + 1, gLevelGenerator:generate(self.level.number - 1)),
            health = self.health,
            score = self.score
        })
    elseif isKeyDown('f') then
        self.pManager:generate(1)
    end
end

function PlayingState:draw()
    self.paddle:draw()
    self.level:draw()

    for k, ball in pairs(self.balls) do
        ball:draw()
    end

    self.pManager:draw()

    drawHealth(self.health, 3)

    love.graphics.printf('Level ' .. tostring(self.level.number), 10, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'left')
    love.graphics.printf('Score ' .. tostring(self.score), -10, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'right')
end