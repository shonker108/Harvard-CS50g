EndState = Class{}

function EndState:init(params)
    self.score = params.score
    self.time = 3
    
    Timer.after(3, function()
        gStateMachine:change('start')
    end)

    Timer.every(1, function()
        self.time = self.time - 1
    end)
end

function EndState:update(dt)

    Timer.update(dt)
end

function EndState:draw()
    local offset = (VIRTUAL_HEIGHT - 256) / 2
    
    love.graphics.setFont(gFonts['big'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('You scored ' .. tostring(self.score) .. ' points!', offset, VIRTUAL_HEIGHT / 2 - offset, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Closing in ' .. tostring(self.time) .. '...', offset, VIRTUAL_HEIGHT - offset - 20, VIRTUAL_WIDTH, 'center')
end