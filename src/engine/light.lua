local light = object:new()

function light:init(radius, smoothing, glow)
    self.radius = radius
    self.smoothing = smoothing or 1.5
    self.glow = glow or {1, 1}

    self.buffer = love.graphics.newCanvas(radius * 2, radius * 2)
    self.postBuffer = love.graphics.newCanvas(radius * 2, radius * 2)
end

-- render light
function light:draw(x, y, color, occ, norm, spec)

    -- occlusion variables
    shaders.light:send("occluders", occ)
    shaders.light:send("radius", self.radius)
    shaders.light:send("w", occ:getWidth())
    shaders.light:send("h", occ:getHeight())
    shaders.light:send("position", {x, y})
    shaders.light:send("smoothing", self.smoothing)
    shaders.light:send("glow", self.glow)

    -- render pre with occlusion
    self.buffer:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)

        love.graphics.setColor(color)
        
        love.graphics.setShader(shaders.light)
            love.graphics.circle("fill", self.radius, self.radius, self.radius)
        love.graphics.setShader()
        
        love.graphics.setColor(1, 1, 1, 1)
    end)

    shaders.blur:send("imageSize", {self.radius * 2, self.radius * 2})
    shaders.blur:send("lightRadius", self.radius)

    -- render post with blur
    self.postBuffer:renderTo(function()
        love.graphics.clear(0, 0, 0, 0)

        love.graphics.setShader(shaders.blur)

        love.graphics.draw(self.buffer)

        love.graphics.setShader()
    end)
    love.graphics.draw(self.postBuffer, x - self.radius, y - self.radius)
end

return light