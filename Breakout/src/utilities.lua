function writeHighscoreToFile(name, score)
    local highscores = readHighscoresFromFile()

    highscores = name .. '.' .. tostring(score) .. '.' .. highscores

    love.filesystem.write('highscores.txt', highscores)
end

function readHighscoresFromFile()
    return love.filesystem.read('highscores.txt')
end

--[[
    Function returns table with strings where
    every two elements are name and score:

    result[1] - name #1 
    result[2] - score #1
    result[3] - name #2
    result[4] - score #2
    ... and so on ...
--]]
function getHighscores()
    local result = {}
    local highscores = readHighscoresFromFile()
    local start = 0  

    for i = 1, #highscores do
        local c = string.sub(highscores, i, i)

        if c == '.' then
            result[#result + 1] = string.sub(highscores, start, i - 1)
            gDebugMessage = result[#result - 1]
            start = i + 1

            if #result == 2 * 10 then
                break
            end
        end
    end

    return result
end