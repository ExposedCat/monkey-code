extends Node

@export var stone_scene = preload("res://scenes/resources/stone/scene.tscn")

var stone_number: int = 150

func _ready() -> void:
	for i in range(1, stone_number):
		spawn_stone()

func spawn_stone() -> void:
	var stone = stone_scene.instantiate()
	stone.position = get_random_position()

	get_parent().add_child.call_deferred(stone)

func get_random_position() -> Vector2:
	var size = 14
	var border_offset = 20
	
	var start_x = border_offset + size
	var start_y = start_x
	var end_x = Constants.width - border_offset - size
	var end_y = Constants.height - border_offset - size
	
	return Vector2(randf_range(start_x, end_x), randf_range(start_y, end_y))
