extends Node2D

var link_scene = preload("./link.tscn")

@export var end_point : Node2D

var link_count = 6
var link_height = 18.0

@export var link_textures : Array[Texture] = []

func _ready() -> void:
	if end_point:
		var distance = end_point.global_position.distance_to(global_position)
		link_count = round(distance / link_height) + 3
	
	for i in range(link_count):
		var pos = Vector2(0.0, link_height * i + link_height)
		
		var body = link_scene.instantiate()
		body.position = pos
		add_child(body)
		
		var link_sprite = Sprite2D.new()
		link_sprite.texture = link_textures[i % 2]
		body.add_child(link_sprite)
		
		if i == 0: continue
		
		var previous_link = get_child(i - 1)
		create_pin(Vector2(0.0, -link_height / 2.0), body, previous_link)
	
	# Add first link
	var first_link = get_child(0)
	
	var start_static_body = create_static_body()
	create_pin(Vector2(0.0, -link_height / 2.0), first_link, start_static_body)
	
	if end_point:
		var last_link = get_child(-2)
		
		var end_static_body = create_static_body()
		end_static_body.global_position = end_point.global_position
		last_link.global_position = end_point.global_position
		
		create_pin(Vector2(0.0, link_height / 2.0), end_static_body, last_link)

func create_pin(offset : Vector2, node_a, node_b):
	var pin = PinJoint2D.new()
	pin.position = offset
	node_a.add_child(pin)
	pin.node_a = node_a.get_path()
	pin.node_b = node_b.get_path()
	
	return pin
	
func create_static_body():
	var static_body = StaticBody2D.new()
	var shape = CollisionShape2D.new()
	shape.shape = CircleShape2D.new()
	add_child(static_body)
	static_body.add_child(shape)
	return static_body
