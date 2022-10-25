local tex = object:new()

function tex:init(image, normal, spectral, occluder)
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

function tex:setQuad(name, quad)
    self[name].quad = quad
end

function tex:setTex(name, tex)
    self[name].tex = tex
end

return tex