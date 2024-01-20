--[[
	
	So you want to know how to code in LUA eh?
	We'll it tis a simple language that when you understand how variables and tables are
	stored on a computer, this language can be used to do many tasks with very simple bytecode translation
	
	FAQS
	
	Lua does not have a hard type for it's numbers but should treat each number as a float
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
	IDEAS
	
	position : size and count
	the values are stored at the top of the list
	where a file reader can then read those values and interpret them as addresses to the read of the file
	the file will then have the data be in a certain format like 4 bytes per struct
	
]]

dont_run_me()