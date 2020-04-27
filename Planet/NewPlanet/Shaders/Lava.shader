shader_type spatial;

uniform sampler2D sampler : hint_white;
uniform sampler2D viewport : hint_white;
uniform sampler2D noise;
uniform sampler2D noiseNormal;
uniform float speed = 0.001;
uniform float glow = 0.15;

void fragment() {
	float theta = UV.y * 3.14159;
	float phi = UV.x * 3.14159 * 2.0;
	vec3 unit = vec3(0.0, 0.0, 0.0);
	
	unit.x = sin(phi) * sin(theta);
	unit.y = cos(theta) * -1.0;
	unit.z = cos(phi) * sin(theta);
	unit = normalize(unit);
	
	vec2 uv = vec2(UV.x + TIME * speed, UV.y);
	vec4 noiseTex = texture(noise, uv);
	vec3 normalTex = texture(noiseNormal, uv).rgb;
	vec4 color = texture(viewport, UV);
	
	ROUGHNESS = 0.3;
	METALLIC = 0.0;
	EMISSION = color.rgb * noiseTex.a * glow;
	
	NORMALMAP = normalTex;
	ALBEDO = noiseTex.rgb * color.rgb;
	ALPHA = color.a;
}