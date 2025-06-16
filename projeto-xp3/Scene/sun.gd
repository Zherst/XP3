extends Node3D

@onready var red_sun = $Sun/Red_Sun
@onready var sparks = $Sun/Sparks
@onready var sparks2 = $Sun/Sparks2

@onready var explosion = $Explosion


	
func end():
	explosion.set_emitting(true)
	red_sun.set_visible(false)
	sparks.process_material.set("color", Color(255,510,1275))
	sparks2.process_material.set("color", Color(255,510,1275))
