shader_type canvas_item;

uniform sampler2D alpha_curve;
uniform sampler2D base_color;
uniform sampler2D band_gradient : repeat_enable;
uniform float deformation = 0.4;

void fragment() {
	float s = (1.0 + sin(UV.x * PI * 4.0 - TIME * 20.0)) / 2.0;
	COLOR.rgb = texture(base_color, vec2(UV.x, 0.0)).rgb
	+
	texture(band_gradient, vec2(UV.x * 2.0 - TIME * 2.0, 0.0)).x * 0.25 * (1.0 - UV.x);
	COLOR.a *= texture(alpha_curve, vec2(UV.x, 0.0)).x;
}
