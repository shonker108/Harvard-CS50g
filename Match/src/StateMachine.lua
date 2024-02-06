StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        update = function() end,  
        draw = function() end  
    }

    self.states = states or {}
    self.currentState = self.empty
end

function StateMachine:update(dt)
    self.currentState:update(dt)
end

function StateMachine:draw()
    self.currentState:draw()
end

function StateMachine:change(newStateName, params)
    self.currentState = self.states[newStateName](params)
end