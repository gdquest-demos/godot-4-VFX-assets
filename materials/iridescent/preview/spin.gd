extends MeshInstance3D


func _ready():
	var t = create_tween().set_loops(0)
	t.tween_property(self, "rotation_degrees:y", 360.0, 20.0).from(0.0)
