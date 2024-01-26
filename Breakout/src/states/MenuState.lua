MenuState = Class{__include = BaseState}

function MenuState:init(params)
    self.choosenButton = 0
end

function MenuState:update(dt)
    if isKeyDown('up') then
        self.choosenButton = (self.choosenButton - 1) % 2
        gSFX['select']:play()
    elseif isKeyDown('down') then
        self.choosenButton = (self.choosenButton + 1) % 2
        gSFX['no-select']:play()
    end

    if isKeyDown('return') then
        -- On 'Start' button
        if self.choosenButton == 0 then
            gStateMachine:change('dresser')
        -- On 'Highscores' button
        else
            gStateMachine:change('highscores')
        end
        gSFX['confirm']:play()
    end
end

function MenuState:draw()
    if DEBUG_MODE then
        love.graphics.print('Button: ' .. tostring(self.choosenButton), 10, 10)
    end
    
    love.graphics.setFont(gFonts['big'])
    love.graphics.printf('Breakout', 0, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, 'center')

    if self.choosenButton == 0 then
        love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
    end
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + 35, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)

    if self.choosenButton == 1 then
        love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
    end

    love.graphics.printf('Highscores', 0, VIRTUAL_HEIGHT / 2 + 50, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
end