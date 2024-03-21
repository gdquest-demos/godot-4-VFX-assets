shader_type canvas_item;
uniform sampler2D vignette_gradient;
void fragment() {
	COLOR.a = texture(vignette_gradient, vec2(distance(UV, vec2(0.5)), 0.0)).x;
}
