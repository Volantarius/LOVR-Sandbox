local ffi = require("ffi")
local module_addons = require("addons")

-- TODO: Create networking:: We need to get started on this since this is one of the things I have no clue how to setup
-- The most important thing I do know is that I need to keep ALL server code in a managable area so that I can make a dedicated
-- version that can run on it's own without depending on the renderer or any bloat
-- basically skeletonise the networking, tick, think, send message, receive message... etc.

local vr_enabled = false

local blur_shader = [[
	Constants {
	// This constant will be set every draw to determine whether we are sampling horizontally or vertically.
		vec3 headDirection;
		vec3 headVelocity;
		vec3 headAngularVelocity;
	};
	
	float length_sqr(vec4 a) {
		return (a.x * a.x) + (a.y * a.y) + (a.z * a.z);
	}
	
	// The texture to sample from.
	layout(set = 2, binding = 0) uniform texture2DArray sourceTexture;
	layout(set = 2, binding = 1) uniform texture2DArray outTexture;
	
	// lovr's shader architecture will automatically supply a main(), which will call this lovrmain() function
	vec4 lovrmain() {
		vec4 color = getPixel(sourceTexture, UV, ViewIndex);
		
		float new_alpha = color[3];
		
		vec4 colorReference = getPixel(outTexture, UV, ViewIndex);
		
		// =====================================
		
		float test3 = 1.0 - length_sqr(vec4(UV.y - 0.5, UV.x - 0.5, 0.0, 0.0) + vec4(headAngularVelocity, 0.0));
		
		test3 = inversesqrt(test3) * 0.5;
		
		color += colorReference;
		
		color *= vec4(test3, test3, test3, test3);
		
		return color;
	}
]]

local straight_shader = [[
	// The texture to sample from.
	layout(set = 2, binding = 0) uniform texture2DArray sourceTexture;
	
	// lovr's shader architecture will automatically supply a main(), which will call this lovrmain() function
	vec4 lovrmain() {
		vec4 color = getPixel(sourceTexture, UV, ViewIndex);
		
		return color;
	}
]]

local pi_half_inverted = -math.pi/2

local tempTexture, clamper, screen_shader, screen_shader_two

-- texture system :: use strings to index textures! 8bit is fine like how it is in lua the lookup can be made faster as well
g_textures = {}

function lovr.load()
	local width, height = lovr.headset.getDisplayDimensions()
	local layers = lovr.headset.getViewCount()
	
	screen_shader = lovr.graphics.newShader("fill", blur_shader)
	
	screen_shader_two = lovr.graphics.newShader("fill", straight_shader)
	
	tempTexture = {
		lovr.graphics.newTexture(width, height, layers, { mipmaps = false }),
		lovr.graphics.newTexture(width, height, layers, { mipmaps = false }),
		lovr.graphics.newTexture(width, height, layers, { mipmaps = false })
	}
	
	clamper = lovr.graphics.newSampler({ wrap = "clamp" })
	
	local blue_texture = lovr.graphics.newTexture("brown_grid.png")
	
	local texture_skybox = lovr.graphics.newTexture("dunes_day_no_bottom.png")
	
	table.insert(g_textures, blue_texture)
	table.insert(g_textures, texture_skybox)
	
	-- Initialize as if the addon is for the engine
	module_addons.init()
	
	-- Initialize as if the addon is for development
	local ts_index = module_addons.checkAddon( "timesplitters" )-- Because we can call for a name instead of literally writing it IN CODE
	
	-- For the engine side using a string check for our project addon we can make sure we can
	-- fail safely and continue running the game without having to crash and stuff
	if ( ts_index ~= nil ) then
		local ts_table = module_addons.getAddonTable( ts_index )
		
		-- Volantarius: This makes it so I can prototype invokations instead of seperating the files or namespace
		-- Users can create addons that the engine would have to be modified in order to run maliciously if it really was backwards??
		-- Actually YES all of lovr context would be available, but then again all code is kind of available in some way
		-- BUT the point is I made unification of the context of lua
		
		-- YAY it works!
		print( ts_table.loadLevel( "addons/timesplitters/levels/level10.raw" ) )
		-- Like get levelFile(3) will return a mesh
		
		-- Things like running over every addon from the addon count and calling each of their functions that returns a function
		-- This makes addon prototyping extremely easy and can make many addons, like entities, drawable objects, math, what not
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

local function fullScreenDraw( source, stage, destination, headDirection, headVelocity, headAngularVelocity )
	local pass = lovr.graphics.getPass("render", {destination,depth=false,samples=1})
	pass:setSampler(clamper)
	pass:setShader(screen_shader)
	pass:send("sourceTexture", source)
	pass:send("outTexture", stage)
	pass:send("headDirection", headDirection)
	pass:send("headVelocity", headVelocity)
	pass:send("headAngularVelocity", headAngularVelocity)
	pass:fill()
	return pass
end

local function inheritDraw( source, destination )
	local pass = lovr.graphics.getPass("render", {destination,depth=false,samples=1})
	pass:setSampler(clamper)
	pass:setShader(screen_shader_two)
	pass:send("sourceTexture", source)
	pass:fill()
	return pass
end

--lovr.graphics.submit(headset, window)
-- SOOO yeah we can replace `headset` with another PASS. This way we can actually do seperate eye rendering!

local time_now = lovr.headset.getTime()
local time_last = time_now

function draw_joint_lines( pass, point_table, key, offset, modolus )
	local joint = point_table[key]
	
	local joint_next = point_table[key + 1]
	
	local adjusted_index = key - offset
	
	if ( joint_next and (adjusted_index % modolus) ~= 0 ) then
		
		pass:line( lovr.math.vec3( unpack( joint, 1, 3 ) ), lovr.math.vec3( unpack( joint_next, 1, 3 ) ) )
	end
end

local hmd_direction_old_x, hmd_direction_old_y, hmd_direction_old_z = 0, 0, 0
local view_l_x, view_l_y, view_l_z, view_l_a, view_l_ax, view_l_ay, view_l_az = 0,0,0, 0,0,0,0
local view_r_x, view_r_y, view_r_z, view_r_a, view_r_ax, view_r_ay, view_r_az = 0,0,0, 0,0,0,0

function runExampleScene( pass )
	pass:setColor(0.76, 1, 0)
	pass:sphere(0, 30, 10, 0.5, 0, 0, 0, 0, 16, 8)
	
	pass:setColor(1, 1, 1)
	pass:setMaterial( g_textures[1] )
	pass:plane(0, -0.7, 0, 64, 64, pi_half_inverted, 1, 0, 0, "fill", 4, 4)
	pass:setMaterial( nil )
	
	pass:setColor(1.0, 0.76, 0.0)
	
	pass:text("hello world :)", 0.0, 1.7, -3.0)
	
	pass:setColor(1.0, 0.95, 0.0)
	pass:cube(0, 1.7, -1.0, 0.5, time_now, 0, 1, 0, "line")
	pass:setColor(1, 1, 1)
end

-- We got pass:push and pass:pop!
function lovr.draw(pass)
	time_last = time_now
	time_now = lovr.headset.getTime()
	
	vr_left = lovr.headset.isTracked("left")
	vr_right = lovr.headset.isTracked("right")
	
	local hand_right_direction_x, hand_right_direction_y, hand_right_direction_z = 0, 0, 0
	local hand_right_pos_x, hand_right_pos_y, hand_right_pos_z = 0, 0, 0
	
	if ( vr_right ) then
		hand_right_direction_x, hand_right_direction_y, hand_right_direction_z = lovr.headset.getDirection("right")
		hand_right_pos_x, hand_right_pos_y, hand_right_pos_z = lovr.headset.getPosition("right")
	end
	
	local passes = {}
	
	local scene = lovr.graphics.getPass("render", tempTexture[1])
	
	local vr_eyes = pass:getViewCount()
	
	for i = 1, vr_eyes do
		if ( vr_eyes > 1 ) then
			-- Grab the originals right away
			if ( i == 2 ) then
				view_r_x, view_r_y, view_r_z, view_r_a, view_r_ax, view_r_ay, view_r_az = pass:getViewPose(i)
			else
				view_l_x, view_l_y, view_l_z, view_l_a, view_l_ax, view_l_ay, view_l_az = pass:getViewPose(i)
			end
			
			--[[if ( i == 2 and vr_right ) then
				local ta, tb, tc, td = lovr.headset.getOrientation("right")
				
				scene:setViewPose(i, hand_right_pos_x, hand_right_pos_y, hand_right_pos_z, ta, tb, tc, td)
				
				scene:setColor(0.7, 0.6, 0.5)
				scene:setCullMode("back")
				scene:sphere(hand_right_pos_x, hand_right_pos_y, hand_right_pos_z, 0.028, ta, tb, tc, td, 16, 8)
				scene:setColor(1,1,1)
			else
				scene:setColor(0.6, 0.5, 0.4)
				scene:setCullMode("back")
				scene:sphere(view_l_x, view_l_y, view_l_z, 0.028, view_l_a, view_l_ax, view_l_ay, view_l_az, 16, 8)
				scene:setColor(1,1,1)
				
				scene:setViewPose(i, view_l_x, view_l_y, view_l_z, view_l_a, view_l_ax, view_l_ay, view_l_az)
			end]]
			
			if ( i == 2 ) then
				scene:setViewPose(i, view_r_x, view_r_y, view_r_z, view_r_a, view_r_ax, view_r_ay, view_r_az)
			else
				scene:setViewPose(i, view_l_x, view_l_y, view_l_z, view_l_a, view_l_ax, view_l_ay, view_l_az)
			end
			
		end
		
		scene:setProjection(i, pass:getProjection( i, mat4() ))
	end
	
	scene:skybox(g_textures[2])
	
	-- //////////////////////////////////////////////////////////////////////////////
	--pass:push("state")
	
	-- DRAW SCENE HERE
	runExampleScene( scene )
	
	-- TODO: Only issue is that we can't pose easily. We can do inverse kinematics at some point but uh yeah were not doing anything insane
	if (vr_left and vr_right) then
		for k, hand in ipairs( {"left", "right"} ) do
			local transforms = lovr.headset.getSkeleton( hand )
			
			-- From the thumb to every finger's proximal and tip we create a triangle and calculate the radius
			local hand_grab_radius = 0
			
			local thumb_tip_transform = transforms[6]
			
			if ( lovr.headset.isTracked( hand ) ) then
				for kk = 3, 6 do
					draw_joint_lines( scene, transforms, kk, 2, 4 )
				end
				
				for kk = 7, 26 do
					draw_joint_lines( scene, transforms, kk, 6, 5 )
					
					-- Now with the finger we do tip to the proximal
					-- Then thumbtip to proximal
				end
			end
		end
	end
	
	--scene:pop("state")
	-- //////////////////////////////////////////////////////////////////////////////
	
	local hmd_direction_x, hmd_direction_y, hmd_direction_z = lovr.headset.getDirection("head")
	local hmd_velocity_x, hmd_velocity_y, hmd_velocity_z = lovr.headset.getVelocity("head")
	local hmd_angular_velocity_x, hmd_angular_velocity_y, hmd_angular_velocity_z = lovr.headset.getAngularVelocity("head")
	
	-- THIS PASS thing could probably be changed in the future? There must be a way to setup the clear function to act differently
	table.insert(passes, scene)
	
	--table.insert(passes, inheritDraw(tempTexture[1], tempTexture[2]))
	--table.insert(passes, fullScreenDraw(tempTexture[1], tempTexture[2], tempTexture[3],
	--	{hmd_direction_x, hmd_direction_y, hmd_direction_z},
	--	{hmd_velocity_x, hmd_velocity_y, hmd_velocity_z},
	--	{hmd_angular_velocity_x, hmd_angular_velocity_y, hmd_angular_velocity_z}
	--))
	
	--table.insert(passes, inheritDraw(tempTexture[3], tempTexture[1]))
	
	--hmd_direction_old_x, hmd_direction_old_y, hmd_direction_old_z = hmd_direction_x, hmd_direction_y, hmd_direction_z
	--hmd_direction_old_x, hmd_direction_old_y, hmd_direction_old_z = hmd_velocity_x, hmd_velocity_y, hmd_velocity_z
	
	table.insert(passes, inheritDraw(tempTexture[3], tempTexture[2]))
	
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
	
	pass:text(string.format("%f %f %f %f", hmd_angle, hmd_ax, hmd_ay, hmd_az), 0.0, 0.0, -20.0)
	
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

-- Functions = asdAsd because everything else is that
-- variables = VERY IMPORTANT! dominate name is first. sims2 had an awesome structure of shirt_type_color same with what we should do

--[[
	TODO: Make a cube follow me to get the very basic locomotion setup.
	Player must be noclip but we need to make sure we have the math setup for the basics of following the player
	
]]
function lovr.update(delta)
	if ( lovr.headset.isTracked("left") ) then
		
		local left_trackpad_x, left_trackpad_y = lovr.headset.getAxis("left", "thumbstick")
		
		-- so uh i'm thinking of just using some pi for the x and y to make a fake rotation, normalize it and then finally set the matrices to lookat
	end
	
end


