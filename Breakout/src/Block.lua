Block = Class{}

gParticleColors = {
    -- Blue
    [0] = {
        91/255,
        110/255,
        225/255
    },

    -- Green
    [1] = {
        75/255,
        105/255,
        47/255
    },

    -- Red
    [2] = {
        172/255,
        50/255,
        50/255
    },

    -- Purple
    [3] = {
        118/255,
        66/255,
        137/255
    },

    -- Gold
    [4] = {
        223/255,
        113/255,
        38/255
    },

    -- Grey
    [5] = {
        89/255,
        86/255,
        82/255
    }
}

function Block:init(x, y, tier, isActive, score)
    self.x = x
    self.y = y
    self.tier = tier
    self.isActive = isActive
    self.isKey = false

    self.width = 32
    self.height = 16

    self.score = score
    
    -- Particles
    self.particles = love.graphics.newParticleSystem(gSprites['particle'], 64)
    self.particles:setParticleLifetime(1, 3)
    self.particles:setEmissionArea('normal', 10, 10)
    self.particles:setLinearAcceleration(1, 10, 3, 15)
end

function Block:update(dt)
    self.particles:update(dt)
end

function Block:draw()
    if self.isActive == true then
        love.graphics.draw(gSprites['atlas'], gQuads['blocks'][self.tier], self.x, self.y)
    end
end

function Block:drawParticles()
    love.graphics.draw(self.particles, self.x + 16, self.y + 8)
end