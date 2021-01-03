-- Load classes
planet_class = require "planet"

function love.load()
    -- setup reandomizer
    love.math.setRandomSeed(love.timer.getTime())
    
    planet = planet_class.new()

    clouds = false
end

function love.keypressed(key)
    if key == "g" then
        planet = planet_class.new()
    end
    if key == "c" then
        clouds = not clouds
    end    
end

function love.update(dt)
    planet:update(dt)
end

function love.draw()

    love.graphics.print("g - generate new planet\nc - cloud toggle", 600, 0)

    planet:draw(clouds)
end