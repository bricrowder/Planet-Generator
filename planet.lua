local planet = {}
planet.__index = planet

function planet.new()
    local p = {}
    setmetatable(p, planet)

    local size = math.random(8,32)
    p.width = size
    p.height = size
    p.cell = {
        width = 16,
        height = 16
    }
    p.colour = {
        threshold = {
            planet = love.math.random(),
            clouds = love.math.random()
        },
        one = {
            love.math.random(),
            love.math.random(),
            love.math.random(),
            1.0
        },
        two = {
            love.math.random(),
            love.math.random(),
            love.math.random(),
            1.0
        },
        clouds = {
            love.math.random(75,100)*0.01,
            love.math.random(75,100)*0.01,
            love.math.random(75,100)*0.01,
            love.math.random(75,100)*0.01        
        }
    }
    p.rng = {
        planet = love.math.random(1,1000),
        clouds = love.math.random(1,1000)
    }
    p.freq = {
        planet = love.math.random(4),
        clouds = love.math.random(3,7)
    }
    p.pos = {
        base = {
            -- x = love.math.random(-(size/2), size/2) * p.cell.width,
            -- y = love.math.random(-(size/2), size/2) * p.cell.height,
            x = 0,
            y = 0
        },
        planet = {
            x = 0,
            y = 0
        },
        clouds = {
            x = 0,
            y = 0
        }
    }
    p.pos.planet.x = p.pos.base.x
    p.pos.planet.y = p.pos.base.y
    p.pos.clouds.x = p.pos.base.x
    p.pos.clouds.y = p.pos.base.y

    p.stencil = {
        origin = {
            x = p.width*p.cell.width/2 + p.pos.base.x,
            y = p.height*p.cell.height/2 + p.pos.base.y
        },
        radius = p.width*p.cell.width/2
    }
    p.speed = {
        planet = love.math.random(1,10),
        clouds = love.math.random(5,25)
    }

    -- planet and cloud arrays
    p.cells = {}
    p.cloudCells = {}

    -- get noise values
    for i=1, p.width, 1 do
        p.cells[i] = {}
        p.cloudCells[i] = {}
        for j=1, p.height, 1 do
            local ni = i/p.width-0.5+p.rng.planet
            local nj = j/p.height-0.5
            p.cells[i][j] = love.math.noise(ni*p.freq.planet,nj*p.freq.planet)

            local ci = i/p.width-0.5+p.rng.clouds
            local cj = j/p.height-0.5
            p.cloudCells[i][j] = love.math.noise(ci*p.freq.clouds,cj*p.freq.clouds)
        end
    end

    -- draw planet based on noise values
    p.texture = love.graphics.newCanvas(p.width*p.cell.width, p.height*p.cell.height)
    love.graphics.setCanvas(p.texture)
    for i=1, p.width, 1 do
        for j=1,p.height, 1 do
            local c = p.colour.one
            if p.cells[i][j] <= p.colour.threshold.planet then
                c = p.colour.two
            end
            --love.graphics.setColor(p.cells[i][j], p.cells[i][j], p.cells[i][j],1.0)
            love.graphics.setColor(c)
            love.graphics.rectangle("fill",(i-1)*p.cell.width,(j-1)*p.cell.height,p.cell.width, p.cell.height)
        end
    end

    -- draw clouds based on noise values
    p.cloudTexture = love.graphics.newCanvas(p.width*p.cell.width, p.height*p.cell.height)
    love.graphics.setCanvas(p.cloudTexture)
    for i=1, p.width, 1 do
        for j=1,p.height, 1 do
            local c = {0,0,0,0}
            if p.cloudCells[i][j] <= p.colour.threshold.clouds then
                c = p.colour.clouds
            end
            --love.graphics.setColor(p.cells[i][j], p.cells[i][j], p.cells[i][j],1.0)
            love.graphics.setColor(c)
            love.graphics.rectangle("fill",(i-1)*p.cell.width,(j-1)*p.cell.height,p.cell.width, p.cell.height)
        end
    end
    love.graphics.setCanvas()
    love.graphics.setColor(1,1,1,1)
    return p
end

function planet:update(dt)
    -- update texture draw positions - gives illusion of rotating
    self.pos.planet.x = self.pos.planet.x - dt*self.speed.planet
    if self.pos.planet.x <= -self.texture:getWidth()+self.pos.base.x then
        self.pos.planet.x = self.pos.base.x
    end
    self.pos.clouds.x = self.pos.clouds.x - dt*self.speed.clouds
    if self.pos.clouds.x <= -self.cloudTexture:getWidth()+self.pos.base.x then
        self.pos.clouds.x = self.pos.base.x
    end
end

function planet:draw(clouds)
    -- setup circular stencil
    love.graphics.setColor(0.25,0.25,0.25,1)
    love.graphics.stencil(
        function()
            love.graphics.circle("fill", self.stencil.origin.x, self.stencil.origin.y, self.stencil.radius)
        end, 
        "replace", 
        1
    )
    love.graphics.setStencilTest("greater", 0)

    -- draw planet
    love.graphics.draw(self.texture, self.pos.planet.x, self.pos.planet.y)
    love.graphics.draw(self.texture, self.pos.planet.x + self.texture:getWidth(), self.pos.planet.y)

    -- draw clouds
    if clouds then
        love.graphics.draw(self.cloudTexture, self.pos.clouds.x, self.pos.clouds.y)
        love.graphics.draw(self.cloudTexture, self.pos.clouds.x + self.cloudTexture:getWidth(), self.pos.clouds.y)
    end
    
    -- reset stencil
    love.graphics.setStencilTest()  
    love.graphics.setColor(1,1,1,1)
end

return planet