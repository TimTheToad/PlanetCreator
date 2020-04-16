shader_type spatial;

// Colors
uniform vec4 water_color : hint_color;

// Noise textures
uniform sampler2D heightmap : hint_white;
uniform sampler2D normalmap : hint_white;

uniform float water_magnitude : hint_range(0.0, 1.0, 0.01);
uniform float wave_speed : hint_range(0.0, 0.1, 0.001);
uniform float wave_height : hint_range(0.0, 0.1, 0.001);

varying vec2 uv;

void vertex() {
	uv = vec2(UV.x + sin(UV.x)+ TIME * wave_speed, UV.y);
	
	float noise = texture(heightmap, uv).r;
	vec3 offset = NORMAL * water_magnitude + NORMAL * noise * wave_height;
	
	// Landscape
	VERTEX += offset;
}

void fragment() {

	// Water coloring
	vec4 color = water_color;
	// Mountain color
	NORMALMAP = texture(normalmap, uv).xyz;
	ALPHA = 0.7;
	ALBEDO = color.rgb;
	METALLIC = 0.4;
	ROUGHNESS = 0.3;
}