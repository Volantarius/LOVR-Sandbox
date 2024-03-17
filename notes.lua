--[[
	
	So you want to know how to code in LUA eh?
	We'll it tis a simple language that when you understand how variables and tables are
	stored on a computer, this language can be used to do many tasks with very simple bytecode translation
	
	FAQS
	
	Lua does not have a hard type for it's numbers but should treat each number as a float
]]

--[[
	BITWISE IS IN A LIBRARY
	
	bit.band(2,1) == 0
	bit.band(1,1) == 1
]]

--[[
	
	FOR LOOPS and INDEXING
	
	Lua uses 1 to size to index arrays
	It's commonly 0 to (size - 1) to index
	
	It is also common to use i < (x - 1)
	Lua I think uses <= which is where the (i = 0; x) can be confused
	when writing this way atleast for me! But this can happen when translating code.
	
	
	Lua is different and I need to look it up on why. but
	the following code is a different number of iterations are indices
	
	x = 40
	
	for i = 0, x do
		-- Returns 0 to 40
	end
	
	for i = 1, x do
		-- Returns 1 to 40
	end
	
	for (i = 0; i < x; i++) {
		// Returns 0 to 39
	}
	
	for (i = 1; i < x; i++) {
		// Returns 1 to 39
	}
	
	Do you see the difference? in Lua the for loop stops on 40 and not "less than".
	
	Once you have this down and remember it you can translate written loops in a script
	to lua without having to compute a new script
]]

--[[
	
	ITERATORS
	
	Surprisingly the iterators will stop once they reach a nil
	false is still a type so it can be used of course
	
	local stuff = {
		1,
		2,
		nil,
		3,
		4
	}
	
	-- Does not work, the table will still carry it's size
	-- I think we need to run some table. function to update it
	stuff[5] = nil
	
	-- This removes and updates the size of the table
	table.remove(stuff)
	
	-- This removes the nil that we placed and update the indices removing their originally stored position
	-- So if you wanted to create a way of storing indices of a table but leaving spaces this is not the function to call
	table.remove(stuff, 3)
	
	-- The size operator says differently. there are 5 elements
	print( "size:", #stuff )
	
	-- Stops at a nil, actually very similar to how strings are interpreted, a nil character stops some string definitions
	for k,v in ipairs(stuff) do
		-- ipairs stops at nil
		print(v)
	end
	
	-- So instead of using a ipairs for a interated list use a for loop to count to the size
	-- Using count of a non table will break lua lol
	for i = 1, #stuff do
		print(stuff[i])
	end
	
	But doing this in a more structured way is the best way to actually do this, and I want to figure that out somehow
	I guess it already is though, it's just that it appears to be structured in memory but I think they are all just pointers (citation needed)
	
	But this would make it easy to store the indices in code when appending to the list or removing it via functions
]]

--[[
	
	STREAMS
	
	function (...) end
	
	You can iterate function argument streams in Lua.
	
	(...)[i] = value passed to this function
	
	type((...)[i]) == returns the type given to the function
	
	If you really want to be concerned over the type given to a function you can
	strictly write the code to make sure to not run a non-function. or attempt at performing
	a transformation to the arguments given
	
	nil acts as a terminator in all streams of a function.
	input or output.
	function (...)  return ...2 end
	input ... == (1, nil)
	output ...2 == (2, nil)
	BOTH streams will end at nil. This is how strings also usually stored in simple formats!
	
	if using luajit is the only method I have tested using just the syntax of the language
	in the most simplest format. because ... shouldn't be magic lol. if we can input any number of
	arguments and return any number of arguments we can create models really easily
	calling a function inside a table creates this same iterator that we can iterate the same
	way we do by sending it values.
	
	local call_args = {"a", "b", "c", "d", "e", 1, 1}
	
	local call_returns = { initial_call_function( call_args ) }
	
	for i = 1, #call_returns do
		-- This is the way the return function is written:
		-- call_returns = { "j", "q", 3, nil, false }
		-- but we do not retrieve anything after the nil since that is our terminator!
		--
		-- So this for loop has the values:
		-- { "j", "q", 3 }
		-- Which should be shorter than the ones given
		-- we can be really super sure and make a break in the code to do that as well
		
		initial_call[5][i] = call_returns[i]
	end
	
	This will allow us to programmatically write a function in a way of representing a node
	in this language! This can make storing certain complicated techniques for dealing with
	designing a way of describing a line of reasoning to create certain designs lol
	
]]

--[[
	IDEAS
	
	position : size and count
	the values are stored at the top of the list
	where a file reader can then read those values and interpret them as addresses to the read of the file
	the file will then have the data be in a certain format like 4 bytes per struct
	
]]

dont_run_me()
