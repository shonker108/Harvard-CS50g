Powerup = Class{}

local speed = 30

function Powerup:init(x, y, type)
    self.x = x
    self.y = y

    self.width = 16
    self.height = 16

    -- It's an integer for more convinient draw code
    -- 0 is the Extra Ball powerup
    -- 1 is the Key
    self.type = type

    self.toDelete = false
end

function Powerup:update(dt)
    self.y = self.y + speed * dt

    if self.y > VIRTUAL_HEIGHT then
        self.toDelete = true
    end
end

function Powerup:collides(paddle)
    if self.x > paddle.x + paddle.width or self.x + self.width < paddle.x then
        return false
    end

    if self.y > paddle.y + paddle.height or self.y + self.height < paddle.y then
        return false
    end

    return true
end

function Powerup:draw()
    love.graphics.draw(gSprites['atlas'], gQuads['powerups'][self.type], self.x, self.y)
end