extends Line2D
@export var follow_node : Node2D
@export var points_count = 16 : set = set_point_count
var points_local : PackedVector2Array = []

func set_point_count(value : int):
	points_count = value
	points_local.resize(value)
	points_local.fill(Vector2.ZERO)

func _ready():
	if !follow_node: follow_node = owner
	set_point_count(points_count)
	top_level = true
	
func _physics_process(delta):
	var global_pos = follow_node.global_position
	points_local[0] = global_pos
	for index in range(1, points_count):
		points_local[index] = lerp(points_local[index - 1], points_local[index], 40.0 * delta)
	points = points_local
