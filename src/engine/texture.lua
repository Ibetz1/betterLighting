local tex = object:new()

function tex:init(image, occluder, normal, spectral)
    self.scale = {x = 1, y = 1};

    self.image = {
        tex = image,
        quad = nil
    }

    self.normal = {
        tex = normal,
        quad = nil
    }

    self.spectral = {
        tex = spectral,
        quad = nil
    }

    self.occluder = {
        tex = occluder,
        quad = nil
    }
end

function tex:setScale(x, y)
    self.scale = {x = x or 1, y = y or 1}
end

function tex:setSegmentQuad(name, quad)
    self[name].quad = quad
end

function tex:setSegmentTexture(name, tex)
    self[name].tex = tex
end

function tex:draw(x, y, texture, normal, occluder, spectral)

    love.graphics.scale(self.scale.x, self.scale.y)

    if self.image.tex then
        -- add to tex buffer
        texture:renderTo(function() 
            
            love.graphics.draw(self.image.tex, x, y)

        end)
    end
    
    if self.normal.tex then
        -- add to normal buffer
        normal:renderTo(function() 

            love.graphics.draw(self.normal.tex, x, y)
            
        end)
    end

    if self.spectral.tex then
        -- add to spectral buffer
        spectral:renderTo(function() 

            love.graphics.draw(self.spectral.tex, x, y)

        end)
    end

    if self.occluder.tex then
        -- add to occlusion buffer
        occluder:renderTo(function() 

            love.graphics.draw(self.occluder.tex, x, y)

        end)
    end

    love.graphics.reset()
end

return tex