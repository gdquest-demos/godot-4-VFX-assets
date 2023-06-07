extends Node3D

@onready var animation_player = %AnimationPlayer

func _ready():
	animation_player.play("poof")
	await animation_player.animation_finished
	queue_free()
