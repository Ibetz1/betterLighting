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

-- scale a texture template
function world:setTextureTemplateScale(name, x, y)
    self.textureTemplates[name]:setScale(x, y)
end

-- renders static texture
function world:renderTextureStatic(name, x, y)

    -- render texture to static buffers
    self.textureTemplates[name]:draw(x, y, 
                                     self.staticBuffers.texture,
                                     self.staticBuffers.normal,
                                     self.staticBuffers.occlusion,
                                     self.staticBuffers.spectral
                                    )
    
end

-- renders non-static texture
function world:renderTextureDynamic(name, x, y)

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
    
    -- render textures
    self.dynamicBuffers.texture:renderTo(function() 
        love.graphics.clear(1, 1, 1, 1)

        love.graphics.draw(self.staticBuffers.texture)
    end)

    -- render occlusion
    self.dynamicBuffers.occlusion:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)

        love.graphics.draw(self.staticBuffers.occlusion)

    end)

    -- render normals
    self.dynamicBuffers.normal:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)

        love.graphics.draw(self.staticBuffers.normal)
    end)

    -- render spectral map
    self.dynamicBuffers.spectral:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)

        love.graphics.draw(self.staticBuffers.spectral)
    end)

    -- render lighting buffer
    self.dynamicBuffers.lighting:renderTo(function()
        love.graphics.clear(0.1, 0.1, 0.2, 1)
        
        love.graphics.setBlendMode("screen")

        -- render lights
        for id, l in pairs(self.lights) do
            self.lightTemplates[l.template]:draw(l.x, l.y, l.z, l.color, 

                -- pass buffers to light
                self.dynamicBuffers.occlusion,
                self.dynamicBuffers.normal,
                self.dynamicBuffers.spectral
            )
        end

        love.graphics.setBlendMode("alpha")
    end)

    -- render screen buffer
    self.dynamicBuffers.screen:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)

        love.graphics.draw(self.dynamicBuffers.texture)

        -- multiply lighting buffer onto textures
        love.graphics.setBlendMode("multiply", "premultiplied")

            love.graphics.draw(self.dynamicBuffers.lighting)
        
        love.graphics.setBlendMode("alpha")
    end)


end

function world:draw()
    love.graphics.draw(self.dynamicBuffers.screen)
end

return world