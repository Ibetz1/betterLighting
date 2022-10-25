local _PACKAGE = string.gsub(...,"%.","/") .. "/" or ""

lighting = {
    light = require(_PACKAGE .. "light"),
    texture = require(_PACKAGE .. "texture"),
    world = require(_PACKAGE .. "world")
}