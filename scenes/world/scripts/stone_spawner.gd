extends Node

@export var stone_scene = preload("res://scenes/resources/stone/stone.tscn")

@onready var map_bounds = $"../../Map/StaticBody2D/CollisionPolygon2D"

var stone_number: int = 10

func _ready() -> void:
	for i in range(1, stone_number):
		spawn_stone()

func spawn_stone() -> void:
	var stone = stone_scene.instantiate()
	stone.position = get_random_position()

	get_parent().add_child.call_deferred(stone)

func get_random_position() -> Vector2:
	var rect_shape: PackedVector2Array = map_bounds.polygon
	var top_left = rect_shape[5]
	var bottom_right = rect_shape[3]
	
	var size = 14
	
	var rand_x = randf_range(top_left.x + size, bottom_right.x - size)
	var rand_y = randf_range(top_left.y + size, bottom_right.y - size)

	return Vector2(rand_x, rand_y)
