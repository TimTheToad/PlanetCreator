shader_type canvas_item;
render_mode blend_premul_alpha;

vec3 hash(vec3 p) {
	p = vec3(dot(p, vec3(127.1, 311.7, 74.7)),
	            dot(p, vec3(269.5, 183.3, 246.1)),
	            dot(p, vec3(113.5, 271.9, 124.6)));
	
	return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec3 p) {
	vec3 i = floor(p);
	vec3 f = fract(p);
	vec3 u = f * f * (3.0 - 2.0 * f);
	
	return mix(mix(mix(dot(hash(i + vec3(0.0, 0.0, 0.0)), f - vec3(0.0, 0.0, 0.0)),
                     dot(hash(i + vec3(1.0, 0.0, 0.0)), f - vec3(1.0, 0.0, 0.0)), u.x),
                 mix(dot(hash(i + vec3(0.0, 1.0, 0.0)), f - vec3(0.0, 1.0, 0.0)),
                     dot(hash(i + vec3(1.0, 1.0, 0.0)), f - vec3(1.0, 1.0, 0.0)), u.x), u.y),
             mix(mix(dot(hash(i + vec3(0.0, 0.0, 1.0)), f - vec3(0.0, 0.0, 1.0)),
                     dot(hash(i + vec3(1.0, 0.0, 1.0)), f - vec3(1.0, 0.0, 1.0)), u.x),
                 mix(dot(hash(i + vec3(0.0, 1.0, 1.0)), f - vec3(0.0, 1.0, 1.0)),
                     dot(hash(i + vec3(1.0, 1.0, 1.0)), f - vec3(1.0, 1.0, 1.0)), u.x), u.y), u.z );
}

float noise2(vec3 p, int octaves) {
	float n = 0.0;
	for (int i = 0; i < octaves; i++) {
		float m = pow(2.0, float(i));
		n += noise(p * 5.0 * m) * 0.5 / m;
	}
	
	return n;
}

uniform float period = 5.0;
uniform int octaves = 1;

void fragment() {
	vec2 uv = vec2(UV.x + TIME * 0.001, UV.y);
	float theta = uv.y * 3.14159;
	float phi = uv.x * 3.14159 * 2.0;
	vec3 unit = vec3(0.0, 0.0, 0.0);
	
	unit.x = sin(phi) * sin(theta);
	unit.y = cos(theta) * -1.0;
	unit.z = cos(phi) * sin(theta);
	unit = normalize(unit);
	
    float n = noise2(unit * (period + sin(TIME * 0.3) * 0.1), octaves);

	COLOR.rgb = mix(vec3(1.0), vec3(0.0), smoothstep(-0.1, 0.0, n));
	COLOR.a = 1.0 - smoothstep(-0.3, 0.0, n);
}