function GetPaddleQuads(atlas)
    local result = {}

    local x = 0
    local y = 64

    local index = 0

    for i = 0, 3 do
        result[index] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        index = index + 1

        result[index] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
        index = index + 1
        
        result[index] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
        index = index + 1
        
        result[index] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
        index = index + 1

        y = y + 32
    end

    return result
end

function GetArrowQuads(atlas)
    local result = {}

    local x = 0
    local y = 208

    for i = 0, 2 do
        result[i] = love.graphics.newQuad(x, y, 16, 16, atlas:getDimensions())
        x = x + 16
    end

    return result
end

--[[
    The 'Index - Tier' table:
        I   |   C
        ---------
        0   |   Blue    
        1   |   Green    
        2   |   Red    
        3   |   Purple    
        4   |   Gold   
        5   |   Grey (Unlocked block)    
        6   |   Grey + Key (Locked block)    
--]]
function GetBlockQuads(atlas)
    local result = {}

    local x = 0
    local y = 0

    local index = 0

    while index < 6 do
        result[index] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        index = index + 1

        x = x + 128

        if x >= 192 then
            x = x - 192
            y = y + 16
        end
    end


    result[index] = love.graphics.newQuad(160, 48, 32, 16, atlas:getDimensions())

    return result
end

function GetBallQuads(atlas)
    local result = {}

    local x = 96
    local y = 48

    local index = 0

    for i = 0, 3 do
        result[index] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        index = index + 1

        x = x + 8
    end

    x = 96
    y = y + 8

    for i = 0, 2 do
        result[index] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        index = index + 1

        x = x + 8
    end

    return result
end

function GetHeartQuads(atlas)
    local result = {}

    -- Full heart
    result[0] = love.graphics.newQuad(128, 48, 10, 9, atlas:getDimensions())
    -- Empty heart
    result[1] = love.graphics.newQuad(138, 48, 10, 9, atlas:getDimensions())

    return result
end


function GetPowerupQuads(atlas)
    local result = {}

    -- Extra ball powerup
    result[0] = love.graphics.newQuad(128, 192, 16, 16, atlas:getDimensions())
    -- Key powerup
    result[1] = love.graphics.newQuad(144, 192, 16, 16, atlas:getDimensions())

    return result
end