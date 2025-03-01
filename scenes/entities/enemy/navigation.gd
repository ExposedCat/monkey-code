extends NavigationRegion2D

func _ready() -> void:
	var width = Constants.width
	var height = Constants.height
	navigation_polygon.vertices = PackedVector2Array([
		Vector2(0, 0),
		Vector2(width, 0),
		Vector2(width, height),
		Vector2(0, height)
	])
	navigation_polygon.add_polygon(PackedInt32Array([0, 1, 2, 3]))
