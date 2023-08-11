shader_type canvas_item;

uniform vec2 uv_ratio = vec2(1.0);


group_uniforms stars;
uniform float seed = 0.0;
uniform float chance : hint_range(0.94, 0.994, 0.001) = 0.95;
uniform float base_scale : hint_range(0.5, 1.0, 0.1) = 0.7;
uniform float star_space = 20.0;
uniform vec2 view_offset = vec2(0.0);
uniform sampler2D star_tile_sampler : filter_linear_mipmap;
uniform sampler2D stars_color_gradient;

group_uniforms sky;
uniform float wave_height : hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float sky_scale : hint_range(1.0, 2.0, 0.1) = 1.5;
uniform vec3 background_color : source_color;
uniform vec3 multiply_color : source_color;
uniform sampler2D space_pattern_sampler : repeat_enable, filter_linear_mipmap;
// Credits: Random and Rotate method from godotshaders.com
// https://godotshaders.com/snippet/rotate/

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));
	
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

vec4 get_stars(vec2 coord, vec2 offset, float base_seed){
	vec2 frag_coord_offset = coord + offset;
	
	vec2 pos = fract(1.0 / star_space * frag_coord_offset);
	float cell_id = random(round(1.0 / star_space * frag_coord_offset + 0.5) + base_seed);
	
	float stars_mask = 0.0;
	vec3 stars_color = vec3(0.0);
	
	if(cell_id > chance){
		float clamped_id = (map(cell_id, chance, 1.0, 0.0, 1.0));
		stars_color = texture(stars_color_gradient, vec2(clamped_id, 0.0)).rgb;
		
		pos.x += sin(clamped_id * 10.0) * 0.1;
		pos.y += cos(clamped_id * 15.0) * 0.1;
		
		float scale = base_scale + (sin(clamped_id * 40.0 + TIME * 2.0) * 0.15);
		vec2 scaled_pos = (pos - 0.5) * scale + 0.5;
		float star_id = floor(clamped_id * 3.0);
		vec2 star_uv = (scaled_pos + vec2(star_id, 0.0)) / vec2(3.0, 1.0);
		stars_mask = texture(star_tile_sampler, star_uv).x;
	}
	return vec4(stars_color, stars_mask);
}

void fragment(){
	vec2 uv = UV * uv_ratio;
	vec2 base_uv = rotate(uv * sky_scale + vec2(0.0, sin(uv.x * PI * 2.0) * wave_height * uv.y), vec2(0.5), 1.8);
	base_uv *= 0.75;
	base_uv.x += TIME * 0.015;

	float space_pattern = texture(space_pattern_sampler, base_uv).x;
	
	float dist = 1.0 - distance(UV, vec2(0.5));
	dist = smoothstep(0.25, 1.0, dist);
	float pattern = ((1.0 - space_pattern) * dist) * 0.4 + 0.6;
	
	vec3 background = background_color * mix(multiply_color, vec3(1.0), pattern);
	
	vec4 stars_1 = get_stars(FRAGCOORD.xy, view_offset * 0.25, seed);
	vec4 stars_2 = get_stars(FRAGCOORD.xy, view_offset * 0.05, seed + 100.0);
	
	vec4 stars = mix(stars_2, stars_1, stars_1.a);
	
	COLOR.rgb = mix(background, stars.rgb, stars.a);
}