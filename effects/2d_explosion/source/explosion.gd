extends Node2D

@onready var trace = %Trace
@onready var fire_circle = %FireCircle
@onready var animation_player = %AnimationPlayer

func _ready():
	fire_circle.material.set_shader_parameter("texture_offset", randf())
	trace.material.set_shader_parameter("noise_offset", Vector2(randf(), randf()))
	animation_player.play("default")
	await animation_player.animation_finished
	if !is_inside_tree(): return
	queue_free()
