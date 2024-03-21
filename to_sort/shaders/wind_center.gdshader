shader_type canvas_item;
uniform sampler2D wind_sampler : repeat_enable;

void fragment() {
	float d = clamp((UV.x * UV.y) * 1.25, 0.0, 1.0);
	float n = texture(wind_sampler, UV * 0.1 + TIME * 0.1).x;

	float def = 0.1;
	float half_def = def / 2.0;

	vec2 uv_def = (UV + n * def * d) - half_def;

	vec4 c = texture(TEXTURE, uv_def);
	COLOR.rgb = c.rgb;
	COLOR.a = c.a * 0.65;

}
