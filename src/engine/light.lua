local light = object:new()

function light:init(radius, smoothing, glow, renderQuality)
    self.radius = radius
    self.smoothing = smoothing or 1.5
    self.glow = glow or {1, 1}

    self:setRenderQuality(renderQuality or 1)
end

function light:setRenderQuality(scalar)
    self.renderQuality = scalar

    self.tBuffer = love.graphics.newCanvas()
    self.preBuffer = love.graphics.newCanvas(self.radius * scalar * 2, self.radius * scalar * 2)
    self.postBuffer = love.graphics.newCanvas(self.radius * scalar * 2, self.radius * scalar * 2)
end

-- render light
function light:draw(x, y, z, color, occ, norm, spec)

    local scaledRadius = self.radius * self.renderQuality

    -- occlusion variables
    shaders.light:send("occluders", occ)
    shaders.light:send("normalMap", norm)
    shaders.light:send("spectralMap", spec)

    shaders.light:send("resolution", {love.graphics.getWidth(), love.graphics.getHeight()})
    shaders.light:send("radius", scaledRadius)
    shaders.light:send("w", occ:getWidth())
    shaders.light:send("h", occ:getHeight())
    shaders.light:send("position", {x, y, z})
    shaders.light:send("smoothing", self.smoothing)
    shaders.light:send("glow", self.glow)

    -- render pre with occlusion
    self.preBuffer:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)

        love.graphics.setColor(color)
        
        love.graphics.setShader(shaders.light)
            love.graphics.circle("fill", scaledRadius, scaledRadius, scaledRadius)
        love.graphics.setShader()
        
        love.graphics.setColor(1, 1, 1, 1)
    end)

    shaders.blur:send("imageSize", {scaledRadius * 2, scaledRadius * 2})
    shaders.blur:send("lightRadius", self.radius)

    -- render post with blur
    self.postBuffer:renderTo(function()
        love.graphics.clear(0, 0, 0, 0)

        love.graphics.setShader(shaders.blur)

        love.graphics.draw(self.preBuffer)

        love.graphics.setShader()
    end)

    love.graphics.scale(2 - self.renderQuality, 2 - self.renderQuality)

    love.graphics.draw(self.postBuffer, x * (self.renderQuality) - scaledRadius, y * (self.renderQuality) - scaledRadius)

    love.graphics.scale(1, 1)
end

return light