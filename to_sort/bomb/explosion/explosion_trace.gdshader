shader_type canvas_item;

uniform sampler2D noise_sampler : repeat_enable;
uniform sampler2D gradient;

void fragment() {
	COLOR.rgb = vec3(0.2);
	COLOR.a = 0.2;
}
