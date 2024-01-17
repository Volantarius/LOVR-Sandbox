local example = {}

-- lovr.filesystem.read( filename, bytes )
-- 

function example.loadPak( file ) end

function example.loadTexture( file ) end

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
local file_index = 0

function example.loadLevel( file )
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
		
		file_index = 0 -- This is the read position, when you create a reader, you move this over the file based on the size and move the header over the unsigned 8 bit
		
		print( blob_file:getU8(file_index, 1) )
		
		file_index = file_index + 4
		
		print( blob_file:getU8(file_index, 1) )
		
		-- What I should do is then try to give a handler that can make the counter count itself like I have done
		print( blob_file:getU8(0 + 0, 1), blob_file:getU8(0 + 1, 1), blob_file:getU8(0 + 2, 1), blob_file:getU8(0 + 3, 1) )
		print( blob_file:getU8(4 + 0, 1), blob_file:getU8(4 + 1, 1), blob_file:getU8(4 + 2, 1), blob_file:getU8(4 + 3, 1) )
		
	end
	
	return true
end

--[[
	init
	
	Addon begins here, starts before the game is even started
	
	You can load your textures, meshes, or fonts in the addon folder
	
	getLevelCount -- 20
	getLevelIndex -- Returns file handler?? Some files are indexed or interators 0,1,2,3 // 4,8,14,17
	getLevelName -- args:index-- String of the name of the level in pretty format by index
	getLevelPath -- args:index -- Path to file/file(s)
	
	getLevelRooms -- args: index
	getLevelMaterials -- args: index
	getLevelMeshes -- args: index
	
	Area Portals, needs to be a room link list. I do believe I have this finished somewhere
	Check the monogame project, I still have all the code for setting up the math and portals
	
	The idea would then list this upon game's prompting for content to load
	Like while in VR I press a button on the hand UI to load a list of levels to list
]]
function example.init()
	print("hello world :)")
end

return example