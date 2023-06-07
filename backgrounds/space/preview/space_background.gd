extends ColorRect

func _process(_delta):
	var camera_2d : Camera2D = get_viewport().get_camera_2d()
	if camera_2d == null: return
	material.set_shader_parameter("view_offset", camera_2d.global_position)
