shader_type spatial;
render_mode shadows_disabled, cull_disabled;

uniform vec3 albedo : source_color;

varying float voronoi_value;

uniform float progress = 0.0;
uniform float smoothness = 0.01;

uniform float ease = 2.0;
uniform float base_scale = 1.0;
uniform float deformation_scale = 1.0;

uniform float texture_offset = 0.0;

// Voronoi method credit:
// The MIT License
// Copyright © 2013 Inigo Quilez
// https://www.shadertoy.com/view/ldl3Dl

vec3 hash( vec3 x ){
	x = vec3( dot(x,vec3(127.1,311.7, 74.7)),
			  dot(x,vec3(269.5,183.3,246.1)),
			  dot(x,vec3(113.5,271.9,124.6)));
	return fract(sin(x)*43758.5453123);
}

vec3 voronoi( in vec3 x ){
	vec3 p = floor( x );
	vec3 f = fract( x );
	
	float id = 0.0;
	vec2 res = vec2( 100.0 );
	for( int k=-1; k<=1; k++ )
	for( int j=-1; j<=1; j++ )
	for( int i=-1; i<=1; i++ ) {
		vec3 b = vec3( float(i), float(j), float(k) );
		vec3 r = vec3( b ) - f + hash( p + b );
		float d = dot( r, r );
		if( d < res.x ) {
			id = dot( p+b, vec3(1.0,57.0,113.0 ) );
			res = vec2( d, res.x );
		} else if( d < res.y ) {
			res.y = d;
		}
    }
    return vec3( sqrt( res ), abs(id) );
}


void vertex() {
	float smooth_df = deformation_scale;
	voronoi_value = voronoi(VERTEX + texture_offset).x;
	VERTEX += NORMAL * (1.0 - pow(voronoi_value, ease)) * smooth_df;
	VERTEX *= base_scale;
}

void fragment(){
	ALBEDO = albedo;
	EMISSION = albedo * 0.5;
	ALPHA = smoothstep(progress - smoothness, progress + smoothness, voronoi_value);
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
