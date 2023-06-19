extends Node

@onready var origin : Node3D = %Origin
@onready var target : Node3D = %Target
@onready var world_3d : Node3D = %World3D

@export var paint_projectile : PackedScene
@export var paint_shot : PackedScene
@export var paint_impact : PackedScene
@export var paint_impact_decal : PackedScene

@onready var timer = %Timer

var x_axis_basis = Basis.looking_at(Vector3(0, 1, 0), Vector3(-1, 0, 0))

func _ready():
	timer.connect("timeout", func():
		shoot(random_position())
		)
	shoot(random_position())

func random_position():
	var t_p = target.global_position
	var a = randf() * TAU
	var r = sqrt(randf()) * 1.0
	
	t_p.y += cos(a) * r
	t_p.z += sin(a) * r
	
	return t_p
	
func shoot(target_position : Vector3):
	# Spawn shot effect
	var shot : Node3D = paint_shot.instantiate()
	world_3d.add_child(shot)
	shot.look_at(target_position)
	shot.global_position = origin.global_position
	# Spawn Projectile
	var speed = 15.0
	var distance = origin.global_position.distance_to(target_position)
	var duration = distance / speed
	
	var projectile : Node3D = paint_projectile.instantiate()
	world_3d.add_child(projectile)
	projectile.global_position = origin.global_position
	projectile.look_at(target_position)
	
	var t = create_tween()
	t.tween_property(projectile, "position", target_position, duration)
	t.tween_callback(func():
		projectile.queue_free()
		impact_at(target_position)
		)

func impact_at(target_position : Vector3):
	var target_scale = Vector3.ONE * randfn(0.6, 0.1)
	
	var impact : Node3D = paint_impact.instantiate()
	world_3d.add_child(impact)
	impact.transform.basis = x_axis_basis
	impact.global_position = target_position
	impact.scale = target_scale * 1.2
	
	var decal : Node3D = paint_impact_decal.instantiate()
	world_3d.add_child(decal)
	decal.transform.basis = x_axis_basis
	decal.scale = target_scale * 0.2
	decal.global_position = target_position
	decal.modulate.a = randf_range(0.45,0.5)
	decal.rotate_x(randf() * TAU)
	var t = create_tween().set_ease(Tween.EASE_IN)
	t.tween_property(decal, "scale", target_scale, 0.1)
	t.tween_property(decal, "modulate:a", 0.0, 2.0).set_delay(2.0)
	t.tween_callback(decal.queue_free)
