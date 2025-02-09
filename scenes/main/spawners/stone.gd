extends Node

@export var stone_scene = preload("res://scenes/items/stone/scene.tscn")
@export var light_scene = preload("res://scenes/items/light/scene.tscn")

var scenes = [
	{"scene": stone_scene, "amount": 250, "min_distance": 5, "positions": []},
	{"scene": light_scene, "amount": 20, "min_distance": 300, "positions": []},
]

func _ready() -> void:
	for scene in scenes:
		for i in range(1, scene["amount"]):
			spawn(scene)

func spawn(scene) -> void:
	var item = scene["scene"].instantiate()
	item.position = get_random_position(scene)
	get_parent().add_child.call_deferred(item)

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
