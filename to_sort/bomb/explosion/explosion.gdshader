shader_type canvas_item;

uniform sampler2D noise_sampler : repeat_enable;
uniform sampler2D gradient;
uniform sampler2D edge_gradient;

uniform float offset = 0.5;
uniform float time = 0.0;

uniform float texture_offset = 0.0;


vec2 polar_coordinates(vec2 uv, vec2 center, float zoom, float repeat)
{
	vec2 dir = uv - center;
	float radius = length(dir) * 2.0;
	float angle = atan(dir.y, dir.x) * 1.0/(3.1416 * 2.0);
	return mod(vec2(radius * zoom, angle * repeat), 1.0);
}


void fragment() {
	vec2 polar_uv = polar_coordinates(UV, vec2(0.5), 1.0, 1.0);
	float n = 1.0 - texture(noise_sampler, ((UV + texture_offset) * 0.25 + vec2(-time, 0.0)) ).x;
	float d = distance(UV, vec2(0.5)) * 2.0;
	float n_smooth_d = (n * offset) * texture(edge_gradient, vec2(d, 0.0)).x;
	COLOR.a = step(0.5, n_smooth_d);
	COLOR.rgb = texture(gradient, vec2(n_smooth_d, 0.0)).rgb;

}
