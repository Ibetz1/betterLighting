local world = object:new()

function world:init(renderQuality)
    self.staticBuffers = {
        occlusion = love.graphics.newCanvas(),
        spectral = love.graphics.newCanvas(),
        normal = love.graphics.newCanvas(),
        texture = love.graphics.newCanvas()
    }

    self.dynamicBuffers = {
        occlusion = love.graphics.newCanvas(),
        spectral = love.graphics.newCanvas(),
        normal = love.graphics.newCanvas(),
        texture = love.graphics.newCanvas(),
        lighting = love.graphics.newCanvas(),
        screen = love.graphics.newCanvas()
    }

    self.renderQuality = renderQuality

    self.lightTemplates = {}
    self.lights = {}

    self.textureTemplates = {}
    self.textures = {}
end

-- new texture template
function world:newTextureTemplate(name, ...)
    self.textureTemplates[name] = lighting.texture(...)
end

-- renders static texture
function world:renderStaticTexture(name, x, y)

    -- static render to all buffers

end

-- renders non-static texture
function world:renderDynamicTexture(name, x, y)

    -- temp render to all buffers

end

-- new template for lights
function world:newLightTemplate(name, ...)
    self.lightTemplates[name] = lighting.light(...)
end

-- generate light source from template
function world:addLight(x, y, z, color, template)
    local id = uuid()
    self.lights[id] = {
        x = x, 
        y = y, 
        z = z,
        color = color, 
        template = template
    }

    return id
end

-- move light
function world:moveLight(id, x, y, z)
    self.lights[id].x = x
    self.lights[id].y = y
    self.lights[id].z = z
end

-- change light color
function world:changeLightColor(id, color)
    self.lights[id].color = color
end

-- change light template
function world:changeLightTemplate(id, template)
    self.lights[id].template = template
end

function world:update(dt)

    -- render occlusion
    self.dynamicBuffers.occlusion:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)

        love.graphics.setColor(1, 1, 0.5, 1)

        love.graphics.rectangle("fill", 100, 100, 80, 80)
        love.graphics.circle("fill", 400, 200, 40)

        love.graphics.setColor(1, 1, 1, 1)

    end)

    -- render normals
    self.dynamicBuffers.normal:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)
    end)

    -- render spectral map
    self.dynamicBuffers.spectral:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)
    end)

    -- render lighting buffer
    self.dynamicBuffers.lighting:renderTo(function()
        love.graphics.clear(0, 0, 0, 0)
    
        for id, l in pairs(self.lights) do
            self.lightTemplates[l.template]:draw(l.x, l.y, l.z, l.color, 
                -- pass buffers to light
                self.dynamicBuffers.occlusion,
                self.dynamicBuffers.normal,
                self.dynamicBuffers.spectral
            )
        end

    end)

    -- render screen buffer
    self.dynamicBuffers.screen:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)
        love.graphics.draw(self.dynamicBuffers.lighting)
        -- love.graphics.draw(self.dynamicBuffers.occlusion)
        
    end)


end

function world:draw()
    love.graphics.draw(self.dynamicBuffers.screen)
end

return world