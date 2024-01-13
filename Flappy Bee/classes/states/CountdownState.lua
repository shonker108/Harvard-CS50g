CountdownState = Class{__includes = BasicState}

function CountdownState:init()
    self.secondsPassed = 1
    self.dtSum = 0
end

function CountdownState:update(dt)
    self.dtSum = self.dtSum + dt
    
    if self.dtSum >= 1 then
        self.dtSum = self.dtSum % 1 
        self.secondsPassed = self.secondsPassed + 1

        if self.secondsPassed == 4 then
            STATE_MACHINE:change('play', {})
        end
    end
end

function CountdownState:draw()
    love.graphics.printf(tostring(self.secondsPassed), 0, 100, VIRTUAL_WIDTH, 'center')
end