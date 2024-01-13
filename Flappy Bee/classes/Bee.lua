Bee = Class{}

function Bee:init()
    self.image = love.graphics.newImage('images/bee.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    self.dy = 0

    self.jumpStrength = 3
end

-- AABB collision detection
function Bee:collides(pipe)
    return (self.x < pipe.x + PIPE_WIDTH) and
           (self.x + self.width > pipe.x) and
           (self.y < pipe.y + PIPE_HEIGHT - 5) and
           (self.y + self.height > pipe.y + 5) 
end

function Bee:update(dt)
    self.dy = self.dy + GRAVITY_STRENGTH * dt
    
    if RECENT_KEYS['space'] then
        SFX['jump']:play()

        self.dy = -self.jumpStrength
    end
    
    self.y = self.y + self.dy
end

function Bee:draw()
    love.graphics.draw(self.image, self.x, self.y)
end