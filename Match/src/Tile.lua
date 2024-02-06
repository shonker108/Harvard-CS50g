Tile = Class{}

function Tile:init(gridX, gridY, color, pattern)
    self.gridX = gridX
    self.gridY = gridY
    
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    self.color = color
    self.pattern = pattern

    self.isShining = math.random(0, 9) == 0 and true or false

    self.particles = love.graphics.newParticleSystem( gSprites['star_particle'], 4 )
    self.particles:setColors(255, 255, 0, 212, 175, 55, 0, 0)
    self.particles:setParticleLifetime(0.5, 1.5)
    self.particles:setEmissionRate(2)
    self.particles:setEmissionArea('normal', 3, 3, 2 * math.pi)
    self.particles:stop()
end

function Tile:update(dt)
    self.particles:update(dt)
end

function Tile:draw(offsetX, offsetY)
    -- Draw shadows
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(gSprites['tiles'], gQuads[self.color][self.pattern], self.x + offsetX + 3, self.y + offsetY + 3)
    
    love.graphics.setColor(1, 1, 1, 1)
    
    if DEBUG_MODE then
        love.graphics.printf(tostring(self.gridY) .. ':' .. tostring(self.gridX), self.x + offsetX, self.y + offsetY, 32, 'center')
    end
    
    love.graphics.draw(gSprites['tiles'], gQuads[self.color][self.pattern], self.x + offsetX, self.y + offsetY)
    
    if self.isShining then
        love.graphics.setColor(1, 1, 0, 1)
        love.graphics.rectangle('line', self.x + offsetX, self.y + offsetY, 32, 32, 5)
    end
end

function Tile:drawParticles(offsetX, offsetY)
    love.graphics.draw(self.particles, self.x + offsetX + 16, self.y + offsetY + 16)
end