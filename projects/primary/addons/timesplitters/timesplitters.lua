--[[local ffi = require("ffi")
local sdl = require("sdl")
local gl = require("opengl")
local GL = require("glsmall")]]

local ts = {}

-- replace the empty table with the table this returns
ts = require("addons/timesplitters/textures")

--[[
	TODO
	
	Paks will need a callback of some sort to create a file system like handler
	It can be loaded using a blob, and then the offsets and strings for that format
	can easily be translated into something like the LOVR file system structure.
	
	PROBLEM I don't know if it is a great idea to setup something like that and interface it in runtime
	Need to test before getting carried away with that.
	
	NOTE
	
	Weird thing I noticed for textures... If they are floats why are we not using the negative axis?
	blue noise canceling helps too
]]

local raw_shader_play_vert = [[
	// The texture to sample from.
	
	// lovr's shader architecture will automatically supply a main(), which will call this lovrmain() function
	vec4 lovrmain() {
		//return Projection * View * Transform * VertexPosition;
		return DefaultPosition;
	}
]]

local raw_shader_play_frag = [[
	// The texture to sample from.
	
	Constants {
	// This constant will be set every draw to determine whether we are sampling horizontally or vertically.
		int s_wrap;
		int t_wrap;
	};
	
	float hdr_scale = (1.0/0.75) * (1.0/0.75);
	
	// lovr's shader architecture will automatically supply a main(), which will call this lovrmain() function
	vec4 lovrmain() {
		// Okay so this is how we are going to have to impliment WRAPPING
		vec2 new_uv = vec2( UV[0], UV[1] );
		
		// My only good idea for how to recreate wrapping in this shader
		// My guess is that the precision is much higher in higher GL versions
		// Because the seam is apparent on older UV methods?
		// 0.008 and 0.992 to shorten the sample distance on these modes
		/*if ( (s_wrap & 1) == 1 ) {
			//fract probably outputs negative
			new_uv[0] = clamp(UV[0], 0.008, 0.992);
		}
		
		if ( (t_wrap & 1) == 1 ) {
			new_uv[1] = clamp(UV[1], 0.008, 0.992);
		}*/
		
		vec4 original_color = Color / 127.0;
		
		original_color *= original_color;
		
		original_color = clamp(original_color, 0.0, 2.0);
		
		original_color[3] = 1.0;
		
		vec4 texture_color = getPixel(ColorTexture, new_uv);// HDR
		
		texture_color[3] = 1.0;
		
		vec4 modded_color = texture_color * original_color;
		
		// Over Intensity!
		// Not completely sure if this is what the PS2 did or any way of
		// easily implimenting HDR, but when we want to over saturate with light
		// we have to swap from multiply to addition to add light instead of
		// guiding the light with multiply
		if ( original_color[0] > 1.0 ) {
			modded_color[0] = texture_color[0] + original_color[0];
		}
		
		if ( original_color[1] > 1.0 ) {
			modded_color[1] = texture_color[1] + original_color[1];
		}
		
		if ( original_color[2] > 1.0 ) {
			modded_color[2] = texture_color[2] + original_color[2];
		}
		
		//hdr_scale = sin(Time * 2.0) + 1.0;
		
		modded_color = clamp(modded_color * hdr_scale, 0.0, 1.0);
		
		modded_color[3] = 1.0;
		
		return modded_color;
	}
]]

-- When the engine calls to load your level
-- Here you state how the mesh is formatted
-- Winding order
-- CW, CCW
-- and then data format for shaders
-- 
-- Wavefront OBJ
-- { x, y, z, [w] }
-- { u, [v, w] }21
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

-- Need to extend this out into the real engine
-- TODO: Suggest a better way of handling this for LOVR devs
-- TODO: OR create a temporary sampler every mesh call?? because of all the different modes
-- Anyway translated to GL terms as well
--
-- This may have a problem with creating more compare types... like use only one type for shadows and this has to be restarted when changed
local sampler_SWrapTWrap = lovr.graphics.newSampler({filter={"linear", "linear", "linear"}, wrap={"repeat", "repeat", "clamp"}, compare="gequal"})
local sampler_SWrapTEdge = lovr.graphics.newSampler({filter={"linear", "linear", "linear"}, wrap={"repeat", "clamp", "clamp"}, compare="gequal"})
local sampler_SEdgeTWrap = lovr.graphics.newSampler({filter={"linear", "linear", "linear"}, wrap={"clamp", "repeat", "clamp"}, compare="gequal"})
local sampler_SEdgeTEdge = lovr.graphics.newSampler({filter={"linear", "linear", "linear"}, wrap={"clamp", "clamp", "clamp"}, compare="gequal"})

local room_textures = {}

-- Using tables because they are basically structs without names
local rooms_room = {}
local rooms_info = {}

local shader_playaround = lovr.graphics.newShader(raw_shader_play_vert, raw_shader_play_frag)
--local shader_playaround = lovr.graphics.newShader("unlit", raw_shader_play_frag)

local function renderScene( pass, import_table )
	local groups_count = import_table[1]
	
	local surface_count = 0
	-- LUA 1 indices
	local vertice_count = 1
	
	pass:setWinding("counterclockwise")
	--pass:setWinding("clockwise")
	
	local clampS = false
	local clampT = false
	
	for group_index = 1, groups_count do
		local current_group = import_table[3][group_index]
		
		-- ROOM_TEXTURES:
		--		{texture, flags_a, flags_b, flags_c}
		pass:setMaterial( room_textures[ current_group[1] + 1 ][1] )
		
		clampS = bit.band( room_textures[ current_group[1] + 1 ][2], 1 ) == 1
		clampT = bit.band( room_textures[ current_group[1] + 1 ][3], 1 ) == 1
		
		if ( clampS and clampT ) then
			pass:setSampler( sampler_SEdgeTEdge )
			
		elseif ( clampS and not clampT ) then
			pass:setSampler( sampler_SEdgeTWrap )
			
		elseif ( not clampS and clampT ) then
			pass:setSampler( sampler_SWrapTEdge )
			
		elseif ( not clampS and not clampT ) then
			pass:setSampler( sampler_SWrapTWrap )
			
		else
			pass:setSampler("linear")
		end
		
		-- //\\ //\\
		pass:send("s_wrap", room_textures[ current_group[1] + 1 ][2])
		
		pass:send("t_wrap", room_textures[ current_group[1] + 1 ][3])
		-- \\//\\//
		
		for surface_index = 1, current_group[2] do
			-- SURFACE:
			--		{vert_count, flags_a, flags_b}
			local current_surface = import_table[4][surface_count + surface_index]
			
			local surface_vert_count = (current_surface[1] - 2) * 3
			
			-- Material IDs are stored as indices for meshs starting from 1
			-- Material IDs point to the table created for the room
			
			pass:setCullMode("front")
			
			if ( bit.band(current_surface[3], 1) == 1 ) then
				pass:setCullMode("back")
			end
			
			pass:mesh( import_table[5], lovr.math.mat4(), vertice_count, surface_vert_count, 1 )
			
			vertice_count = vertice_count + surface_vert_count
		end
		
		surface_count = surface_count + current_group[2]
	end
end

--{primary_group_size, secondary_group_size, mesh_groups, room_surfaces, mesh_buffer}

function ts.renderScene( pass, import_table )
	pass:setShader( shader_playaround )
	
	pass:setSampler( sampler_SWrapTWrap )
	
	for k = 1, #rooms_room do
		
		renderScene( pass, rooms_room[k] )
		
	end
	
	pass:setSampler("linear")
end

--[[
blob_file

room_surfaces table
1 = vert_count
2 = flags_a
3 = flags_b

address_table
1 = {primary_groups, primary_strips, primary_verts, primary_uvs, primary_colors, primary_group_size}
2 = {secondary_groups, secondary_strips, secondary_verts, secondary_uvs, secondary_colors, secondary_group_size}
]]
function generateMesh( blob_file, room_surfaces, address_mesh, address_table )
	local mesh_element = {}
	
		--
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
					
					--if ( red < 0 or gre < 0 or blu < 0 or alp < 0 ) then
					--	print("AAH", red, gre, blu, alp)
					--end
					
					--
					-- The binary is in bytes, let's store them this way and we can convert the color in the shader!
					--[[red = red / 127.0
					gre = gre / 127.0
					blu = blu / 127.0
					alp = alp / 127.0]]
					
					-- SWEET! all the data is being read correctly!
					-- Now we set element table to hold the values in the way that GL
					mesh_element[new_vert_index] = { position_x, position_y, position_z, 0, 1, 0, uv_x, uv_y, red, gre, blu, alp }
					
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

--
-- Returns: vertice count, table of strip information
local function get_strips( blob, strips_size, strips_address )
	local vertice_count, file_index = 0, 0
	local strip_info = {}
	
	if ( strips_address > 0 ) then
		
		for i = 1, strips_size do
			-- lua: indexs start at 1, so for loops naturally are <=
			file_index = strips_address + ((i - 1) * 16)
			
			local vert_count = blob:getU8(file_index, 1)
			file_index = file_index + 1
			
			local flags_a = blob:getU8(file_index, 1)
			file_index = file_index + 1
			
			local flags_b = blob:getU8(file_index, 1)
			file_index = file_index + 1
			
			strip_info[i] = {vert_count, flags_a, flags_b}
			
			-- Raw value
			--vertice_count = vertice_count + vert_count
			
			-- TODO: 24/2/11 Create samplers for each strip setup. Even though I think
			-- graphics cards might not natively support all strip modes on drawing?
			-- Because if this is a graphics card option and not just a GL option
			-- this could open the window to all drawing modes per call?
			
			-- We are converting vertice count to triangle count for this engine
			vertice_count = vertice_count + (vert_count - 2)
		end
		
	end
	
	return strip_info
end

-- Bad naming change this!
local areaportals_level = {}
local areaportals_rooms = {}

local room_a_adjacent_rooms = 0
local room_b_adjacent_rooms = 0
local level_room_a_adjacent_rooms = {}
local level_room_b_adjacent_rooms = {}
local areaportal_addresses = {}
local vertex_position_color = {}

local function do_area_portals( blob_file, room_count, block_rooms, block_areaportals )
	local file_index = block_rooms + (1 * 4 * 11)
	
	--print("READ:", file_index)
	
	-- Read the first room's mesh address because the area portal list is above it
	-- I am probably reading this out of order but this works
	local x_areaportal = blob_file:getU32(file_index, 1)
	
	file_index = x_areaportal - 60
	
	--print("READ:", file_index)
	
	local areaportal_end = blob_file:getU32(file_index, 1)
	
	local areaportal_count = (areaportal_end - block_areaportals) / 16
	areaportal_count = (areaportal_count - 1) * 4
	
	for i = 1, areaportal_count do areaportals_level[i] = {} end
	for i = 1, (room_count - 1) do areaportals_rooms[i] = {} end
	
	print("PORTALS ():", areaportal_count)
	
	-- Area Portal vertice positions
	for i = 1, areaportal_count do
		areaportal_addresses[i + 0] = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
		
		areaportal_addresses[i + 1] = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
		
		areaportal_addresses[i + 2] = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
		
		areaportal_addresses[i + 3] = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
	end
	
	local areaportal_vertice_count = 0
	
	for areaportal_index = 1, areaportal_count do
		file_index = block_areaportals + (areaportal_index * 4)
		
		local areaportal_address = blob_file:getU32(file_index, 1)
		
		file_index = areaportal_address * 1
		
		local room_a = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
		
		local room_b = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
		
		-- Room indices are off by one
		-- And we skip room zero!
		room_a = room_a - 1
		room_b = room_b - 1
		
		-- Unknown flags
		local unknown_a = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
		local unknown_b = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
		local unknown_c = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
		
		-- Area Portals are triangle fans :>
		local vert_count = blob_file:getU32(file_index, 1)
		
		local vert_fan_count = vert_count
		
		if (vert_count > 3) then
			vert_fan_count = vert_fan_count + ((vert_count - 3) * 2)
		end
		
		local vert_index = 0
		
		for i = 1, vert_fan_count do
			vertex_position_color[i] = {}
			
			local x = blob_file:getF32(file_index, 1)
			file_index = file_index + 4
			local y = blob_file:getF32(file_index, 1)
			file_index = file_index + 4
			local z = blob_file:getF32(file_index, 1)
			file_index = file_index + 4
			
			--print(x, y, z)
			
			--[[if (i > 2) then
				vertex_position_color[] = vertex_position_color[j - 1]
				vertex_position_color[] = vertex_position_color[j - 3]
				vertex_position_color[] = {}
				
				vert_index = vert_index + 2
			else
				
				
			end]]
		end
		
		--print("ap test", room_a, "||", room_b)
		
		areaportals_level[areaportal_index] = {room_a, room_b, vert_count, areaportal_vertice_count}
		
		local portal_a_good = true
		local portal_b_good = true
		
		-- -..-
		-- adjacent rooms is an ipairs
		for i = 0, room_a_adjacent_rooms do
			if (room_b == level_room_a_adjacent_rooms[i]) then
				portal_a_good = false
			end
		end
		
		-- The difference is that ipairs counts the array, instead of referencing the number we are counting
		--[[for i = 0, ipairs(level_room_a_adjacent_rooms) do
			if (room_b == level_room_a_adjacent_rooms[i]) then
				portal_a_good = false
			end
		end]]
		
		for i = 0, room_b_adjacent_rooms do
			if (room_a == level_room_b_adjacent_rooms[i]) then
				portal_b_good = false
			end
		end
		
		if (portal_a_good) then
			--print("	ap:", areaportal_index, room_b)
			
			level_room_a_adjacent_rooms[room_a_adjacent_rooms] = room_b
			room_a_adjacent_rooms = room_a_adjacent_rooms + 1
		end
		
		if (portal_b_good) then
			--print("	ap:", areaportal_index, room_a)
			
			level_room_b_adjacent_rooms[room_b_adjacent_rooms] = room_a
			room_b_adjacent_rooms = room_b_adjacent_rooms + 1
		end
		
		-- Keep count of the vertices
		areaportal_vertice_count = areaportal_vertice_count + vert_count
	end
	
	print("VERT COUNMT:", areaportal_vertice_count)
	
	--file_index
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
	
	-- pointers to the position where the list of each other mesh component this model format uses
	local block_materials = blob_file:getU32(0, 1)
	local block_rooms = blob_file:getU32(4, 1)
	local block_areaportals = blob_file:getU32(8, 1)
	
	--print( block_materials, block_rooms, block_areaportals )
	
	file_index = file_index + 8
	
	-- We can use the multiple of 8 from a byte to calculate hard counts of each struct based off what was found through reverse engineering
	-- The storage format for this model aligns to every 4 bytes, so we can easily calculate the size of each list
	local material_count = (block_rooms - block_materials) / 16
	local room_count = math.floor( ((block_areaportals - block_rooms) / 4 / 11) - 1 )
	
	--print( block_materials, block_rooms, block_areaportals )
	--print( "(Timesplitters) Material Count: ", material_count, " Rooms: ", room_count )
	
	-- //// Textures ////
	file_index = block_materials * 1
	
	-- IN Cpp this for loop is 0 to 38
	-- IN Lua this for loop is 0 to 39 () : 0 to (x - 1)
	-- Lua is 1 to (x - 1)
	for material_index = 1, (material_count - 1) do
		local texture_index = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
		
		local texture_flags_a = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
		local texture_flags_b = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
		local texture_flags_c = blob_file:getU32(file_index, 1)
		file_index = file_index + 4
		
		--print( "texture: ", texture_index, material_index )
		
		--print( "t	", texture_index, texture_flags_a, bit.band(texture_flags_a, 1), texture_flags_b, bit.band(texture_flags_b, 1) )
		
		-- Then we create a list of materials with all of the following flags
		-- And texture name
		
		local texture_image = ts.loadTexture( string.format("addons/timesplitters/textures/%04d.qpm", texture_index), string.format("%04d", texture_index) )
		
		room_textures[material_index] = {texture_image, texture_flags_a, texture_flags_b, texture_flags_c}
	end
	
	for room_index = 1, (room_count - 1) do rooms_room[room_index] = {} end
	
	print("ROOMS:", room_count)
	
	-- //// Meshes ////
	-- We start with one and (room_count - 1)
	for room_index = 1, (room_count - 1) do
		-- Start the reading head at the rooms block of the file that we read before
		-- This is an address in bytes of the file, using the size of a room index
		-- that is determined from a hex editor to be 11 times 4 bytes long.
		file_index = (1 * block_rooms) + (room_index * 4 * 11)
		
		file_index = file_index + 20-- 4 * 5
		
		local room_bounds_min_x, room_bounds_min_y, room_bounds_min_z = blob_file:getF32(file_index, 3)
		file_index = file_index + (4 * 3)
		
		local room_bounds_max_x, room_bounds_max_y, room_bounds_max_z = blob_file:getF32(file_index, 3)
		file_index = file_index + (4 * 3)
		
		-- First mesh is the primary opaque mesh format
		-- We use the very top of the rooms address and cycle through getting the mesh addresses
		local address_mesh = blob_file:getU32(block_rooms + math.floor(4 * 11 * room_index), 1)
		
		--rooms_info = {}
		
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
		
		-- Unknown
		file_index = file_index + 8-- Skip two unknowns
		
		-- SECONDARY
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
		
		--[[
			I think I should add an assert to make sure these values never have decimals
			If there is a decimal the data is incorrect always, the math above must be correct though
			It has a lot of benefits to use a structure like this to hold this kind of data
		]]
		
		local address_mesh_terminator = address_mesh - 8 - 64 - 8
		
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
		end
		
		-- TODO: Secondary Groups
		-- Secondary is all of the transparent non shootable geometry
		
		-- TODO: Has to be in this scope, need to change
		local primary_surfaces = get_strips( blob_file, primary_strip_size, primary_strips )
		
		-- TODO: Secondary Strips
		
		-- LOVR we want to store the values we read so that we can pass them to a mesh function
		-- I originally determined Timeplitters to use GL for it's graphics and it is true
		-- that it's raw format for levels are in a 3 floats per position and so on
		-- Setup an array that we can store all the values in to make transfers easy
		
		local room_primary = {primary_groups, primary_strips, primary_verts, primary_uvs, primary_colors, primary_group_size}
		local room_secondary = {secondary_groups, secondary_strips, secondary_verts, secondary_uvs, secondary_colors, secondary_group_size}
		
		-- Put all these addresses into a table because why not
		local pass_to_mesh_maker = {room_primary, room_secondary}
		
		-- Generate a mesh via addresses
		local mesh_data, mesh_groups = generateMesh( blob_file, primary_surfaces, address_mesh, pass_to_mesh_maker )
		
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
			
			--local material_id = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			file_index = file_index + 4
			
			local group_strips_count = blob_file:getU32(file_index, 1)
			file_index = file_index + 4
			
			--local group_vertices_start = blob_file:getU32(file_index, 1)
			
			for k = 1, group_strips_count do
				local strip = primary_surfaces[new_strip_index]
				
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
					--new_mesh_data[ triangle_offset + 1 ] = mesh_data[ fixed_index + 0 ]
					--new_mesh_data[ triangle_offset + 2 ] = mesh_data[ fixed_index + 1 ]
					--new_mesh_data[ triangle_offset + 3 ] = mesh_data[ fixed_index + 2 ]
					
					if ( bit.band(vert_index, 1) == 1 ) then
						new_mesh_data[ triangle_offset + 1 ] = mesh_data[ fixed_index + 2 ]
						new_mesh_data[ triangle_offset + 2 ] = mesh_data[ fixed_index + 1 ]
						new_mesh_data[ triangle_offset + 3 ] = mesh_data[ fixed_index + 0 ]
					else
						new_mesh_data[ triangle_offset + 1 ] = mesh_data[ fixed_index + 0 ]
						new_mesh_data[ triangle_offset + 2 ] = mesh_data[ fixed_index + 1 ]
						new_mesh_data[ triangle_offset + 3 ] = mesh_data[ fixed_index + 2 ]
					end
					
					new_vert_index = new_vert_index + 1
					
					test_vert_index = test_vert_index + 1
				end
				
				orig_offset = orig_offset + strip_vert_count
				--new_offset = new_offset + (strip_vert_count - 2)
				new_strip_index = new_strip_index + 1
			end
		end
		
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
		
		local mesh_buffer = lovr.graphics.newBuffer(test_mesh_format, new_mesh_data)
		
		rooms_room[room_index] = {primary_group_size, secondary_group_size, mesh_groups, primary_surfaces, mesh_buffer}
	end
	
	-- Area Portals and Visibility
	-- Basically Binary Space Partitioning using stencil portals
	do_area_portals( blob_file, room_count, block_rooms, block_areaportals )
	
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
	
	sampler_SWrapTWrap = lovr.graphics.newSampler({filter={"linear", "linear", "linear"}, wrap={"repeat", "repeat", "clamp"}, compare="gequal"})
	sampler_SWrapTEdge = lovr.graphics.newSampler({filter={"linear", "linear", "linear"}, wrap={"repeat", "clamp", "clamp"}, compare="gequal"})
	sampler_SEdgeTWrap = lovr.graphics.newSampler({filter={"linear", "linear", "linear"}, wrap={"clamp", "repeat", "clamp"}, compare="gequal"})
	sampler_SEdgeTEdge = lovr.graphics.newSampler({filter={"linear", "linear", "linear"}, wrap={"clamp", "clamp", "clamp"}, compare="gequal"})
end

--[[
	Ideas
	
	draw pass
	
	No idea what to call the start and init to load
]]

return ts
