extends CanvasLayer

@onready var main_ui = $"../../UI"
@onready var build_button = $"../../UI/Build"
@onready var preview = $"../Preview"
@onready var entities = $"../../Entities"

var stone_scene = preload("res://scenes/items/stone/scene.tscn")
var furnance_scene = preload("res://scenes/items/furnance/scene.tscn")
var buildable_by_name = {
	"stone": stone_scene,
	"furnance": furnance_scene
}

var buildable = null

func cancel() -> void:
	build_button.text = "Build"
	preview.visible = false
	buildable = null

func toggle_open() -> bool:
	if buildable:
		cancel()
		return false
	visible = not visible
	return true

func on_select_stone():
	on_select("stone")
	
func on_select_furnance():
	on_select("furnance")
	
func on_select(item: StringName):
	toggle_open()
	build_button.text = "Cancel"
	preview.visible = true
	buildable = buildable_by_name[item]
	main_ui.toggle_pause()
	
func on_build(position: Vector2):
	if buildable:
		var scene = buildable.instantiate()
		scene.position = position
		entities.add_child.call_deferred(scene)
		cancel()
