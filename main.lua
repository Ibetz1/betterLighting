love.graphics.setDefaultFilter("nearest", "nearest")

require("src")
love.window.setVSync(0)

local world = lighting.world()


local utex  = love.graphics.newImage("assets/machine.png")
local unorm = love.graphics.newImage("assets/machine_normal.png")
local uocc  = love.graphics.newImage("assets/machine_occluder.png")
local uspec = love.graphics.newImage("assets/machine_spectral.png")

world:newLightTemplate("test1", 300, 0.99, {0.5, 0.5})
world:newTextureTemplate("utex", utex, uocc, unorm, uspec)
world:setTextureTemplateScale("utex", 3, 3)

for x = 1, 4 do
    for y = 1,3 do
        world:renderTextureStatic("utex", (64 * x) - 64, (64 * y - 64))
    end
end


-- local l1 = world:addLight(100, 100, 1, {1, 1, 1, 1}, "test1")

function love.update(dt)
    -- world:moveLight(l1, love.mouse.getX(), love.mouse.getY(), 2)
    world:update(dt)
end

function love.draw()
    world:draw()
    love.graphics.print(love.timer.getFPS()) 
end

function love.mousepressed(x, y)
    world:addLight(x, y, 1, {1, 0.4, 0, 1}, "test1")
end