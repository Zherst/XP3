class_name BalancePoint
extends Node3D

var relevant_forces: Array = []

var acceleration: Vector3 = Vector3.ZERO
var acceleration_magnetude: float = 0.0
var down: Vector3 = Vector3.ZERO
var up: Vector3 = Vector3.ZERO

func _physics_process(delta):
	acceleration = Vector3.ZERO
	for force in relevant_forces:
		acceleration += force.get_acceleration_at(global_transform.origin)
		
	acceleration_magnetude = acceleration.length()
	if acceleration_magnetude > 0:
		down = acceleration / acceleration_magnetude
	else:
		down = Vector3.ZERO
		
	up = -down
	



func _on_area_entered(area: Area3D) -> void:
	relevant_forces.append(area)


func _on_area_exited(area: Area3D) -> void:
	relevant_forces.erase(area)
