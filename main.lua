-- Load classes
planet_class = require "planet"

function love.load()
    -- setup reandomizer
    love.math.setRandomSeed(love.timer.getTime())
    
    planet = planet_class.new()
end

function love.keypressed(key)
    if key == "g" then
        planet = planet_class.new()
    end
end

function love.update(dt)

end

function love.draw()
    planet:draw()
end