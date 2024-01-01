local ts = {}

-- lovr.filesystem.read( filename, bytes )
-- 

function ts.loadPak( file ) end

function ts.loadTexture( file ) end

-- When the engine calls to load your level
-- Here you state how the mesh is formatted
-- Winding order
-- CW, CCW
-- and then data format for shaders
-- 
-- Wavefront OBJ
-- { x, y, z, [w] }
-- { u, [v, w] }
-- { r, g, b, a }
-- 
-- local format = {
-- { "VertexPosition", "vec3" }
-- { "VertexColor", "vec4" }
-- }
-- 
-- mesh = lovr.graphics.newMesh(format, {
-- { 0, 0, 0,  0, 0, 0, 0 }
-- { 0, 0, 0,  0, 0, 0, 0 }
-- { 0, 0, 0,  0, 0, 0, 0 }
-- })
-- 
-- function lovr.draw(pass)
-- pass:draw(mesh, 0, 1.7, -1)-- X, Y, Z position
-- end
-- 
-- DRAWING, we are called for the draw. We must invert that meaning when we want to draw at different positions of said ENTITY
-- 
local read_i = 0

function ts.loadLevel( file )
	local is_valid = lovr.filesystem.isFile( file )
	
	-- Early returns work, so if there really is a problem then you return and the game will attempt to skip loading this file
	if (not is_valid) then return print("Not valid level: ", file) end
	
	local size = lovr.filesystem.getSize( file )
	
	print("Loading RAW", is_valid, size)
	
	--local contents, bytes = lovr.filesystem.read( file, size )-- Ascii
	--local contents, bytes = lovr.filesystem.read( file, -1 )-- Ascii
	local blob_file = lovr.filesystem.newBlob( file )
	
	-- For ASCII Examples, you get the entire txt file as a single string
	-- Useful for converting languages into other languages
	-- This can be great for prototyping the engine as well as developing ways to run those converted languages
	--
	-- Actually I have a prototyper that can interate the file and call the right functions that will allow custom lookups for that language
	
	-- Blobs are 0 indexed, which means you index the array by 0 to (size - 1)
	print( blob_file, type(blob_file) )
	
	if ( blob_file ~= nil ) then
		-- Now we have contents as a 8bit, char, short... you know 8 bits per indice for the data read from the file
		
		read_i = 0 -- This is the read position, when you create a reader, you move this over the file based on the size and move the header over the unsigned 8 bit
		
		print( blob_file:getU8(read_i, 1) )
		
		read_i = read_i + 4
		
		print( blob_file:getU8(read_i, 1) )
		
		-- What I should do is then try to give a handler that can make the counter count itself like I have done
		print( blob_file:getU8(0 + 0, 1), blob_file:getU8(0 + 1, 1), blob_file:getU8(0 + 2, 1), blob_file:getU8(0 + 3, 1) )
		print( blob_file:getU8(4 + 0, 1), blob_file:getU8(4 + 1, 1), blob_file:getU8(4 + 2, 1), blob_file:getU8(4 + 3, 1) )
		
		-- RESET read position
		read_i = 0
		
		-- 8 bit pointers to the position where the list of each other mesh component this model format uses
		-- 8 bit pointer to a multiple of one byte in the memory (Timesplitters format)
		local block_materials = blob_file:getU8(0, 1)
		local block_rooms = blob_file:getU8(4, 1)
		local block_areaportals = blob_file:getU8(8, 1)
		
		-- We can use the multiple of 8 from a byte to calculate hard counts of each struct based off what was found through reverse engineering
		-- The storage format for this model aligns to every 4 bytes, so we can easily calculate the size of each list
		local material_count = (block_rooms - block_materials) / 16
		local room_count = ((block_areaportals - block_rooms) / 4 / 11) - 1
	end
	
	-- TODO
	return true
end

--[[
	init
	
	Addon begins here, starts before the game is even started
	
	You can load your textures, meshes, or fonts in the addon folder
	
	The function for getting a list of levels will then be called here (for example) for the levels that are in the addon
	# 2 village
	# 5 chemical plant
	# 8 haunted mansion
	# 9 planet x
	# 10 compound
	# 11 streets
	# 12 warzone
	# 13 construction site
	# 14 cyberden
	# 15 bank
	# 16 graveyard
	# 17 spaceship
	# 18 mall
	# 21 chinese
	# 22 castle
	# 23 egypt
	# 24 docks
	# 25 unused or test map (VR themed)
	# 26 egypt MP
	# 27 spaceways
	
	getLevelCount -- 20
	getLevelIndex -- Some files are indexed or interators 0,1,2,3 // 4,8,14,17
	getLevelName -- String of the name of the level in pretty format by index
	getLevelPath -- Path to file/file(s) You get the path from the index by count
	getLevelFile -- input is the file loaded by the module
	
	The idea would then list this upon game's prompting for content to load
	Like while in VR I press a button on the hand UI to load a list of levels to list
]]
function ts.init()
	print("hello world :) DONKEY DICK LOL")
end

--[[
	Ideas
	
	draw pass
	
	No idea what to call the start and init to load
]]

return ts