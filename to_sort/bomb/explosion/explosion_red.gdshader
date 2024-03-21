shader_type canvas_item;

uniform vec3 color : source_color;
uniform sampler2D alpha_gradient;
uniform float opacity = 1.0;

void fragment() {
	float d = 1.0 - distance(UV, vec2(0.5));
	COLOR.rgb = color;
	COLOR.a = texture(alpha_gradient, vec2(d, 0.0)).x * opacity;
}
