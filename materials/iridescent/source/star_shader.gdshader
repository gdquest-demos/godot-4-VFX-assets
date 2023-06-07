shader_type spatial;


uniform vec3 albedo : source_color = vec3(1.0);
uniform float specular : hint_range(0.0, 1.0, 0.1) = 0.65;
uniform float roughness : hint_range(0.0, 1.0, 0.1) = 0.65;
uniform float metallic : hint_range(0.0, 1.0, 0.1) = 0.65;

uniform vec2 uv_scale = vec2(1.0);

group_uniforms glitter;
uniform sampler2D noise_direction_sampler;
uniform float glitter_glow_intensity = 1.0;

group_uniforms shimmer;
uniform float shimmer_glow_intensity : hint_range(0.0, 2.0, 0.1) = 1.0;
uniform float fresnel_power : hint_range(0.5, 4.0, 0.1) = 2.0;

float fresnel(vec3 normal, vec3 view, float amount){
	return pow(1.0 - clamp(dot(normal, view), 0.0, 1.0), amount);
}

// https://www.reddit.com/r/godot/comments/iwocl2/comment/hx1p5un/?utm_source=reddit&utm_medium=web2x&context=3

vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	float f = fresnel(NORMAL, VIEW, fresnel_power);
	float t = mod(TIME * 0.25, 1.0);
	vec3 directions = texture(noise_direction_sampler, UV * uv_scale).xyz;
	
	vec3 world_normal = NORMAL * mat3(INV_VIEW_MATRIX);
	float glitter_mask = clamp(dot(directions - 0.85, 1.0 - world_normal), 0.0, 1.0);
	vec3 shimmer = hsv2rgb(vec3(NORMAL.z + NORMAL.y + t, 0.6, 0.8));
	
	ALBEDO = albedo;
	EMISSION = shimmer * f * shimmer_glow_intensity;
	SPECULAR = specular;
	ROUGHNESS = roughness;
	METALLIC = metallic;
	// Add glitters
	EMISSION += shimmer * ((1.0-f) * glitter_mask) * glitter_glow_intensity;
}
