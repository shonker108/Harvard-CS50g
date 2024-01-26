PowerupManager = Class{}

local timer = 0

function PowerupManager:init(keyAvailible)
    self.powerups = {}
    self.keyAvailible = keyAvailible

    gDebugMessage = 'KEY POWERUP: ' .. (self.keyAvailible == true and '+' or '-')
end

function PowerupManager:update(dt)
    timer = timer + dt

    if timer >= SECONDS_BEFORE_POWERUP then
        timer = 0

        -- Generate the Extra ball powerup
        if not self.keyAvailible then
            self:generate(0)

        -- Else, randomly generate either Extra ball or Key powerup
        else
            self:generate(math.random(0, 1))
        end
    end

    for i = 1, #self.powerups do
        self.powerups[i]:update(dt)
    end
end

function PowerupManager:generate(type)
    self.powerups[#self.powerups + 1] = Powerup(
        math.random(0, VIRTUAL_WIDTH - 16),
        math.random(0, 50),
        type
    )
end

-- Clears powerups table by deleting powerups with enabled 'toDelete' flag
function PowerupManager:clear()
    local temp = {}

    for i = 1, #self.powerups do
        if not self.powerups[i].toDelete then
            temp[#temp + 1] = self.powerups[i]
        end 
    end

    self.powerups = temp
end

function PowerupManager:deleteKeyPowerups()
    for i = 1, #self.powerups do
        if self.powerups[i].type == 1 then
            self.powerups[i].toDelete = true
        end
    end
end

function PowerupManager:draw()
    for i = 1, #self.powerups do
        self.powerups[i]:draw()
    end
end