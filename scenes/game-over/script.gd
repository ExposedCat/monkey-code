extends Control

var map_scene = preload("res://scenes/map/scene.tscn")
var main_scene = preload("res://scenes/main/scene.tscn")
var start_scene = preload("res://scenes/start/scene.tscn")

func _ready() -> void:
	var map = map_scene.instantiate()
	add_child(map)
	move_child(map, 0)

func _on_start() -> void:
	get_tree().change_scene_to_packed(main_scene)

func _on_main_menu() -> void:
	get_tree().change_scene_to_packed(start_scene)
