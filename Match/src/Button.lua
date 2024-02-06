Button = Class{}

function Button:init(x, y, text, action)
    self.x = x
    self.y = y

    self.text = text
    self.action = action
end

function Button:activate()
    self.action()
end

function Button:draw()
    love.graphics.print(self.text, self.x, self.y)
end