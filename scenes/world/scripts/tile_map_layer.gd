extends Control

func _draw() -> void:
	draw_rect(
		Rect2(Vector2.ZERO, Vector2(Constants.width, Constants.height)), 
		Color.FOREST_GREEN,
		true
	)
