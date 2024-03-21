extends Node2D

# TODO: have the bird wander in a given radius.

@export var elevation_curve : Curve

@onready var root = %Root
@onready var shadow = %Shadow

@onready var air_timer : Timer = %AirTimer
@onready var peck_timer : Timer = %PeckTimer
@onready var walk_around_timer : Timer = %WalkAroundTimer
@onready var fear_zone = %FearZone
@onready var sprite = %Sprite

var flip_h := false : set = set_flip_h
var flip_scale := 1.0

var is_on_ground = true : set = set_is_on_ground
var is_walking = false : get = get_is_walking
var walk_tween : Tween = null

var peck_sequence = -1

func _ready() -> void:
	set_is_on_ground(is_on_ground)
	fear_zone.mouse_entered.connect(flee)
	peck_timer.timeout.connect(on_peck_timeout)
	air_timer.timeout.connect(land)
	walk_around_timer.timeout.connect(on_walk_around_timeout)


func set_flip_h(state : bool):
	flip_h = state
	flip_scale = float(!flip_h) * 2.0 - 1.0
	root.scale.x = flip_scale


func flee():
	if not is_on_ground:
		return

	if is_walking:
		walk_tween.kill()

	is_on_ground = false
	var start = position
	var end = get_air_point(position)
	flip_h = start.x < end.x
	var tween = create_tween().set_parallel(true)
	tween.tween_method(fly_to.bind(start, end), 0.0, 1.0, 1.0)
	tween.tween_property(self, "modulate:a", 0.0, 0.2).set_delay(0.8)
	tween.tween_property(shadow, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(func():
		air_timer.start(randf_range(1.0, 4.0))
		)

func land():
	var ground_position_target = Vector2(600, 400)
	var start = get_air_point(ground_position_target)
	var end = ground_position_target
	flip_h = start.x < end.x
	var tween = create_tween().set_parallel(true)
	tween.tween_method(fly_to.bind(start, end, true), 0.0, 1.0, 1.0)
	tween.tween_property(self, "modulate:a", 1.0, 0.2).from(0.0)
	tween.tween_property(shadow, "modulate:a", 1.0, 0.2).set_delay(0.8)
	tween.chain().tween_callback(func():
		is_on_ground = true
		)

func fly_to(progress, start, end, reverse : bool = false):
	if not reverse:
		var elevation = elevation_curve.sample(progress)
		position.x = lerp(start.x, end.x, progress)
		position.y = lerp(start.y, end.y, elevation)
		shadow.global_position.y = start.y
	else:
		var elevation = elevation_curve.sample(1.0 - progress)
		position.x = lerp(start.x, end.x, progress)
		position.y = lerp(start.y, end.y, 1.0 - elevation)
		shadow.global_position.y = end.y


func get_air_point(pos : Vector2):
	var up_position = pos
	var offset_y = 200.0 + randf_range(0.0, 100.0)
	if randf() > 0.5: offset_y *= -1.0
	up_position.x += offset_y
	up_position.y -= 256.0
	return up_position


func on_peck_timeout():
	if is_walking: return
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(root, "scale", Vector2(flip_scale, 1.0) * Vector2(1.2, 0.8), 0.1)
	tween.tween_property(root, "scale", Vector2(flip_scale, 1.0), 0.1)
	tween.tween_callback(func():
		var next_peck = randf_range(2.0, 4.0)
		if peck_sequence == -1:
			if randf() > 0.6: peck_sequence = randi_range(2, 3)
		if peck_sequence > 1:
			next_peck = randf_range(0.1, 0.2)
			peck_sequence -= 1
		else:
			peck_sequence = -1

		peck_timer.start(next_peck)
		)

func get_is_walking():
	return walk_tween != null && walk_tween.is_running()

func on_walk_around_timeout():
	if is_walking: return
	walk_tween = create_tween()
	var start = position
	var destination = Vector2(600, 400) + randf_range(0, 100) * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))
	var distance = start.distance_to(destination)
	var duration = distance / 100.0
	var hop_count = round(distance / 24.0)
	walk_tween.chain().tween_property(self, "position", destination, duration).from(start)
	walk_tween.set_parallel(true)
	walk_tween.tween_callback(func():
		flip_h = start.x < destination.x
		)
	walk_tween.tween_method(hop_tween.bind(hop_count), 0.0, 1.0, duration)

	walk_tween.chain().tween_callback(func():
		walk_around_timer.start(randf_range(2.0, 8.0))
		)

func hop_tween(progress : float, hop_count : float):
	root.position.y = ((1.0 + sin(progress * hop_count * TAU)) / 2.0) * 8.0

func set_is_on_ground(state : bool):
	is_on_ground = state

	if is_on_ground:
		walk_around_timer.start(randf_range(0.1, 2.0))
		peck_timer.start(randf_range(0.1, 2.0))
		sprite.play("default")
	else:
		walk_around_timer.stop()
		peck_timer.stop()
		sprite.play("fly")

# Get random position where bird can land
func get_random_position() -> Vector2:
	var rect = get_viewport_rect()
	return Vector2(
		randf_range(0.0, rect.size.x),
		randf_range(0.0, rect.size.y)
	)

