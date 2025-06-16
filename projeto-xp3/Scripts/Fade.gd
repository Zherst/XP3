extends Control

@onready var fade_rect = $ColorRect
var tween: Tween

func _ready():
	tween = get_tree().create_tween()

func fade_in(duration: float = 1.0):
	tween.kill()  # Cancela animações anteriores
	fade_rect.set_visible(true)
	tween.tween_property(fade_rect, "color", Color.TRANSPARENT, duration)

func fade_out(duration: float = 1.0):
	tween.kill()
	fade_rect.set_visible(true)
	tween.tween_property(fade_rect, "color", Color.BLACK, duration)
	await  get_tree().create_timer(1.0).timeout
	fade_rect.set_visible(false)
