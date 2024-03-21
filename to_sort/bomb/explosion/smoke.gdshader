shader_type canvas_item;

uniform float offset = 0.0;
uniform float opacity = 1.0;

void fragment() {
	vec2 p = texture(TEXTURE, UV).ra;
	COLOR.rgb = vec3(1.0);
	
	COLOR.a = smoothstep(offset - 0.1, offset + 0.1, p.x) * p.y * opacity;
}
