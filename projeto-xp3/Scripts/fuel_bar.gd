extends ProgressBar

@onready var timer = $Timer
@onready var used_bar = $Used_Bar

var fuel = 0 : set = _set_fuel

func _set_fuel(new_fuel: float):
	var prev_fuel = fuel
	fuel = min (max_value, new_fuel)
	value = fuel
	
	if fuel < prev_fuel:
		timer.start()
	else:
		used_bar.value = fuel
		

func init_fuel(_fuel):
	fuel = _fuel
	max_value = 100
	value = fuel
	used_bar.max_value = 100
	used_bar.value = fuel


func _on_timer_timeout() -> void:
	used_bar.value = fuel
