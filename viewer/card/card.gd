extends VBoxContainer

var title : String = "" : set = set_title
var thumbnail : Texture = null : set = set_thumbnail
var data : PreviewData = null
signal pressed

var focused = false : set = set_focused

@onready var thumbnail_node = %Thumbnail
@onready var label_node = %Label

func set_focused(state : bool):
	focused = state
	
	if focused:
		thumbnail_node.zoom = 1.1
		thumbnail_node.border_weight = 1.0
	else:
		thumbnail_node.border_weight = -0.1
		thumbnail_node.zoom = 1.0
		
func _gui_input(event):
	if !(event is InputEventMouseButton): return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	if event.is_pressed():
		focused = true
		emit_signal("pressed")
	
func set_title(value : String):
	title = value
	if is_inside_tree(): label_node.text = title
	
func set_thumbnail(value : Texture):
	thumbnail = value
	if is_inside_tree():
		thumbnail_node.texture = thumbnail
		thumbnail_node.set_texture_ratio()

func _ready():
	label_node.text = title
	thumbnail_node.texture = thumbnail
	thumbnail_node.set_texture_ratio()
