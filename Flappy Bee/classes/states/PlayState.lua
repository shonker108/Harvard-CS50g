PlayState = Class{__includes = BasicState}

-- Variable keeps X where pipes will spawn
local spawnX = 416 + 20

-- Tracks distance between pairs of pipes
local xPointer = spawnX

function PlayState:init()
    self.bee = Bee()
    self.pipePairGenerator = PipePairGenerator()
    self.pipePairs = {}
    
    self.spawnX = VIRTUAL_WIDTH + 20
    self.xPointer = self.spawnX

    self.score = 0

end

function PlayState:update(dt)
    love.window.setTitle('Flappy Bee | FPS: ' .. tostring(love.timer.getFPS()))

    -- Pause/Unpause the game
    if RECENT_KEYS['p'] then
        if IS_GAME_RUNNING == true then
            IS_GAME_RUNNING = false

            SFX['loop']:pause()
        else
            IS_GAME_RUNNING = true
           
            SFX['loop']:play()
        end
    end
    
    if IS_GAME_RUNNING then
        -- Update pointer to keep track of a distance between last pipe and spawn
        self.xPointer = self.xPointer - ROAD_SLIDE_SPEED * dt
    
        -- 'Pipe pairs spawner'
        -- Spawns a new pair of pipes if distance
        -- between spawn point and current X-pointer
        -- is equal to or greater than the last distance between another
        -- pair of pipes
        if self.spawnX - self.xPointer >= self.pipePairGenerator.lDistanceBetween then
            table.insert(self.pipePairs, self.pipePairGenerator:generatePipePair())
    
            self.xPointer = self.spawnX
        end
    
        self.bee:update(dt)
    
        for key, value in pairs(self.pipePairs) do
            value:update(dt)
    
            -- End by hitting a pipe
            if self.bee:collides(value.topPipe) or self.bee:collides(value.downPipe) then
                SFX['hit']:play()
                
                STATE_MACHINE:change('score', { score = self.score})
            end

            if value.x + PIPE_WIDTH < self.bee.x and not value.wasPassedByPlayer then
                self.score = self.score + 1
                value.wasPassedByPlayer = true
            end
    
            if value.x < -PIPE_WIDTH then
                table.remove(self.pipePairs, key)
            end
        end

        -- End by hitting the road
        if self.bee.y + self.bee.height > VIRTUAL_HEIGHT - 16 then
            SFX['hit']:play()

            STATE_MACHINE:change('score', { score = self.score })
        end

    end

    RECENT_KEYS = {}
end

function PlayState:draw()
    for key, value in pairs(self.pipePairs) do
        -- Collision boxes
        --love.graphics.rectangle('line', value.topPipe.x, value.topPipe.y, PIPE_WIDTH, PIPE_HEIGHT)
        --love.graphics.rectangle('line', value.downPipe.x, value.downPipe.y, PIPE_WIDTH, PIPE_HEIGHT)
        value:draw()
    end

    self.bee:draw()

    love.graphics.print('SCORE: ' .. tostring(self.score), 10, 10)

    if IS_GAME_RUNNING == false then
        love.graphics.draw(PAUSE_IMAGE, VIRTUAL_WIDTH - PAUSE_IMAGE:getWidth() - 10, 10)
    end
end