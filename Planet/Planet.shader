shader_type spatial;

// Colors
uniform vec4 water_color : hint_color;
uniform vec4 ground_color : hint_color;
uniform vec4 mountain_color : hint_color;
uniform vec4 snow_color : hint_color;

// Noise textures
uniform sampler2D heightmap : hint_white;
uniform sampler2D normalmap : hint_white;

uniform float slider : hint_range(0.0, 1.0, 0.01);
uniform float water_amount : hint_range(0.1, 1.0, 0.01);
uniform float mountain_amount : hint_range(0.0, 1.0, 0.01);
uniform float snow_amount : hint_range(0.0, 1.0, 0.01);

varying float vertexDist;

void vertex() {
	float magnitude = slider;
	float noise = texture(heightmap, UV).r;
	vec3 offset = NORMAL * noise * magnitude;
	vec3 water_offset = offset * 0.9;
	
	vertexDist = length(offset);
	float isWater = step(water_amount, vertexDist);
	
	// Landscape
	VERTEX += offset * isWater + water_offset * (1.0 - isWater);
}

void fragment() {
	float isWater = step(water_amount, vertexDist);
	float isMountain = step(vertexDist, mountain_amount);
	float isSnow = step(vertexDist, snow_amount);
	
	// Water coloring
	vec4 color = ground_color * isWater * isMountain * isSnow;
	color += water_color * (1.0 - isWater);
	color += mountain_color * (1.0 - isMountain);
	color += snow_color * (1.0 - isSnow);
	
	// Mountain color
//	ALPHA = isWater;
	ALBEDO = color.rgb;
	METALLIC = 0.4 * (1.0 - isWater);
	ROUGHNESS = 0.3 * (isWater);
}