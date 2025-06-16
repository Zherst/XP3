extends CharacterBody3D

var is_running := false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_animation(direction: Vector3):
	if not is_on_floor():
		if velocity.y > 0:
			animation_player.play("PulandoT")
		else:
			animation_player.play("CaindoT")
	elif direction.length() > 0.1:
		animation_player.play("CorrendoT" if is_running else "Andando")
	else:
		animation_player.play("Parado")
