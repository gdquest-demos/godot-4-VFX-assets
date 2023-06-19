extends Decal

@export var albedo_atlas : Array[Texture2D] = []
@export var normal_atlas : Array[Texture2D] = []

func _ready():
	set_random_shape()

func set_random_shape():
	var picked_index = randi() % albedo_atlas.size()
	texture_albedo = albedo_atlas[picked_index]
	texture_normal = normal_atlas[picked_index]
	
