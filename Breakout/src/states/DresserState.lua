DresserState = Class{__include = BaseState}

function DresserState:init(params)
    self.choosenColor = 0
    
    self.paddle = Paddle(1, 0)
end

function DresserState:update(dt)
    if isKeyDown('return') then
        gStateMachine:change('serving', {
            paddle = self.paddle,
            level = Level(1, gLevelGenerator:generate(0)),
            health = MAX_HEALTH
        })   
        gSFX['confirm']:play()
    end

    if isKeyDown('left') then
        self.choosenColor = math.max(0, self.choosenColor - 1)
        self.paddle.color = self.choosenColor
        gSFX['select']:play()
    elseif isKeyDown('right') then
        self.choosenColor = math.min(3, self.choosenColor + 1)
        self.paddle.color = self.choosenColor
        gSFX['no-select']:play()
    end
end

function DresserState:draw()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Choose your paddle color and press Enter', 0, VIRTUAL_HEIGHT / 2 - 10, VIRTUAL_WIDTH, 'center')

    if self.choosenColor == 0 then
        love.graphics.draw(gSprites['atlas'], gQuads['arrows'][2], self.paddle.x - 30 - 16, self.paddle.y)
    else
        love.graphics.draw(gSprites['atlas'], gQuads['arrows'][0], self.paddle.x - 30 - 16, self.paddle.y)
    end  
    
    if self.choosenColor == 3 then
        love.graphics.draw(gSprites['atlas'], gQuads['arrows'][2], self.paddle.x + self.paddle.width + 30, self.paddle.y)
    else
        love.graphics.draw(gSprites['atlas'], gQuads['arrows'][1], self.paddle.x + self.paddle.width + 30, self.paddle.y)
    end

    self.paddle:draw()
end