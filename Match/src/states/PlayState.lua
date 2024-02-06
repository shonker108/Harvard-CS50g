PlayState = Class{}

function PlayState:init(params)
    self.level = params.level
    self.grid = params.grid

    self.score = params.score
    self.time = params.time

    self.target = params.target

    self.currentTilePos = { y = 1, x = 1 } 
    self.selectedTilePos = { y = -1, x = -1 }

    Timer.every(3, function()
        for i = 1, self.grid.size, 1 do
            for j = 1, self.grid.size, 1 do
                if self.grid.tiles[i][j].isShining then
                    self.grid.tiles[i][j].particles:start()
                    self.grid.tiles[i][j].particles:emit(math.random(1, 4))
                    self.grid.tiles[i][j].particles:stop()
                end
            end
        end
    end)

    Timer.every(1, function()
        self.time = self.time - 1
    end)

    self.fadeRectangleAlpha = 0

    self.actionsAllowed = true

    self.goToNextLevel = false
    self.isEnd = false
end

function PlayState:update(dt)
    self.grid:update(dt)

    if not self.goToNextLevel and self.score >= self.target then
        gSounds['next-level']:play()

        self.goToNextLevel = true

        Timer.tween(1, {
            [self] = { fadeRectangleAlpha = 1 }
        }):finish(function()
            gStateMachine:change('loading', { level = self.level + 1, maxPattern =  math.min(6, self.level + 1), score = self.score, time = self.time, target = self.score })
        end)
    end
    
    if not self.isEnd and self.time <= 0 then
        gSounds['game-over']:play()
        
        self.isEnd = true

        Timer.tween(1, {
            [self] = { fadeRectangleAlpha = 1 }
        }):finish(function()
            gStateMachine:change('end', { score = self.score })
        end)
    end

    if self.actionsAllowed then
        if love.keyboard.wasPressed('up') then
            self.currentTilePos.y = math.max(1, self.currentTilePos.y - 1) 
        elseif love.keyboard.wasPressed('down') then
            self.currentTilePos.y = math.min(GRID_SIZE, self.currentTilePos.y + 1) 
        end
    
        if love.keyboard.wasPressed('left') then
            self.currentTilePos.x = math.max(1, self.currentTilePos.x - 1) 
        elseif love.keyboard.wasPressed('right') then
            self.currentTilePos.x = math.min(GRID_SIZE, self.currentTilePos.x + 1) 
        end
    
        if love.keyboard.wasPressed('return') then
            gSounds['select']:play()

            -- If the first tile is not selected yet, then make it selected
            if self.selectedTilePos.x == -1 and self.selectedTilePos.y == -1 then
                self.selectedTilePos.x = self.currentTilePos.x
                self.selectedTilePos.y = self.currentTilePos.y
            -- Else handle two selected tiles
            else
                self.actionsAllowed = false
                -- If it is the same tile as before, make selected tile nil
                if self.currentTilePos.x == self.selectedTilePos.x and
                    self.currentTilePos.y == self.selectedTilePos.y then
                        self.selectedTilePos.x = -1
                        self.selectedTilePos.y = -1

                    self.actionsAllowed = true
                else

                    -- If the current tile is neighboor to the selected 
                    if self:isTileNeighboorToSelected(self.currentTilePos, self.selectedTilePos) then
                        -- TODO: Spaw tiles on the grid and screen
                        local currentTile = self.grid.tiles[self.currentTilePos.y][self.currentTilePos.x]
                        local selectedTile = self.grid.tiles[self.selectedTilePos.y][self.selectedTilePos.x]
                        
                        local tempX = currentTile.gridX
                        local tempY = currentTile.gridY
    
                        currentTile.gridX = selectedTile.gridX
                        currentTile.gridY = selectedTile.gridY
    
                        selectedTile.gridX = tempX
                        selectedTile.gridY = tempY
    
                        self.grid.tiles[currentTile.gridY][currentTile.gridX] = currentTile
                        self.grid.tiles[selectedTile.gridY][selectedTile.gridX] = selectedTile
    
                        
                        Timer.tween(0.25, {
                            [currentTile] = { x = selectedTile.x, y = selectedTile.y },
                            [selectedTile] = { x = currentTile.x, y = currentTile.y }
                        }):finish(function()
                            local matches = self.grid:checkMatches()
                            
                            -- Undo swap if we get no matches
                            if #matches == 0 then
                                tempX = currentTile.gridX
                                tempY = currentTile.gridY
    
                                currentTile.gridX = selectedTile.gridX
                                currentTile.gridY = selectedTile.gridY
    
                                selectedTile.gridX = tempX
                                selectedTile.gridY = tempY
    
                                self.grid.tiles[currentTile.gridY][currentTile.gridX] = currentTile
                                self.grid.tiles[selectedTile.gridY][selectedTile.gridX] = selectedTile
                            
                                Timer.tween(0.25, {
                                    [currentTile] = { x = selectedTile.x, y = selectedTile.y },
                                    [selectedTile] = { x = currentTile.x, y = currentTile.y }
                                }):finish(function()
                                    self.actionsAllowed = true
                                end)
                            else
                                gSounds['match']:play()

                                local deletedMatchesCount = self.grid:deleteMatches(matches)
                                self.score = self.score + deletedMatchesCount
                                self.time = self.time + deletedMatchesCount / 100
                                
                                self.grid:dropTiles()
        
                                self:handleNextMatches()
                            
                                self.actionsAllowed = true
                            end
                        end)
                        
                        self.currentTilePos.x = self.selectedTilePos.x
                        self.currentTilePos.y = self.selectedTilePos.y
                        
                        self.selectedTilePos.x = -1
                        self.selectedTilePos.y = -1
                        
                    else
                        gSounds['error']:play()
                        self.actionsAllowed = true
                    end

                end
            end
        end
    end

    if love.keyboard.wasPressed('n') then
        self.grid:generateNew(self.grid.initPattern)
    end

    Timer.update(dt)
end

function PlayState:handleNextMatches()
    local matches = self.grid:checkMatches()
    self.score = self.score + self.grid:deleteMatches(matches)
    self.grid:dropTiles()

    if #matches == 0 then
        return
    end

    self:handleNextMatches()
end

function PlayState:draw()
    local offsetX = VIRTUAL_WIDTH - 256 - (VIRTUAL_HEIGHT - 256) / 2
    local offsetY = (VIRTUAL_HEIGHT - 256) / 2
    
    self.grid:draw(offsetX, offsetY)

    -- Draw rectangle to indicate selected tile
    local rectanglePos = {
        self.grid.tiles[self.currentTilePos.y][self.currentTilePos.x].x,
        self.grid.tiles[self.currentTilePos.y][self.currentTilePos.x].y
    } 

    if self.selectedTilePos.x ~= -1 and self.selectedTilePos.y ~= -1 then
        rectanglePos[1] = self.grid.tiles[self.selectedTilePos.y][self.selectedTilePos.x].x
        rectanglePos[2] = self.grid.tiles[self.selectedTilePos.y][self.selectedTilePos.x].y
    end

    love.graphics.setColor(0.9, 0.9, 0.9, 0.5)
    love.graphics.rectangle('fill', rectanglePos[1] + offsetX, rectanglePos[2] + offsetY, 32, 32, 5)
    
    love.graphics.setColor(0.9, 0, 0, 1)
    love.graphics.rectangle(
        'line',
        self.grid.tiles[self.currentTilePos.y][self.currentTilePos.x].x + offsetX,
        self.grid.tiles[self.currentTilePos.y][self.currentTilePos.x].y + offsetY,
        32,
        32,
        5
    )
    
    self:drawLevelInfo(offset)

    if DEBUG_MODE then
        love.graphics.setColor(1, 1, 1, 1)
        if self.selectedTilePos.x ~= -1 and self.selectedTilePos.y ~= -1 then
            love.graphics.print('SEL ' .. tostring(self.selectedTilePos.y) .. ':' .. tostring(self.selectedTilePos.x), (VIRTUAL_HEIGHT - 256) / 2 + 5, (VIRTUAL_HEIGHT - 256) / 2 + 5)
        end
    
        love.graphics.print('CUR ' .. tostring(self.currentTilePos.y) .. ':' .. tostring(self.currentTilePos.x), (VIRTUAL_HEIGHT - 256) / 2 + 5, (VIRTUAL_HEIGHT - 256) / 2 + 25)
    end

    love.graphics.setColor(0.5, 0.5, 0.5, self.fadeRectangleAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)  
end

function PlayState:drawLevelInfo(offset)
    local offset = (VIRTUAL_HEIGHT - 256) / 2
    local rectangleWidth = VIRTUAL_WIDTH - 256 - 3 * offset
    local rectangleHeight = VIRTUAL_HEIGHT - 2 * offset - 100

    -- Draw rectangle with shadows
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', offset + 3, offset + 3, rectangleWidth, rectangleHeight, 5)
    
    love.graphics.setColor(0.5, 0.5, 0.5, 0.6)
    love.graphics.rectangle('fill', offset, offset, rectangleWidth, rectangleHeight, 5)

    -- Draw level info
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Level:\t' .. tostring(self.level), offset + 5, offset + 5, rectangleWidth - 5, 'center')
    love.graphics.printf('Score:\t' .. tostring(self.score), offset + 5, offset + 25, rectangleWidth - 5, 'center')
    love.graphics.printf('Target:\t' .. tostring(self.target), offset + 5, offset + 45, rectangleWidth - 5, 'center')
    love.graphics.printf('Time:\t' .. tostring(self.time), offset + 5, offset + 65, rectangleWidth - 5, 'center')
    
    -- Draw unlocked and locked patterns
    love.graphics.printf('Unlocked patterns', offset + 5, offset + 85, rectangleWidth - 5, 'center')
    local patternX = offset + 2
    
    for i = 1, self.grid.initPattern, 1 do
        love.graphics.draw(gSprites['tiles'], gQuads[1][i], patternX, offset + 115)
        patternX = patternX + 32 + 2
    end

    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    for i = self.grid.initPattern + 1, 6, 1 do
        love.graphics.draw(gSprites['tiles'], gQuads[1][i], patternX, offset + 115)
        patternX = patternX + 32 + 2
    end

end

function PlayState:isTileNeighboorToSelected(currentTilePos, selectedTilePos)
    -- Left neighboor
    if currentTilePos.x == selectedTilePos.x - 1 and
        currentTilePos.y == selectedTilePos.y then
            return true
    end

    -- Right neighboor
    if currentTilePos.x == selectedTilePos.x + 1 and
        currentTilePos.y == selectedTilePos.y then
            return true
    end
    
    -- Top neighboor
    if currentTilePos.x == selectedTilePos.x and
        currentTilePos.y == selectedTilePos.y + 1 then
            return true
    end

    -- Down neighboor
    if currentTilePos.x == selectedTilePos.x and
        currentTilePos.y == selectedTilePos.y - 1 then
            return true
    end

    return false
end