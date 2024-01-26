LevelGenerator = Class{}

function LevelGenerator:generate(levelNum)
    local blocks = {}

    local rows = math.random(1, 5)
    local columns = math.random(5, 11)

    columns = columns % 2 == 0 and columns + 1 or columns

    local width = columns * 32

    local xStart = VIRTUAL_WIDTH / 2 - (width / 2)

    -- 33% of the key existing
    local keyExists = math.random(0, 2) == 0 and true or false

    for y = 1, rows do
        local tier = math.random(
            -- Min tier
            math.max(0, math.min(4, levelNum - 2)),

            -- Max tier
            math.min(4, levelNum)
        )

        local toMakeGaps = math.random(0, 1) == 0 and true or false
        local gapFlag = false
        
        if toMakeGaps then
            gapFlag = math.random(0, 1) == 0 and true or false
        end

        local toAlternateTiers = math.random(0, 1) == 0 and true or false
        local alternateFlag = false

        if toAlternateTiers then
            alternateFlag = math.random(0, 1) == 0 and true or false
        end

        local alternativeTier = math.random(0, tier)

        for x = 1, columns do
            if toMakeGaps and not gapFlag then
                gapFlag = true
            else
                gapFlag = false
            end

            blocks[#blocks + 1] = Block(
                xStart + (x - 1) * 32,
                (y - 1) * 16 + 3,
                tier,
                not gapFlag,
                50 * levelNum + 100
            )

            if toAlternateTiers and not alternateFlag then
                alternateFlag = true
            else
                alternateFlag = false
            end

            if alternateFlag then
                blocks[#blocks].tier = alternativeTier
            end
        end
    end

    local keyIndex = -1
    -- The Key block integration
    if keyExists then
        keyIndex = math.random(1, #blocks)
        
        while not blocks[keyIndex].isActive do
            keyIndex = math.random(1, #blocks)
        end

        blocks[keyIndex] = Block(
            blocks[keyIndex].x,
            blocks[keyIndex].y,
            6,                  -- Key block tier is 6
            true,               -- It always exists (unless 'keyExists' equals to false)
            1000 * levelNum / 2
        )

        blocks[keyIndex].isKey = true
    end
    

    return blocks, keyExists, keyIndex
end