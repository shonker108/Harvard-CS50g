ScoreState = Class{__includes = BasicState}

local maxScore = 0
local prevMaxScore = 0
local firstPlaceMedalImage = love.graphics.newImage('images/firstplacemedal.png')
local secondPlaceMedalImage = love.graphics.newImage('images/secondplacemedal.png')
local thirdPlaceMedalImage = love.graphics.newImage('images/thirdplacemedal.png')

function ScoreState:init()
    self.score = STATE_PARAMS.score
    self.highscore = false

    if self.score > maxScore then
        self.highscore = true
        prevMaxScore = maxScore
        maxScore = self.score
    end
end

function ScoreState:update(dt)
    if RECENT_KEYS['space'] then
        STATE_MACHINE:change('menu', {})
    end

    RECENT_KEYS = {}
end

function ScoreState:draw()
    if self.highscore then
        love.graphics.printf('NEW HIGHSCORE!\n' .. tostring(maxScore), 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Previous highscore: ' .. tostring(prevMaxScore), 0, 75, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Your score: ' .. tostring(self.score), 0, 50, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.printf('Here is your medal!', 0, 100, VIRTUAL_WIDTH, 'center')
    if self.score <= 15 then
        love.graphics.draw(thirdPlaceMedalImage, VIRTUAL_WIDTH / 2 - (thirdPlaceMedalImage:getWidth() / 2), 130)
    elseif self.score > 15 and self.score <= 30 then
        love.graphics.draw(secondPlaceMedalImage, VIRTUAL_WIDTH / 2 - (secondPlaceMedalImage:getWidth() / 2), 130)
    else
        love.graphics.draw(firstPlaceMedalImage, VIRTUAL_WIDTH / 2 - (firstPlaceMedalImage:getWidth() / 2), 130)
    end
end