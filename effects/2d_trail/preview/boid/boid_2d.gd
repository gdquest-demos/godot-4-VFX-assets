extends Node2D

@export var target : Node2D
var size_factor = randf_range(0.8, 1.2)
@onready var zone = %Zone
@onready var zone_collision = %CollisionShape2D

var speed = 50.0
var top_speed = 10.0
var fear_factor = 1.0
var velocity : Vector2 = Vector2.ZERO

@onready var zone_size = 256.0 * size_factor
@onready var half_zone_size = zone_size / 2.0
@onready var visual_root = %VisualRoot
@onready var trail_2d = %Trail2D
@onready var fade = %Fade

func _ready():
	fade.width *= size_factor	
	trail_2d.width *= size_factor
	visual_root.scale *= size_factor
	zone_collision.shape = CircleShape2D.new()
	zone_collision.shape.radius = zone_size

func avoid(delta):
	var others = zone.get_overlapping_areas()
	if others.size() == 0: return
	var fear_velocity : Vector2 = Vector2.ZERO
	for other_zone in others:
		var other = other_zone.owner
		if !other.is_in_group("boid_2d"): continue
		var distance_other = clamp(position.distance_to(other.position), 0.0, half_zone_size)
		var angle_other = other.position.angle_to_point(position)
		var fear_amount = remap(distance_other, 0.0, half_zone_size, 1.0, 0.2)
		fear_velocity += Vector2.from_angle(angle_other) * fear_factor * fear_amount
	velocity += fear_velocity / others.size() * delta

func _physics_process(delta):
	# Follow target
	var distance_target = clamp(position.distance_to(target.position), 0.0, zone_size * 2.0)
	var angle_target = position.angle_to_point(target.position)
	var acceleration_amount = remap(distance_target, 0.0, zone_size * 2.0, 0.0, 1.0)
	velocity += Vector2.from_angle(angle_target) * speed * acceleration_amount * delta
	# Avoid
	if fear_factor != 0.0:
		avoid(delta)
	velocity = velocity.limit_length(top_speed)
	position += velocity
	visual_root.rotation = velocity.angle()
