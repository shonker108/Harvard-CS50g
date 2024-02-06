StartState = Class{__include = BaseState}

function StartState:init()
    self.letters = {
        {'M', -108},
        {'A', -64},
        {'T', -28},
        {'C', 2},
        {'H', 40},
        {'3', 112}
    }

    self.letterColors = {
        { 255/255, 180/255, 180/255, 255/255 },
        { 180/255, 255/255, 180/255, 255/255 },
        { 180/255, 180/255, 255/255, 255/255 },
        { 255/255, 255/255, 180/255, 255/255 },
        { 255/255, 180/255, 255/255, 255/255 },
        { 180/255, 255/255, 255/255, 255/255 }
    }

    self.letterTimer = Timer.every(0.75, function()
        self.letterColors[0] = self.letterColors[#self.letterColors]

        for i = #self.letterColors, 1, -1 do
            self.letterColors[i] = self.letterColors[i - 1]
        end
    end)

    self.fadeRectangleAlpha = 0

    self.choosenButtonIndex = 1

    self.grid = Grid(GRID_SIZE, 6)

    self.isPaused = false
end

function StartState:update(dt)
    if not self.isPaused then
        if love.keyboard.wasPressed('up') then
            self.choosenButtonIndex = math.max(1, self.choosenButtonIndex - 1)
        elseif love.keyboard.wasPressed('down') then
            self.choosenButtonIndex = math.min(2, self.choosenButtonIndex + 1)
        end

        if love.keyboard.wasPressed('return') then
            gSounds['select']:play()
            
            if self.choosenButtonIndex == 1 then
                self.isPaused = true
           
                Timer.tween(1, {
                    [self] = {fadeRectangleAlpha = 1}
                }):finish(function()
                    gStateMachine:change('loading', { level = 1, maxPattern = 1, score = 0, time = 60, target = 0 })
                end)

                self.letterTimer:remove()
            else
                love.event.quit()
            end

        end
    end
    
    Timer.update(dt)
end

function StartState:draw()
    local offsetX = VIRTUAL_WIDTH / 2 - 128
    local offsetY = (VIRTUAL_HEIGHT - 256) / 2
    
    self.grid:draw(offsetX, offsetY)

    -- Draw a bit transparent rectangle
    love.graphics.setColor(0, 0, 0, 0.35)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(1, 1, 1 ,1)

    -- Draw title
    love.graphics.setFont(gFonts['title'])
    for i = 1, #self.letters, 1 do
        love.graphics.setColor(self.letterColors[i])
        love.graphics.printf(self.letters[i][1], 0, VIRTUAL_HEIGHT / 2 - 50, VIRTUAL_WIDTH + self.letters[i][2], 'center')
    end

    love.graphics.setFont(gFonts['big'])
    drawTextShadow('Start', VIRTUAL_HEIGHT / 2 - love.graphics.getFont():getHeight() / 2 + 10)
    -- Draw buttons
    if self.choosenButtonIndex == 1 then
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(0.75, 0.1, 0.1, 1)
    end

    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 - love.graphics.getFont():getHeight() / 2 + 10, VIRTUAL_WIDTH, 'center')
    
    drawTextShadow('Quit game', VIRTUAL_HEIGHT / 2 - love.graphics.getFont():getHeight() / 2 + 35)
    if self.choosenButtonIndex == 2 then
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(0.75, 0.1, 0.1, 1)
    end

    love.graphics.printf('Quit game', 0, VIRTUAL_HEIGHT / 2 - love.graphics.getFont():getHeight() / 2 + 35, VIRTUAL_WIDTH, 'center')

    -- Draw fade rectangle
    love.graphics.setColor(0.5, 0.5, 0.5, self.fadeRectangleAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(1, 1, 1, 1)
end

function drawTextShadow(text, y)
    love.graphics.setColor(0, 0, 0, 1)

    love.graphics.printf(text, 1, y, VIRTUAL_WIDTH, 'center')
end