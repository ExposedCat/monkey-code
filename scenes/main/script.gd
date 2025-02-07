extends Node2D

var map_scene = preload("res://scenes/map/scene.tscn")

func _ready() -> void:
	var map = map_scene.instantiate()
	add_child(map)
	move_child(map, 0)
