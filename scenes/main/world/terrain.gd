extends TileMapLayer

func _ready() -> void:
	var total_tiles = int(float(Constants.width * Constants.height) / rendering_quadrant_size)
	var total_grass = total_tiles * 0.01
	
	for i in range(1, total_grass):
		spawn_grass()

func spawn_grass() -> void:
	var target = get_random_position()
	var possible_tiles = [
		{"source": 0, "coords": Vector2i(0,5)},
		{"source": 0, "coords": Vector2i(1,5)},
		{"source": 0, "coords": Vector2i(2,5)},
	]
	var chosen_tile = possible_tiles[randi() % possible_tiles.size()]
	set_cell(
		Vector2i(target.x, target.y),
		chosen_tile.source,
		chosen_tile.coords
	)

func get_random_position() -> Vector2:
	var total_width = round(float(Constants.width) / rendering_quadrant_size)
	var total_height = round(float(Constants.height) / rendering_quadrant_size)
	
	return Vector2(
		randf_range(0, total_width),
		randf_range(0, total_height)
	)
