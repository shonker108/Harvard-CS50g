Ball = Class{}

function Ball:init(x, y, dx)
    self.x = x
    self.y = y

    self.dx = dx
    self.dy = -200

    self.width = 8
    self.height = 8

    self.color = math.random(0, 6)

    self.belowFloor = false
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt

    if self.x < 0 then
        self.dx = -self.dx
        self.x = 0
        gSFX['wall-hit']:play()
    elseif self.x + self.width > VIRTUAL_WIDTH then
        self.dx = -self.dx
        self.x = VIRTUAL_WIDTH - self.width
        gSFX['wall-hit']:play()
    end

    self.y = self.y + self.dy * dt

    if self.y < 0 then
        self.dy = -self.dy
        gSFX['wall-hit']:play()
    end
    
    if self.y >= VIRTUAL_HEIGHT then
        self.belowFloor = true
    end
end

function Ball:collides(object)
    if self.x + self.width <= object.x or self.x >= object.x + object.width then
        return false
    end
    
    if self.y + self.height <= object.y or self.y >= object.y + object.height then
        return false
    end

    return true
end

function Ball:handleCollision(object)
    if self.x + 2 < object.x and self.dx > 0 then
        self.dx = -self.dx
        self.x = object.x - 8
    elseif self.x + 6 > object.x + object.width and self.dx < 0 then
        self.dx = -self.dx
        self.x = object.x + object.width
    elseif self.y < object.y then
        self.dy = -self.dy
        self.y = object.y - 8
    else
        self.dy = -self.dy
        self.y = object.y + object.height
    end
end

function Ball:draw()
    love.graphics.draw(gSprites['atlas'], gQuads['balls'][self.color], self.x, self.y)
end