[[
cool shaders!


// The texture to sample from.

float hdr_scale = 1.0;

// lovr's shader architecture will automatically supply a main(), which will call this lovrmain() function
vec4 lovrmain() {
	//vec4 color_coord = getPixel(ColorTexture, UV);
	vec4 color_coord = texture(sampler2D(ColorTexture, Sampler), UV);
	
	hdr_scale = abs(sin(Time * 0.2));
	
	float byte_scale = 127.0 * hdr_scale;
	
	vec4 cool_color = (Color / byte_scale);
	
	vec4 cool = (cool_color * cool_color) * color_coord;
	
	// 
	// Maybe lower half is multiply and topper half is add
	// 
	
	if ( cool_color[0] > hdr_scale ) {
		cool[0] = color_coord[0];
		
		cool[0] += (byte_scale - Color[0]) / byte_scale;
		
		cool[0] = clamp(cool[0], 0.0, 1.0);
	}
	if ( cool_color[1] > hdr_scale ) {
		cool[1] = color_coord[1];
		
		cool[1] += (byte_scale - Color[1]) / byte_scale;
		
		cool[1] = clamp(cool[1], 0.0, 1.0);
	}
	if ( cool_color[2] > hdr_scale ) {
		cool[2] = color_coord[2];
		
		cool[2] += (byte_scale - Color[2]) / byte_scale;
		
		cool[2] = clamp(cool[2], 0.0, 1.0);
	}
	
	cool[3] = 1.0;
	
	return cool;
}

/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

	Trueset 3D looking light, still wrong though!

/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

// The texture to sample from.

float hdr_scale = 1.0;

// lovr's shader architecture will automatically supply a main(), which will call this lovrmain() function
vec4 lovrmain() {
	//vec4 color_coord = getPixel(ColorTexture, UV);
	vec4 color_coord = texture(sampler2D(ColorTexture, Sampler), UV);
	
	hdr_scale = abs(sin(Time * 0.2));
	
	float byte_scale = 127.0 * hdr_scale;
	
	vec4 cool_color = (Color / byte_scale);
	
	vec4 cool = (cool_color * cool_color) * (color_coord * (hdr_scale * 0.5));
	
	// 
	// Maybe lower half is multiply and topper half is add
	// 
	
	if ( cool_color[0] > hdr_scale ) {
		cool[0] = color_coord[0] * (hdr_scale * 0.5);
		
		float aa = (Color[0] - byte_scale) / byte_scale;
		
		cool[0] += aa * aa;
		
		cool[0] = clamp(cool[0], 0.0, 1.0);
	}
	if ( cool_color[1] > hdr_scale ) {
		cool[1] = color_coord[1] * (hdr_scale * 0.5);
		
		float aa = (Color[1] - byte_scale) / byte_scale;
		
		cool[1] += aa * aa;
		
		cool[1] = clamp(cool[1], 0.0, 1.0);
	}
	if ( cool_color[2] > hdr_scale ) {
		cool[2] = color_coord[2] * (hdr_scale * 0.5);
		
		float aa = (Color[2] - byte_scale) / byte_scale;
		
		cool[2] += aa * aa;
		
		cool[2] = clamp(cool[2], 0.0, 1.0);
	}
	
	cool[3] = 1.0;
	
	return cool;
}
