shader_type spatial;

// Colors
uniform vec4 sand_color : hint_color;
uniform vec4 ground_color : hint_color;
uniform vec4 mountain_color : hint_color;
uniform vec4 snow_color : hint_color;

// Noise textures
uniform sampler2D heightmap : hint_white;
uniform sampler2D normalmap : hint_white;

uniform float terrain_magnitude : hint_range(0.0, 1.0, 0.01);
uniform float sand_amount : hint_range(0.0, 1.0, 0.01);
uniform float mountain_amount : hint_range(0.0, 1.0, 0.01);
uniform float snow_amount : hint_range(0.0, 1.0, 0.01);

varying float vertexDist;

void vertex() {
	float noise = texture(heightmap, UV).r;
	vec3 offset = NORMAL * noise * noise * terrain_magnitude;
	
	vertexDist = noise;
	
	// Landscape
	VERTEX += offset;
}

void fragment() {
	float isMountain = step(vertexDist, mountain_amount);
	float isSnow = step(vertexDist, snow_amount);
	float isSand = step(vertexDist, sand_amount);
	
	// Water coloring
	vec4 color = ground_color * isMountain * isSnow * (1.0 - isSand);
	color += sand_color * isSand;
	color += mountain_color * (1.0 - isMountain);
	color += snow_color * (1.0 - isSnow);
	
	// Mountain color
	NORMALMAP = texture(normalmap, UV).xyz;
	ALBEDO = color.rgb;
	METALLIC = 0.0;
	ROUGHNESS = 0.7;
}