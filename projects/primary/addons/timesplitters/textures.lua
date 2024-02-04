-- Textures
local ts = {}

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
function ts.loadTexture( file, name )
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

return ts
