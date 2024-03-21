@tool
extends Node2D

func _ready() -> void:
	for leaf in get_children():
		leaf.material = leaf.material.duplicate()
		leaf.material.set("shader_parameter/offset", leaf.global_position * 0.001)
