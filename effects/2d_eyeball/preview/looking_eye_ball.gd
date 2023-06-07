extends Node2D

@onready var eye_ball = %EyeBall

func _physics_process(_delta):
	var diff = get_global_mouse_position() - global_position
	var length = diff.length()
	var angle = diff.angle()
	var map_length = (min(abs(length), 500.0) / 500.0) * 0.4
	
	eye_ball.material.set_shader_parameter("eye_offset", Vector2.from_angle(angle) * map_length)
