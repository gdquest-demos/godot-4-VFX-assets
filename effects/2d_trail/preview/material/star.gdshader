shader_type canvas_item;

uniform sampler2D rings_ease_sampler;

uniform vec3 shine_color : source_color;
uniform vec3 star_color : source_color;

float star(vec2 uv, float mult){
	return max(0.0, 
	(1.0 - abs(uv.x * uv.y * (80.0 + sin(TIME * 10.0) * 10.0)))
	* 1.0 - (length(uv) * mult)
	) ;
}

void fragment() {
	vec2 c_uv = UV * 2.0 - 1.0;
	float dist = 1.0 - length(c_uv);
	float star_shape = star(c_uv, 1.5);
	float rings = max(0.0, texture(rings_ease_sampler, vec2(mod(dist * 2.0 + TIME * 0.5, 1.0), 0.0)).x) * dist;
	
	star_shape = smoothstep(0.0, 0.5, star_shape) * 0.8;
	
	COLOR.a = dist * 0.35
	+
	smoothstep(0.4, 0.6, star_shape) * 0.8
	+ 
	rings * 0.5;
	
	COLOR.rgb = mix(star_color, shine_color, star_shape * dist);
}
