NewHighScoreState = Class{__include = BaseState}

function NewHighScoreState:init(params)
    self.name = {
        [0] = 65,
        [1] = 65,
        [2] = 65 
    }
    self.score = params.score
    self.selectedChar = 0
    self.gap = 3
    
    self.width = #self.name * 16 + #self.name * self.gap
    self.x = (VIRTUAL_WIDTH / 2) - (self.width / 2)  
end

function NewHighScoreState:update(dt)
    if isKeyDown('return') then
        local nameStr = ''
        for i = 0, #self.name do
            nameStr = nameStr .. string.char(self.name[i])
        end
        -- TODO: Write new highscore and name to the file
        writeHighscoreToFile(nameStr, self.score)
        gStateMachine:change('highscores')    
        
        gSFX['select']:play()
    end

    if isKeyDown('up') then
        self.name[self.selectedChar] = self.name[self.selectedChar] + 1
        
        if self.name[self.selectedChar] > 90 then
            self.name[self.selectedChar] = 65
        end
        gSFX['select']:play()
    elseif isKeyDown('down') then
        self.name[self.selectedChar] = self.name[self.selectedChar] - 1
        
        if self.name[self.selectedChar] < 65 then
            self.name[self.selectedChar] = 90
        end
        gSFX['select']:play()
    end

    if isKeyDown('left') then
        self.selectedChar = math.max(0, self.selectedChar - 1)
        gSFX['select']:play()
    elseif isKeyDown('right') then
        self.selectedChar = math.min(2, self.selectedChar + 1)
        gSFX['select']:play()
    end
end

function NewHighScoreState:draw()
    love.graphics.setFont(gFonts['big'])
    love.graphics.printf('NEW HIGHSCORE', 0, 40, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Enter your name', 0, 70, VIRTUAL_WIDTH, 'center')

    for i = 0, #self.name do
        if i == self.selectedChar then
            love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
        end

        love.graphics.print(string.char(self.name[i]), self.x, VIRTUAL_HEIGHT / 2)
        
        self.x = self.x + 16 + self.gap

        love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    end

    self.x = (VIRTUAL_WIDTH / 2) - (self.width / 2)

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to continue', 0, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, 'center')
end