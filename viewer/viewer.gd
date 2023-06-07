extends HBoxContainer

@export var category_scene : PackedScene
@export_dir var preview_data_path = ""
@onready var wrap_container = %Wrap
@onready var preview_holder = %PreviewHolder
@onready var search_input = %SearchInput
@onready var preview = %Preview

var cards = []
var preview_data = []
var focused_card = null

func _ready():
	search_input.connect("text_changed", on_text_changed)
	
	
	for files in get_dir_files(preview_data_path):
		preview_data.append(load(preview_data_path + "/" + files))
	
	for category_name in PreviewData.CATEGORIES:
		var category = category_scene.instantiate()
		wrap_container.add_child(category)
		category.title = category_name.to_upper()
		
		for data in get_card_by_category(category_name):
			var card = category.add_card(data)
			cards.append(card)
			card.connect("pressed", on_card_pressed.bind(card, data))

func on_text_changed(new_text : String):
	for card in cards:
		card.visible = card.data.title.to_lower().contains(new_text.to_lower()) || new_text == ""

func on_card_pressed(card_node : Node, card_data : PreviewData):
	if card_node == focused_card: return
	if focused_card: focused_card.focused = false
	focused_card = card_node
	
	preview.show()
	
	if preview_holder.get_child_count() != 0:
		for child in preview_holder.get_children():
			child.queue_free()
		await get_tree().process_frame
	
	var scene = card_data.preview_scene.instantiate()
	preview_holder.add_child(scene)

func get_card_by_category(category : String):
	return preview_data.filter(func(data : PreviewData):
			return PreviewData.CATEGORIES.find_key(data.category) == category
			)

func get_dir_files(path : String):
	return DirAccess.open(path).get_files()
