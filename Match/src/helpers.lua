function getTileQuads(atlas)
    quads = {}

    for y = 1, 9, 1 do
        quads[#quads + 1] = {}

        for x = 1, 6, 1 do
            table.insert(quads[#quads], love.graphics.newQuad(
                (x - 1) * 32, (y - 1) * 32,
                32, 32, atlas:getDimensions()
            ))
        end
    
        quads[#quads + 1] = {}

        for x = 7, 12, 1 do
            table.insert(quads[#quads], love.graphics.newQuad(
                (x - 1) * 32, (y - 1) * 32,
                32, 32, atlas:getDimensions()
            ))
        end
    end

    return quads
end