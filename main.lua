love.graphics.setDefaultFilter("nearest", "nearest")

require("src")
love.window.setVSync(0)

local world = lighting.world()

world:newLightTemplate("test1", 150, 1.5, {1, 1})
local l1 = world:addLight(100, 100, {1, 0, 0, 1}, "test1")

function love.update(dt)
    world:moveLight(l1, love.mouse.getPosition())
    world:update(dt)
end

function love.draw()
    world:draw()
end