extends Marker2D

func _process(_delta):
	var t = Time.get_ticks_msec() / 1000.0
	position.x = cos(t) * 800.0
	position.y = sin(t * 0.8) * 1200.0
