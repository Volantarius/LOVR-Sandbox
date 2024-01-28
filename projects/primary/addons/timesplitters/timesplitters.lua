local ffi = require("ffi")

local ts = {}

--[[
	TODO
	
	Paks will need a callback of some sort to create a file system like handler
	It can be loaded using a blob, and then the offsets and strings for that format
	can easily be translated into something like the LOVR file system structure.
	
	PROBLEM I don't know if it is a great idea to setup something like that and interface it in runtime
	Need to test before getting carried away with that.
]]

-- Blob file
-- endChar (ascii number)
-- Returns string and amount of bytes read
local function readUntilTerminate( blob, offset, endChar )
	local string_temp = {}
	local read_count = 0
	
	local final = ""
	
	for i = 0, 16 do
		-- Read bytes as unsigned and convert to ascii with string.char
		-- then we can either create a string with ..
		-- or insert into our table and parse it later
		local char = blob:getU8( offset + i, 1 )
		
		-- We always want to default to newline or null character to terminate
		if ( char == 0x0A or char == endChar ) then
			final = string.char( unpack( string_temp ) )
			
			read_count = i + 1
			
			offset = offset + read_count

			break
		end
		
		table.insert( string_temp, char )
	end

	return final, read_count
end

-- Assumes bytes are ascii
-- Basically subtract the byte by 48
-- Also re constructs the number using 10s and stuff (REPLACE WITH BIT shifter)
local function readUntilTerminateNumber( blob, offset, endChar )
	local digits = {}
	local digits_count = 0
	local read_count = 0
	
	local final = 0
	
	-- LOL I always end up with two loops...
	-- Terminated strings are always a mystery to me lol
	
	for i = 0, 16 do
		-- Read bytes as unsigned and convert to ascii with string.char
		-- then we can either create a string with ..
		-- or insert into our table and parse it later
		local char = blob:getU8( offset + i, 1 )
		
		-- We always want to default to newline or null character to terminate
		if ( char == 0x0A or char == endChar ) then
			read_count = i + 1
			
			digits_count = #digits
			
			offset = offset + read_count
			
			break
		end
		
		table.insert( digits, char - 48 )
	end
	
	local place = 1
	
	for i = 1, digits_count do
		-- Like in math class
		final = final + (place * digits[digits_count - i + 1])
		
		place = place * 10
	end
	
	return final, read_count
end

--
-- Palette Image
--
local function createQ8( blob, offset, width, height, palette )
	local table_palette = {}
	
	-- TODO: Update the string at the end to use the texture name
	local aaa = lovr.data.newImage( width, height, "rgba8", lovr.data.newBlob( width * height * 4, "testpal" ) )
	
	-- Paletted images use a list of colors instead of a raw data
	-- This is usually stored as a byte allowing 256 colors instead of the usual 32bit millions
	-- Can make the stored data larger but it is a very nice compression
	
	local file_index = offset * 1
	
	local red, gre, blu, alp = 0, 0, 0, 0
	
	local palette_index = offset * 1
	local read_index = offset + (palette * 4)
	
	--
	-- Feast your eyes! This is quite literally a shader. This is what your gpu is good at doing.
	--
	for y = 0, (height - 1) do
		for x = 0, (width - 1) do
			-- Important! every Y we move by the width amount!
			local i = (width * y) + x
			
			-- Read the index from the palette position
			local index = blob:getU8(read_index + i, 1)
			
			-- Multiply by 4, this is the stride because we have 4 components per index from the palette
			index = index * 4
			
			-- Last argument is 4 to read all four byte into the variables
			-- I don't really like this short hand which is why there is a note for reading
			-- Finally we are using the palette_index offset and using the index from above
			red, gre, blu, alp = blob:getU8(palette_index + index, 4)
			
			aaa:setPixel(x, y, red / 255, gre / 255, blu / 255, (alp / 255) * 2)
		end
	end
	
	local texture = lovr.graphics.newTexture(aaa, {format = "rgba8", type = "2d", linear = true})
	
	return texture
end

--
-- Raw RGBA
--
local function createQ6( blob, offset, width, height )
	-- TODO: Update the string at the end to use the texture name
	local aaa = lovr.data.newImage( width, height, "rgba8", lovr.data.newBlob( width * height * 4, "testpal" ) )
	
	local file_index = offset * 1
	
	local red, gre, blu, alp = 0, 0, 0, 0
	
	for y = 0, (height - 1) do
		for x = 0, (width - 1) do
			-- Important! every Y we move by the width amount!
			local i = ((width * y) + x) * 4
			
			-- Read the 4 bytes into the variables
			red, gre, blu, alp = blob:getU8(file_index + i, 4)
			
			aaa:setPixel(x, y, red / 255, gre / 255, blu / 255, (alp / 255) * 2)
		end
	end
	
	local texture = lovr.graphics.newTexture(aaa, {format = "rgba8", type = "2d", linear = true})
	
	return texture
end

--
-- Using a HEX editor that supports various visual interpretations of the binary is helpful
-- in seeing what the data is structured like. A Hex editor in LOVE2d is a great project to
-- start if you want to reverse engineer formats like this one!
--
function ts.loadTexture( file )
	local blah = 0-- throw away variable
	local is_valid = lovr.filesystem.isFile( file )
	
	-- Early returns work, so if there really is a problem then you return and the game will attempt to skip loading this file
	if (not is_valid) then return print("Not valid texture: ", file) end
	
	local size = lovr.filesystem.getSize( file )
	
	local blob_file = lovr.filesystem.newBlob( file )
	
	if ( blob_file == nil ) then return false end
	
	-- RESET read position
	local file_index = 0
	local string_size = 0

	local header, width, height = "", -1, -1
	local color_depth, unknown_v = 0, ""

	-- This is so messy ugh
	-- we have two return values for the read count

	-- Timesplitters textures have the following headers:
	-- Q6 is raw rgba
	-- Q8 is palette based with 256 colors and an array of indices
	-- M8 predefined mipmapped Q8
	header, string_size = readUntilTerminate( blob_file, file_index, 0x20 )
	file_index = file_index + string_size

	width, string_size = readUntilTerminateNumber( blob_file, file_index, 0x20 )
	file_index = file_index + string_size

	height, string_size = readUntilTerminateNumber( blob_file, file_index, 0x20 )
	file_index = file_index + string_size
	
	
	color_depth, string_size = readUntilTerminateNumber( blob_file, file_index, 0x20 )
	file_index = file_index + string_size
	
	-- I think this is the value
	unknown_v, string_size = readUntilTerminate( blob_file, file_index, 0x20 )
	file_index = file_index + string_size
	
	local palette_size = 256
	
	palette_size, string_size = readUntilTerminateNumber( blob_file, file_index, 0x20 )
	file_index = file_index + string_size
	
	print(color_depth, unknown_v, palette_size)
	
	-- Adjust to the next (4 * byte). The file is in binary and keeping the data aligned
	-- like a struct is very useful for loading on the ps2 as it wasn't worried about tampering or bugs
	-- And because we use a terminator to end the stream it can always be off by some offset
	if ( math.fmod( file_index, 4 ) > 0 ) then
		file_index = file_index + (4 - math.fmod( file_index, 4 ))
	end
	
	local texture = false

	print( "file size: ", blob_file:getSize() )
	
	if ( header == "Q8" ) then
		
		texture = createQ8( blob_file, file_index, width, height, palette_size )
		
	elseif ( header == "Q6" ) then
		
		texture = createQ6( blob_file, file_index, width, height )
		
	elseif ( header == "M8" ) then
		
		--
		
	else
		--
	end

	return texture
end

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
-- Actually fill this completely out for all meshes

-- 24/1/17 We may have to setup addons to try and stick to one level at a time
-- It's just that you will need to make sure you load a level the same way everytime, but thats models for you or whatever

-- Using tables because they are basically structs without names
local rooms_room = {}

local function renderScene( pass, import_table )
	local groups_count = import_table[1]
	
	local surface_count = 0
	-- LUA 1 indices
	local vertice_count = 1
	
	--pass:setWinding("counterclockwise")
	--pass:setCullMode("front")
	
	for group_index = 1, groups_count do
		local current_group = import_table[4][group_index]
		
		for surface_index = 1, current_group[2] do
			local current_surface = import_table[5][surface_count + surface_index]
			
			local surface_vert_count = (current_surface[1] - 2) * 3
			
			-- FACK it won't draw a mesh itself, it has to be a buffer object lol
			-- With the buffer it is close but still off since now the data is weird
			--
			-- The conversion to the other data type ruined the grouping method
			pass:mesh( import_table[6], lovr.math.mat4(), vertice_count, surface_vert_count, 1 )
			
			vertice_count = vertice_count + surface_vert_count
		end
		
		surface_count = surface_count + current_group[2]
	end
end

--{primary_group_size, secondary_group_size, butt_buffer, mesh_groups, room_surfaces, tit_buffer}

function ts.renderScene( pass, import_table )
	for k = 1, #rooms_room do
		
		renderScene( pass, rooms_room[k] )
		
	end
end

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
			
			-- This is the raw data offset in the file in bytes
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
					
					--print("x", vert_index, new_vert_index)
					
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
					--mesh_element[new_vert_index] = {position_x, position_y, position_z ; 0, 1, 0 ; uv_x, uv_y ; red, gre, blu, alp }
					mesh_element[new_vert_index] = { position_x, position_y, position_z, 0, 1, 0, uv_x, uv_y, red, gre, blu, alp }
					--mesh_element[new_vert_index] = {position_x, position_y, position_z, uv_x, uv_y, red, gre, blu, alp}
					--mesh_element[new_vert_index] = {position_x, position_y, position_z, 0, 1, 0, uv_x, uv_y}
					--mesh_element[new_vert_index] = { vec3(position_x, position_y, position_z), vec3(0, 1, 0), vec2(uv_x, uv_y) }
					
					--print( position_x, position_y, position_z, 0, 1, 0, uv_x, uv_y, red, gre, blu, alp )
					
					new_vert_index = new_vert_index + 1
				end
				
				offset = offset + strip_vert_count
				strip_index = strip_index + 1
			end
		end
	end
	
	-- Ah crap we need to pass the groups down to the render buffer
	return mesh_element, groups_primary
end

-- TODO: CLOSE BLOB FILE, clean up and garbage collect when we are done

function ts.loadLevel( file )
	local is_valid = lovr.filesystem.isFile( file )
	
	-- Early returns work, so if there really is a problem then you return and the game will attempt to skip loading this file
	if (not is_valid) then return print("Not valid level: ", file) end
	
	local size = lovr.filesystem.getSize( file )
	
	print("Loading RAW", is_valid, size)
	
	local blob_file = lovr.filesystem.newBlob( file )
	
	if ( blob_file == nil ) then return false end
	
	-- RESET read position
	local file_index = 0
	
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
	
	for room_index = 1, (room_count - 1) do rooms_room[room_index] = {} end
	
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
		local test_newcount = 0
		
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
				
				-- TODO: Setup a list of triangles vertice count and not this.... Pain in the butt lol
				final_vert_count = final_vert_count + vert_count
				
				test_newcount = test_newcount + (vert_count - 2)
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
		
		local pass_to_mesh_maker = {room_primary, room_secondary}
		
		-- Generate a mesh via addresses and we can hallucinate a table we need for our openGL context
		local mesh_data, mesh_groups = generateMesh( blob_file, final_vert_count, room_surfaces, address_mesh, pass_to_mesh_maker )
		
		-- //// Convert strips to triangles
		local odd_order = 1
		
		local new_mesh_data = {}
		
		local new_strip_index = 1
		local new_vert_index = 1
		local test_vert_index = 1
		local new_offset = 0
		local orig_offset = 0
		
		for group_index = 1, primary_group_size do
			-- remember lua index
			file_index = primary_groups + ((group_index - 1) * 24)
			
			local material_id = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			file_index = file_index + 4
			
			local group_strips_count = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			local group_vertices_start = blob_file:getU32(file_index, 1)
			
			for k = 1, group_strips_count do
				local strip = room_surfaces[new_strip_index]
				
				local strip_vert_count = strip[1] * 1
				
				-- TODO: Convert a list of triangle strips to straight triangles
				-- Comparing this function to the one on how we read the file can be helpful to create a generalized reader based off addresses, strides, and counts
				-- Actually it would be in the same vein as Shaders, since we have a finite list of pixels to run code on
				-- We can do the same with meshes, audio, textures, etc.
				-- Maybe we should design this like so??
				--
				-- Eventually setup a mesh reading function that can switch between these modes
				
				-- Vertices from 1 to (x - 2) is a list of triangles
				-- So adjust the other counter to go (i * 3) and we have ourselves a counter for triangle lists
				-- We can additionally store the indices we generate from strips, fans, or lists.
				-- Also if the mesh format has indices, we can copy them straight over.
				
				for vert_index = 1, (strip_vert_count - 2) do
					
					local fixed_index = vert_index + orig_offset
					
					local triangle_offset = (test_vert_index - 1) * 3
					
					-- 1,2,3 and 0,1,2 This is lua again so indices must start with 1
					new_mesh_data[ triangle_offset + 1 ] = mesh_data[ fixed_index + 0 ]
					new_mesh_data[ triangle_offset + 2 ] = mesh_data[ fixed_index + 1 ]
					new_mesh_data[ triangle_offset + 3 ] = mesh_data[ fixed_index + 2 ]
					
					new_vert_index = new_vert_index + 1
					
					test_vert_index = test_vert_index + 1
				end
				
				orig_offset = orig_offset + strip_vert_count
				--new_offset = new_offset + (strip_vert_count - 2)
				new_strip_index = new_strip_index + 1
			end
		end
		
		--print(final_vert_count, test_newcount)
		
		--[[
			
			STRIPS
			
			1
			 \
			2  3
			
			1  4
			| \| \
			2  3  5
		]]
		
		local test_mesh_format = {
			{"VertexPosition", "vec3"},
			{"VertexNormal", "vec3"},
			{"VertexUV", "vec2"},
			{"VertexColor", "vec4"}
		}
		
		--local temp_buffer = lovr.graphics.newMesh(test_mesh_format, mesh_data)
		local temp_buffer = lovr.graphics.newBuffer(test_mesh_format, mesh_data)
		
		--temp_buffer:setData( mesh_data )
		-- Not the correct kind of buffer lol
		
		local butt_buffer = temp_buffer
		
		local tit_buffer = lovr.graphics.newBuffer(test_mesh_format, new_mesh_data)
		
		--[[if ( #new_mesh_data > 2 ) then
			
			butt_buffer = lovr.graphics.newMesh(test_mesh_format, new_mesh_data)
			
		end]]
		
		--rooms_room[room_index] = {primary_group_size, secondary_group_size, mesh_data, mesh_groups, room_surfaces}
		rooms_room[room_index] = {primary_group_size, secondary_group_size, butt_buffer, mesh_groups, room_surfaces, tit_buffer}
	end
	
	-- TODO
	--return rooms_room[1]
	return rooms_room[2]
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
