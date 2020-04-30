shader_type spatial;

uniform sampler2D sampler : hint_white;
uniform sampler2D noise;

void fragment() {
	float theta = UV.y * 3.14159;
	float phi = UV.x * 3.14159 * 2.0;
	vec3 unit = vec3(0.0, 0.0, 0.0);
	
	unit.x = sin(phi) * sin(theta);
	unit.y = cos(theta) * -1.0;
	unit.z = cos(phi) * sin(theta);
	unit = normalize(unit);
	
	vec4 waterTex = texture(sampler, UV);
	vec3 noiseTex = texture(noise, UV + TIME * 0.01).rgb;
	
	ROUGHNESS = 0.3;
	METALLIC = 0.0;
	EMISSION = vec3(0.0);
	
	NORMALMAP = noiseTex;
	ALBEDO = waterTex.rgb;
	ALPHA = waterTex.a;
}