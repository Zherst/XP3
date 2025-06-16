extends Node3D
@onready var camera_s = $Not_to_Delete/Camera3D
@onready var UID = $Not_to_Delete/Control
@onready var label = $Not_to_Delete/Control/VBoxContainer/Label
@onready var player = $Player
@onready var pos = $Positions
@onready var center = $Not_to_Delete/Origin
@onready var fade = $Not_to_Delete/Control2
@onready var sun = $Not_to_Delete/Origin/Sun
@onready var not_to_delete = $Not_to_Delete


var text = "Pontos: "
var end_game = false

var planet1 = preload("res://Scene/planets/Planet.tscn")
var planet2 = preload("res://Scene/planets/Planet2.tscn")
var planet3 = preload("res://Scene/planets/Planet3.tscn")
var planet4 = preload("res://Scene/planets/Planet4.tscn")

func _ready() -> void:
	
	fade.fade_out()
	var planets = [planet1,planet2,planet3,planet4]
	randomize()
	
	for child in pos.get_children():	
		var kinds = planets[randi() % planets.size()]
		var planet = kinds.instantiate()
		planet.global_position = child.global_position
		planet.center_node = self
		planet.color = Color(lerp(0.5,1.0,randf()),lerp(0.5,1.0,randf()),lerp(0.5,1.0,randf()))
		planet.orbit_anomaly= lerp(10,100,randf())
		planet.center_mass = lerp(100,500,randf())
		add_child(planet)

func _end():
	sun.end()
	await get_tree().create_timer(1.0).timeout
	for child in self.get_children():
		if child != not_to_delete:
			child.queue_free()

func _on_area_3d_body_entered(player: CharacterBody3D) -> void:
	camera_s.current = true
	UID.visible = true
	label.set_text("Points: " + str(int(player.points)))
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	player.queue_free()
	await get_tree().create_timer(2.0).timeout
	_end()


func _on_return_pressed() -> void:
	fade.fade_in()
	await  get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scene/menu.tscn")
