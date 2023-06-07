extends TextureRect

var zoom = 1.0 : set = set_zoom
var border_weight = -0.1 : set = set_border_weight

func set_zoom(value : float):
	zoom = value
	var t = create_tween()
	t.tween_property(material, "shader_parameter/zoom", zoom, 0.1)
	
func set_border_weight(value : float):
	border_weight = value
	var t = create_tween()
	t.tween_property(material, "shader_parameter/border_weight", border_weight, 0.1)

func _ready():
	connect("resized", _set_ratio)
	
func _set_ratio():
	material.set("shader_parameter/ratio", Vector2(size.x/size.y, 1.0))
	
func set_texture_ratio():
	var s = texture.get_size()
	material.set("shader_parameter/texture_ratio", Vector2(s.y/s.x, 1.0))
	
