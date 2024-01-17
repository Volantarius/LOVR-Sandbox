local ffi = require("ffi")

ffi.cdef[[
void *SDL_GL_GetProcAddress(const char *proc);
]]

local sdl

if ( ffi.os == "Windows" ) then
	if ( not lovr.filesystem.isFused() and lovr.filesystem.isFile("bin/SDL2.dll") ) then
		sdl = ffi.load("bin/SDL2")
	else
		sdl = ffi.load("SDL2")
	end
else
	-- On other systems, we get the symbols for free.
	sdl = ffi.C
end

return sdl