extends Node2D

@export var default_color : Color
@export var danger_color : Color
@onready var bomb_sprite = %Bomb
@onready var bomb_root = %BombRoot

var time_start = 0.0
@export var power = 1.0
@export var duration = 6.0
var duration_ms = duration * 1000.0

@export var wobble_intensity : Curve
@export var color_intensity : Curve

@onready var line_2d = %Line2D
var line_length = 24.0
var line_resolution = 4
var half_pi = PI / 2.0
@onready var rope_end = %RopeEnd

signal exploded

func _ready() -> void:
	time_start = Time.get_ticks_msec()
	var points = []
	for i in line_resolution:
		var offset = float(i) / (line_resolution - 1)
		points.append(Vector2(0.0, -line_length * offset))
	line_2d.points = points
	
func _process(_delta):
	# go from 0.0 to 1.0
	var elapsed = Time.get_ticks_msec() - time_start
	var progress = elapsed / duration_ms
	var intensity = wobble_intensity.sample(progress)
	var c_intensity = color_intensity.sample(progress)
	
	if progress >= 1.0: 
		emit_signal("exploded")
		queue_free()
	
	var base_time = progress * intensity * 60.0
	bomb_root.rotation = sin(base_time) * 0.45 * intensity
	bomb_root.scale = Vector2.ONE * remap(sin(base_time * 2.0) * intensity, -1.0, 1.0, 0.9, 1.1)
	var color_map = remap(sin(progress * c_intensity * 60.0 - half_pi), -1.0, 1.0, 0.0, 1.0)
	bomb_sprite.self_modulate = lerp(default_color, danger_color, color_map)
	
	# Line wobble
	
	for i in line_resolution:
		var i_o = float(i) / (line_resolution - 1)
		var offset = i_o * line_length * max(0.2, (1.0 - progress) * 0.8)
		var angle = sin((progress + i / 100.0) * intensity * 60.0 - PI * i_o) * intensity
		line_2d.points[i].x = cos(angle - half_pi) * offset
		line_2d.points[i].y = sin(angle - half_pi) * offset
		
	var end_angle = line_2d.points[-1].angle_to_point(line_2d.points[-2])
	rope_end.position = line_2d.points[-1]
	rope_end.rotation = end_angle
