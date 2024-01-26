GameOverState = Class{__include = BaseState}

function GameOverState:init(params)
    self.score = params.score
    self.highscore = tonumber(getHighscores()[2]) or 0
end

function GameOverState:update(dt)

    if self.highscore < self.score then
        self.highscore = self.score
        gStateMachine:change('new_highscore', { score = self.score })
    end
    
    if isKeyDown('return') then
        gStateMachine:change('menu')    
        gSFX['confirm']:play()
    end
end

function GameOverState:draw()
    love.graphics.setFont(gFonts['big'])
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to continue', 0, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'center')
end