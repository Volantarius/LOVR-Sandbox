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

-- 
-- This is a complex mesh format that is not an indexed list of triangles
-- This uses groups of strips for it's textures and splitting geometry
-- The way it is read in memory is pretty linear and straight forward when looked in a hex editor
-- 
local file_index = 0

-- Actually fill this completely out for all meshes
function generateMesh( blob_file, final_vert_count, groups, group_size, input_address )
	-- blob_file
	-- primary_groups
	-- primary_group_size
	-- room_primary
	-- 
	
	-- Initialize the array buffer
	local elements = {}-- make this init a table of size final_vert_count
	local element_size = final_vert_count
	
	local file_index = 0
	
	-- Start creating a mesh
	if ( groups > 0 ) then
		-- MOVED
		local strip_index = 0
		local new_vert_index = 0
		
		-- room struct
		local groups_count = primary_group_size
		
		for group_index = 0, primary_group_size do
			file_index = primary_groups + (group_index * 24)-- 6 * 4
			
			-- room struct
			--local current_group = groups[group_index]
			
			local material_id = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			file_index = file_index + 4 -- Strip unknown
			local group_strips_count = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			local group_vertices_start = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			--local group_vertices_end = blob_file:getU32(file_index, 1)
			-- Another unknown? Can't remember
			
			-- room struct
			--strips_count = group_strips_count
			
			-- Start where the vertices start
			local offset = group_vertices_start * 1
			
			for k = 0, group_strips_count do
				-- room struct
				--local strip = surfaces[strip_index]
				
				-- room struct
				--local strip_vert_count = strip->vert_count
				
				for vert_index = 0, strip_vert_count do
					--local element = elements[new_vert_index]
					
					--fill_element()
					
					-- ahh it's a lot of code to read vertices and fill tables..!!
					
					new_vert_index = new_vert_index + 1
				end
				
				offset = offset + strip_vert_count
				strip_index = strip_index + 1
			end
		end
	end
end

-- TODO: CLOSE BLOB FILE, clean up and garbage collect when we are done

function ts.loadLevel( file )
	local is_valid = lovr.filesystem.isFile( file )
	
	-- Early returns work, so if there really is a problem then you return and the game will attempt to skip loading this file
	if (not is_valid) then return print("Not valid level: ", file) end
	
	local size = lovr.filesystem.getSize( file )
	
	print("Loading RAW", is_valid, size)
	
	local blob_file = lovr.filesystem.newBlob( file )
	
	if ( blob_file ~= nil ) then
		-- RESET read position
		file_index = 0
		
		-- 8 bit pointers to the position where the list of each other mesh component this model format uses
		-- 8 bit pointer to a multiple of one byte in the memory (Timesplitters format)
		local block_materials = blob_file:getU32(0, 1)
		local block_rooms = blob_file:getU32(4, 1)
		local block_areaportals = blob_file:getU32(8, 1)
		
		print( block_materials, block_rooms, block_areaportals )
		
		file_index = file_index + 8
		
		-- We can use the multiple of 8 from a byte to calculate hard counts of each struct based off what was found through reverse engineering
		-- The storage format for this model aligns to every 4 bytes, so we can easily calculate the size of each list
		local material_count = (block_rooms - block_materials) / 16
		local room_count = math.floor( ((block_areaportals - block_rooms) / 4 / 11) - 1 )
		
		print( block_materials, block_rooms, block_areaportals )
		
		-- Should be 90 and 53
		-- LOL the room count is really weird, VERIFY the room count since there is a bug when loading chinese
		print( "(Timesplitters) Material Count: ", material_count, " Rooms: ", room_count )
		
		-- //// Textures ////
		file_index = block_materials * 1
		
		-- IN Cpp this for loop is 0 to 38
		-- IN Lua this for loop is 0 to 39 () : 0 to (x - 1)
		-- WOW in lua 1 to (x - 1)
		for material_index = 1, (material_count - 1) do
			local texture_index = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			local texture_flags_a = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			local texture_flags_b = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			local texture_flags_c = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			-- Then we create a list of materials with all of the following flags
			-- And texture name
		end
		
		-- Using tables because they are basically structs without names
		local rooms_room = {}
		
		-- //// Meshes ////
		-- We start with one and (room_count - 1)
		for room_index = 1, (room_count - 1) do
			-- Setup an array that we can store all the values in to make transfers easy
			local room_data = {}
			local room_primary = {}
			local room_secondary = {}
			
			file_index = (1 * block_rooms) + (room_index * 4 * 11)
			
			file_index = file_index + 20-- 4 * 5
			
			local room_bounds_min_x = blob_file:getF32(file_index, 1)
			file_index = file_index + 4
			
			local room_bounds_min_y = blob_file:getF32(file_index, 1)
			file_index = file_index + 4
			
			local room_bounds_min_z = blob_file:getF32(file_index, 1)
			file_index = file_index + 4
			
			local room_bounds_max_x = blob_file:getF32(file_index, 1)
			file_index = file_index + 4
			
			local room_bounds_max_y = blob_file:getF32(file_index, 1)
			file_index = file_index + 4
			
			local room_bounds_max_z = blob_file:getF32(file_index, 1)
			file_index = file_index + 4
			
			-- First mesh is the primary opaque mesh format
			-- We use the very top of the rooms address and cycle through getting the mesh addresses
			local address_mesh = blob_file:getU32(block_rooms + math.floor(4 * 11 * room_index), 1)
			
			--file_index = address_mesh - 10-- Weird U32 number
			
			-- Primary mesh info address
			file_index = address_mesh - 8 - 64
			
			local primary_groups = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			local secondary_groups = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			local unknown_info = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			-- PRIMARY
			local primary_strips = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			local primary_verts = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			local primary_uvs = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			local primary_colors = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			file_index = file_index + 8-- Skip two unknowns
			
			local secondary_strips = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			local secondary_verts = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			local secondary_uvs = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			local secondary_colors = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			--[[
				Volantarius
				
				The addresses are in order from top to bottom in a hex editor
				so from groups to colors is a section of 4 bytes containing the values for number of vertices
				The number of vertices is where we then use a address offset lower in the binary to then read
				the values from, this is far later in the code though
			]]
			local primary_vert_count   = (primary_groups - primary_colors) / 4
			local secondary_vert_count = (secondary_groups - secondary_colors) / 4
			
			local primary_strip_size   = (primary_verts - primary_strips) / 16
			local secondary_strip_size = (secondary_verts - secondary_strips) / 16
			
			-- I think I should add a assert to make sure these values never have decimals
			-- If there is a decimal the data is incorrect always, the math above must be correct though
			-- It has a lot of benefits to use a structure like this to hold this kind of data
			
			local address_mesh_terminator = address_mesh - 8 - 64 - 8
			
			--print("address mesh", primary_vert_count, primary_strip_size)
			
			-- //// Groups ////
			
			local primary_group_size = 0
			local secondary_group_size = 0
			
			if ( primary_groups > 0 ) then
				primary_group_size = address_mesh_terminator - primary_groups
				
				if ( secondary_strips > 0 ) then
					
					primary_group_size = secondary_strips - primary_groups
					
				elseif ( unknown_info > 0 ) then
					
					primary_group_size = unknown_info - primary_groups
					
				end
				
				primary_group_size = math.floor(primary_group_size / 24)
				
				primary_group_size = primary_group_size - 1
				
				--print("RI", room_index, primary_group_size)
			end
			
			-- TODO: Secondary groups
			
			-- THEN for the generate mesh, WE will just use a table to stack all the info in
			-- where then the mesh generator will read those addresses and start reading the mesh data
			
			local final_vert_count = 0
			
			if ( primary_strips > 0 ) then
				local room_surfaces = {}
				for i = 1, primary_strip_size do room_surfaces[i] = {} end
				
				for i = 1, primary_strip_size do
					-- lua: indexs start at 1, so for loops naturally are <=
					file_index = primary_strips + ((i - 1) * 16)
					
					local vert_count = blob_file:getU8(file_index, 1)
					file_index = file_index + 1
					
					local flags_a = blob_file:getU8(file_index, 1)
					file_index = file_index + 1
					
					local flags_b = blob_file:getU8(file_index, 1)
					file_index = file_index + 1
					
					print("strip index", i, vert_count, flags_a, flags_b)
					
					-- store the strip as a table ("it's a struct in memory")
					room_surfaces[i] = {vert_count, flags_a, flags_b}
					
					final_vert_count = final_vert_count + vert_count
				end
				
				-- Setup our arrays for the mesh
				-- Store it as you wish and then we can translate
				-- it with the shader or the engine's mesh generate code
				local mesh_element = {}
				for i = 1, final_vert_count do mesh_element[i] = {} end
				
				
			else
				-- warning and halt
				-- for debugging to find a mesh that does have only transparent meshes
				-- If this is a break point we can start to look at the hex of the mesh to setup any of its cases
				assert(false, "mesh with no primary mesh! that or wrong file type bro")
				
				-- CLEAN UP: make this silently fail instead of breaking lua
			end
		end
		
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
	# 21 chinese (best to debug here, there are rooms with no mesh data so that is a challenge)
	# 22 castle
	# 23 egypt
	# 24 docks
	# 25 unused or test map (VR themed)
	# 26 egypt MP
	# 27 spaceways
	
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
function ts.init()
	print("(TIMESPLITTERS) hello world :)")
end

--[[
	Ideas
	
	draw pass
	
	No idea what to call the start and init to load
]]

return ts