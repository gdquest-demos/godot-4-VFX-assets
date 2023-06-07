extends Camera2D

func _process(_delta):
	var mouse_pos = get_local_mouse_position() * 0.2
	position = mouse_pos
