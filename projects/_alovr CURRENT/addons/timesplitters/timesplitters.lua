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

--[[
blob_file, final_vert_count

room_surfaces table
1 = vert_count
2 = flags_a
3 = flags_b

address_table
1 = {primary_groups,primary_strips,primary_verts,primary_uvs,primary_colors, primary_group_size}
2 = {secondary_groups,secondary_strips,secondary_verts,secondary_uvs,secondary_colors, secondary_group_size}
]]
function generateMesh( blob_file, final_vert_count, room_surfaces, address_mesh, address_table )
	local mesh_element = {}
	for i = 1, final_vert_count do mesh_element[i] = {} end
	
	--local file_index = address_table[1][7]
	local file_index = address_mesh * 1
	
	-- THEN we can eliminate this table of tables by inputting all 6 addresses
	-- 1 primary, 2 secondary
	local primary_groups = address_table[1][1] * 1
	local primary_strips = address_table[1][2] * 1
	local primary_verts = address_table[1][3] * 1
	local primary_uvs = address_table[1][4] * 1
	local primary_colors = address_table[1][5] * 1
	local primary_group_size = address_table[1][6] * 1
	
	local groups_primary = {}
	
	if ( primary_groups > 0 ) then
		local strip_index = 1
		local new_vert_index = 1
		
		local groups_count = primary_group_size * 1
		
		for group_index = 1, groups_count do
			-- remember lua index
			file_index = primary_groups + ((group_index - 1) * 24)
			
			--print("F", group_index, file_index)
			
			-- x = {}
			--local current_group = groups_primary[group_index]
			
			local material_id = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			file_index = file_index + 4
			
			local group_strips_count = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			local group_vertices_start = blob_file:getU32(file_index, 1)
			--file_index = file_index + 4
			
			--local group_vertices_end = blob_file:getU32(file_index, 1)
			--file_index = file_index + 4
			
			--print("x", material_id, group_strips_count, group_vertices_start)
			
			-- Assign the group data as well, we want this information still
			--local current_group = {material_id, group_strips_count, group_vertices_start}
			groups_primary[group_index] = {material_id, group_strips_count, group_vertices_start}
			
		end
		
		for group_index = 1, groups_count do
			local group_info = groups_primary[group_index]
			
			local group_strips_count = group_info[2] * 1
			
			local offset = group_info[3] * 1
			
			--print("Q", group_index, group_info[1], group_info[2], group_info[3])
			--print(group_index, primary_groups + (group_index * 24))
			
			for k = 1, group_strips_count do
				
				local strip = room_surfaces[strip_index]
				
				local strip_vert_count = strip[1] * 1
				
				for vert_index = 1, strip_vert_count do
					local base_test = (vert_index - 1) + offset
					
					local index = math.floor(base_test * 12)-- 4 * 3
					
					local temp_readpos = primary_verts * 1
					--print("ass", k, new_vert_index)
					
					-- SWEET these work
					local position_x = blob_file:getF32(temp_readpos + 0 + index, 1)
					local position_y = blob_file:getF32(temp_readpos + 4 + index, 1)
					local position_z = blob_file:getF32(temp_readpos + 8 + index, 1)
					
					--print(position_x, position_y, position_z)
					
					-- Now read the UVs with a stride of 16
					index = math.floor(base_test * 16)-- 4 * 4
					temp_readpos = primary_uvs * 1
					
					local uv_x = blob_file:getF32(temp_readpos + 0 + index, 1)
					local uv_y = blob_file:getF32(temp_readpos + 4 + index, 1)
					
					--print(uv_x, uv_y)
					
					-- Now colors
					index = math.floor(base_test * 4)
					temp_readpos = primary_colors * 1
					
					local red = blob_file:getU8(temp_readpos + 0 + index)
					local gre = blob_file:getU8(temp_readpos + 1 + index)
					local blu = blob_file:getU8(temp_readpos + 2 + index)
					local alp = blob_file:getU8(temp_readpos + 3 + index)
					
					red = red / 127.0
					gre = gre / 127.0
					blu = blu / 127.0
					alp = alp / 127.0
					
					--print(red, gre, blu, alp)
					
					-- SWEET! all the data is being read correctly!
					-- Now we set element table to hold the values in the way that GL
					-- will read as per our mesh definition {"vertex_position", 3, ...}
					--mesh_element[new_vert_index] = {position_x, position_y, position_z ; uv_x, uv_y ; red, gre, blu, alp}
					--mesh_element[new_vert_index] = {position_x, position_y, position_z, uv_x, uv_y, red, gre, blu, alp}
					mesh_element[new_vert_index] = {position_x, position_y, position_z, 0, 1, 0, uv_x, uv_y}
					
					-- // NORMAL calculation when we are past 1 vertice
					local normal = lovr.math.newVec3(0, 1, 0)
					
					local ind_a = 0
					local ind_b = 0
					local ind_c = 0
					
					local odd_order = 1
					
					if ( math.modf(strip[3], 1) == 1 ) then
						odd_order = 0
					end
					
					if ( vert_index > 2 ) then
						if ( math.modf(vert_index, 2) == odd_order ) then
							ind_a = new_vert_index - 0
							ind_b = new_vert_index - 1
							ind_c = new_vert_index - 2
						else
							ind_a = new_vert_index - 2
							ind_b = new_vert_index - 1
							ind_c = new_vert_index - 0
						end
						
						local room_a = mesh_element[ind_a]
						local room_b = mesh_element[ind_b]
						local room_c = mesh_element[ind_c]
						
						-- calc face normal
						-- ind_a
						local vec_a = lovr.math.newVec3(room_a[1], room_a[2], room_a[3])
						-- ind_b
						local vec_b = lovr.math.newVec3(room_b[1], room_b[2], room_b[3])
						-- ind_c
						local vec_c = lovr.math.newVec3(room_c[1], room_c[2], room_c[3])
						
						local vec_xx = vec_b - vec_a
						local vec_yy = vec_c - vec_a
						
						-- We do a cross product of the positions to find the orientation
						normal = vec_xx:cross(vec_yy)
						normal:normalize()
					end
					
					-- We then update the format of the entire mesh to use the normal data
					mesh_element[new_vert_index][4] = normal.x
					mesh_element[new_vert_index][5] = normal.y
					mesh_element[new_vert_index][6] = normal.z
					
					-- Set the first two elements with the same normal as it's dominate one
					if ( vert_index == 3 ) then
						mesh_element[new_vert_index - 1][4] = normal.x
						mesh_element[new_vert_index - 1][5] = normal.y
						mesh_element[new_vert_index - 1][6] = normal.z
						mesh_element[new_vert_index - 2][4] = normal.x
						mesh_element[new_vert_index - 2][5] = normal.y
						mesh_element[new_vert_index - 2][6] = normal.z
					end
					
					new_vert_index = new_vert_index + 1
				end
				
				offset = offset + strip_vert_count
				strip_index = strip_index + 1
			end
		end
	end
	
	
	--[[
	So this file format has it's vertices in a raw format being what is sent to the
	gpu or opengl context. if it's 3 vectors per position, then our shader must be
	in the same format to draw this data. it's tough to think about but we could
	make a addon structure to accerate this kind of reverse engineering in other
	formats that could have an odd transformation order, like y is up
	Additionally we can make the module automatically detect the direction
	doing a reverse cross on X and Y we can find the forward direction that the
	geometry tends, and adjust the input. We could probably compress the input
	if it's not normalized as well, some formats may be only one axis direction.
	
	NOTE: This is all very theoritical and not tested as this engine may not follow
	this in it's transformation identity. But we will try it.
	]]
	
	-- OKAY so here we need to create a buffer that uses our format
	
	local temp_buffer = lovr.graphics.newBuffer({{ name = "VertexPostion", type = "vec3" }, { name = "VertexNormal", type = "vec3" }, { name = "VertexUV", type = "vec2" }}, mesh_element)
	
	-- Ah crap we need to pass the groups down to the render buffer
	--return mesh_element, groups_primary
	return temp_buffer, groups_primary
end

-- TODO: CLOSE BLOB FILE, clean up and garbage collect when we are done

function ts.loadLevel( file )
	local is_valid = lovr.filesystem.isFile( file )
	
	-- Early returns work, so if there really is a problem then you return and the game will attempt to skip loading this file
	if (not is_valid) then return print("Not valid level: ", file) end
	
	local size = lovr.filesystem.getSize( file )
	
	print("Loading RAW", is_valid, size)
	
	local blob_file = lovr.filesystem.newBlob( file )
	
	-- TEST of system overall
	final_mesh = false
	
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
		for room_index = 1, (room_count - 1) do rooms_room[room_index] = {} end
		
		local rooms_mesh = {}
		for room_index = 1, (room_count - 1) do rooms_mesh[room_index] = {} end
		
		-- //// Meshes ////
		-- We start with one and (room_count - 1)
		for room_index = 1, (room_count - 1) do
			-- Start the reading head at the rooms block of the file that we read before
			-- This is an address in bytes of the file, using the size of a room index
			-- that is determined from a hex editor to be 11 times 4 bytes long.
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
			
			-- NOTE: groups being the type indicator
			--local groups_primary = {}
			
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
			
			local room_surfaces = {}-- has to be in this scope
			
			if ( primary_strips > 0 ) then
				--for i = 1, primary_strip_size do room_surfaces[i] = {} end
				
				for i = 1, primary_strip_size do
					-- lua: indexs start at 1, so for loops naturally are <=
					file_index = primary_strips + ((i - 1) * 16)
					
					local vert_count = blob_file:getU8(file_index, 1)
					file_index = file_index + 1
					
					local flags_a = blob_file:getU8(file_index, 1)
					file_index = file_index + 1
					
					local flags_b = blob_file:getU8(file_index, 1)
					file_index = file_index + 1
					
					--print("strip index", i, vert_count, flags_a, flags_b)
					
					-- store the strip as a table ("it's a struct in memory")
					room_surfaces[i] = {vert_count, flags_a, flags_b}
					
					final_vert_count = final_vert_count + vert_count
				end
				
				-- Now we go on to creating the groups below
			else
				-- warning and halt
				-- for debugging to find a mesh that does have only transparent meshes
				-- If this is a break point we can start to look at the hex of the mesh to setup any of its cases
				assert(false, "mesh with no primary mesh! that or wrong file type bro")
				
				-- CLEAN UP: make this silently fail instead of breaking lua
			end
			
			-- LOVR we want to store the values we read so that we can pass them to a mesh function
			-- I originally determined Timeplitters to use GL for it's graphics and it is true
			-- that it's raw format for levels are in a 3 floats per position and so on
			-- Setup an array that we can store all the values in to make transfers easy
			--local room_data = {room_bounds_min_x,room_bounds_min_y,room_bounds_min_z,room_bounds_max_x,room_bounds_max_y,room_bounds_max_z,address_mesh,unknown_info}
			local room_primary = {primary_groups,primary_strips,primary_verts,primary_uvs,primary_colors, primary_group_size}
			local room_secondary = {secondary_groups,secondary_strips,secondary_verts,secondary_uvs,secondary_colors, secondary_group_size}
			
			--rooms_room[room_index] = {room_data, room_primary, room_secondary}
			rooms_room[room_index] = {room_primary, room_secondary}
			
			-- Generate a mesh via addresses and we can hallucinate a table we need for our openGL context
			local mesh_data, mesh_groups = generateMesh( blob_file, final_vert_count, room_surfaces, address_mesh, rooms_room[room_index] )
			
			rooms_mesh[room_index] = {mesh_data, mesh_groups}
			-- So the mesh data is {{{position, 3}, {uv, 2}, {color, 4}}, ...}
		end
		
		-- now rooms_mesh is a complete list of meshs that can be translated
		
		local test_first_room = rooms_mesh[1]
		
		local format_test_first_room = {
			{"VertexPosition", "vec3"},
			{"VertexNormal", "vec3"},
			{"VertexUV", "vec2"},
			{"VertexColor", "vec4"}
		}
		
		local format_default = {
			{"VertexPosition", "vec3"},
			{"VertexNormal", "vec3"},
			{"VertexUV", "vec2"}
		}
		
		-- Still can throw errors!
		--final_mesh = lovr.graphics.newMesh(format_test_first_room, test_first_room)
		--final_mesh = lovr.graphics.newMesh(format_default, test_first_room)
		--final_mesh = lovr.graphics.newBuffer(test_first_room_format, test_first_room)
		final_mesh = test_first_room
	end
	
	-- TODO
	return final_mesh
end

--[[
	TODO: Make this creation shared between our actual mesh and buffer so that we can always change this and use the same structure
]]
function ts.createIndexBuffer()
	local buffer = lovr.graphics.newBuffer({
		{ name = "VertexPosition", type = "vec3" },
		{ name = "VertexNormal", type = "vec3" },
		{ name = "VertexUV", type = "vec2" },
		{ name = "VertexColor", type = "vec4" }
	}, 4)
	
	return buffer
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