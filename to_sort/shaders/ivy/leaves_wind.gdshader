shader_type canvas_item;

uniform sampler2D wind_sampler : repeat_enable;
uniform vec2 offset = vec2(0.0);
uniform float sway_amount = 1.0;

// Rotates a 2D vector by a given angle
vec2 rotate_2d(vec2 position, float angle) {
    float cosa = cos(angle);
    float sina = sin(angle);
    return vec2(
        cosa * position.x - sina * position.y,
        cosa * position.y + sina * position.x 
    );
}

void vertex() {
	float angle = 0.5 - texture(wind_sampler, vec2(TIME * 0.04691, TIME * 0.0264) + offset).x;
    VERTEX = rotate_2d(VERTEX, angle * sway_amount);
}