extends Node2D

@onready var small_circle = $SmallCircle
@onready var animation_player = $AnimationPlayer
@onready var trace = %Trace

func _ready() -> void:
	small_circle.material.set_shader_parameter("texture_offset", randf())
	trace.material.set_shader_parameter("noise_offset", Vector2(randf(), randf()))
	animation_player.play("explosion")
	await animation_player.animation_finished
	if !is_inside_tree(): return
	queue_free()
