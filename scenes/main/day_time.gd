extends ColorRect

func _ready() -> void:
	size = Vector2(Constants.width, Constants.height)
	DayNight.time_change.connect(on_time_change)
	
func on_time_change(time: float):
	color.a = time
