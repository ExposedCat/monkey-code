extends CollisionPolygon2D

func _ready() -> void:
	var thickness = 10
	var width = Constants.width / 2
	var height = Constants.height / 2
	polygon = PackedVector2Array([
		Vector2(-width - thickness, -height - thickness),
		Vector2(-width - thickness, height + thickness),
		Vector2(width + thickness, height + thickness),
		Vector2(width, height),
		Vector2(-width, height),
		Vector2(-width, -height),
		Vector2(width, -height),
		Vector2(width, height),
		Vector2(width + thickness, height + thickness),
		Vector2(width + thickness, -height - thickness),
		Vector2(-width - thickness, -height - thickness)
	])
	print(width, height, polygon)
