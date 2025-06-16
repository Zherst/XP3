extends Control

@onready var menu = $HBoxContainer
@onready var credits = $HBoxContainer2
@onready var fade = $Control

func _on_play_pressed() -> void:
	fade.fade_in()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scene/main.tscn")


func _on_crédits_pressed() -> void:
	menu.set_visible(false)
	credits.set_visible(true)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_menu_pressed() -> void:
	menu.set_visible(true)
	credits.set_visible(false)
