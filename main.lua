love.graphics.setDefaultFilter("nearest", "nearest")

require("src")
love.window.setVSync(0)

local world = lighting.world()


local utex  = love.graphics.newImage("assets/machine.png")
local unorm = love.graphics.newImage("assets/machine_normal.png")
local uocc  = love.graphics.newImage("assets/machine_occluder.png")
local uspec = love.graphics.newImage("assets/machine_spectral.png")

world:newLightTemplate("test1", 300, 0.6, {0.5, 0.5}, 1/3)


world:newTextureTemplate("utex", utex, uocc, unorm, uspec)
world:setTextureTemplateScale("utex", 3, 3)

for x = 1, 4 do
    for y = 1,3 do
        world:renderTextureStatic("utex", (64 * x) - 64, (64 * y - 64))
    end
end

local l1 = world:addLight(100, 100, 1, {1, 1, 1, 1}, "test1")

local z = 0;
function love.update(dt)
    z = math.min(math.max(z, 0), 2)
    
    if love.keyboard.isDown("w") then z = z + 1 * dt end
    if love.keyboard.isDown("s") then z = z - 1 * dt end

    world:moveLight(l1, love.mouse.getX(), love.mouse.getY(), z)
    world:update(dt)
end

function love.draw()
    world:draw()
end

function love.mousepressed(x, y)
    world:addLight(x, y, z, {1, 0.4, 0, 1}, "test1")
end