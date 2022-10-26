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
    local scaledRadius = math.floor(self.radius * self.renderQuality)

    -- occlusion variables
    shaders.light:send("occluders", occ)
    shaders.light:send("normalMap", norm)
    shaders.light:send("spectralMap", spec)

    shaders.light:send("resolution", {love.graphics.getWidth() * self.renderQuality, love.graphics.getHeight() * self.renderQuality})
    shaders.light:send("radius", scaledRadius)

    -- get scaled position
    local px = math.floor(x * self.renderQuality)
    local py = math.floor(y * self.renderQuality)

    shaders.light:send("position", {px, py, z})
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

    -- pass blur info
    shaders.blur:send("imageSize", {scaledRadius * 2, scaledRadius * 2})
    shaders.blur:send("lightRadius", scaledRadius)

    -- render post with blur
    self.postBuffer:renderTo(function()
        love.graphics.clear(0, 0, 0, 0)

        love.graphics.setShader(shaders.blur)

        love.graphics.draw(self.preBuffer)

        love.graphics.setShader()
    end)

    -- draw post buffer
    love.graphics.draw(self.postBuffer, 
                       (px * 1 / self.renderQuality) - self.radius, (py * 1 / self.renderQuality) - self.radius, 
                       0, 1 / self.renderQuality, 1 / self.renderQuality)
end

return light