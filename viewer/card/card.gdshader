shader_type canvas_item;

uniform float zoom = 1.0;
uniform float radius : hint_range(0.1, 0.5, 0.1) = 0.2;
uniform vec2 ratio = vec2(1.0, 1.0);
uniform vec2 texture_ratio = vec2(1.0, 1.0);
uniform float border_weight : hint_range(-0.1, 1.0, 0.1) = 0.0;
uniform vec3 border_color : source_color;

void fragment() {
	vec2 ratio_uv = UV * ratio;
	float d = length(max(abs(ratio_uv - vec2(0.5) * ratio) + radius - vec2(0.5) * ratio,0.0)) - radius;
	float border = 0.04 * border_weight;
	float normalized_zoom = (1.0 - zoom) + 1.0;
	COLOR.rgb = mix(
	border_color,
	texture(TEXTURE, (UV - 0.5) * normalized_zoom * texture_ratio * ratio + 0.5).rgb, smoothstep(-(border), -(border + 0.01), d));
	COLOR.a = smoothstep(0.0, -0.01, d);
}
