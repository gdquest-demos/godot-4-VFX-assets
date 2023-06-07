extends Node2D

var explosion_scene = preload("../source/explosion.tscn")
@onready var smoke_holder = %ExplosionHolder

func _ready():
	spawn_smoke()

func spawn_smoke():
	if !is_inside_tree(): return
	var smoke = explosion_scene.instantiate()
	smoke.connect("tree_exited", spawn_smoke)
	smoke_holder.add_child(smoke)
	
