extends Node3D

var smoke_scene = preload("../source/smoke_explosion.tscn")
@onready var smoke_holder = %SmokeHolder

func _ready():
	spawn_smoke()

func spawn_smoke():
	if !is_inside_tree(): return
	var smoke = smoke_scene.instantiate()
	smoke.connect("tree_exited", spawn_smoke)
	smoke_holder.add_child(smoke)
	
