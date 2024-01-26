Paddle = Class{}

local paddleSpeed = 200

function Paddle:init(size, color)
    self.size = size
    self.color = color
    
    self.width = (size + 1) * 32
    self.height = 16

    self.x = VIRTUAL_WIDTH / 2 - self.width / 2 
    self.y = VIRTUAL_HEIGHT - self.height - 30
    
    self.dx = 0
end

function Paddle:update(dt)
    if love.keyboard.isDown('left') then
        self.dx = -paddleSpeed
    elseif love.keyboard.isDown('right') then
        self.dx = paddleSpeed
    else
        self.dx = 0
    end

    self.x = math.max(0, self.x + self.dx * dt)

    self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
end

function Paddle:changeSize(newSize)
    if newSize < 0 or newSize > 3 then
        return
    end

    self.size = newSize

    local centerX = self.x + self.width / 2

    self.width = 32 * (self.size + 1)

    self.x = centerX - self.width / 2
end

function Paddle:draw()
    love.graphics.draw(gSprites['atlas'], gQuads['paddles'][self.color * 4 + self.size], self.x, self.y)
end