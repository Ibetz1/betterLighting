local world = object:new()

function world:init()
    self.ScreenBuffer    = love.graphics.newCanvas()

    self.lightingBuffer  = love.graphics.newCanvas()
    self.occlusionBuffer = love.graphics.newCanvas()
    self.spectralBuffer  = love.graphics.newCanvas()
    self.normalBuffer    = love.graphics.newCanvas()
    self.textureBuffer   = love.graphics.newCanvas()

    self.lightTemplates = {}
    self.lights = {}

    self.textureTemplate = {}
    self.textures = {}
end

-- new template for lights
function world:newLightTemplate(name, ...)
    self.lightTemplates[name] = lighting.light(...)
end

-- generate light source from template
function world:addLight(x, y, color, template)
    local id = uuid()
    self.lights[id] = {
        x = x, 
        y = y, 
        color = color, 
        template = template
    }

    return id
end

-- move light
function world:moveLight(id, x, y)
    self.lights[id].x = x
    self.lights[id].y = y
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
    self.occlusionBuffer:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)

        love.graphics.rectangle("fill", 100, 100, 80, 80)
        love.graphics.circle("fill", 400, 200, 40)

    end)

    -- render normals
    self.normalBuffer:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)
    end)

    -- render spectral map
    self.spectralBuffer:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)
    end)

    -- render lighting buffer
    self.lightingBuffer:renderTo(function()
        love.graphics.clear(0, 0, 0, 0)
    
        for id, l in pairs(self.lights) do
            self.lightTemplates[l.template]:draw(l.x, l.y, l.color, self.occlusionBuffer, self.normalBuffer, self.spectralBuffer)
        end

    end)

    -- render screen buffer
    self.ScreenBuffer:renderTo(function() 
        love.graphics.clear(0, 0, 0, 0)
        love.graphics.draw(self.lightingBuffer)
        
    end)


end

function world:draw()
    love.graphics.draw(self.ScreenBuffer)
end

return world