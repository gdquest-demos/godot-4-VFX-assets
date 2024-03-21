extends Node2D

@export var bomb_scene : PackedScene
@export var explosion_scene : PackedScene

func _input(event):
	if !(event is InputEventMouseButton and event.is_pressed()): return
	if event.button_index == MOUSE_BUTTON_LEFT:
		var b = bomb_scene.instantiate()
		b.position = event.position
		add_child(b)
		b.exploded.connect(func() -> void:
			var explosion = explosion_scene.instantiate()
			explosion.position = event.position
			add_child(explosion)
			)
