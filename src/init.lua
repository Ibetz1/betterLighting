local _PACKAGE = string.gsub(...,"%.","/") .. "/" or ""

require(_PACKAGE .. "luaObjects")

light = require(_PACKAGE .. "engine")
shaders = require(_PACKAGE .. "shaders")