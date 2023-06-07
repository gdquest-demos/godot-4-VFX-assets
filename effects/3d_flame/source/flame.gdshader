shader_type spatial;
render_mode cull_disabled;

uniform sampler2D flame_sdf_sampler;
uniform sampler2D voronoi_sampler;
uniform vec3 flame_color : source_color;


void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0), vec4(0.0, 1.0, 0.0, 0.0), vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0), MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}



void fragment() {
	float voronoi = texture(voronoi_sampler, NODE_POSITION_WORLD.xz + UV * 0.2 + (TIME * vec2(0.145, 0.684)) * 0.5).x;
	float flame_sdf = texture(flame_sdf_sampler, UV).a;
	ALBEDO = flame_color.rgb;
	EMISSION = flame_color.rgb * 2.0;
	ALPHA = smoothstep(0.15, 0.3, flame_sdf * voronoi) * UV.y;
}
