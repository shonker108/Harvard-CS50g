MenuState = Class{__includes = BasicState}

function MenuState:init()

end

function MenuState:update(dt)
    if RECENT_KEYS['space'] then
        STATE_MACHINE:change('countdown', {})
    end

    RECENT_KEYS = {}
end

function MenuState:draw()
    love.graphics.printf('FLAPPY BEE', 0, 60, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press \'Space\' to play...', 0, 90, VIRTUAL_WIDTH, 'center')
end