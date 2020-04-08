shader_type spatial;

// Colors
uniform vec4 water_color : hint_color;
uniform vec4 ground_color : hint_color;
uniform vec4 mountain_color : hint_color;
uniform vec4 snow_color : hint_color;

// Noise textures
uniform sampler2D heightmap : hint_white;

uniform float slider : hint_range(0.0, 1.0, 0.01);
uniform float water_amount : hint_range(0.1, 1.0, 0.01);
uniform float mountain_amount : hint_range(0.0, 1.0, 0.01);
uniform float snow_amount : hint_range(0.0, 1.0, 0.01);

varying float vertex_height;

void vertex() {
	float noise = texture(heightmap, UV).r;
	vec3 offset = NORMAL * noise * slider;
	float isWater = step(water_amount, noise);
	
	// Landscape
	VERTEX += offset * isWater;
	
	// Waves
	float waveNoise = texture(heightmap, UV + TIME * 0.1).r;
	offset = NORMAL * noise * (slider - 0.1) + NORMAL * waveNoise * 0.05;
	VERTEX += offset * (1.0 - isWater);
	
	vertex_height = length(VERTEX) - 1.0;
}

void fragment() {
	
	// Water coloring
	float isWater = step(water_amount, vertex_height);
	float isMountain = step(vertex_height, mountain_amount);
	float isSnow = step(vertex_height, snow_amount);
	
	vec4 color = ground_color * isWater * isMountain;
	color += water_color * (1.0 - isWater);
	color += mountain_color * (1.0 - isMountain);
	color += snow_color * (1.0 - isSnow);
	
	// Mountain color
	ALBEDO = color.rgb;
	METALLIC = 0.1 * (1.0 - isWater);
	ROUGHNESS = 0.4 * (isWater);
}