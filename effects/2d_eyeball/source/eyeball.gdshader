shader_type canvas_item;

uniform vec3 eye_color : source_color;
uniform vec3 light_color : source_color;
uniform vec3 shadow_color : source_color;
uniform vec2 eye_offset = vec2(0.0);
uniform vec3 iris_color : source_color;
uniform float pupil_dilation : hint_range(0.0, 1.0, 0.1) = 0.5;

vec3 hard_light(vec3 base, vec3 blend){
	vec3 limit = step(0.5, blend);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

void fragment() {
	float iris = smoothstep(0.55, 0.6, distance(vec2(0.5) + eye_offset, UV) * 2.0);
	float p_v = map(pupil_dilation, 0.0, 1.0, 0.2, 0.4);
	
	float pupil = smoothstep(p_v - 0.05, p_v + 0.05, distance(vec2(0.5) + eye_offset * 0.8, UV) * 2.0);
	COLOR.rgb = mix(iris_color, eye_color, iris);
	COLOR.rgb *= pupil;
	// Shadow
	float shadow = smoothstep(0.8, 0.25, distance(vec2(0.5, 0.4), UV));
	float light = smoothstep(0.8, 0.25, distance(vec2(0.5, 0.6), UV));
	float highlight = 1.0 - smoothstep(0.08, 0.09, distance(vec2(0.3, 0.3), UV));
	
	COLOR.rgb *= mix(shadow_color, vec3(1.0), shadow);
	COLOR.rgb = hard_light(COLOR.rgb, mix(light_color, vec3(0.5), light));
	COLOR.rgb = mix(COLOR.rgb, vec3(1.0), highlight);
	COLOR.a = smoothstep(0.5, 0.495, distance(UV, vec2(0.5)));
}
