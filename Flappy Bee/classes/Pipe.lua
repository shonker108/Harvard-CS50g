local image = love.graphics.newImage('images/pipe.png')

Pipe = Class{}

PIPE_WIDTH = image:getWidth()
PIPE_HEIGHT = image:getHeight()

function Pipe:init(x, y, orientation)
    self.x = x
    self.y = orientation == 'down' and y or y - PIPE_HEIGHT
    self.orientation = orientation
end

function Pipe:update(dt)
    self.x = self.x - ROAD_SLIDE_SPEED * dt
end

function Pipe:draw()
    if self.orientation == 'top' then
        love.graphics.draw(image, self.x, self.y + PIPE_HEIGHT, 0, 1, -1)
    else
        love.graphics.draw(image, self.x, self.y, 0, 1, 1)
    end
end