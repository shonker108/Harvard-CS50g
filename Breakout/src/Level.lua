Level = Class{}

function Level:init(number, blocks, keyExists, keyIndex)
    self.number = number
    self.blocks = blocks 

    self.keyExists = keyExists
    self.keyIndex = keyIndex
end

function Level:update(dt)
    for i = 1, #self.blocks do
        self.blocks[i]:update(dt)
    end
end

function Level:isEmpty()
    for i = 1, #self.blocks do
        -- We don't count key block because it's a valuable block
        -- Thus, if there is only this block, we're going to the next level
        if self.blocks[i].isActive and not self.blocks[i].isKey then
            return false
        end
    end

    return true
end

function Level:draw()
    for i = 1, #self.blocks do
        self.blocks[i]:draw()
        self.blocks[i]:drawParticles()
    end
end