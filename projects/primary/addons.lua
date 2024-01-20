-- Volantarius 2023
-- Yes this will allow you to create your own addon structure without hassle of loosing the main context
-- Must resize if these get too large, or actually create a new table to overflow into
local addon_list = {}

local addons = {}

local addons_index = {}

local addons_creation_counter = 0

-- TODO: Add real warnings to the setup so that things can actually fail better
-- TODO: I should keep note of where the loop will fail

function addons.init()
	local directory_addons = lovr.filesystem.getDirectoryItems( "addons" )
	
	-- Oh yess
	for k, entry_name in ipairs( directory_addons ) do
		local is_directory = lovr.filesystem.isDirectory( "addons/" .. entry_name )
		
		-- we can do ( unpack(dir list) )
		-- asd/ and the / is a terminator
		-- asd.txt and . is a terminator
		
		if ( is_directory ) then
			--local table_path = {}
			--table.insert( table_path, "addons/" )
			
			local path_main = "addons/" .. entry_name .. "/" .. entry_name .. ".lua"
			
			local has_addon_header = lovr.filesystem.isFile( "addons/" .. entry_name .. "/" .. entry_name .. ".txt" )
			
			print( "Adding addon: ", entry_name, has_addon_header )
			
			local has_main_file = lovr.filesystem.isFile( path_main )
			
			-- The result is stored into the addons table
			if ( has_main_file ) then
				
				local lua_table = require( "addons/" .. entry_name .. "/" .. entry_name )
				
				table.insert( addons, lua_table )
				
			else
				-- BREAK
				table.insert( addons, { "TEMPORARY" } )
				
			end
			
			-- Increament the count, since table insert doesn't return a position
			addons_creation_counter = addons_creation_counter + 1
			
			-- Store the name to key in this table to get the index from a string
			addons_index[entry_name] = addons_creation_counter
			
			-- Horray!
			print( addons[1][1], addons_index[entry_name] )
			
			print( addons[addons_creation_counter] )
			
			local addon_main_init = addons[addons_creation_counter]-- DAMN lua breaks we need to find a way to check if key exists ASIDUHAS
			
			local addon_lua_init = addon_main_init.init
			
			print( addon_lua_init )
			
			-- OKAY IF THE FUNCTION IS THERE we are good to go
			if ( type(addon_lua_init) == "function" ) then
				addon_main_init.init()
				-- if returns true we can
			end
		end
	end
end

--[[
	IMPORTANT This is a temporary solution for the main engine right now
]]

-- So the input can be a string "timesplitters"
-- RETURNS: Index
function addons.checkAddon( name )
	return addons_index[name]
end

-- After checking if the addon exists and storing the index of the table for this function we get the table back
-- RETURNS: Addon table of functions that can be called like an namespace module.
function addons.getAddonTable( index )
	return addons[index]
end

-- Oh gosh lol we will need to do this at some point because of the games lol

return addons
