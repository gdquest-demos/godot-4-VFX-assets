extends Node

var boid_scene = preload("res://effects/2d_trail/preview/boid/boid_2d.tscn")
@onready var marker_2d = %Marker2D

func _ready():
	
	var main_boid = boid_scene.instantiate()
	main_boid.target = marker_2d
	main_boid.fear_factor = 1.0
	add_child(main_boid)
	main_boid.trail_2d.points_count = 32
	var c = Camera2D.new()
	c.position_smoothing_enabled = true
	main_boid.add_child(c)
	
	var boid_count = 8
	
	for i in range(boid_count):
		var boid = boid_scene.instantiate()
		boid.size_factor = randf_range(0.2, 0.6)
		boid.target = main_boid
		boid.fear_factor = randf_range(40.0, 200.0)
		boid.speed = randf_range(60.0, 100.0)
		boid.top_speed = randf_range(10.0, 15.0)
		boid.position = Vector2.from_angle((i / float(boid_count)) * TAU) * 200.0
		add_child(boid)
		boid.trail_2d.points_count = 8
