extends Sprite2D

@export var reflection_offset = 0.0


func _ready() -> void:
	get_viewport().size_changed.connect(offset_reflection)
	offset_reflection()


func offset_reflection():
	var viewport_rect = get_viewport_rect()
	var camera_y = get_viewport().get_camera_2d().global_position.y
	var y_pos = global_position.y
	var offset_y = (y_pos - reflection_offset - camera_y) / viewport_rect.size.y * 2.0

	material.set("shader_parameter/y_offset", offset_y)
