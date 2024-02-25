-- Only for small GL features
-- LVOR does not have the texture wrap function bound to LUA
local ffi = require("ffi")
local sdl = require("sdl")

local GL = {
	ZERO = 0,
	TEXTURE_2D = 0x0DE1,
	NEAREST = 0x2600,
	LINEAR = 0x2601,
	NEAREST_MIPMAP_NEAREST = 0x2700,
	LINEAR_MIPMAP_NEAREST = 0x2701,
	NEAREST_MIPMAP_LINEAR = 0x2702,
	LINEAR_MIPMAP_LINEAR = 0x2703,
	TEXTURE_MAG_FILTER = 0x2800,
	TEXTURE_MIN_FILTER = 0x2801,
	TEXTURE_WRAP_S = 0x2802,
	TEXTURE_WRAP_T = 0x2803,
	CLAMP_TO_EDGE = 0x812F,
	REPEAT = 0x2901
}

return GL
