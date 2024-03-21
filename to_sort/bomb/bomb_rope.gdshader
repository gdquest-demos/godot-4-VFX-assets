shader_type canvas_item;

uniform float offset : hint_range(0.0, 0.8, 0.1) = 0.0;
uniform float mult = 1.0;

void fragment() {
	COLOR.rgb = vec3(1.0);
	COLOR.a = texture(TEXTURE, vec2((UV.x + offset) * mult - (mult - 1.0), UV.y)).a;
}
