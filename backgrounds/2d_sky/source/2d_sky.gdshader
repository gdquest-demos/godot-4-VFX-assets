shader_type canvas_item;

uniform vec3 top_color : source_color;
uniform vec3 scatter_color : source_color;
uniform vec3 bottom_color : source_color;

uniform float scatter_intensity : hint_range(0.0, 1.0, 0.1) = 1.0;

group_uniforms star;
uniform float star_smoothness : hint_range(0.01, 0.25, 0.01) = 0.1;
uniform vec2 star_position = vec2(0.0);
uniform float star_size = 100.0;
uniform bool crop_star = false;
uniform vec2 star_hole_position = vec2(0.0);
uniform float star_hole_size = 0.95;

group_uniforms stars;
uniform float seed = 0.0;
uniform float stars_cell_size = 20.0;
uniform float stars_offset_amount = 0.25;
uniform float stars_luminosity : hint_range(0.0, 2.0, 0.1) = 1.0;

group_uniforms custom;
uniform vec2 size = vec2(0.0);

float random (vec2 uv) {
	return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

vec4 get_stars(vec2 coord){
	vec2 position = fract(coord / stars_cell_size);
	float cell_id = random(round(coord / stars_cell_size + 0.5) + seed);
	float clamped_id = map(cell_id, 0.98, 1.0, 0.0, 1.0);
	position.x += sin(clamped_id * 10.0) * stars_offset_amount;
	position.y += cos(clamped_id * 10.0) * stars_offset_amount;
	
	float scale = 8.0 + (sin(clamped_id * 10.0 + TIME * 2.0) * 2.0);
	
	vec2 scaled_position = (position - 0.5) * scale + 0.5;
	
	vec3 stars_color = vec3(1.0) * clamped_id * 2.0;
	float stars_alpha = 1.0 - distance(vec2(0.5), scaled_position);
	stars_alpha *= round(cell_id * 0.51);
	
	return vec4(stars_color, clamp(stars_alpha, 0.0, 1.0));
}

float circle(vec2 coord, vec2 circle_pos, float circle_size) {
	return clamp(1.0 - distance((coord - circle_pos * size) / circle_size + 0.5, vec2(0.5)), 0.0, 1.0);
}

void fragment() {
	float star_mask = smoothstep(0.0, star_smoothness, circle(FRAGCOORD.xy, star_position, star_size));
	if(crop_star){
		vec2 hole_position = star_size / size;
		float star_hole = smoothstep(0.0, star_smoothness, circle(FRAGCOORD.xy, star_position + vec2(hole_position.x * star_hole_position.x, hole_position.y * star_hole_position.y), star_size * star_hole_size)); 
		star_mask = max(0.0, star_mask - star_hole);
	}
	vec3 stars_color = vec3(0.0);
	if(stars_luminosity > 0.0){
		vec4 stars = get_stars(FRAGCOORD.xy);
		stars_color = stars.rgb * stars.a * stars_luminosity;
	}
	vec3 sky_color = mix(top_color, bottom_color, UV.y);
	COLOR.rgb = sky_color + stars_color + star_mask + (scatter_color * sin(UV.y * PI) * scatter_intensity);
}
