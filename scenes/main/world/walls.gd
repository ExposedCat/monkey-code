extends CollisionPolygon2D

func _ready() -> void:
	var thickness = 10
	var width = Constants.width
	var height = Constants.height
	polygon = PackedVector2Array([
		Vector2(-thickness, -thickness),
		Vector2(-thickness, height + thickness),
		Vector2(width + thickness, height + thickness),
		Vector2(width, height),
		Vector2(0, height),
		Vector2.ZERO,
		Vector2(width, 0),
		Vector2(width, height),
		Vector2(width + thickness, height + thickness),
		Vector2(width + thickness, -thickness),
		Vector2(-thickness, -thickness),
	])
