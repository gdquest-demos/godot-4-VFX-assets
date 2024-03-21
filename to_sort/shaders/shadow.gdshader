shader_type canvas_item;

uniform sampler2D shadow_gradient;

void fragment() {
	COLOR.rgb = vec3(0.0);
	COLOR.a *= texture(shadow_gradient, vec2(distance(UV * 2.0, vec2(1.0)), 0.0)).x;
}
