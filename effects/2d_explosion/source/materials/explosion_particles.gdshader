shader_type canvas_item;

varying float lifetime;

uniform sampler2D opacity_gradient;

void vertex(){
	lifetime = INSTANCE_CUSTOM.y;
}

void fragment() {
	COLOR.rgb += UV.y * 0.8 * (1.0 - lifetime);
	COLOR.a = step(0.5, sin(UV.x * PI) * sin(UV.y)) * texture(opacity_gradient, vec2(lifetime, 0.0)).x * (1.0 - UV.y) * 4.0;
}
