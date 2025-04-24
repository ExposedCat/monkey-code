extends Node

@export var enemy_scene = preload("res://scenes/entities/enemy/scene.tscn")

var spawned = true

var scenes = [
	{"scene": enemy_scene, "amount": 20, "min_distance": 5, "positions": []},
]

func _ready() -> void:
	DayNight.time_change.connect(self.handle_time_change)
	pass

func handle_time_change(time: float):
	if time == DayNight.MAX_DARK and not spawned:
		spawned = true
		for scene in scenes:
			for i in range(1, scene["amount"]):
				var enemy = scene["scene"].instantiate()
				enemy.position = get_random_position(scene)
				get_parent().add_child.call_deferred(enemy)
	elif time != DayNight.MAX_DARK and spawned:
			spawned = false

func get_random_position(scene) -> Vector2:
	var border_offset = 20

	var start_x = border_offset
	var start_y = start_x
	var end_x = Constants.width - border_offset
	var end_y = Constants.height - border_offset

	for i in range(0, 1001):
		var coords = Vector2(randf_range(start_x, end_x), randf_range(start_y, end_y))
		if not scene["positions"].any(func (position): return position.distance_to(coords) < scene["min_distance"]) or i == 1000:
			scene["positions"].append(coords)
			return coords
	return Vector2.ZERO
