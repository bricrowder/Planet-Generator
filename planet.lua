local planet = {}
planet.__index = planet

function planet.new()
    local p = {}
    setmetatable(p, planet)

    p.width = 32
    p.height = 32
    p.cell = {
        width = 16,
        height = 16
    }
    p.colour = {
        love.math.random(),
        love.math.random(),
        love.math.random(),
        1.0
    }
    p.rng = love.math.random(1,1000)
    --p.rng = 10.9
    p.cells = {}
    for i=1, p.width, 1 do
        p.cells[i] = {}
        for j=1, p.height, 1 do
            local freq = 1.5
            local ni = i/p.width-0.5+p.rng
            local nj = j/p.height-0.5
            p.cells[i][j] = love.math.noise(ni*freq,nj*freq)
        end
    end

    -- draw to texture
    p.texture = love.graphics.newCanvas(p.width*p.cell.width, p.height*p.cell.height)
    love.graphics.setCanvas(p.texture)
    for i=1, p.width, 1 do
        for j=1,p.height, 1 do
            love.graphics.setColor(p.cells[i][j], p.cells[i][j], p.cells[i][j],1.0)
            love.graphics.rectangle("fill",(i-1)*p.cell.width,(j-1)*p.cell.height,p.cell.width, p.cell.height)
        end
    end
    love.graphics.setCanvas()

    return p
end

function planet:draw()
    love.graphics.setColor(self.colour)
    love.graphics.draw(self.texture)
    love.graphics.setColor(1,1,1,1)
end

return planet