Grid = Class{}

function Grid:init(size, initPattern)
    self.size = size

    self.tiles = {}

    self.initPattern = initPattern

    -- Init grid with first pattern tiles if there is no given init pattern
    self:generateNew(initPattern or 1)
end

function Grid:update(dt)
    for i = 1, self.size, 1 do
        for j = 1, self.size, 1 do
            if self.tiles[i][j] ~= nil then
                self.tiles[i][j]:update(dt)
            end
        end
    end
end

function Grid:generateNew(maxPattern)
    self.tiles = {}

    for y = 1, self.size, 1 do
        self.tiles[#self.tiles + 1] = {}

        for x = 1, self.size, 1 do
            local color = math.random(1, #gQuads)
            local pattern = math.random(1, maxPattern)

            local offset = (VIRTUAL_HEIGHT - 256) / 2

            table.insert(self.tiles[#self.tiles], Tile(
                x, y, color, pattern
            ))    
        end
    end
end

function Grid:checkMatches()
    local matches = {}
    local matchesCount = 1

    -- Checking the rows
    for y = 1, self.size, 1 do
        local prevColor = self.tiles[y][1].color
        local prevPattern = self.tiles[y][1].pattern

        matchesCount = 1

        for x = 2, self.size, 1 do
            if self.tiles[y][x].color == prevColor and
            self.tiles[y][x].pattern == prevPattern then
                matchesCount = matchesCount + 1
            else
                if matchesCount >= 3 then
                    local match = {}

                    for x2 = x - 1, x - matchesCount, -1 do
                        if self.tiles[y][x2].isShining then
                            match = self.tiles[y]
                            break
                        end

                        match[#match + 1] = self.tiles[y][x2]
                    end
                    
                    matches[#matches + 1] = match
                end

                matchesCount = 1

                if x >= 7 then
                    break
                end
            end

            prevColor = self.tiles[y][x].color
            prevPattern = self.tiles[y][x].pattern
        end

        if matchesCount >= 3 then
            local match = {}

            for x2 = 8, 8 - matchesCount + 1, -1 do
                if self.tiles[y][x2].isShining then
                    match = self.tiles[y]
                    break
                end

                match[#match + 1] = self.tiles[y][x2]
            end
            
            matches[#matches + 1] = match
        end
    end

    -- Checking the columns
    for x = 1, self.size, 1 do
        local prevColor = self.tiles[1][x].color
        local prevPattern = self.tiles[1][x].pattern

        matchesCount = 1

        for y = 2, self.size, 1 do
            if self.tiles[y][x].color == prevColor and
            self.tiles[y][x].pattern == prevPattern then
                matchesCount = matchesCount + 1
            else
                if matchesCount >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchesCount, -1 do
                        if self.tiles[y2][x].isShining then
                            match = self:getColumn(x)
                            break
                        end

                        match[#match + 1] = self.tiles[y2][x]
                    end
                    
                    matches[#matches + 1] = match
                end

                matchesCount = 1

                if y >= 7 then
                    break
                end
            end

            prevColor = self.tiles[y][x].color
            prevPattern = self.tiles[y][x].pattern
        end

        if matchesCount >= 3 then
            local match = {}

            for y2 = 8, 8 - matchesCount + 1, -1 do
                if self.tiles[y2][x].isShining then
                    match = self:getColumn(x)
                    break
                end

                match[#match + 1] = self.tiles[y2][x]
            end
            
            matches[#matches + 1] = match
        end
    end

    return matches
end

function Grid:deleteMatches(matches)
    local score = 0

    for i = 1, #matches, 1 do
        for j = 1, #matches[i], 1 do
            self.tiles[matches[i][j].gridY][matches[i][j].gridX] = nil
            score = score + 100
        end
    end

    return score
end

function Grid:getColumn(index)
    local column = {}

    for i = 1, self.size, 1 do
        column[#column + 1] = self.tiles[i][index]
    end

    return column
end

function Grid:dropTiles()
    local tilesToDrop = {}

    -- Drop old tiles
    for x = 1, self.size, 1 do
        local pullToY = -1

        for y = self.size, 1, -1 do
            if self.tiles[y][x] == nil and pullToY == -1 then
                pullToY = y
            end

            if self.tiles[y][x] ~= nil and pullToY ~= -1 then
                self.tiles[pullToY][x] = Tile(x, pullToY, self.tiles[y][x].color, self.tiles[y][x].pattern)
                self.tiles[pullToY][x].isShining = self.tiles[y][x].isShining
                
                local tempY = self.tiles[pullToY][x].y

                self.tiles[pullToY][x].y = self.tiles[y][x].y
                
                tilesToDrop[self.tiles[pullToY][x]] = { y = tempY }
                
                self.tiles[y][x] = nil

                pullToY = pullToY - 1
            end
        end
    end

    -- Drop new tiles
    for y = 1, self.size, 1 do
        for x = 1, self.size, 1 do
            if self.tiles[y][x] == nil then
                self.tiles[y][x] = Tile(x, y, math.random(1, #gQuads), math.random(1, self.initPattern))
                self.tiles[y][x].y = self.tiles[y][x].y - VIRTUAL_HEIGHT
                tilesToDrop[self.tiles[y][x]] = { y = self.tiles[y][x].y + VIRTUAL_HEIGHT }
            end
        end
    end

    Timer.tween(0.5, tilesToDrop)
end

function Grid:draw(offsetX, offsetY)
    for i = 1, self.size, 1 do
        for j = 1, self.size, 1 do
            if self.tiles[i][j] ~= nil then
                self.tiles[i][j]:draw(offsetX, offsetY)

                self.tiles[i][j]:drawParticles(offsetX, offsetY)
            end
        end
    end
end