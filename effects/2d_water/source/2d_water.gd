@tool
extends ColorRect

func _ready():
	_set_ratio()
	connect("resized", _set_ratio)

func _set_ratio():
	material.set_shader_parameter("size", size)
