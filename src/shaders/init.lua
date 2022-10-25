local _PACKAGE = string.gsub(...,"%.","/") .. "/" or ""

return {
    light = love.graphics.newShader(_PACKAGE .. "light.frag"),
    blur  = love.graphics.newShader(_PACKAGE .. "blur.frag")
}