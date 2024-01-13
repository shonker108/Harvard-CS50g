PipePair = Class{}

function PipePair:init(distanceBetween, gapHeight, y)
    self.spawnOffset = 20

    self.x = math.max(VIRTUAL_WIDTH + self.spawnOffset, VIRTUAL_WIDTH + self.spawnOffset + distanceBetween)
    self.y = y

    self.topPipe = Pipe(self.x, self.y, 'top')
    self.downPipe = Pipe(self.x, self.y + gapHeight, 'down')

    self.wasPassedByPlayer = false
end

function PipePair:update(dt)
    self.x = self.x - ROAD_SLIDE_SPEED * dt

    self.topPipe:update(dt)
    self.downPipe:update(dt)
end

function PipePair:draw()
    self.topPipe:draw()
    self.downPipe:draw()
end