shader_type canvas_item;

uniform float speed = 1.0;
uniform float opening : hint_range(0.0, 0.5, 0.1) = 0.5;
uniform float bend = 1.5;

// swirl method from godotshaders.com
// https://godotshaders.com/snippet/swirl/

float swirl(vec2 uv, float size, int arms, float offset)
{
	float angle = atan(-uv.y + 0.5, uv.x - 0.5) - offset;
	float len = length(uv - vec2(0.5, 0.5));
	return sin(len * size + angle * float(arms));
}

void fragment() {
	float dist = distance(vec2(0.5), UV);
	float arms = clamp(swirl(UV, 35.0 * bend, 5, TIME * speed), 0.0, 1.0);
	COLOR.a = max(0.0, arms - smoothstep(opening - 0.2, opening, dist)) + smoothstep(opening - 0.1, opening - 0.2, dist);
}
