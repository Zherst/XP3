extends Node3D
@onready var camera_s = $Camera3D
@onready var UID = $Control
@onready var label = $Control/HBoxContainer/Label
@onready var player = $Player
var text = "Pontos: "

func _on_area_3d_body_entered(player: CharacterBody3D) -> void:
	camera_s.current = true
	UID.visible = true
	label.set_text(str(player.points))
	await get_tree().create_timer(5.0).timeout
	get_tree().reload_current_scene()
	pass # Replace with function body.
