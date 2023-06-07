extends VBoxContainer

@export var card_scene : PackedScene

var title = "" : set = set_title
@onready var label = %Label
@onready var cards = %Cards

func set_title(value : String):
	label.text = value

func add_card(preview_data : PreviewData):
	var card = card_scene.instantiate()
	card.data = preview_data
	card.title = preview_data.title
	card.thumbnail = preview_data.thumbnail
	cards.add_child(card)
	return card
