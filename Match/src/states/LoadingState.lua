LoadingState = Class{}

function LoadingState:init(params)
    self.level = params.level

    self.maxPattern = params.maxPattern
    self.grid = Grid(GRID_SIZE, self.maxPattern)

    self.fadeRectangleAlpha = 1
    self.sliderY = -60

    self.score = params.score
    self.time = params.time
    self.target = params.target + 1000

    Timer.tween(0.5, {
        [self] = { fadeRectangleAlpha = 0 }
    }):finish(function()
        Timer.tween(0.5, {
            [self] = { sliderY = VIRTUAL_HEIGHT / 2 - 30 }
        }):finish(function()
            Timer.after(1, function()
                Timer.tween(0.5, {
                    [self] = { sliderY = VIRTUAL_HEIGHT }
                }):finish(function()
                    gStateMachine:change('play', {
                        level = self.level, grid = self.grid, score = self.score, time = self.time, target = self.target
                    })
                end)
            end)
        end)
    end)
end

function LoadingState:update(dt)
    Timer.update(dt)
end

function LoadingState:draw()
    local offsetX = VIRTUAL_WIDTH - 256 - (VIRTUAL_HEIGHT - 256) / 2
    local offsetY = (VIRTUAL_HEIGHT - 256) / 2

    self.grid:draw(offsetX, offsetY)

    love.graphics.setColor(0.5, 0.5, 0.5, self.fadeRectangleAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(0.1, 0.75, 0.1, 0.5)
    love.graphics.rectangle('fill', 0, self.sliderY, VIRTUAL_WIDTH, 60)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Level ' .. tostring(self.level), 0, self.sliderY + 10, VIRTUAL_WIDTH, 'center')
end