extends Node3D
@onready var mesh = $MeshInstance3D
@onready var par = $GPUParticles3D

func _on_area_3d_body_entered(player: CharacterBody3D) -> void:
	player.add_points()
	mesh.set_visible(false)
	par.set_emitting(false)
	await get_tree().create_timer(1.0).timeout
	self.queue_free()
