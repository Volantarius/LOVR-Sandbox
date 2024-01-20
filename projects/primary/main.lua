local ffi = require("ffi")
local module_addons = require("addons")

-- TODO: Create networking:: We need to get started on this since this is one of the things I have no clue how to setup
-- The most important thing I do know is that I need to keep ALL server code in a managable area so that I can make a dedicated
-- version that can run on it's own without depending on the renderer or any bloat
-- basically skeletonise the networking, tick, think, send message, receive message... etc.

-- Should work like how shaders use send to send values over to the shader program, we need one
-- that can handle bytecode commands, like send, print in console, prediction etc.

local blank = 0

local blurShader = [[
	#define WEIGHT0 0.2270270270
	
	float gaussian( float uv, float scalar, float peak_point, float scale, float offset ) {
		float final = 0;
		
		float yyy = fract( (uv + scalar + (offset * scalar)) / scalar );
		
		if ( yyy >= (peak_point - scale) && yyy < peak_point ) {
			final = ( yyy - (peak_point - scale) ) / scale;
		} else if ( yyy >= peak_point && yyy < (peak_point + scale) ) {
			final = ( scale - ( yyy - peak_point ) ) / scale;
		} else {
			final = 0;
		}
		
		return final;
	}
	
	float length_sqr(vec3 a) {
		return (a.x * a.x) + (a.y * a.y) + (a.z * a.z);
	}
	
	float length_sqr(vec4 a) {
		return (a.r * a.r) + (a.g * a.g) + (a.b * a.b) + (a.a * a.a);
	}
	
	Constants {
	// This constant will be set every draw to determine whether we are sampling horizontally or vertically.
		float factor;
	};
	
	// The texture to sample from.
	layout(set = 2, binding = 0) uniform texture2DArray sourceTexture;
	layout(set = 2, binding = 1) uniform texture2DArray outTexture;
	
	// This is the main entry point
	
	// Resolution, Normal, PositionWorld, Color
	
	// lovr's shader architecture will automatically supply a main(), which will call this lovrmain() function
	vec4 lovrmain() {
		vec4 color = getPixel(sourceTexture, UV, ViewIndex);
		
		float new_alpha = color[3];
		
		vec4 color_reference = getPixel(outTexture, UV, ViewIndex);
		
		float riserun = UV.x - 0.5;
		float riserun2 = UV.y - 0.5;
		
		float idk = fract( riserun + riserun2 * 1.0 );
		
		color = clamp( abs(((vec4(factor) - color) * 0.97) - color_reference), 0, 1 );
		//color = clamp( abs(((vec4(1.0) - color) * 0.97 * factor) - color_reference), 0, 1 );
		
		//vec4 color_t = color - color_reference;
		
		//float color_distance = length_sqr(color_t);
		//float difference_normal = inversesqrt(color_distance);
		
		//color = clamp( abs( vec4(difference_normal) ), 0, 1 );
		
		color[3] = new_alpha;
		
		return color;
	}
]]

local straightShader = [[
	// The texture to sample from.
	layout(set = 2, binding = 0) uniform texture2DArray sourceTexture;
	
	// lovr's shader architecture will automatically supply a main(), which will call this lovrmain() function
	vec4 lovrmain() {
		vec4 color = vec4(0.0);
		
		color += getPixel(sourceTexture, UV, ViewIndex);
		
		return color;
	}
]]

-- Functions = asdAsd because everything else is that
-- variables = VERY IMPORTANT! dominate name is first. sims2 had an awesome structure of shirt_type_color same with what we should do
local player_up = lovr.math.newVec3(0, 1, 0)
local player_position = lovr.math.newVec3(0, 0, 0)
local player_rotation = 0-- LOCOMOTION rotation??

local pi_half_inverted = -math.pi/2

local test_mesh = {
	{ 0,  0, 0,  0, 1, 0,  0, 0,  1, 0, 0, 1},
	{ 0, 10, 0,  0, 1, 0,  0, 1,  0, 1, 0, 1},
	{10,  0, 0,  0, 1, 0,  1, 0,  0, 0, 1, 1},
	
	{ 0, 10, 0,  0, 1, 0,  0, 1,  0, 1, 0, 1},
	{10,  0, 0,  0, 1, 0,  1, 0,  0, 0, 1, 1},
	{10, 10, 0,  0, 1, 0,  1, 1,  1, 1, 1, 1}
}
local mesh_example = false

local ts_index = false
local import_table = false

local tempTexture, clamper, screenShader, screenShaderTwo

-- texture system :: use strings to index textures! 8bit is fine like how it is in lua the lookup can be made faster as well
g_textures = {}

function lovr.load()
	local width, height = lovr.headset.getDisplayDimensions()
	local layers = lovr.headset.getViewCount()
	
	screenShader = lovr.graphics.newShader("fill", blurShader)
	
	screenShaderTwo = lovr.graphics.newShader("fill", straightShader)
	
	tempTexture = {
		lovr.graphics.newTexture(width, height, layers, { mipmaps = false }),
		lovr.graphics.newTexture(width, height, layers, { mipmaps = false }),
		lovr.graphics.newTexture(width, height, layers, { mipmaps = false })
	}
	
	clamper = lovr.graphics.newSampler({ wrap = "clamp" })
	
	local texture_brown = lovr.graphics.newTexture("green_grid.png")
	local texture_white = lovr.graphics.newTexture("white_grid.png")
	local texture_skybox = lovr.graphics.newTexture("dunes_day_no_bottom.png")
	
	table.insert(g_textures, texture_brown)
	table.insert(g_textures, texture_white)
	table.insert(g_textures, texture_skybox)
	
	local test_mesh_format = {
		{"VertexPosition", "vec3"},
		{"VertexNormal", "vec3"},
		{"VertexUV", "vec2"},
		{"VertexColor", "vec4"}
	}
	
	mesh_example = lovr.graphics.newMesh(test_mesh_format, test_mesh)
	
	-- /////////////////
	-- Addon development starts here
	-- \\\\\\\\\\\\\\\\\
	
	module_addons.init()
	
	ts_index = module_addons.checkAddon( "timesplitters" )
	
	if ( ts_index > 0 ) then
		local ts_table = module_addons.getAddonTable( ts_index )
		
		--import_table = ts_table.loadLevel( "addons/timesplitters/levels/level10.raw" )
		import_table = ts_table.loadLevel( "addons/timesplitters/levels/level11.raw" )
	end
end

-- main MAIN
function lovr.run()
	if lovr.timer then lovr.timer.step() end
	if lovr.load then lovr.load(arg) end
	
	return function()
		if lovr.system then lovr.system.pollEvents() end
		if lovr.event then
			for name, a, b, c, d in lovr.event.poll() do
				if name == "restart" then
					local cookie = lovr.restart and lovr.restart()
					
					return "restart", cookie
				elseif name == "quit" and (not lovr.quit or not lovr.quit(a)) then
					return a or 0
				end
				
				if lovr.handlers[name] then lovr.handlers[name](a, b, c, d) end
			end
		end
		
		-- OKAY so this could be wrong since it is accounting for more processes or threads!
		local dt = 0
		
		if lovr.time then dt = lovr.timer.step() end
		if lovr.headset then dt = lovr.headset.update() end
		if lovr.update then lovr.update(dt) end
		
		if lovr.graphics then
			local headset = lovr.headset.getPass()
			
			if (headset) then
				lovr.draw( headset )
			end
			
			local window = lovr.graphics.getWindowPass()
			
			if window and (not lovr.mirror or lovr.mirror(window)) then window = nil end
			
			lovr.graphics.submit(headset, window)
			lovr.graphics.present()
		end
		
		if lovr.headset then lovr.headset.submit() end
		lovr.math.drain()
	end
end

local function fullScreenDraw( source, texture_source, texture_stage, destination )
	local pass = lovr.graphics.getPass("render", {destination,depth=false,samples=1})
	pass:setSampler(clamper)
	pass:setShader(screenShader)
	pass:send("factor", source)
	pass:send("sourceTexture", texture_source)
	pass:send("outTexture", texture_stage)
	
	pass:fill()
	return pass
end

local function inheritDraw( source, destination )
	local pass = lovr.graphics.getPass("render", {destination,depth=false,samples=1})
	pass:setSampler(clamper)
	pass:setShader(screenShaderTwo)
	pass:send("sourceTexture", source)
	pass:fill()
	return pass
end

local inital_catch = false

--lovr.graphics.submit(headset, window)
-- SOOO yeah we can replace `headset` with another PASS. This way we can actually do seperate eye rendering!

local time_now = lovr.headset.getTime()
local time_last = time_now

local out_frametime = 0
local out_fixedframetime = 0

function testAddonScene( pass )
	
	if ( import_table ) then
		if ( ts_index > 0 ) then
			local ts_table = module_addons.getAddonTable( ts_index )
			
			pass:setColor(1, 1, 1)
			pass:setMaterial( g_textures[1] )
			ts_table.renderScene( pass, import_table )
			pass:setMaterial( nil )
		end
	end
	
end

function runExampleScene( pass )
	pass:setColor(1, 1, 1)
	pass:draw( mesh_example, -5, 0, -3.5 )
	
	pass:setColor(0.76, 1, 0)
	pass:sphere(-10, 0, 0, 3, 0, 0, 0, 0, 16, 8)
	
	pass:setColor(1, 1, 1)
	pass:setMaterial( g_textures[2] )
	pass:plane(0, -0.7, 0, 10, 10, pi_half_inverted, 1, 0, 0, "fill", 4, 4)
	pass:setMaterial( nil )
	
	pass:setColor(1.0, 0.95, 0.0)
	pass:cube(0, 1.7, -1.0, 0.5, time_now, 0, 1, 0, "line")
	
	
	if ( not initial_catch ) then
		print( pass:getViewCount() )
		
		initial_catch = true
	end
	
	pass:setColor(1.0, 0.02, 0.0)
	
	-- The alpha on text and things have to be drawn last as per usual
	pass:text("hello world :)", 0.0, 1.7, -3.0)
	
	pass:setMaterial( nil )
end

-- We got pass:push and pass:pop!
function lovr.draw(pass)
	time_last = time_now
	time_now = lovr.headset.getTime()
	
	local passes = {}
	
	local scene = lovr.graphics.getPass("render", tempTexture[1])
	
	for i = 1, pass:getViewCount() do
		scene:setViewPose(i, pass:getViewPose(i))
		
		--scene:translate(0, 0, math.sin(time_now))
		scene:translate(player_position)
		
		scene:setProjection(i, pass:getProjection(i, mat4()))
	end
	
	-- //////////////////////////////////////////////////////////////////////////////
	--pass:push("state")
	
	scene:skybox(g_textures[3])
	
	runExampleScene( scene )
	
	testAddonScene( scene )
	
	--scene:pop("state")
	-- //////////////////////////////////////////////////////////////////////////////
	
	local delta = time_now - time_last
	local delta_normal = delta / ( 1 / 90 )
	
	out_frametime = out_frametime + delta
	
	if ( out_frametime >= 1 ) then
		blank, out_frametime = math.modf( out_frametime )
	end
	
	--out_fixedframetime = out_fixedframetime + ( 0.00441 * 400.0 )
	--out_fixedframetime = out_fixedframetime + ( 0.00441 * 20.0 )
	out_fixedframetime = out_fixedframetime + ( 0.00441 * 0.4 )
	
	if ( out_fixedframetime >= 1 ) then
		blank, out_fixedframetime = math.modf( out_fixedframetime )
	end
	
	local out_sinerate = math.sin( math.pi * out_fixedframetime )
	
	--out_sinerate = out_sinerate * out_sinerate
	
	table.insert(passes, scene)
	
	--table.insert(passes, inheritDraw(tempTexture[1], tempTexture[2]))
	
	--table.insert(passes, fullScreenDraw(out_fixedframetime, tempTexture[1], tempTexture[2], tempTexture[3]))
	--table.insert(passes, fullScreenDraw(out_sinerate, tempTexture[1], tempTexture[2], tempTexture[3]))
	
	--table.insert(passes, inheritDraw(tempTexture[3], tempTexture[1]))
	--table.insert(passes, inheritDraw(tempTexture[3], tempTexture[2]))
	
	pass:fill(tempTexture[1])-- FILL WITH two
	
	table.insert(passes, pass)
	
	return lovr.graphics.submit(passes)
end

-- Window companion can be replaced to draw other passes. returning true will disable
--[[function lovr.mirror(pass)
	
	if ( lovr.headset.isTracked("left") ) then
		local sk = lovr.headset.getSkeleton("left")
		
		pass:text( string.format("%f %f %f", sk[16][5], sk[16][6], sk[16][7]), 0.0, 0.0, -20.0 )
	end
	
	--pass:text(string.format("%f %f %f %f", hmd_angle, hmd_ax, hmd_ay, hmd_az), 0.0, 0.0, -20.0)
	
	if ( lovr.headset ) then
		local texture = lovr.headset.getTexture()
		
		if ( texture ) then
			pass:fill(texture)
		else
			return true
		end
	else
		return lovr.draw and lovr.draw(pass)
	end
end]]

-- TODO: VECTORS are annoying and their are temporary module ones `lovr.math.vec3` versus the `vec3`
-- No idea what the difference is but apparently there is a difference and I don't know what it is

function lovr.update(delta)
	if ( lovr.headset.isTracked("left") ) then
		
		local left_thumb_x, left_thumb_y = lovr.headset.getAxis("left", "thumbstick")
		
		local hmd_direction_x, hmd_direction_y, hmd_direction_z = lovr.headset.getDirection("head")
		
		-- NOTICE the vec3 and not lovr.math.vec3
		local hmd_forward = vec3(hmd_direction_x, hmd_direction_y, hmd_direction_z)
		
		local hmd_right = ( vec3(hmd_direction_x, hmd_direction_y, hmd_direction_z) ):cross( player_up )
		hmd_right:normalize()
		
		player_position:add( hmd_forward:mul( -left_thumb_y * 0.05 ) )
		
		player_position:add( hmd_right:mul( -left_thumb_x * 0.05 ) )
	end
	
end


