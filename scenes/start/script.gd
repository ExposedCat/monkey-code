extends Control

var map_scene = preload("res://scenes/map/scene.tscn")
var main_scene = preload("res://scenes/main/scene.tscn")

func _ready() -> void:
	ProjectSettings.set_setting("rendering/environment/defaults/default_clear_color", Color.WHITE)
	var map = map_scene.instantiate()
	add_child(map)
	move_child(map, 0)

func _on_start() -> void:
	get_tree().change_scene_to_packed(main_scene)
