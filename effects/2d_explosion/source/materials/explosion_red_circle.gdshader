shader_type canvas_item;

uniform sampler2D edge_gradient;
uniform vec3 color : source_color;
uniform float opacity = 1.0;

void fragment() {
	float d =  distance(UV, vec2(0.5));
	COLOR.rgb = color;
	COLOR.a = texture(edge_gradient, vec2(d, 0.0)).x * opacity;
}
