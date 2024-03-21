shader_type canvas_item;

uniform sampler2D screen_texture : filter_linear_mipmap, hint_screen_texture;
uniform sampler2D noise_sampler : filter_linear_mipmap, repeat_enable;
uniform vec2 noise_offset = vec2(0.0);
uniform vec4 tint : source_color = vec4(1.0);
uniform float opacity = 1.0;
uniform float y_offset = 0.0;

void fragment() {
	
	vec2 flipped_uv = vec2(SCREEN_UV.x, (1.0 - SCREEN_UV.y) + y_offset);
	vec3 reflection_color = textureLod(screen_texture, flipped_uv, 0.65).rgb;
	
	float dist = distance(UV, vec2(0.5)) * 4.0;
	float n = texture(noise_sampler, (UV + noise_offset) * 0.15 * vec2(0.8, 1.0)).x;
	float mask = smoothstep(0.45, 0.4, dist * n);
	COLOR.rgb = mix(reflection_color, reflection_color * tint.rgb, tint.a);
	COLOR.a = mask * opacity;
}
