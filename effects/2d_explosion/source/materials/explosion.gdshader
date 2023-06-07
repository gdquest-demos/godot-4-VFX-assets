shader_type canvas_item;

uniform sampler2D noise_sampler : repeat_enable;
uniform sampler2D gradient;
uniform sampler2D edge_gradient;

uniform float offset = 0.5;
uniform float time = 0.0;

uniform float texture_offset = 0.0;

void fragment() {
	float n = 1.0 - texture(noise_sampler, ((UV + texture_offset) * 0.25 + vec2(-time, 0.0)) ).x;
	float d = distance(UV, vec2(0.5)) * 2.0;
	float n_smooth_d = (n * offset) * texture(edge_gradient, vec2(d, 0.0)).x;
	COLOR.a = step(0.5, n_smooth_d);
	COLOR.rgb = texture(gradient, vec2(n_smooth_d, 0.0)).rgb;
}