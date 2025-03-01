extends ColorRect

func _ready() -> void:
	DayNight.time_change.connect(on_time_change)
	
func on_time_change(time: float):
	material.set_shader_parameter("alpha", time)
