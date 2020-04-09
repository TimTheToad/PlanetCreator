shader_type spatial;

// Colors
uniform vec4 water_color : hint_color;


// Noise textures
uniform sampler2D heightmap : hint_white;
uniform sampler2D normalmap : hint_white;

uniform float slider : hint_range(0.0, 1.0, 0.01);
uniform float water_speed : hint_range(0.0, 0.1, 0.001);
uniform float wave_height : hint_range(0.0, 0.1, 0.001);

void vertex() {
	float magnitude = slider;
	float noise = texture(heightmap, UV).r;
	vec3 offset = NORMAL * magnitude + NORMAL * wave_height;
	
	// Landscape
	VERTEX += offset;
}

void fragment() {

	// Water coloring
	vec4 color = water_color;
	// Mountain color
	NORMALMAP = texture(normalmap, UV  + TIME * water_speed).xyz;
	ALPHA = 0.7;
	ALBEDO = color.rgb;
	METALLIC = 0.4;
	ROUGHNESS = 0.3;
}