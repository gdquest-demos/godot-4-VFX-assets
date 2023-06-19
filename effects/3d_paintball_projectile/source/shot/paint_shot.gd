extends Node3D

@onready var gpu_particles_3d = %GPUParticles3D

func _ready():
	gpu_particles_3d.one_shot = true
	gpu_particles_3d.emitting = true
	var t = get_tree().create_timer(1.0)
	t.connect("timeout", queue_free)
