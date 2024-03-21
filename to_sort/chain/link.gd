extends RigidBody2D


func _ready() -> void:
	input_event.connect(on_mouse_input)


func on_mouse_input(_node, event: InputEvent, _shape_idx):
	if !(event is InputEventMouseMotion):
		return
	linear_velocity += event.velocity.limit_length(100.0)
