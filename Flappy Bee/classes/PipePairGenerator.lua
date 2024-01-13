PipePairGenerator = Class{}

function PipePairGenerator:init()
    -- Last recorded variables:
    -- The prefix 'l' stands for 'last'
    -- to shorten the names of variables...
    self.lDistanceBetween = 50
    self.lGapHeight = 90 / 2
    self.lY = VIRTUAL_HEIGHT / 2 - (self.lGapHeight / 2)

    -- Constrain variables:
    self.minDistanceBetween = 50 + PIPE_WIDTH
    self.maxDistanceBetween = 80 + PIPE_WIDTH
    self.minGapHeight = 40
    self.maxGapHeight = 90
    self.minY = 10
    -- We have to subtract 16 from maxY because of the road height (16)
    self.maxY = VIRTUAL_HEIGHT - self.lGapHeight - 10 - 16
    
    -- Random constrain variables:
    -- These variables mean the maximum difference between
    -- the new and the old variables.
    self.maxRandDistanceDiff = 30
    self.maxRandGapDiff = 10
    self.maxRandYDiff = 40
end

function PipePairGenerator:generatePipePair()
    local distanceBetween = self:generateDistance()
    local gapHeight = self:generateGap()
    local y = self:generateY()

    self.lDistanceBetween = distanceBetween
    self.lGapHeight = gapHeight
    self.lY = y

    return PipePair(distanceBetween, gapHeight, y)
end

function PipePairGenerator:generateDistance()
    local randDistanceBetween = math.random(
        -self.maxRandDistanceDiff + self.lDistanceBetween,
        self.maxRandDistanceDiff + self.lDistanceBetween
    )

    return math.max(self.minDistanceBetween, math.min(self.maxDistanceBetween, randDistanceBetween))
end

function PipePairGenerator:generateGap()
    return math.max(
        self.minGapHeight,
        math.min(
            self.maxGapHeight,
            math.random(-self.maxRandGapDiff + self.lGapHeight, self.maxRandGapDiff + self.lGapHeight)
        )
    )
end

function PipePairGenerator:generateY()
    return math.max(
        self.minY,
        math.min(
            self.maxY,
            math.random(-self.maxRandYDiff + self.lY, self.maxRandYDiff + self.lY)
        )
    )
end