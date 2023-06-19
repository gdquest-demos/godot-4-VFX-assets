shader_type spatial;
render_mode cull_disabled;
uniform vec3 albedo : source_color;
uniform sampler2D voronoi_sampler : filter_linear_mipmap, repeat_enable;

void fragment() {
	float shape = sin(UV.x * PI) * sin(UV.y * PI);
	float voronoi = texture(voronoi_sampler, UV * 0.5 + vec2(0.0, -TIME * 0.5)).x;
	float edge = shape - (voronoi * UV.y);
 	ALBEDO = albedo;
	ROUGHNESS = 0.25;
	NORMAL_MAP = normalize(vec3(0.5, 0.5 + edge * 0.5, 0.5));
	ALPHA = step(0.2, edge);
}