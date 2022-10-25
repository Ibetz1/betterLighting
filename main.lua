love.graphics.setDefaultFilter("nearest", "nearest")

require("src")
love.window.setVSync(0)

local world = lighting.world()

world:newLightTemplate("test1", 300, 1, {1, 1})
local l1 = world:addLight(100, 100, 0.5, {1, 0, 0, 1}, "test1")

local z = 0
function love.update(dt)
    if z < 0 then z = 0 end
    if z > 1 then z = 1 end

    if love.keyboard.isDown("w") then z = z + 0.01 end
    if love.keyboard.isDown("s") then z = z - 0.01 end

    world:moveLight(l1, love.mouse.getX(), love.mouse.getY(), z)
    world:update(dt)
end

function love.draw()
    love.graphics.print(love.timer.getFPS())
    world:draw()
end

function love.mousepressed(x, y)
    -- world:addLight(x, y, {0, 1, 0}, "test1")
end