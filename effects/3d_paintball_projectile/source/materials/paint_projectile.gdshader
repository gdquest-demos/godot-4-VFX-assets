shader_type spatial;

uniform vec3 albedo : source_color;
uniform sampler2D normal : hint_normal, filter_linear_mipmap;

void vertex() {
	float wave = (sin(UV.y * 2.0 * PI - TIME * 20.0) + 1.0) / 2.0;
	VERTEX += NORMAL * wave * 0.2;
}

void fragment() {
	ROUGHNESS = 0.25;
	ALBEDO = albedo;
	NORMAL_MAP = texture(normal, UV + vec2(TIME * 0.25, - TIME)).xyz;
}