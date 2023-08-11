extends ColorRect

func _ready():
	_set_ratio()
	connect("resized", _set_ratio)

func _process(_delta):
	var camera_2d : Camera2D = get_viewport().get_camera_2d()
	if camera_2d == null: return
	material.set_shader_parameter("view_offset", camera_2d.global_position)

func _set_ratio():
	var uv_ratio : Vector2 = Vector2(1.0, size.y / size.x) if size.x < size.y else Vector2(size.x / size.y, 1.0)
	material.set_shader_parameter("uv_ratio", uv_ratio)
