HighScoresState = Class{__include = BaseState}

function HighScoresState:init(params)
    self.highscores = getHighscores()

    gDebugMessage = #self.highscores
end

function HighScoresState:update(dt)
    if isKeyDown('return') then
        gStateMachine:change('menu')    
    end
end

function HighScoresState:draw()
    love.graphics.setFont(gFonts['big'])
    love.graphics.printf('HIGHSCORES', 0, 20, VIRTUAL_WIDTH, 'center')

    if #self.highscores == 0 then
        love.graphics.printf('There is no any highscores! You can be the first!', 0, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, 'center')
    end

    local i = 1
    local y = 50

    love.graphics.setFont(gFonts['medium'])  
    while i <= #self.highscores do
        love.graphics.print(self.highscores[i], VIRTUAL_WIDTH / 2 - 100, y)
        love.graphics.print(self.highscores[i + 1], VIRTUAL_WIDTH / 2 + 50, y)

        i = i + 2
        y = y + 15
    end

    love.graphics.setFont(gFonts['small'])  
    love.graphics.printf('Press \'Enter\' to continue', 0, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'center')
end